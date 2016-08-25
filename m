Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 109BA7D7C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:34:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7A9C304051
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id aHe7nIqlz4CBxPjG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:24 -0700 (PDT)
Subject: [PATCH 22/71] xfs: introduce reflink utility functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:34:18 -0700
Message-ID: <147216805883.867.2849292964061840223.stgit@birch.djwong.org>
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

These functions will be used by the other reflink functions to find
the maximum length of a range of shared blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.coM>
---
 fs/xfs/libxfs/xfs_refcount.c |  100 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    4 ++
 2 files changed, 104 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b52ecfe..58b7770 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1128,3 +1128,103 @@ xfs_refcount_decrease_extent(
 	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_DECREASE,
 			PREV->br_startblock, PREV->br_blockcount);
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
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			aglen,
+	xfs_agblock_t			*fbno,
+	xfs_extlen_t			*flen,
+	bool				find_maximal)
+{
+	struct xfs_refcount_irec	tmp;
+	int				i;
+	int				have;
+	int				error;
+
+	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_private.a.agno,
+			agbno, aglen);
+
+	/* By default, skip the whole range */
+	*fbno = agbno + aglen;
+	*flen = 0;
+
+	/* Try to find a refcount extent that crosses the start */
+	error = xfs_refcount_lookup_le(cur, agbno, &have);
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
+	error = xfs_refcount_get_rec(cur, &tmp, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
+
+	/* If the extent ends before the start, look at the next one */
+	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto out_error;
+		if (!have)
+			goto done;
+		error = xfs_refcount_get_rec(cur, &tmp, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
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
+		error = xfs_refcount_get_rec(cur, &tmp, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
+		if (tmp.rc_startblock >= agbno + aglen ||
+		    tmp.rc_startblock != *fbno + *flen)
+			break;
+		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
+	}
+
+done:
+	trace_xfs_refcount_find_shared_result(cur->bc_mp,
+			cur->bc_private.a.agno, *fbno, *flen);
+
+out_error:
+	if (error)
+		trace_xfs_refcount_find_shared_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 605d7d7..0ec9a28 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -53,4 +53,8 @@ extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
 		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
 
+extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
+		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
+		xfs_extlen_t *flen, bool find_maximal);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
