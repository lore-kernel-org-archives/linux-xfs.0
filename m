Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 17:01:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K01Ldo020260
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 17:01:23 -0700
Date: Wed, 20 Jun 2007 10:01:09 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs freeze/umount problem
Message-ID: <20070620000109.GU86004887@sgi.com>
References: <46778F60.5090107@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46778F60.5090107@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>

On Tue, Jun 19, 2007 at 09:10:08AM +0100, David Greaves wrote:
> David Chinner wrote:
> > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an 
> XFS
> > filesystem for a suspend/resume to work safely and have argued that the 
> only
> > safe thing to do is freeze the filesystem before suspend and thaw it after
> > resume.
> 
> Whilst testing a potential bug in another thread I accidentally found that 
> unmounting a filesystem that I'd just frozen would hang.
> 
> As the saying goes: "Well, duh!!"

<grin>

It's the s_umount semaphore that is the problem here - freeze_bdev()
does a get_super() call which does a down_read(&sb->s_umount) and
the corresponding up_read() call does not occur until the filesystem
is thawed.

So yes, your umount will hang until you thaw the fileystem.

As i just tried this, I can't unfreeze the filesystem because it's
been removed from /proc/mounts already and so xfs_freeze -u aborts:

budgie:~ # xfs_freeze -u /dev/sdb8
xfs_freeze: specified file ["/dev/sdb8"] is not on an XFS filesystem
budgie:~ #

> I could eventually run an unfreeze but the mount was still hung. This lead 
> to an unclean shutdown.

So I couldn't reproduce the unclean shutdown.

> OK, it may not be bright but it seems like this shouldn't happen; umount 
> should either unfreeze and work or fail ("Attempt to umount a frozen 
> filesystem.") if the fs is frozen.

IMO, an unmount of a frozen fileystem should simply return EBUSY.

> Is this a kernel bug/misfeature or a (u)mount one?

Kernel bug. umount should know nothing about frozen filesystems...

Maybe something like th patch below needs to be done to prvent
the hang....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Don't try to unmount a frozen filesystem as the unmount will hang
waiting on the s_umount semaphore held by the freeze and you may not
be able to unfreeze the filesystem to allow the umount to proceed.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/namespace.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: 2.6.x-xfs-new/fs/namespace.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/namespace.c	2007-05-29 16:17:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/namespace.c	2007-06-20 09:57:21.310048007 +1000
@@ -545,6 +545,13 @@ static int do_umount(struct vfsmount *mn
 	int retval;
 	LIST_HEAD(umount_list);
 
+	/*
+	 * don't try to unmount frozen filesystems as we'll
+	 * hang on the s_umount held by the freeze a bit later.
+	 */
+	if (sb->s_frozen != SB_UNFROZEN)
+		return -EBUSY;
+
 	retval = security_sb_umount(mnt, flags);
 	if (retval)
 		return retval;
