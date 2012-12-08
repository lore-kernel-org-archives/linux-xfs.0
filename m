Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C7djL029951 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:07:39 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	I3mAnUxmfhMIfm5B (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:10:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ThJEL-0004gQ-OO
	for xfs@oss.sgi.com; Sat, 08 Dec 2012 12:10:05 +0000
Message-Id: <20121208121005.710569599@bombadil.infradead.org>
Date: Sat, 08 Dec 2012 07:08:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: remove the unused XFS_ATTR_NONBLOCK flag
References: <20121208120812.755863148@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ioctl.c    |    3 ---
 fs/xfs/xfs_vnodeops.h |    1 -
 2 files changed, 4 deletions(-)

Index: xfs/fs/xfs/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ioctl.c	2012-12-06 16:04:50.908778675 +0100
+++ xfs/fs/xfs/xfs_ioctl.c	2012-12-06 16:05:13.272111942 +0100
@@ -633,9 +633,6 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -XFS_ERROR(EINVAL);
 
-	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= XFS_ATTR_NONBLOCK;
-
 	if (filp->f_flags & O_DSYNC)
 		attr_flags |= XFS_ATTR_SYNC;
 
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2012-12-06 16:04:50.908778675 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2012-12-06 16:05:18.452111928 +0100
@@ -15,7 +15,6 @@ struct xfs_inode;
 int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap, int flags);
 int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
-#define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 #define XFS_ATTR_SYNC		0x10	/* synchronous operation required */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
