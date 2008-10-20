Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 15:32:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KMWZ3p012636
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:32:35 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F4761310D4B
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:34:20 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id 4c84LhI7z6ArkcOG for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 15:34:20 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9KMYKjb006933
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 18:34:20 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KMYKiW015213
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 18:34:20 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9KMYJGk005639
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 18:34:19 -0400
Message-ID: <48FD076B.1000707@sandeen.net>
Date: Mon, 20 Oct 2008 17:34:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2, RFC] hook up fiemap & associated formatter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

This starts hooking up fiemap.

Reporting delalloc extents may still be a bit dodgey, and the interface is
also supposed to flag the last extent in the file, which I've not yet 
quiiiite worked out how to do.  But here's the start.

Thanks,
-Eric

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
@@ -661,6 +662,78 @@ out_error:
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
+	if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+		fiemap_flags |= FIEMAP_EXTENT_DELALLOC;
+		physical = 0;   /* no block yet */
+	}
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
+	/* Special case for whole file */ /* XXX ERS needed? */
+	if (length == ~0ULL)
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
@@ -671,6 +744,7 @@ static const struct inode_operations xfs
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
@@ -5819,6 +5819,7 @@ xfs_getbmap(
 						 * preallocated data space */
 	int			sh_unwritten;	/* true, if unwritten */
 						/* extents listed separately */
+	int			sh_delalloc;	/* show delayed extents */
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 
@@ -5827,6 +5828,7 @@ xfs_getbmap(
 
 	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
 	sh_unwritten = (iflags & BMV_IF_PREALLOC) != 0;
+	sh_delalloc = (iflags & BMV_IF_DELALLOC) != 0;
 
 	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
 	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
@@ -5897,7 +5899,7 @@ xfs_getbmap(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (whichfork == XFS_DATA_FORK &&
+	if (!sh_delalloc && (whichfork == XFS_DATA_FORK) &&
 		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
 		error = xfs_flush_pages(ip, (xfs_off_t)0,
@@ -5930,7 +5932,7 @@ xfs_getbmap(
 
 	bmv->bmv_entries = 0;
 
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0) {
+	if (!sh_delalloc && (XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
 		error = 0;
 		goto unlock_and_return;
 	}
@@ -5948,12 +5950,15 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out.bmv_oflags = (map[i].br_state == XFS_EXT_UNWRITTEN) ?
-					BMV_OF_PREALLOC : 0;
+ 			out.bmv_oflags = 0;
+ 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
+ 				out.bmv_oflags |= BMV_OF_PREALLOC;
+ 			else if (map[i].br_startblock == DELAYSTARTBLOCK)
+ 				out.bmv_oflags |= BMV_OF_DELALLOC;
 			out.bmv_offset = XFS_FSB_TO_BB(mp, map[i].br_startoff);
 			out.bmv_length = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out.bmv_unused1 = out.bmv_unused2 = 0;
-			ASSERT(map[i].br_startblock != DELAYSTARTBLOCK);
+			ASSERT(sh_delalloc || (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
Index: linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.27.x86_64.orig/fs/xfs/xfs_fs.h
+++ linux-2.6.27.x86_64/fs/xfs/xfs_fs.h
@@ -113,10 +113,13 @@ struct getbmapx {
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
 
 /*
  * Structure for XFS_IOC_FSSETDM.
