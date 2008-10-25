Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 06:34:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PDYqjQ024863
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:34:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62DC91B1A50D
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:34:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id vYBuPXAvDRTbTdyx for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:34:51 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 809F1A9ABD3
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 08:34:51 -0500 (CDT)
Message-ID: <4903207B.6030009@sandeen.net>
Date: Sat, 25 Oct 2008 08:34:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2 v2] hook up fiemap & associated formatter
References: <49031E81.7040807@sandeen.net>
In-Reply-To: <49031E81.7040807@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Hook up the fiemap ioctl.

This adds the fiemap inode_operation, which for us converts the 
fiemap values & flags into a getbmapx structure which can be sent
to xfs_getbmap.  The formatter then copies the bmv array back into the
user's fiemap buffer via the fiemap helpers.

This adds a new output flag, BMV_OF_LAST to indicate if we've hit
the last extent in the inode.  This potentially saves an extra call
from userspace to see when the whole mapping is done.

It also adds BMV_IF_DELALLOC and BMV_OF_DELALLOC to request, and
indicate, delayed-allocation extents.

If we wanted to be more clever, we could also return mapping data for 
in-inode attributes, but I'm not terribly motivated to do that just yet.

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
@@ -661,6 +662,80 @@ out_error:
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
+	struct fiemap_extent_info *fieinfo = *arg;
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
+	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		physical = 0;   /* no block yet */
+	}
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
+	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
+		bm.bmv_iflags |= BMV_IF_DELALLOC;
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
@@ -671,6 +746,7 @@ static const struct inode_operations xfs
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fallocate		= xfs_vn_fallocate,
+	.fiemap			= xfs_vn_fiemap,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
@@ -5813,6 +5813,9 @@ xfs_getbmapx_fix_eof_hole(
 {
 	__int64_t		fixlen;
 	xfs_mount_t		*mp;		/* file system mount point */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last extent pointer */
+	xfs_fileoff_t		fileblock;
 
 	if (startblock == HOLESTARTBLOCK) {
 		mp = ip->i_mount;
@@ -5827,6 +5830,11 @@ xfs_getbmapx_fix_eof_hole(
 		}
 	} else {
 		out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
+			out->bmv_oflags |= BMV_OF_LAST;
 	}
 
 	return 1;
@@ -5880,8 +5888,6 @@ xfs_getbmap(
 	int			whichfork;	/* data or attr fork */
 	int			prealloced;	/* this is a file with
 						 * preallocated data space */
-	int			sh_unwritten;	/* true, if unwritten */
-						/* extents listed separately */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 
@@ -5889,7 +5895,6 @@ xfs_getbmap(
 	iflags = bmv->bmv_iflags;
 
 	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
-	sh_unwritten = (iflags & BMV_IF_PREALLOC) != 0;
 
 	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
 	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
@@ -5960,8 +5965,9 @@ xfs_getbmap(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (whichfork == XFS_DATA_FORK &&
-		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
+	if (((iflags & BMV_IF_DELALLOC) == 0) &&
+	    (whichfork == XFS_DATA_FORK) &&
+	    (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
 		error = xfs_flush_pages(ip, (xfs_off_t)0,
 					       -1, 0, FI_REMAPF);
@@ -5971,7 +5977,8 @@ xfs_getbmap(
 		}
 	}
 
-	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);
+	ASSERT(whichfork == XFS_ATTR_FORK || (iflags & BMV_IF_DELALLOC) ||
+	       ip->i_delayed_blks == 0);
 
 	lock = xfs_ilock_map_shared(ip);
 
@@ -5983,7 +5990,7 @@ xfs_getbmap(
 		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
 
 	bmapi_flags = XFS_BMAPI_AFLAG(whichfork) |
-			((sh_unwritten) ? 0 : XFS_BMAPI_IGSTATE);
+			((iflags & BMV_IF_PREALLOC) ? 0 : XFS_BMAPI_IGSTATE);
 
 	/*
 	 * Allocate enough space to handle "subnex" maps at a time.
@@ -5993,9 +6000,12 @@ xfs_getbmap(
 
 	bmv->bmv_entries = 0;
 
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0) {
-		error = 0;
-		goto unlock_and_return;
+	if ((XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
+		if (((iflags & BMV_IF_DELALLOC) == 0) ||
+		    whichfork == XFS_ATTR_FORK) {
+			error = 0;
+			goto unlock_and_return;
+		}
 	}
 
 	nexleft = nex;
@@ -6011,15 +6021,20 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out.bmv_oflags = (map[i].br_state == XFS_EXT_UNWRITTEN) ?
-					BMV_OF_PREALLOC : 0;
+			out.bmv_oflags = 0;
+			if (map[i].br_state == XFS_EXT_UNWRITTEN)
+				out.bmv_oflags |= BMV_OF_PREALLOC;
+			else if (map[i].br_startblock == DELAYSTARTBLOCK)
+				out.bmv_oflags |= BMV_OF_DELALLOC;
 			out.bmv_offset = XFS_FSB_TO_BB(mp, map[i].br_startoff);
 			out.bmv_length = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out.bmv_unused1 = out.bmv_unused2 = 0;
-			ASSERT(map[i].br_startblock != DELAYSTARTBLOCK);
+			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
+			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
+				out.bmv_oflags |= BMV_OF_LAST;
 				goto unlock_and_return;
 			} else {
 				int filled;	/* nr extents filled */
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h
@@ -113,10 +113,14 @@ struct getbmapx {
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
-#define BMV_IF_VALID	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC)
+#define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_VALID	\
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
 
 /*	bmv_oflags values - returned for for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
+#define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
