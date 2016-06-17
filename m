Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2AC382D1
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:39:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C37F4304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:39:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CsbY3pEoOVHAZydQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:39:50 -0700 (PDT)
Subject: [PATCH 085/145] xfs: introduce reflink utility functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:39:44 -0700
Message-ID: <146612758493.16048.18392330941529369752.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

These functions will be used by the other reflink functions to find
the maximum length of a range of shared blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.coM>
---
 include/xfs_trace.h   |    3 +
 libxfs/xfs_refcount.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h |    4 ++
 3 files changed, 116 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 0b167e9..d3b2486 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -252,6 +252,9 @@
 #define trace_xfs_refcount_deferred(...)	((void) 0)
 #define trace_xfs_refcount_defer(...)		((void) 0)
 #define trace_xfs_refcount_finish_one_leftover(...)	((void) 0)
+#define trace_xfs_refcount_find_shared(...)	((void) 0)
+#define trace_xfs_refcount_find_shared_result(...)	((void) 0)
+#define trace_xfs_refcount_find_shared_error(...)	((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 55859cd..d2b614b 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1128,3 +1128,112 @@ xfs_refcount_decrease_extent(
 
 	return __xfs_refcount_add(mp, dfops, &ri);
 }
+
+/*
+ * Given an AG extent, find the lowest-numbered run of shared blocks within
+ * that range and return the range in fbno/flen.  If find_maximal is set,
+ * return the longest extent of shared blocks; if not, just return the first
+ * extent we find.  If no shared blocks are found, flen will be set to zero.
+ */
+int
+xfs_refcount_find_shared(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_maximal)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	struct xfs_refcount_irec	tmp;
+	int			error;
+	int			i, have;
+	int			bt_error = XFS_BTREE_ERROR;
+
+	trace_xfs_refcount_find_shared(mp, agno, agbno, aglen);
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto out;
+	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+
+	/* By default, skip the whole range */
+	*fbno = agbno + aglen;
+	*flen = 0;
+
+	/* Try to find a refcount extent that crosses the start */
+	error = xfs_refcountbt_lookup_le(cur, agbno, &have);
+	if (error)
+		goto out_error;
+	if (!have) {
+		/* No left extent, look at the next one */
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have)
+			goto done;
+	}
+	error = xfs_refcountbt_get_rec(cur, &tmp, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	/* If the extent ends before the start, look at the next one */
+	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have)
+			goto done;
+		error = xfs_refcountbt_get_rec(cur, &tmp, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	}
+
+	/* If the extent ends after the range we want, bail out */
+	if (tmp.rc_startblock >= agbno + aglen)
+		goto done;
+
+	/* We found the start of a shared extent! */
+	if (tmp.rc_startblock < agbno) {
+		tmp.rc_blockcount -= (agbno - tmp.rc_startblock);
+		tmp.rc_startblock = agbno;
+	}
+
+	*fbno = tmp.rc_startblock;
+	*flen = min(tmp.rc_blockcount, agbno + aglen - *fbno);
+	if (!find_maximal)
+		goto done;
+
+	/* Otherwise, find the end of this shared extent */
+	while (*fbno + *flen < agbno + aglen) {
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have)
+			break;
+		error = xfs_refcountbt_get_rec(cur, &tmp, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (tmp.rc_startblock >= agbno + aglen ||
+		    tmp.rc_startblock != *fbno + *flen)
+			break;
+		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
+	}
+
+done:
+	bt_error = XFS_BTREE_NOERROR;
+	trace_xfs_refcount_find_shared_result(mp, agno, *fbno, *flen);
+
+out_error:
+	xfs_btree_del_cursor(cur, bt_error);
+	xfs_buf_relse(agbp);
+out:
+	if (error)
+		trace_xfs_refcount_find_shared_error(mp, agno, error, _RET_IP_);
+	return error;
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 92c05ea..b7b83b8 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -53,4 +53,8 @@ extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
 		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
 
+extern int xfs_refcount_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
+		xfs_extlen_t *flen, bool find_maximal);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
