Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28FB07F58
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ABBD8F8065
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AKY6NeJtpDs9GiKh for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiD3-000178-ON
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiD3-00066Z-KL
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/27] xfs: move xfs_getbmap to xfs_extent_ops.c
Date: Wed, 12 Jun 2013 20:22:40 +1000
Message-Id: <1371032567-21772-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

While xfs_getbmap() walks the extent tree and formats it for
userspace, it's not really a core function of the block mapping API.
It is a user of the interface, and one that is kernel only
functionality. xfs_bmap.c is shared with libxfs, so to minimise the
differences between userspace and kernel files, move the getbmap
functionality to xfs_extent_ops.c. This provides a nice separation
between the core functionality and implementation of kernel
interfaces.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c       |  281 ----------------------------------------------
 fs/xfs/xfs_bmap.h       |    5 -
 fs/xfs/xfs_extent_ops.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_extent_ops.h |    6 +
 fs/xfs/xfs_iops.c       |    1 +
 5 files changed, 290 insertions(+), 286 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 747f2d3..7b8b3ab 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5790,287 +5790,6 @@ error0:
 }
 
 /*
- * returns 1 for success, 0 if we failed to map the extent.
- */
-STATIC int
-xfs_getbmapx_fix_eof_hole(
-	xfs_inode_t		*ip,		/* xfs incore inode pointer */
-	struct getbmapx		*out,		/* output structure */
-	int			prealloced,	/* this is a file with
-						 * preallocated data space */
-	__int64_t		end,		/* last block requested */
-	xfs_fsblock_t		startblock)
-{
-	__int64_t		fixlen;
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_ifork_t		*ifp;		/* inode fork pointer */
-	xfs_extnum_t		lastx;		/* last extent pointer */
-	xfs_fileoff_t		fileblock;
-
-	if (startblock == HOLESTARTBLOCK) {
-		mp = ip->i_mount;
-		out->bmv_block = -1;
-		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
-		fixlen -= out->bmv_offset;
-		if (prealloced && out->bmv_offset + out->bmv_length == end) {
-			/* Came to hole at EOF. Trim it. */
-			if (fixlen <= 0)
-				return 0;
-			out->bmv_length = fixlen;
-		}
-	} else {
-		if (startblock == DELAYSTARTBLOCK)
-			out->bmv_block = -2;
-		else
-			out->bmv_block = xfs_fsb_to_db(ip, startblock);
-		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
-		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
-		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
-			out->bmv_oflags |= BMV_OF_LAST;
-	}
-
-	return 1;
-}
-
-/*
- * Get inode's extents as described in bmv, and format for output.
- * Calls formatter to fill the user's buffer until all extents
- * are mapped, until the passed-in bmv->bmv_count slots have
- * been filled, or until the formatter short-circuits the loop,
- * if it is tracking filled-in extents on its own.
- */
-int						/* error code */
-xfs_getbmap(
-	xfs_inode_t		*ip,
-	struct getbmapx		*bmv,		/* user bmap structure */
-	xfs_bmap_format_t	formatter,	/* format to user */
-	void			*arg)		/* formatter arg */
-{
-	__int64_t		bmvend;		/* last block requested */
-	int			error = 0;	/* return value */
-	__int64_t		fixlen;		/* length for -1 case */
-	int			i;		/* extent number */
-	int			lock;		/* lock state */
-	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
-	xfs_mount_t		*mp;		/* file system mount point */
-	int			nex;		/* # of user extents can do */
-	int			nexleft;	/* # of user extents left */
-	int			subnex;		/* # of bmapi's can do */
-	int			nmap;		/* number of map entries */
-	struct getbmapx		*out;		/* output structure */
-	int			whichfork;	/* data or attr fork */
-	int			prealloced;	/* this is a file with
-						 * preallocated data space */
-	int			iflags;		/* interface flags */
-	int			bmapi_flags;	/* flags for xfs_bmapi */
-	int			cur_ext = 0;
-
-	mp = ip->i_mount;
-	iflags = bmv->bmv_iflags;
-	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
-
-	if (whichfork == XFS_ATTR_FORK) {
-		if (XFS_IFORK_Q(ip)) {
-			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
-			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
-			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
-				return XFS_ERROR(EINVAL);
-		} else if (unlikely(
-			   ip->i_d.di_aformat != 0 &&
-			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
-			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
-					 ip->i_mount);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
-
-		prealloced = 0;
-		fixlen = 1LL << 32;
-	} else {
-		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-			return XFS_ERROR(EINVAL);
-
-		if (xfs_get_extsz_hint(ip) ||
-		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
-			prealloced = 1;
-			fixlen = mp->m_super->s_maxbytes;
-		} else {
-			prealloced = 0;
-			fixlen = XFS_ISIZE(ip);
-		}
-	}
-
-	if (bmv->bmv_length == -1) {
-		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
-		bmv->bmv_length =
-			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
-	} else if (bmv->bmv_length == 0) {
-		bmv->bmv_entries = 0;
-		return 0;
-	} else if (bmv->bmv_length < 0) {
-		return XFS_ERROR(EINVAL);
-	}
-
-	nex = bmv->bmv_count - 1;
-	if (nex <= 0)
-		return XFS_ERROR(EINVAL);
-	bmvend = bmv->bmv_offset + bmv->bmv_length;
-
-
-	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
-		return XFS_ERROR(ENOMEM);
-	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out) {
-		out = kmem_zalloc_large(bmv->bmv_count *
-					sizeof(struct getbmapx));
-		if (!out)
-			return XFS_ERROR(ENOMEM);
-	}
-
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
-		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
-			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
-			if (error)
-				goto out_unlock_iolock;
-		}
-		/*
-		 * even after flushing the inode, there can still be delalloc
-		 * blocks on the inode beyond EOF due to speculative
-		 * preallocation. These are not removed until the release
-		 * function is called or the inode is inactivated. Hence we
-		 * cannot assert here that ip->i_delayed_blks == 0.
-		 */
-	}
-
-	lock = xfs_ilock_map_shared(ip);
-
-	/*
-	 * Don't let nex be bigger than the number of extents
-	 * we can have assuming alternating holes and real extents.
-	 */
-	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
-		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
-
-	bmapi_flags = xfs_bmapi_aflag(whichfork);
-	if (!(iflags & BMV_IF_PREALLOC))
-		bmapi_flags |= XFS_BMAPI_IGSTATE;
-
-	/*
-	 * Allocate enough space to handle "subnex" maps at a time.
-	 */
-	error = ENOMEM;
-	subnex = 16;
-	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
-	if (!map)
-		goto out_unlock_ilock;
-
-	bmv->bmv_entries = 0;
-
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
-	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
-		error = 0;
-		goto out_free_map;
-	}
-
-	nexleft = nex;
-
-	do {
-		nmap = (nexleft > subnex) ? subnex : nexleft;
-		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
-				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
-				       map, &nmap, bmapi_flags);
-		if (error)
-			goto out_free_map;
-		ASSERT(nmap <= subnex);
-
-		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out[cur_ext].bmv_oflags = 0;
-			if (map[i].br_state == XFS_EXT_UNWRITTEN)
-				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
-			else if (map[i].br_startblock == DELAYSTARTBLOCK)
-				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
-			out[cur_ext].bmv_offset =
-				XFS_FSB_TO_BB(mp, map[i].br_startoff);
-			out[cur_ext].bmv_length =
-				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			out[cur_ext].bmv_unused1 = 0;
-			out[cur_ext].bmv_unused2 = 0;
-
-			/*
-			 * delayed allocation extents that start beyond EOF can
-			 * occur due to speculative EOF allocation when the
-			 * delalloc extent is larger than the largest freespace
-			 * extent at conversion time. These extents cannot be
-			 * converted by data writeback, so can exist here even
-			 * if we are not supposed to be finding delalloc
-			 * extents.
-			 */
-			if (map[i].br_startblock == DELAYSTARTBLOCK &&
-			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
-				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
-
-                        if (map[i].br_startblock == HOLESTARTBLOCK &&
-			    whichfork == XFS_ATTR_FORK) {
-				/* came to the end of attribute fork */
-				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
-				goto out_free_map;
-			}
-
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
-					prealloced, bmvend,
-					map[i].br_startblock))
-				goto out_free_map;
-
-			bmv->bmv_offset =
-				out[cur_ext].bmv_offset +
-				out[cur_ext].bmv_length;
-			bmv->bmv_length =
-				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
-
-			/*
-			 * In case we don't want to return the hole,
-			 * don't increase cur_ext so that we can reuse
-			 * it in the next loop.
-			 */
-			if ((iflags & BMV_IF_NO_HOLES) &&
-			    map[i].br_startblock == HOLESTARTBLOCK) {
-				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
-				continue;
-			}
-
-			nexleft--;
-			bmv->bmv_entries++;
-			cur_ext++;
-		}
-	} while (nmap && nexleft && bmv->bmv_length);
-
- out_free_map:
-	kmem_free(map);
- out_unlock_ilock:
-	xfs_iunlock_map_shared(ip, lock);
- out_unlock_iolock:
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	for (i = 0; i < cur_ext; i++) {
-		int full = 0;	/* user array is full */
-
-		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
-		if (error || full)
-			break;
-	}
-
-	if (is_vmalloc_addr(out))
-		kmem_free_large(out);
-	else
-		kmem_free(out);
-	return error;
-}
-
-/*
  * dead simple method of punching delalyed allocation blocks from a range in
  * the inode. Walks a block at a time so will be slow, but is only executed in
  * rare error cases so the overhead is not critical. This will alays punch out
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 1cf1292..cbcaf00 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -18,7 +18,6 @@
 #ifndef __XFS_BMAP_H__
 #define	__XFS_BMAP_H__
 
-struct getbmap;
 struct xfs_bmbt_irec;
 struct xfs_ifork;
 struct xfs_inode;
@@ -206,13 +205,9 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 
 #ifdef __KERNEL__
-/* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
 
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 		int *committed);
-int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
-		xfs_bmap_format_t formatter, void *arg);
 int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		int whichfork, int *eof);
 int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_extent_ops.c b/fs/xfs/xfs_extent_ops.c
index 113d682..2702a3c 100644
--- a/fs/xfs/xfs_extent_ops.c
+++ b/fs/xfs/xfs_extent_ops.c
@@ -48,6 +48,7 @@
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_extent_ops.h"
 
 
 /*
@@ -769,3 +770,285 @@ xfs_change_file_space(
 		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp, 0);
 }
+
+/*
+ * returns 1 for success, 0 if we failed to map the extent.
+ */
+STATIC int
+xfs_getbmapx_fix_eof_hole(
+	xfs_inode_t		*ip,		/* xfs incore inode pointer */
+	struct getbmapx		*out,		/* output structure */
+	int			prealloced,	/* this is a file with
+						 * preallocated data space */
+	__int64_t		end,		/* last block requested */
+	xfs_fsblock_t		startblock)
+{
+	__int64_t		fixlen;
+	xfs_mount_t		*mp;		/* file system mount point */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last extent pointer */
+	xfs_fileoff_t		fileblock;
+
+	if (startblock == HOLESTARTBLOCK) {
+		mp = ip->i_mount;
+		out->bmv_block = -1;
+		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
+		fixlen -= out->bmv_offset;
+		if (prealloced && out->bmv_offset + out->bmv_length == end) {
+			/* Came to hole at EOF. Trim it. */
+			if (fixlen <= 0)
+				return 0;
+			out->bmv_length = fixlen;
+		}
+	} else {
+		if (startblock == DELAYSTARTBLOCK)
+			out->bmv_block = -2;
+		else
+			out->bmv_block = xfs_fsb_to_db(ip, startblock);
+		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
+			out->bmv_oflags |= BMV_OF_LAST;
+	}
+
+	return 1;
+}
+
+/*
+ * Get inode's extents as described in bmv, and format for output.
+ * Calls formatter to fill the user's buffer until all extents
+ * are mapped, until the passed-in bmv->bmv_count slots have
+ * been filled, or until the formatter short-circuits the loop,
+ * if it is tracking filled-in extents on its own.
+ */
+int						/* error code */
+xfs_getbmap(
+	xfs_inode_t		*ip,
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg)		/* formatter arg */
+{
+	__int64_t		bmvend;		/* last block requested */
+	int			error = 0;	/* return value */
+	__int64_t		fixlen;		/* length for -1 case */
+	int			i;		/* extent number */
+	int			lock;		/* lock state */
+	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
+	xfs_mount_t		*mp;		/* file system mount point */
+	int			nex;		/* # of user extents can do */
+	int			nexleft;	/* # of user extents left */
+	int			subnex;		/* # of bmapi's can do */
+	int			nmap;		/* number of map entries */
+	struct getbmapx		*out;		/* output structure */
+	int			whichfork;	/* data or attr fork */
+	int			prealloced;	/* this is a file with
+						 * preallocated data space */
+	int			iflags;		/* interface flags */
+	int			bmapi_flags;	/* flags for xfs_bmapi */
+	int			cur_ext = 0;
+
+	mp = ip->i_mount;
+	iflags = bmv->bmv_iflags;
+	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
+
+	if (whichfork == XFS_ATTR_FORK) {
+		if (XFS_IFORK_Q(ip)) {
+			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
+			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
+			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
+				return XFS_ERROR(EINVAL);
+		} else if (unlikely(
+			   ip->i_d.di_aformat != 0 &&
+			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
+			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
+					 ip->i_mount);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
+		prealloced = 0;
+		fixlen = 1LL << 32;
+	} else {
+		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+			return XFS_ERROR(EINVAL);
+
+		if (xfs_get_extsz_hint(ip) ||
+		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
+			prealloced = 1;
+			fixlen = mp->m_super->s_maxbytes;
+		} else {
+			prealloced = 0;
+			fixlen = XFS_ISIZE(ip);
+		}
+	}
+
+	if (bmv->bmv_length == -1) {
+		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
+		bmv->bmv_length =
+			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
+	} else if (bmv->bmv_length == 0) {
+		bmv->bmv_entries = 0;
+		return 0;
+	} else if (bmv->bmv_length < 0) {
+		return XFS_ERROR(EINVAL);
+	}
+
+	nex = bmv->bmv_count - 1;
+	if (nex <= 0)
+		return XFS_ERROR(EINVAL);
+	bmvend = bmv->bmv_offset + bmv->bmv_length;
+
+
+	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
+		return XFS_ERROR(ENOMEM);
+	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
+	if (!out) {
+		out = kmem_zalloc_large(bmv->bmv_count *
+					sizeof(struct getbmapx));
+		if (!out)
+			return XFS_ERROR(ENOMEM);
+	}
+
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
+		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
+			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
+			if (error)
+				goto out_unlock_iolock;
+		}
+		/*
+		 * even after flushing the inode, there can still be delalloc
+		 * blocks on the inode beyond EOF due to speculative
+		 * preallocation. These are not removed until the release
+		 * function is called or the inode is inactivated. Hence we
+		 * cannot assert here that ip->i_delayed_blks == 0.
+		 */
+	}
+
+	lock = xfs_ilock_map_shared(ip);
+
+	/*
+	 * Don't let nex be bigger than the number of extents
+	 * we can have assuming alternating holes and real extents.
+	 */
+	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
+		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
+
+	bmapi_flags = xfs_bmapi_aflag(whichfork);
+	if (!(iflags & BMV_IF_PREALLOC))
+		bmapi_flags |= XFS_BMAPI_IGSTATE;
+
+	/*
+	 * Allocate enough space to handle "subnex" maps at a time.
+	 */
+	error = ENOMEM;
+	subnex = 16;
+	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
+	if (!map)
+		goto out_unlock_ilock;
+
+	bmv->bmv_entries = 0;
+
+	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
+	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
+		error = 0;
+		goto out_free_map;
+	}
+
+	nexleft = nex;
+
+	do {
+		nmap = (nexleft > subnex) ? subnex : nexleft;
+		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
+				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
+				       map, &nmap, bmapi_flags);
+		if (error)
+			goto out_free_map;
+		ASSERT(nmap <= subnex);
+
+		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
+			out[cur_ext].bmv_oflags = 0;
+			if (map[i].br_state == XFS_EXT_UNWRITTEN)
+				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
+			else if (map[i].br_startblock == DELAYSTARTBLOCK)
+				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
+			out[cur_ext].bmv_offset =
+				XFS_FSB_TO_BB(mp, map[i].br_startoff);
+			out[cur_ext].bmv_length =
+				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
+			out[cur_ext].bmv_unused1 = 0;
+			out[cur_ext].bmv_unused2 = 0;
+
+			/*
+			 * delayed allocation extents that start beyond EOF can
+			 * occur due to speculative EOF allocation when the
+			 * delalloc extent is larger than the largest freespace
+			 * extent at conversion time. These extents cannot be
+			 * converted by data writeback, so can exist here even
+			 * if we are not supposed to be finding delalloc
+			 * extents.
+			 */
+			if (map[i].br_startblock == DELAYSTARTBLOCK &&
+			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
+
+                        if (map[i].br_startblock == HOLESTARTBLOCK &&
+			    whichfork == XFS_ATTR_FORK) {
+				/* came to the end of attribute fork */
+				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
+				goto out_free_map;
+			}
+
+			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
+					prealloced, bmvend,
+					map[i].br_startblock))
+				goto out_free_map;
+
+			bmv->bmv_offset =
+				out[cur_ext].bmv_offset +
+				out[cur_ext].bmv_length;
+			bmv->bmv_length =
+				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
+
+			/*
+			 * In case we don't want to return the hole,
+			 * don't increase cur_ext so that we can reuse
+			 * it in the next loop.
+			 */
+			if ((iflags & BMV_IF_NO_HOLES) &&
+			    map[i].br_startblock == HOLESTARTBLOCK) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}
+
+			nexleft--;
+			bmv->bmv_entries++;
+			cur_ext++;
+		}
+	} while (nmap && nexleft && bmv->bmv_length);
+
+ out_free_map:
+	kmem_free(map);
+ out_unlock_ilock:
+	xfs_iunlock_map_shared(ip, lock);
+ out_unlock_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	for (i = 0; i < cur_ext; i++) {
+		int full = 0;	/* user array is full */
+
+		/* format results & advance arg */
+		error = formatter(&arg, &out[i], &full);
+		if (error || full)
+			break;
+	}
+
+	if (is_vmalloc_addr(out))
+		kmem_free_large(out);
+	else
+		kmem_free(out);
+	return error;
+}
+
diff --git a/fs/xfs/xfs_extent_ops.h b/fs/xfs/xfs_extent_ops.h
index a737640..550a37d 100644
--- a/fs/xfs/xfs_extent_ops.h
+++ b/fs/xfs/xfs_extent_ops.h
@@ -21,4 +21,10 @@
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
 
+/* bmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+
+int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
+		xfs_bmap_format_t formatter, void *arg);
+
 #endif /* _XFS_EXTENT_OPS_H */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7f44efa..99775a2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
+#include "xfs_extent_ops.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
