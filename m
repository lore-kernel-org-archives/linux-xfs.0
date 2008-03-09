Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 15:59:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m29Mx80D003705
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 15:59:12 -0700
Date: Mon, 10 Mar 2008 09:59:25 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080309225925.GT155407@sgi.com>
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com> <20080213214551.GR155407@sgi.com> <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Mar 05, 2008 at 02:53:18PM +0100, Christian Røsnes wrote:
> On Wed, Feb 13, 2008 at 10:45 PM, David Chinner <dgc@sgi.com> wrote:
> After being hit several times by the problem mentioned above (running
> kernel 2.6.17.7),
> I upgraded the kernel to version 2.6.24.3. I then ran a rsync test to
> a 99% full partition:
> 
> df -k:
> /dev/sdb1            286380096 282994528   3385568  99% /data
> 
> The rsync application will probably fail because it will most likely
> run out of space,
> but I got another xfs_trans_cancel kernel message:
> 
> Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1163 of
> file fs/xfs/xfs_trans.c.  Caller 0xc021a010
> Pid: 11642, comm: rsync Not tainted 2.6.24.3FC #1
>  [<c0212678>] xfs_trans_cancel+0x5d/0xe6
>  [<c021a010>] xfs_mkdir+0x45a/0x493
>  [<c021a010>] xfs_mkdir+0x45a/0x493
>  [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
>  [<c0222d70>] xfs_vn_mknod+0x165/0x243
>  [<c0217b9e>] xfs_access+0x2f/0x35
>  [<c0222e6d>] xfs_vn_mkdir+0x12/0x14
>  [<c016057b>] vfs_mkdir+0xa3/0xe2
>  [<c0160644>] sys_mkdirat+0x8a/0xc3
>  [<c016069c>] sys_mkdir+0x1f/0x23
>  [<c01025ee>] syscall_call+0x7/0xb
>  =======================
> xfs_force_shutdown(sdb1,0x8) called from line 1164 of file
> fs/xfs/xfs_trans.c.  Return address = 0xc0212690
> Filesystem "sdb1": Corruption of in-memory data detected.  Shutting
> down filesystem: sdb1
> Please umount the filesystem, and rectify the problem(s)

Ok, so the problem still exists.

> Trying to umount /dev/sdb1 fails (umount just hangs) .

That shouldn't happen. Any output in the log when it hung? What
were the blocked process stack traces (/proc/sysrq-trigger is your friend)?

> Rebooting the system seems to hang also - and I believe the kernel
> outputs this message
> when trying to umount /dev/sdb1:
> 
>   xfs_force_shutdown(sdb1,0x1) called from line 420 of file fs/xfs/xfs_rw.c.
>   Return address = 0xc021cb21

It's already been shut down, right? An unmount should not trigger more
of these warnings...

> 
> After waiting 5 minutes I power-cycle the system to bring it back up.
> 
> After the restart, I ran:
> 
> xfs_check /dev/sdb1
> 
> (there was no output from xfs_check).
> 
> Could this be the same problem I experienced with 2.6.17.7 ?

Yes, it likely is. Can you apply the patch below and reproduce the problem?
I can't reproduce the problem locally, so I'll need you to apply test patches
to isolate the error. I suspect a xfs_dir_canenter()/xfs_dir_createname()
with resblks == 0 issue, and the patch below will tell us if this is the
case. It annotates the error paths for both create and mkdir (the two places
I've seen this error occur), and what I am expecting to see is something
like:

xfs_create: dir_enter w/ 0 resblks ok.
xfs_create: dir_createname error 28
<shutdown>

Cheers,

Dave.
---
 fs/xfs/xfs_vnodeops.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-02-22 17:40:04.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-03-10 09:53:43.658179381 +1100
@@ -1886,12 +1886,17 @@ xfs_create(
 	if (error)
 		goto error_return;
 
-	if (resblks == 0 && (error = xfs_dir_canenter(tp, dp, name, namelen)))
-		goto error_return;
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name, namelen);
+		if (error)
+			goto error_return;
+		printk(KERN_WARNING "xfs_create: dir_enter w/ 0 resblks ok.\n");
+	}
 	error = xfs_dir_ialloc(&tp, dp, mode, 1,
 			rdev, credp, prid, resblks > 0,
 			&ip, &committed);
 	if (error) {
+		printk(KERN_WARNING "xfs_create: dir_ialloc error %d\n", error);
 		if (error == ENOSPC)
 			goto error_return;
 		goto abort_return;
@@ -1921,6 +1926,7 @@ xfs_create(
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
 		ASSERT(error != ENOSPC);
+		printk(KERN_WARNING "xfs_create: dir_createname error %d\n", error);
 		goto abort_return;
 	}
 	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1955,6 +1961,7 @@ xfs_create(
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
 		xfs_bmap_cancel(&free_list);
+		printk(KERN_WARNING "xfs_create: xfs_bmap_finish error %d\n", error);
 		goto abort_rele;
 	}
 
@@ -2727,9 +2734,12 @@ xfs_mkdir(
 	if (error)
 		goto error_return;
 
-	if (resblks == 0 &&
-	    (error = xfs_dir_canenter(tp, dp, dir_name, dir_namelen)))
-		goto error_return;
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, dir_name, dir_namelen);
+		if (error)
+			goto error_return;
+		printk(KERN_WARNING "xfs_mkdir: dir_enter w/ 0 resblks ok.\n");
+	}
 	/*
 	 * create the directory inode.
 	 */
@@ -2737,6 +2747,7 @@ xfs_mkdir(
 			0, credp, prid, resblks > 0,
 		&cdp, NULL);
 	if (error) {
+		printk(KERN_WARNING "xfs_mkdir: dir_ialloc error %d\n", error);
 		if (error == ENOSPC)
 			goto error_return;
 		goto abort_return;
@@ -2761,6 +2772,7 @@ xfs_mkdir(
 				   &first_block, &free_list, resblks ?
 				   resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
 	if (error) {
+		printk(KERN_WARNING "xfs_mkdir: dir_createname error %d\n", error);
 		ASSERT(error != ENOSPC);
 		goto error1;
 	}
@@ -2805,6 +2817,7 @@ xfs_mkdir(
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error) {
+		printk(KERN_WARNING "xfs_mkdir: bmap_finish error %d\n", error);
 		IRELE(cdp);
 		goto error2;
 	}
