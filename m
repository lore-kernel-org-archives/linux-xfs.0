Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 09:59:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TGxBUQ001531
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:59:13 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1893714AB159
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:59:09 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id YG9GPWVy9kgvZuFf for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:59:09 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9TGx8hx010152
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:59:08 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TGx841032721
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:59:08 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9TGx76T032065
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:59:07 -0400
Message-ID: <4908965B.5000803@sandeen.net>
Date: Wed, 29 Oct 2008 11:59:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3 v4] hook up fiemap & associated formatter
References: <49089596.80006@sandeen.net>
In-Reply-To: <49089596.80006@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Hook up the fiemap ioctl.

This adds the fiemap inode_operation, which for us converts the 
fiemap values & flags into a getbmapx structure which can be sent
to xfs_getbmap.  The formatter then copies the bmv array back into
the user's fiemap buffer via the fiemap helpers.

If we wanted to be more clever, we could also return mapping data
for in-inode attributes, but I'm not terribly motivated to do that
just yet.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
@@ -53,6 +53,7 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/falloc.h>
+#include <linux/fiemap.h>
 
 /*
  * Bring the atime in the XFS inode uptodate.
@@ -661,6 +662,88 @@ out_error:
 	return error;
 }
 
+#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
+
+/*
+ * Call fiemap helper to fill in user data.
+ * Returns positive errors to xfs_getbmap.
+ */
+STATIC int
+xfs_fiemap_format(
+	void			**arg,
+	struct getbmapx		*bmv,
+	int			*full)
+{
+	int			error;
+	struct fiemap_extent_info *fieinfo = *arg;
+	u32			fiemap_flags = 0;
+	u64			logical, physical, length;
+
+	/* Do nothing for a hole */
+	if (bmv->bmv_block == -1LL)
+		return 0;
+
+	logical = BBTOB(bmv->bmv_offset);
+	physical = BBTOB(bmv->bmv_block);
+	length = BBTOB(bmv->bmv_length);
+
+	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
+		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
+	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		physical = 0;   /* no block yet */
+	}
+	if (bmv->bmv_oflags & BMV_OF_LAST)
+		fiemap_flags |= FIEMAP_EXTENT_LAST;
+
+	error = fiemap_fill_next_extent(fieinfo, logical, physical,
+					length, fiemap_flags);
+	if (error > 0) {
+		error = 0;
+		*full = 1;	/* user array now full */
+	}
+
+	return -error;
+}
+
+STATIC int
+xfs_vn_fiemap(
+	struct inode		*inode,
+	struct fiemap_extent_info *fieinfo,
+	u64			start,
+	u64			length)
+{
+	xfs_inode_t		*ip = XFS_I(inode);
+	struct getbmapx		bm;
+	int			error;
+
+	error = fiemap_check_flags(fieinfo, XFS_FIEMAP_FLAGS);
+	if (error)
+		return error;
+
+	/* Set up bmap header for xfs internal routine */
+	bm.bmv_offset = BTOBB(start);
+	/* Special case for whole file */
+	if (length == FIEMAP_MAX_OFFSET)
+		bm.bmv_length = -1LL;
+	else
+		bm.bmv_length = BTOBB(length);
+
+	/* our formatter will tell xfs_getbmap when to stop. */
+	bm.bmv_count = MAXEXTNUM;
+	bm.bmv_iflags = BMV_IF_PREALLOC;
+	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
+		bm.bmv_iflags |= BMV_IF_ATTRFORK;
+	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
+		bm.bmv_iflags |= BMV_IF_DELALLOC;
+
+	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
+	if (error)
+		return -error;
+
+	return 0;
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.permission		= xfs_vn_permission,
 	.truncate		= xfs_vn_truncate,
@@ -671,6 +754,7 @@ static const struct inode_operations xfs
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fallocate		= xfs_vn_fallocate,
+	.fiemap			= xfs_vn_fiemap,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
