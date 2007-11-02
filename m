Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:11:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21BL24006076
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:11:24 -0700
Message-ID: <472A7940.5070800@sgi.com>
Date: Fri, 02 Nov 2007 12:11:28 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: bug: truncate to zero + setuid
References: <47249E7A.7060709@filmlight.ltd.uk> <47252F62.6030503@sgi.com> <47262CD0.5010708@filmlight.ltd.uk> <4726ADAE.9070206@sgi.com> <472769A1.5090605@filmlight.ltd.uk>
In-Reply-To: <472769A1.5090605@filmlight.ltd.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

Hi Roger,

Roger Willcocks wrote:
> Timothy Shimmin wrote:
>> I presume it was done where it was done so that the inode was locked 
>> and we
>> were under the XFS_AT_SIZE predicate.
>>
>> I was just thinking of something like...
>> but I'm probably missing something.
>>
>> Index: 2.6.x-xfs/fs/xfs/xfs_vnodeops.c
>> ===================================================================
>> --- 2.6.x-xfs.orig/fs/xfs/xfs_vnodeops.c        2007-10-12 
>> 16:06:15.000000000 +1000
>> +++ 2.6.x-xfs/fs/xfs/xfs_vnodeops.c     2007-10-30 14:59:46.418837757 
>> +1100
>> @@ -304,6 +304,24 @@
>>         }
>>
>>         /*
>> +        * Short circuit the truncate case for zero length files.
>> +        * If more mask bits are set, then just remove the SIZE one
>> +        * and keep going.
>> +        */
>> +       if (mask & XFS_AT_SIZE) {
>> +               xfs_ilock(ip, XFS_ILOCK_SHARED);
>> +               if ((vap->va_size == 0) && (ip->i_size == 0) && 
>> (ip->i_d.di_nextents == 0)) {
>> +                       if (mask & ~XFS_AT_SIZE) {
>> +                               mask &= ~XFS_AT_SIZE;
>> +                       } else {
>> +                               xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +                               return 0;
>> +                       }
>> +               }
>> +               xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +       }
>> +
>> +       /*
>>          * For the other attributes, we acquire the inode lock and
>>          * first do an error checking pass.
>>          */
>> @@ -451,17 +469,6 @@
>>          * Truncate file.  Must have write permission and not be a 
>> directory.
>>          */
>>         if (mask & XFS_AT_SIZE) {
>> -               /* Short circuit the truncate case for zero length 
>> files */
>> -               if ((vap->va_size == 0) &&
>> -                  (ip->i_size == 0) && (ip->i_d.di_nextents == 0)) {
>> -                       xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> -                       lock_flags &= ~XFS_ILOCK_EXCL;
>> -                       if (mask & XFS_AT_CTIME)
>> -                               xfs_ichgtime(ip, XFS_ICHGTIME_MOD | 
>> XFS_ICHGTIME_CHG);
>> -                       code = 0;
>> -                       goto error_return;
>> -               }
>> -
>>                 if (VN_ISDIR(vp)) {
>>                         code = XFS_ERROR(EISDIR);
>>                         goto error_return;
 >
> This misses setting the access and changed times which still need to be 
> touched even if the file's already zero bytes. How about this:
> (noting that open.c/do_truncate uses XFS_AT_SIZE | XFS_AT_CTIME)
> 

Well, if XFS_AT_CTIME was set then my patch wouldn't
return straight away and would continue processing the mask fields.
And I was presuming that the times would be set doing this.

However, it doesn't look quite so simple and consistent:

* going down the normal (non-short-circuit) path for AT_SIZE,
   it doesn't test for CTIME but rather just does:

       /*
        * Have to do this even if the file's size doesn't change.
        */
       timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;

   And yet our short-circuit case only does it if AT_CTIME is set.
   Doesn't look consistent to me.

* So what in the vfs would call it...

   -----------------------
   open(O_TRUNC)...

   int may_open(struct nameidata *nd, int acc_mode, int flag)
   {

         if (flag & O_TRUNC) {
   ...
                         error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);

   ------------------------

   static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
   {
         if (!error)
                 error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);

   ------------------------

   This is NOR the case for
   * do_sys_truncate() and
   * do_coredump(),
   however, which send in zero for those bits.
   Not to mention other ways to get to these calls.

   Anyway, open(O_TRUNC) will be a good candidate for the optimization
   by the looks of it as it always trunc's to zero.

   So in the 2 truncate cases, it is setting MTIME and CTIME.

   And how is MTIME handled in the xfs code...

         /*
          * Change file access or modified times.
          */
         if (mask & (XFS_AT_ATIME|XFS_AT_MTIME)) {
                 if (mask & XFS_AT_ATIME) {
                         ip->i_d.di_atime.t_sec = vap->va_atime.tv_sec;
                         ip->i_d.di_atime.t_nsec = vap->va_atime.tv_nsec;
                         ip->i_update_core = 1;
                         timeflags &= ~XFS_ICHGTIME_ACC;
                 }
                 if (mask & XFS_AT_MTIME) {
                         ip->i_d.di_mtime.t_sec = vap->va_mtime.tv_sec;
                         ip->i_d.di_mtime.t_nsec = vap->va_mtime.tv_nsec;
                         timeflags &= ~XFS_ICHGTIME_MOD;
                         timeflags |= XFS_ICHGTIME_CHG;
                 }
                 if (tp && (flags & ATTR_UTIME))
                         xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
         }

         /*
          * Send out timestamp changes that need to be set to the
          * current time.  Not done when called by a DMI function.
          */
         if (timeflags && !(flags & ATTR_DMI))
                 xfs_ichgtime(ip, timeflags);

   And note that MTIME, will actually turn on the timeflags for XFS_ICHGTIME_CHG,
   which is the time associated with XFS_AT_CTIME.

   So for the 2 do_truncate calls paths,
   it will set the mtime based
   on the va_mtime and set the ctime based on current time (nanotime()).
   Our shortcut is setting both to current time.
   I don't know if anyone really cares.


I don't like all these inconsistencies.
One way to reduce inconsistencies is to allow code to go thru
common paths so we can do the same strange thing in the one spot ;-)

It looks like in the AT_SIZE, we should always set those timeflags
irrespective of AT_CTIME.

BTW, your locking looks wrong - it appears you don't unlock when the
file is non-zero size.

--Tim


> --- xfs_vnodeops.c      2007-09-04 15:57:40.000000000 +0100
> +++ /tmp/xfs_vnodeops.c 2007-10-30 17:11:32.000000000 +0000
> @@ -378,6 +378,24 @@
>                        return (code);
>        }
> 
> +
> +       if ((mask & XFS_AT_SIZE) && (vap->va_size == 0)) {
> +
> +               /* Short circuit the truncate case for zero length files */
> +
> +               xfs_ilock(ip, XFS_ILOCK_EXCL);
> +               if ((ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 0)) {
> +                       xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +                       if (mask & XFS_AT_CTIME)
> +                               xfs_ichgtime(ip, 
> XFS_ICHGTIME_MOD|XFS_ICHGTIME_CHG);
> +                       mask &= ~(XFS_AT_SIZE|XFS_AT_CTIME);
> +                       if (mask == 0) {
> +                               code = 0;
> +                               goto error_return;
> +                       }
> +               }
> +       }
> +
>        /*
>         * For the other attributes, we acquire the inode lock and
>         * first do an error checking pass.
> @@ -528,17 +546,6 @@
>         * Truncate file.  Must have write permission and not be a 
> directory.
>         */
>        if (mask & XFS_AT_SIZE) {
> -               /* Short circuit the truncate case for zero length files */
> -               if ((vap->va_size == 0) &&
> -                  (ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 0)) {
> -                       xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -                       lock_flags &= ~XFS_ILOCK_EXCL;
> -                       if (mask & XFS_AT_CTIME)
> -                               xfs_ichgtime(ip, XFS_ICHGTIME_MOD | 
> XFS_ICHGTIME_CHG);
> -                       code = 0;
> -                       goto error_return;
> -               }
> -
>                if (vp->v_type == VDIR) {
>                        code = XFS_ERROR(EISDIR);
>                        goto error_return;
