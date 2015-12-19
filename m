Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0ECEF80BC
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87D85AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:48 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JHqGXNFh6f47D0LW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:47 -0800 (PST)
Subject: [PATCH 48/76] xfs: introduce reflink utility functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:01:44 -0800
Message-ID: <20151219090144.12713.14500.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_refcount.c |  118 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    4 +
 2 files changed, 122 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c9d6e5d..49f6a7a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1012,3 +1012,121 @@ xfs_refcount_put_extent(
 	xfs_trans_brelse(tp, agbp);
 	return error;
 }
+
+/**
+ * xfs_refcount_find_shared() -- Given an AG extent, find the lowest-numbered
+ *				 run of shared blocks within that range.
+ *
+ * @mp: XFS mount.
+ * @agno: AG number.
+ * @agbno: AG block number to start searching.
+ * @aglen: Length of the range to search.
+ * @fbno: Returns the AG block number of the first shared range, or
+ *     agbno + aglen if no shared blocks are found.
+ * @flen: Returns the length of the shared range found, or 0 if no shared
+ *     blocks are found.
+ * @find_maximal: If true, find the length of the run of shared blocks.
+ *     Otherwise, the length of the first refcount extent is found.
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 074d620..e8e0beb 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -38,4 +38,8 @@ extern int xfs_refcount_put_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_bmap_free *flist, xfs_fsblock_t fsbno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo);
 
+extern int xfs_refcount_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
+		xfs_extlen_t *flen, bool find_maximal);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
