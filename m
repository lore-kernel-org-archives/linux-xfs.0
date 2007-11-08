Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Nov 2007 19:12:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA83Co1V026200
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2007 19:12:53 -0800
Message-ID: <47327ED2.8060402@sgi.com>
Date: Thu, 08 Nov 2007 14:13:22 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: bug: truncate to zero + setuid
References: <47249E7A.7060709@filmlight.ltd.uk> <47252F62.6030503@sgi.com> <47262CD0.5010708@filmlight.ltd.uk> <4726ADAE.9070206@sgi.com> <472769A1.5090605@filmlight.ltd.uk> <472A7940.5070800@sgi.com> <000001c81f3e$eff344b0$6501a8c0@BODDINGTON>
In-Reply-To: <000001c81f3e$eff344b0$6501a8c0@BODDINGTON>
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
>> Hi Roger,
>>
> ...
>> I don't like all these inconsistencies.
> 
> Take a look at the attached patch relative to the current cvs (it's a 
> bit big to put
> inline). The basic problem is it's currently unclear when to set the 
> times from
> va_atime etc. and when to set them to the current time. So I've used the 
> already
> defined XFS_AT_UPDxTIME flags to indicate that a time should be set to 
> 'now'
> and XFS_AT_xTIME to mean set it using va_xtime. This seems to fit well with
> the current code and I wonder if that's how it was meant to work in the 
> first
> place. 

Yeah, I've looked at this a few times now ;-) and this _seems_ like
a reasonable thing to do to me.

So patch:
ATTR_ATIME_SET => XFS_AT_ATIME (& set va_atime etc) (used to set to given time)
ATTR_ATIME     => XFS_AT_UPDATIME (used to set to "now")
likewise for M variant.

Previously:
ATTR_ATIME_SET => ATTR_UTIME flag (used to set given time)
                   must expect ATTR_ATIME to be set too to get va_atime
ATTR_ATIME     => XFS_AT_ATIME (& set va_atime) (used to set to "now")
                   a bit confusing since it can store va_atime even if
                   ATTR_ATIME_SET is not on


> I've also removed the now redundant ATTR_UTIME flag and pulled
> the null truncate to the top, which simplifies things.
> 

So these changes of:

         if (mask & (XFS_AT_ATIME|XFS_AT_MTIME)) {
                 if (!file_owner) {
-                       if ((flags & ATTR_UTIME) &&
-                           !capable(CAP_FOWNER)) {
+                       if (!capable(CAP_FOWNER)) {

Where you take out ATTR_UTIME make sense since XFS_AT_ATIME et al,
now refer to the case where a given time is provided
instead of requiring ATTR_UTIME to be set.

> One query: in both xfs_iops.c/xfs_vn_setattr and 
> xfs_dm.c/xfs_dm_set_fileattr the
> ATIME branch sets the inode's atime directly.

xfs_vn_setattr()
         if (ia_valid & ATTR_ATIME) {
                 vattr.va_mask |= XFS_AT_ATIME;
                 vattr.va_atime = attr->ia_atime;
                 inode->i_atime = attr->ia_atime;
         }

xfs_dm_set_fileattr()
         if (mask & DM_AT_ATIME) {
                 vat.va_mask |= XFS_AT_ATIME;
                 vat.va_atime.tv_sec = stat.fa_atime;
                 vat.va_atime.tv_nsec = 0;
                 inode->i_atime.tv_sec = stat.fa_atime;
         }

Hmmm....
So this could change behavior for xfs_vn_setattr().
If previously we had ATTR_ATIME set but NOT ATTR_ATIME_SET,
then we would set inode->i_atime.
Now with the patch, in this case, we don't set inode->i_atime
at this point.
However, in this case we wouldn't want i_atime to be set to ia_atime
as we would want it to be set to "now" in xfs_ichgtime().

> This is probably something 
> to do with
> the comment above xfs_iops.c/xfs_ichgtime ('to make sure the access time 
> update
> will take') but it could probably be handled better.
> 
I'll need to look.

>> BTW, your locking looks wrong - it appears you don't unlock when the
>> file is non-zero size.
> 
> Oops...
> 
I was also thinking of a read lock here.
And initializing quot vars to zero in variable definition at top.

This stuff really needs to be QA'ed well.
It would be too easy to get a regression in expected behavior.
Need to hunt out qa tests.

Thanks for the effort,
Tim.
