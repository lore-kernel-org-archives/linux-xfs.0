Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9I59qg6151045 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 00:09:52 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Md96y2mQFfN7Wyxo for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 22:11:29 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: implement FIEMAP_FLAG_FREESPACE_*
Date: Thu, 18 Oct 2012 16:11:19 +1100
Message-Id: <1350537079-16246-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1350537079-16246-1-git-send-email-david@fromorbit.com>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

As you wish.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |  219 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_alloc.h |    7 ++
 fs/xfs/xfs_iops.c  |   12 ++-
 3 files changed, 237 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 335206a..ee680c9 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2470,3 +2470,222 @@ error0:
 	xfs_perag_put(args.pag);
 	return error;
 }
+
+/*
+ * Walk the extents in the tree given by the cursor, and dump them all into the
+ * fieinfo. At the last extent in the tree, set the FIEMAP_EXTENT_LAST flag so
+ * that we return only free space from this tree in a given request.
+ */
+static int
+xfs_alloc_ag_freespace_map(
+	struct xfs_btree_cur    *cur,
+	struct fiemap_extent_info *fieinfo,
+	xfs_agblock_t		sagbno,
+	xfs_agblock_t		eagbno)
+{
+	int	error = 0;
+	int	i = 1;
+
+	/*
+	 * Loop until we have either filled the fiemap or reached the end of
+	 * the AG walk.
+	 */
+	while (i) {
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+		xfs_daddr_t	dbno;
+		xfs_fileoff_t	dlen;
+		int		flags = 0;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			break;
+		XFS_WANT_CORRUPTED_RETURN(i == 1);
+
+		/*
+		 * move the cursor now to make it easy to continue the loop and
+		 * detect the last extent in the lookup.
+		 */
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			break;
+
+		/* range check - must be wholly withing requested range */
+		if (fbno < sagbno ||
+		    (eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
+		xfs_warn(cur->bc_mp, "10: %d/%d, %d/%d", sagbno, eagbno, fbno, flen);
+			continue;
+		}
+
+		/*
+		 * use daddr format for all range/len calculations as that is
+		 * the format the range/len variables are supplied in by
+		 * userspace.
+		 */
+		dbno = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno, fbno);
+		dlen = XFS_FSB_TO_BB(cur->bc_mp, flen);
+
+		if (i == 0)
+			flags |= FIEMAP_EXTENT_LAST;
+		error = -fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
+						BBTOB(dbno), BBTOB(dlen), flags);
+		if (error)
+			break;
+	}
+	return error;
+
+}
+
+/*
+ * Map the freespace from the requested range in the requested order.
+ *
+ * To make things simple, this function will only return the freespace from a
+ * single AG regardless of the size of the map passed in. That AG will be the AG
+ * that the first freespace is found in. In other words, FIEMAP_EXTENT_LAST does
+ * not mean the last freespace extent has been mapped, just that the last extent
+ * in a given freespace index has been mapped. The caller is responsible for
+ * moving the range to the next freespace region if it needs to query for more
+ * information.
+ *
+ * IOWs, the caller is responsible for knowing about the XFS filesystem
+ * structure and how it indexes freespace to use this call effectively.
+ */
+#define XFS_FREESP_FLAGS (FIEMAP_FLAG_FREESPACE | FIEMAP_FLAG_FREESPACE_SIZE)
+int
+xfs_alloc_freespace_map(
+	struct xfs_mount	*mp,
+	struct fiemap_extent_info *fieinfo,
+	u64			start,
+	u64			length)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	xfs_agnumber_t		sagno;
+	xfs_agblock_t		sagbno;
+	xfs_agnumber_t		eagno;
+	xfs_agblock_t		eagbno;
+	bool			bycnt;
+	int			error = 0;
+
+	/* can only have one type of mapping */
+	if ((fieinfo->fi_flags & XFS_FREESP_FLAGS) == XFS_FREESP_FLAGS) {
+		xfs_warn(mp, "1: 0x%x\n", fieinfo->fi_flags);
+		return EINVAL;
+	}
+	bycnt = (fieinfo->fi_flags & FIEMAP_FLAG_FREESPACE_SIZE);
+
+	if (XFS_B_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks) {
+		xfs_warn(mp, "2: %lld, %lld/%lld\n", start,
+				XFS_B_TO_FSB(mp, start), mp->m_sb.sb_dblocks);
+		return EINVAL;
+	}
+	if (length < mp->m_sb.sb_blocksize) {
+		xfs_warn(mp, "3: %lld, %d\n", length, mp->m_sb.sb_blocksize);
+		return EINVAL;
+	}
+	if (start + length < start) {
+		xfs_warn(mp, "4: %lld/%lld, %lld", start, length, start + length);
+		return EINVAL;
+	}
+
+	sagno = xfs_daddr_to_agno(mp, BTOBB(start));
+	sagbno = xfs_daddr_to_agbno(mp, BTOBB(start));
+
+	eagno = xfs_daddr_to_agno(mp, BTOBB(start + length));
+	eagbno = xfs_daddr_to_agbno(mp, BTOBB(start + length));
+
+	if (sagno == eagno && sagbno == eagbno) {
+		xfs_warn(mp, "5: %d/%d, %d/%d", sagno, eagno, sagbno, eagbno);
+		return EINVAL;
+	}
+
+	/*
+	 * Force out the log.  This means any transactions that might have freed
+	 * space before we took the AGF buffer lock are now on disk, and the
+	 * volatile disk cache is flushed.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * Do initial lookup in by-bno tree. Keep skipping AGs until with
+	 * either find a free space extent or reach the end of the search.
+	 */
+	for (agno = sagno; agno < eagno; agno++) {
+		int	i;
+		error = 0;
+
+		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		if (error || !agbp) {
+			xfs_warn(mp, "7: %p, %d", agbp, error);
+			goto next;
+		}
+
+		pag = xfs_perag_get(mp, agno);
+		if (pag->pagf_freeblks <= pag->pagf_flcount) {
+			/* no free space worth reporting */
+			xfs_warn(mp, "6: %d %d", pag->pagf_freeblks,
+						pag->pagf_flcount);
+			goto put_agbp;
+		}
+
+		cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
+					      XFS_BTNUM_BNO);
+		error = xfs_alloc_lookup_ge(cur, 0, sagbno, &i);
+		if (error) {
+			xfs_warn(mp, "8: %d/%d, %d/%d", sagno, eagno, sagbno, eagbno);
+			goto del_cursor;
+		}
+		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+
+		if (!bycnt) {
+			/*
+			 * if we are doing a bno ordered lookup, we can just
+			 * loop across the free space extents formatting them
+			 * until we get to the end of the AG, eagbno or fill the
+			 * fieinfo map.
+			 */
+			error = xfs_alloc_ag_freespace_map(cur, fieinfo, sagbno,
+					agno == eagno ? eagbno : NULLAGBLOCK);
+		} else {
+			/*
+			 * We are doing a size ordered lookup. We know there is
+			 * a free space extent somewhere past out start bno, so
+			 * just kill the current cursor and start a size
+			 * ordered scan to find all the freespace in the given
+			 * range.
+			 */
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
+						      XFS_BTNUM_CNT);
+			error = xfs_alloc_lookup_ge(cur, 0, 1, &i);
+			if (error)
+				goto del_cursor;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
+
+			error = xfs_alloc_ag_freespace_map(cur, fieinfo, sagbno,
+					agno == eagno ? eagbno : NULLAGBLOCK);
+		}
+
+del_cursor:
+		xfs_btree_del_cursor(cur, error < 0 ? XFS_BTREE_ERROR
+						    : XFS_BTREE_NOERROR);
+put_agbp:
+		xfs_perag_put(pag);
+		xfs_buf_relse(agbp);
+next:
+		if (error)
+			break;
+		sagbno = 0;
+	}
+
+	/*
+	 * negative errno indicates that we hit a FIEMAP_EXTENT_LAST flag. Clear
+	 * the error in that case.
+	 */
+	if (error < 0)
+		error = 0;
+
+	return error;;
+}
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index feacb06..371b02c 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -231,4 +231,11 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
+int
+xfs_alloc_freespace_map(
+	struct xfs_mount	*mp,
+	struct fiemap_extent_info *fieinfo,
+	u64			start,
+	u64			length);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4e00cf0..4555525 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -938,7 +938,9 @@ xfs_vn_update_time(
 	return -xfs_trans_commit(tp, 0);
 }
 
-#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
+#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR | \
+				 FIEMAP_FLAG_FREESPACE |		\
+				 FIEMAP_FLAG_FREESPACE_SIZE)
 
 /*
  * Call fiemap helper to fill in user data.
@@ -997,6 +999,13 @@ xfs_vn_fiemap(
 	if (error)
 		return error;
 
+	if ((fieinfo->fi_flags &
+			(FIEMAP_FLAG_FREESPACE | FIEMAP_FLAG_FREESPACE_SIZE))) {
+		error = xfs_alloc_freespace_map(ip->i_mount, fieinfo,
+						start, length);
+		goto out;
+	}
+
 	/* Set up bmap header for xfs internal routine */
 	bm.bmv_offset = BTOBB(start);
 	/* Special case for whole file */
@@ -1017,6 +1026,7 @@ xfs_vn_fiemap(
 		bm.bmv_iflags |= BMV_IF_DELALLOC;
 
 	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
+out:
 	if (error)
 		return -error;
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
