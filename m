Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09MD0bj027470 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:13:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 388C417C957D
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:13:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zCKmQPlrUsARA0aF for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:13:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LLPb9-0003ug-Sw
	for xfs@oss.sgi.com; Fri, 09 Jan 2009 22:12:59 +0000
Message-Id: <20090109221259.664448000@bombadil.infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
Date: Fri, 09 Jan 2009 17:11:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: use mnt_want_write in compat_attrmulti ioctl
Content-Disposition: inline; filename=xfs-compat-attrmulti-writecount
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

The compat version of the attrmulti ioctl needs to ask for and then
later release write access to the mount just like the native version,
otherwise we could potentially write to read-only mounts.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-29 01:25:19.000000000 +0000
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-29 01:26:24.000000000 +0000
@@ -17,6 +17,7 @@
  */
 #include <linux/compat.h>
 #include <linux/ioctl.h>
+#include <linux/mount.h>
 #include <asm/uaccess.h>
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -458,15 +459,23 @@
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_set(
 					dentry->d_inode, attr_name,
 					compat_ptr(ops[i].am_attrvalue),
 					ops[i].am_length, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
 			break;
 		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_remove(
 					dentry->d_inode, attr_name,
 					ops[i].am_flags);
+			mnt_drop_write(parfilp->f_path.mnt);
 			break;
 		default:
 			ops[i].am_error = EINVAL;

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
