Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 21:06:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9U469nL031039
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 21:06:12 -0700
Message-ID: <4726ADAE.9070206@sgi.com>
Date: Tue, 30 Oct 2007 15:06:06 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: bug: truncate to zero + setuid
References: <47249E7A.7060709@filmlight.ltd.uk> <47252F62.6030503@sgi.com> <47262CD0.5010708@filmlight.ltd.uk>
In-Reply-To: <47262CD0.5010708@filmlight.ltd.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

Roger Willcocks wrote:
> Tim Shimmin wrote:
>> Hi Roger,
>>
>> Roger Willcocks wrote:
>>> The nfsv3 setattr call permits a simultaneous truncate + setuid/gid 
>>> operation. Normally XFS handles this fine, but if the file's being 
>>> truncated to zero, and the file's already empty, XFS simply ignores 
>>> the setuid/gid part, returning 'success'.
>>>
>>> The error's in xfs_vnodeops.c/xfs_setattr below the comment 'Short 
>>> circuit the truncate case for zero length files', which bypasses all 
>>> other changes.
>>>
>>> The simplest fix is to test whether this is the only change that's 
>>> happening, otherwise you get tangled in transactions.
>>>
>>>        if (mask & XFS_AT_SIZE) {
>>>                /* Short circuit the truncate case for zero length 
>>> files */
>>> -               if ((vap->va_size == 0) &&
>>> +               if (((mask & ~XFS_AT_SIZE) == 0) && (vap->va_size == 
>>> 0) &&
>>>                   (ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 
>>> 0)) {
>>>
>>>
>>> -- 
>>> Roger
>>>
>>
>> Yeah, I see your problem.
>> It is interesting to know how much of multiple actions (different
>> bits of mask) are supported.
>> XFS_AT_UPDTIMES doesn't support anything else and will return quickly.
>> As far as code which goes via error_return, it looks like the
>> only non-error case is the short-circuit one mentioned above -
>> truncating to zero an already zeroed file.
>>
>> I see your fix will get what we want although, it will mean that we
>> will go thru the truncating path when we don't need to.
>> It would be nice if we could act like the XFS_AT_SIZE was never set
>> on the call in the case that other bits are set.
>> Though when we first test the AT_SIZE, we don't have the inode locked.
>> And I presume in that case we don't necessarily need to send a
>> DMAPI truncate event?
>> So I wonder if before the 1st AT_SIZE test that we have now,
>> in the AT_SIZE case and with other bits set,
>> we could lock the inode and test
>> for the zero truncate of zero-len file and if so then remove the 
>> AT_SIZE bit
>> and then go on to the other testing as if AT_SIZE was never set.
>> Hmmm, may be that just complicates things too much.
>>
> Yes I looked at simply unsetting the XFS_AT_SIZE bit (you'd also need to 
> set
> timeflags appropriately) but the problem is the bit's used to check when 
> to create
> a transaction - either up front as  XFS_TRANS_SETATTR_NOT_SIZE, or
> later on, after the inode's been locked and unlocked again, as
> XFS_TRANS_SETATTR_SIZE. So if you unset the bit (and there's still more
> to do) you need to build a not_size transaction, at which point you 
> might as well
> rewrite the whole routine...
> 
> -- 
> Roger

So this was done by Steve L. for AIM performance...

----------------------------
revision 1.446
date: 2000/06/09 02:59:45;  author: lord;  state: Exp;  lines: +11 -0
modid: 2.4.0-test1-xfs:slinx:55891a
Merge of 2.3.99pre2-xfs:slinx:55891a by ananth.

   Short circuit the case where we truncate a zero length
   file down to zero length so that we do not do a transaction.
   This close to doubles create/close AIM run performance.
----------------------------

 > p_rdiff -r1.445,1.446 xfs_vnodeops.c
746a747,757
 >               /* Short circuit the truncate case for zero length files */
 >               if ((vap->va_size == 0) &&
 >                  (ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 0)) {
 >                       xfs_iunlock(ip, XFS_ILOCK_EXCL);
 >                       lock_flags &= ~XFS_ILOCK_EXCL;
 >                       if (mask & AT_CTIME)
 >                               xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
 >                       code = 0;
 >                       goto error_return;
 >               }
 >


----------------------------
revision 1.506
date: 2001/06/26 22:07:29;  author: lord;  state: Exp;  lines: +1 -1
modid: 2.4.x-xfs:slinx:97694a
Set the mtime on a zero length file when a create is being done on
top of it.
----------------------------

 > p_rdiff -r1.505,1.506 xfs_vnodeops.c
526c526
<                               xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
---
 >                               xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);




I presume it was done where it was done so that the inode was locked and we
were under the XFS_AT_SIZE predicate.

I was just thinking of something like...
but I'm probably missing something.

Index: 2.6.x-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_vnodeops.c        2007-10-12 16:06:15.000000000 +1000
+++ 2.6.x-xfs/fs/xfs/xfs_vnodeops.c     2007-10-30 14:59:46.418837757 +1100
@@ -304,6 +304,24 @@
         }

         /*
+        * Short circuit the truncate case for zero length files.
+        * If more mask bits are set, then just remove the SIZE one
+        * and keep going.
+        */
+       if (mask & XFS_AT_SIZE) {
+               xfs_ilock(ip, XFS_ILOCK_SHARED);
+               if ((vap->va_size == 0) && (ip->i_size == 0) && (ip->i_d.di_nextents == 0)) {
+                       if (mask & ~XFS_AT_SIZE) {
+                               mask &= ~XFS_AT_SIZE;
+                       } else {
+                               xfs_iunlock(ip, XFS_ILOCK_SHARED);
+                               return 0;
+                       }
+               }
+               xfs_iunlock(ip, XFS_ILOCK_SHARED);
+       }
+
+       /*
          * For the other attributes, we acquire the inode lock and
          * first do an error checking pass.
          */
@@ -451,17 +469,6 @@
          * Truncate file.  Must have write permission and not be a directory.
          */
         if (mask & XFS_AT_SIZE) {
-               /* Short circuit the truncate case for zero length files */
-               if ((vap->va_size == 0) &&
-                  (ip->i_size == 0) && (ip->i_d.di_nextents == 0)) {
-                       xfs_iunlock(ip, XFS_ILOCK_EXCL);
-                       lock_flags &= ~XFS_ILOCK_EXCL;
-                       if (mask & XFS_AT_CTIME)
-                               xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-                       code = 0;
-                       goto error_return;
-               }
-
                 if (VN_ISDIR(vp)) {
                         code = XFS_ERROR(EISDIR);
                         goto error_return;
