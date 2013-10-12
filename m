Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C3F447F51
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 02:56:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 927DB8F8078
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 00:56:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HiwrElmtRfR6dADY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 00:56:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VUu40-0000lJ-7d
	for xfs@oss.sgi.com; Sat, 12 Oct 2013 07:56:40 +0000
Message-Id: <20131012075640.115410017@bombadil.infradead.org>
Date: Sat, 12 Oct 2013 00:55:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: remove the unused XFS_ATTR_NONBLOCK flag
References: <20131012075503.370510641@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_ATTR_NONBLOCK
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ioctl.c |    3 ---
 fs/xfs/xfs_iops.h  |    1 -
 2 files changed, 4 deletions(-)

Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2013-09-12 18:43:35.480015650 +0200
+++ xfs/fs/xfs/xfs_ioctl.c	2013-10-01 20:16:53.240138969 +0200
@@ -661,9 +661,6 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -XFS_ERROR(EINVAL);
 
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= XFS_ATTR_NONBLOCK;
-
 	if (filp->f_flags & O_DSYNC)
 		attr_flags |= XFS_ATTR_SYNC;
 
Index: xfs/fs/xfs/xfs_iops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.h	2013-08-13 15:21:06.716303663 +0200
+++ xfs/fs/xfs/xfs_iops.h	2013-10-01 20:17:18.440139568 +0200
@@ -31,7 +31,6 @@ extern void xfs_setup_inode(struct xfs_i
  * Internal setattr interfaces.
  */
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
-#define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if op would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 #define XFS_ATTR_SYNC		0x10	/* synchronous operation required */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
