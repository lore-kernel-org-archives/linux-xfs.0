Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8269D7E18
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:27:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09A73AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id grY7dFKe2qNUe7M6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:52 -0700 (PDT)
Subject: [PATCH 092/119] xfs: teach get_bmapx and fiemap about shared
	extents and the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:27:45 -0700
Message-ID: <146612686537.12839.9576429345676177064.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Teach xfs_getbmapx how to report shared extents and CoW fork contents,
then modify the FIEMAP formatters to set the appropriate flags.  A
previous version of this patch only modified the fiemap formatter,
which is insufficient.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    4 ++-
 fs/xfs/xfs_bmap_util.c |   66 ++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_iops.c      |    2 +
 3 files changed, 63 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6230230..b1af423 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -81,14 +81,16 @@ struct getbmapx {
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
 #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
+#define BMV_IF_COWFORK		0x20	/* return CoW fork rather than data */
 #define BMV_IF_VALID	\
 	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
-	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
+	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES|BMV_IF_COWFORK)
 
 /*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
 #define BMV_OF_DELALLOC		0x2	/* segment = delayed allocation */
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
+#define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
  * Structure for XFS_IOC_FSSETDM.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9285111..3d71a17 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -44,6 +44,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_refcount.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -391,6 +392,7 @@ xfs_bmap_count_blocks(
 STATIC int
 xfs_getbmapx_fix_eof_hole(
 	xfs_inode_t		*ip,		/* xfs incore inode pointer */
+	int			whichfork,
 	struct getbmapx		*out,		/* output structure */
 	int			prealloced,	/* this is a file with
 						 * preallocated data space */
@@ -420,7 +422,7 @@ xfs_getbmapx_fix_eof_hole(
 		else
 			out->bmv_block = xfs_fsb_to_db(ip, startblock);
 		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
-		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		ifp = XFS_IFORK_PTR(ip, whichfork);
 		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
 		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
 			out->bmv_oflags |= BMV_OF_LAST;
@@ -464,9 +466,19 @@ xfs_getbmap(
 
 	mp = ip->i_mount;
 	iflags = bmv->bmv_iflags;
-	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	if (whichfork == XFS_ATTR_FORK) {
+	if ((iflags & BMV_IF_ATTRFORK) && (iflags & BMV_IF_COWFORK))
+		return -EINVAL;
+
+	if (iflags & BMV_IF_ATTRFORK)
+		whichfork = XFS_ATTR_FORK;
+	else if (iflags & BMV_IF_COWFORK)
+		whichfork = XFS_COW_FORK;
+	else
+		whichfork = XFS_DATA_FORK;
+
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
 		if (XFS_IFORK_Q(ip)) {
 			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
 			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
@@ -482,7 +494,15 @@ xfs_getbmap(
 
 		prealloced = 0;
 		fixlen = 1LL << 32;
-	} else {
+		break;
+	case XFS_COW_FORK:
+		if (ip->i_cformat != XFS_DINODE_FMT_EXTENTS)
+			return -EINVAL;
+
+		prealloced = 0;
+		fixlen = XFS_ISIZE(ip);
+		break;
+	default:
 		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
@@ -496,6 +516,7 @@ xfs_getbmap(
 			prealloced = 0;
 			fixlen = XFS_ISIZE(ip);
 		}
+		break;
 	}
 
 	if (bmv->bmv_length == -1) {
@@ -522,7 +543,8 @@ xfs_getbmap(
 		return -ENOMEM;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	if (whichfork == XFS_DATA_FORK) {
+	switch (whichfork) {
+	case XFS_DATA_FORK:
 		if (!(iflags & BMV_IF_DELALLOC) &&
 		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
 			error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
@@ -540,8 +562,14 @@ xfs_getbmap(
 		}
 
 		lock = xfs_ilock_data_map_shared(ip);
-	} else {
+		break;
+	case XFS_COW_FORK:
+		lock = XFS_ILOCK_SHARED;
+		xfs_ilock(ip, lock);
+		break;
+	case XFS_ATTR_FORK:
 		lock = xfs_ilock_attr_map_shared(ip);
+		break;
 	}
 
 	/*
@@ -616,8 +644,30 @@ xfs_getbmap(
 				goto out_free_map;
 			}
 
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
-					prealloced, bmvend,
+			/* Is this a shared block? */
+			if (whichfork == XFS_DATA_FORK &&
+			    map[i].br_startblock != DELAYSTARTBLOCK &&
+			    map[i].br_startblock != HOLESTARTBLOCK &&
+			    !ISUNWRITTEN(&map[i]) && xfs_is_reflink_inode(ip)) {
+				xfs_agblock_t	ebno;
+				xfs_extlen_t	elen;
+
+				error = xfs_refcount_find_shared(mp,
+						XFS_FSB_TO_AGNO(mp,
+							map[i].br_startblock),
+						XFS_FSB_TO_AGBNO(mp,
+							map[i].br_startblock),
+						map[i].br_blockcount,
+						&ebno, &elen, true);
+				if (error)
+					goto out_free_map;
+				if (elen)
+					out[cur_ext].bmv_oflags |=
+							BMV_OF_SHARED;
+			}
+
+			if (!xfs_getbmapx_fix_eof_hole(ip, whichfork,
+					&out[cur_ext], prealloced, bmvend,
 					map[i].br_startblock))
 				goto out_free_map;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c5d4eba..e57bfe8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1025,6 +1025,8 @@ xfs_fiemap_format(
 
 	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
 		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
+	else if (bmv->bmv_oflags & BMV_OF_SHARED)
+		fiemap_flags |= FIEMAP_EXTENT_SHARED;
 	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
 		fiemap_flags |= (FIEMAP_EXTENT_DELALLOC |
 				 FIEMAP_EXTENT_UNKNOWN);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
