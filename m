Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 16:12:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NNC7W9016381
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:12:07 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF545537485
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:13:53 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id EOo8Iji3HDVARz6w for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 16:13:53 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9NNDrjY011490
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:13:53 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NNDqCY020642
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:13:52 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9NNDpfR002743
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 19:13:52 -0400
Message-ID: <4901052F.5090002@redhat.com>
Date: Thu, 23 Oct 2008 18:13:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] hook up fiemap & associated formatter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Hook up the fiemap ioctl.

This simply adds the fiemap inode_operation, which for us converts
the fiemap values & flags into a getbmapx structure which can be sent
to xfs_getbmap.  The formatter then copies the bmv array back into the
user's fiemap buffer.

This does *not* yet do delalloc; it still syncs the file just as xfs_bmap
always did.  That will come later; I'd like to get the basic hookup
out for review & committed so that we have something for 2.6.28.

This adds another output flag, BMV_OF_LAST to indicate if we've hit
the last extent in the inode.  This potentially saves an extra call
from userspace to see when the whole mapping is done.

If we wanted to be clever-er, we could also return mapping data for 
in-inode attributes, but I'm not terribly motivated to do that just yet.  :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6.27.x86_64/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ linux-2.6.27.x86_64/fs/xfs/linux-2.6/xfs_iops.c
@@ -53,6 +53,7 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/falloc.h>
+#include <linux/fiemap.h>
 
 /*
  * Bring the atime in the XFS inode uptodate.
@@ -661,6 +662,74 @@ out_error:
 	return error;
 }
 
+#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
+
+STATIC int xfs_fiemap_format(
+	void			**arg,
+	struct getbmapx		*bmv,
+	int			*filled)
+{
+	int			error = 0;
+	struct fiemap_extent_info *fieinfo= *arg;
+	u32			fiemap_flags = 0;
+	u64			logical, physical, length;
+
+	*filled = 0;
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
+	if (bmv->bmv_oflags & BMV_OF_LAST)
+		fiemap_flags |= FIEMAP_EXTENT_LAST;
+
+	error = fiemap_fill_next_extent(fieinfo, logical, physical,
+					length, fiemap_flags);
+	if (error < 0)
+		return -error;
+	*filled = 1;
+	return 0;
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
+	if (fiemap_check_flags(fieinfo, XFS_FIEMAP_FLAGS))
+		return -EBADR;
+
+	/* Set up bmap header for xfs internal routine */
+	bm.bmv_offset = BTOBB(start);
+	/* Special case for whole file */
+	if (length == FIEMAP_MAX_OFFSET)
+		bm.bmv_length = -1LL;
+	else
+		bm.bmv_length = BTOBB(length);
+	/* xfs_getbmap takes count as header + array */
+	bm.bmv_count = fieinfo->fi_extents_max + 1;
+	bm.bmv_iflags = BMV_IF_PREALLOC;
+	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
+		bm.bmv_iflags |= BMV_IF_ATTRFORK;
+
+	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
+	if (error)
+		return -XFS_ERROR(error);
+
+	return 0;
+}
+
 static const struct inode_operations xfs_inode_operations = {
 	.permission		= xfs_vn_permission,
 	.truncate		= xfs_vn_truncate,
@@ -671,6 +740,7 @@ static const struct inode_operations xfs
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fallocate		= xfs_vn_fallocate,
+	.fiemap			= xfs_vn_fiemap,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
Index: linux-2.6.27.x86_64/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6.27.x86_64/fs/xfs/xfs_bmap.c
@@ -5750,6 +5750,9 @@ xfs_getbmapx_fix_eof_hole(
 {
 	__int64_t		fixlen;
 	xfs_mount_t		*mp;		/* file system mount point */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last extent pointer */
+	xfs_fileoff_t		fileblock;	/* logical mapping offset */
 
 	if (startblock == HOLESTARTBLOCK) {
 		mp = ip->i_mount;
@@ -5764,6 +5767,11 @@ xfs_getbmapx_fix_eof_hole(
 		}
 	} else {
 		out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) - 1))
+			out->bmv_oflags |= BMV_OF_LAST;
 	}
 
 	return 1;
@@ -5957,6 +5965,7 @@ xfs_getbmap(
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
+				out.bmv_oflags |= BMV_OF_LAST;
 				goto unlock_and_return;
 			} else {
 				int filled;	/* extents filled by formatter */
Index: linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/xfs_fs.h
+++ linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
@@ -117,6 +117,7 @@ struct getbmapx {
 
 /*	bmv_oflags values - returned for for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
