Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DC7SZ5058962 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 07:07:28 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CA68159C62
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 05:07:26 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id sJpKC7BxVZ7Cmep7
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 05:07:26 -0700 (PDT)
Received: by fxh2 with SMTP id 2so493407fxh.26
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 05:07:26 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Sep 2011 17:37:25 +0530
Message-ID: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
Subject: =?windows-1252?Q?Code_Changes_=5BReview_Request=5D=3A_xfs=5Ftrans=5Fail=5Fdelete=28?=
	=?windows-1252?Q?=29_gets_invoked_with_corrupted_values_=96_Causing_Crash_and_D?=
	=?windows-1252?Q?eadlock=2E?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Architecture: ARM
Kernel: 2.6.38.13 (observed on 3.0.3 also)
Test Case: Unplug device during umount

BackTrace:
Unable to handle kernel NULL pointer dereference at virtual address 00000023
Process umount (pid: 220, stack limit =3D 0xe45f22e8)
Backtrace:
(xfs_log_move_tail+0x0/0x280) from [<c01ac3b0>]
(xfs_trans_ail_delete+0xbc/0x17c)
(xfs_trans_ail_delete+0x0/0x17c) from [<c01830c0>] (xfs_buf_iodone+0x64/0x7=
c)
(xfs_buf_iodone+0x0/0x7c) from [<c0183028>] (xfs_buf_do_callbacks+0x2c/0x3c)
(xfs_buf_do_callbacks+0x0/0x3c) from [<c0183260>]
(xfs_buf_iodone_callbacks+0x14c/0x174)
(xfs_buf_iodone_callbacks+0x0/0x174) from [<c01b660c>]
(xfs_buf_iodone_work+0x58/0x7c)
(xfs_buf_iodone_work+0x0/0x7c) from [<c01b66b4>] (xfs_buf_ioend+0x84/0x9c)
(xfs_buf_ioend+0x0/0x9c) from [<c01b6d60>] (xfs_bioerror+0x4c/0x54)
(xfs_bioerror+0x0/0x54) from [<c01b6dc4>] (xfs_bdstrat_cb+0x5c/0x6c)
(xfs_bdstrat_cb+0x0/0x6c) from [<c01b6858>] (xfs_flush_buftarg+0xe4/0x18c)
(xfs_flush_buftarg+0x0/0x18c) from [<c01b6920>] (xfs_free_buftarg+0x20/0x78)
(xfs_free_buftarg+0x0/0x78) from [<c01bdecc>] (xfs_close_devices+0x64/0x68)
(xfs_close_devices+0x0/0x68) from [<c01bdf44>] (xfs_fs_put_super+0x74/0x88)
(xfs_fs_put_super+0x0/0x88) from [<c00c3a9c>]
(generic_shutdown_super+0x7c/0x120)
(generic_shutdown_super+0x0/0x120) from [<c00c3b74>]
(kill_block_super+0x34/0x4c)
(kill_block_super+0x0/0x4c) from [<c00c2b54>]
(deactivate_locked_super+0x3c/0x5c)
(deactivate_locked_super+0x0/0x5c) from [<c00c2d60>]
(deactivate_super+0x5c/0x60)
(deactivate_super+0x0/0x60) from [<c00da79c>] (mntput_no_expire+0x9c/0xe8)
(mntput_no_expire+0x0/0xe8) from [<c00dae40>] (sys_umount+0x308/0x334)
(sys_umount+0x0/0x334) from [<c001ef80>] (ret_fast_syscall+0x0/0x30)
Code: e1a02007 e59f00bc e1a01006 eb055bd7 (e5d53023)
---[ end trace ddd9103bce1b5eae ]---
------------[ cut here ]------------

In the case of crash (back trace as shown), the log structure is
de-allocated as part of the xfs_log_unmount(), but there was a pending
callback which gets called after all these un-mount routine. Since,
log structure doesn=92t hold valid values it causes OOPS when accessed.

In the function xfs_buf_iodone() : file xfs_buf_item.c

If Mount point and the log structure addresses are checked through
xfs_buf_t *bp, it shows correct values =96 valid address for mount point
and NULL for log(bp->b_mount,bp->b_mount->m_log). While if the same
are accessed through =93ailp->xa_mount,ailp->xa_mount->m_log=94 =96 these
hold garbage values.

I have made few changes:
diff -Nurp linux-orig/fs/xfs/xfs_buf_item.c linux-Modified/fs/xfs/xfs_buf_i=
tem.c
--- linux-orig/fs/xfs/xfs_buf_item.c	2011-09-13 17:08:13.000000000 +0530
+++ linux-Modified/fs/xfs/xfs_buf_item.c	2011-09-13 17:05:43.000000000 +0530
@@ -1065,7 +1065,9 @@ xfs_buf_iodone(
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
-	xfs_buf_item_free(bip);
+	if(bp->b_mount->m_log){
+		spin_lock(&ailp->xa_lock);
+		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
+		xfs_buf_item_free(bip);
+	}
 }
diff -Nurp linux-orig/fs/xfs/xfs_trans_ail.c
linux-Modified/fs/xfs/xfs_trans_ail.c
--- linux-orig/fs/xfs/xfs_trans_ail.c	2011-06-02 12:10:52.000000000 +0530
+++ linux-Modified/fs/xfs/xfs_trans_ail.c	2011-09-13 17:06:31.000000000 +05=
30
@@ -27,6 +27,7 @@
 #include "xfs_mount.h"
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
+#include "xfs_log_priv.h"

 STATIC void xfs_ail_insert(struct xfs_ail *, xfs_log_item_t *);
 STATIC xfs_log_item_t * xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
@@ -619,6 +619,9 @@ xfs_trans_ail_destroy(
 	struct xfs_ail	*ailp =3D mp->m_ail;

 	xfsaild_stop(ailp);
+	mp->m_ail->xa_mount =3D NULL;
+        mp->m_ail =3D NULL;
+        mp->m_log->l_ailp =3D NULL;
 	kmem_free(ailp);
 }

Please share your opinion on these changes.

Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
