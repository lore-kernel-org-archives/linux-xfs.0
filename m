Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 002617DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:37:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 775A4AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qHHcP7sH51thQpo7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:15 -0700 (PDT)
Subject: [PATCH 48/71] xfs: teach get_bmapx about shared extents and the CoW
	fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:11 -0700
Message-ID: <147216823143.867.5001532335455709937.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Teach xfs_getbmapx how to report shared extents and CoW fork contents
accurately in the bmap output by querying the refcount btree
appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +
 fs/xfs/xfs_bmap_util.c |  132 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 121 insertions(+), 15 deletions(-)


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
index 4ece4f2..5e1c679f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -42,6 +42,9 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_iomap.h"
+#include "xfs_reflink.h"
+#include "xfs_refcount.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -389,11 +392,13 @@ xfs_bmap_count_blocks(
 STATIC int
 xfs_getbmapx_fix_eof_hole(
 	xfs_inode_t		*ip,		/* xfs incore inode pointer */
+	int			whichfork,
 	struct getbmapx		*out,		/* output structure */
 	int			prealloced,	/* this is a file with
 						 * preallocated data space */
 	__int64_t		end,		/* last block requested */
-	xfs_fsblock_t		startblock)
+	xfs_fsblock_t		startblock,
+	bool			moretocome)
 {
 	__int64_t		fixlen;
 	xfs_mount_t		*mp;		/* file system mount point */
@@ -418,8 +423,9 @@ xfs_getbmapx_fix_eof_hole(
 		else
 			out->bmv_block = xfs_fsb_to_db(ip, startblock);
 		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
-		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		ifp = XFS_IFORK_PTR(ip, whichfork);
+		if (!moretocome &&
+		    xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
 		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
 			out->bmv_oflags |= BMV_OF_LAST;
 	}
@@ -459,12 +465,23 @@ xfs_getbmap(
 	int			iflags;		/* interface flags */
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 	int			cur_ext = 0;
+	struct xfs_bmbt_irec	inject_map;
 
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
@@ -480,7 +497,15 @@ xfs_getbmap(
 
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
@@ -494,6 +519,7 @@ xfs_getbmap(
 			prealloced = 0;
 			fixlen = XFS_ISIZE(ip);
 		}
+		break;
 	}
 
 	if (bmv->bmv_length == -1) {
@@ -520,7 +546,8 @@ xfs_getbmap(
 		return -ENOMEM;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	if (whichfork == XFS_DATA_FORK) {
+	switch (whichfork) {
+	case XFS_DATA_FORK:
 		if (!(iflags & BMV_IF_DELALLOC) &&
 		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
 			error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
@@ -538,8 +565,14 @@ xfs_getbmap(
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
@@ -581,7 +614,8 @@ xfs_getbmap(
 			goto out_free_map;
 		ASSERT(nmap <= subnex);
 
-		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
+		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
+				cur_ext < bmv->bmv_count; i++) {
 			out[cur_ext].bmv_oflags = 0;
 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
 				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
@@ -614,9 +648,74 @@ xfs_getbmap(
 				goto out_free_map;
 			}
 
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
-					prealloced, bmvend,
-					map[i].br_startblock))
+			/* Is this a shared block? */
+			inject_map.br_blockcount = 0;
+			if (whichfork == XFS_DATA_FORK &&
+			    map[i].br_startblock != DELAYSTARTBLOCK &&
+			    map[i].br_startblock != HOLESTARTBLOCK &&
+			    !ISUNWRITTEN(&map[i]) && xfs_is_reflink_inode(ip)) {
+				xfs_agblock_t	agbno;
+				xfs_agblock_t	ebno;
+				xfs_extlen_t	elen;
+				xfs_extlen_t	nlen;
+
+				agbno = XFS_FSB_TO_AGBNO(mp,
+						map[i].br_startblock);
+				error = xfs_reflink_find_shared(mp,
+						XFS_FSB_TO_AGNO(mp,
+							map[i].br_startblock),
+						agbno,
+						map[i].br_blockcount,
+						&ebno, &elen, true);
+				if (error)
+					goto out_free_map;
+
+				inject_map = map[i];
+				if (agbno == ebno) {
+					/*
+					 * Shared extent at (agbno, elen).
+					 * Shrink the reported extent length
+					 * and prepare to move the start of
+					 * map[i] to agbno+elen, with the aim
+					 * of (re)formatting the new map[i]
+					 * the next time through the inner
+					 * loop.
+					 */
+					out[cur_ext].bmv_length =
+							XFS_FSB_TO_BB(mp, elen);
+					out[cur_ext].bmv_oflags |=
+							BMV_OF_SHARED;
+					inject_map.br_startblock += elen;
+					inject_map.br_startoff += elen;
+					inject_map.br_blockcount -= elen;
+					map[i].br_blockcount -= elen;
+				} else {
+					/*
+					 * There's an unshared extent
+					 * (agbno, ebno - agbno) followed by
+					 * shared extent at (ebno, elen).
+					 * Shrink the reported extent length to
+					 * cover only the unshared extent and
+					 * prepare to move up the start of
+					 * map[i] to ebno, with the aim of
+					 * (re)formatting the new map[i] the
+					 * next time through the inner
+					 * loop.
+					 */
+					nlen = ebno - agbno;
+					out[cur_ext].bmv_length =
+							XFS_FSB_TO_BB(mp, nlen);
+					inject_map.br_startblock += nlen;
+					inject_map.br_startoff += nlen;
+					inject_map.br_blockcount -= nlen;
+					map[i].br_blockcount -= nlen;
+				}
+			}
+
+			if (!xfs_getbmapx_fix_eof_hole(ip, whichfork,
+					&out[cur_ext], prealloced, bmvend,
+					map[i].br_startblock,
+					inject_map.br_blockcount != 0))
 				goto out_free_map;
 
 			bmv->bmv_offset =
@@ -636,11 +735,16 @@ xfs_getbmap(
 				continue;
 			}
 
-			nexleft--;
+			if (inject_map.br_blockcount) {
+				map[i] = inject_map;
+				i--;
+			} else
+				nexleft--;
 			bmv->bmv_entries++;
 			cur_ext++;
 		}
-	} while (nmap && nexleft && bmv->bmv_length);
+	} while (nmap && nexleft && bmv->bmv_length &&
+		 cur_ext < bmv->bmv_count);
 
  out_free_map:
 	kmem_free(map);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
