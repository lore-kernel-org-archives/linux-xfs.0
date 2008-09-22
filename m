Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 03:57:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MAuu8t015965
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:56:58 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D35021BD182A
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:58:29 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id bnQtF8wGFMwyetZ8 for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:58:29 -0700 (PDT)
Subject: [PATCH 9/10] Remove XFS specific ioctl interfaces for freeze feature
Message-Id: <20080922195819t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:58:18 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

It removes XFS specific ioctl interfaces and request codes
for freeze feature.
This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 linux-2.6/xfs_ioctl.c   |   15 ---------------
 linux-2.6/xfs_ioctl32.c |    2 --
 xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-
2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 14:19:19.000000000 +0900
@@ -1529,21 +1529,6 @@ xfs_ioctl(
 		return -error;
 	}
 
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
 	case XFS_IOC_GOINGDOWN: {
 		__uint32_t in;
 
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linu
x-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 14:19:19.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h linux-2.6.27-rc7-xf
s/fs/xfs/xfs_fs.h
--- linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/xfs_fs.h	2008-09-22 14:19:19.000000000 +0900
@@ -477,8 +477,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
