Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756963AbdLWAsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:48:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0lmpW002298
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:48:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2f1cvf0049-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:48:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0hUih013442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0hUUC031434
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:30 GMT
Subject: [PATCH 06/21] xfs: add scrub cross-referencing helpers for the free
 space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:43:29 -0800
Message-ID: <151398980952.18741.2406350344342839518.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the free space btrees that will be used
to cross-reference metadata against the bnobt/cntbt, and a generic
btree function that provides the real implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   21 ++++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.h |   10 ++++++++++
 fs/xfs/libxfs/xfs_btree.c |   29 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 4 files changed, 61 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 83ed771..82333fc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -167,7 +167,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-static int				/* error */
+int					/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
@@ -2981,3 +2981,22 @@ xfs_verify_fsbno(
 		return false;
 	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_alloc_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.a.ar_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.a.ar_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 7ba2d12..65a0caf 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -198,6 +198,13 @@ xfs_free_extent(
 	enum xfs_ag_resv_type	type);	/* block reservation type */
 
 int				/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
+int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
@@ -237,4 +244,7 @@ bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno);
 bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 
+int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exist);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5f33adf..e0bdff3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4953,3 +4953,32 @@ xfs_btree_diff_two_ptrs(
 		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
+
+/* If there's an extent, we're done. */
+STATIC int
+xfs_btree_has_record_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/* Is there a record covering a given range of keys? */
+int
+xfs_btree_has_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_irec	*low,
+	union xfs_btree_irec	*high,
+	bool			*exists)
+{
+	int			error;
+
+	error = xfs_btree_query_range(cur, low, high,
+			&xfs_btree_has_record_helper, NULL);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		return error;
+	*exists = error == XFS_BTREE_QUERY_RANGE_ABORT;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b57501c..551a2a0 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -545,5 +545,7 @@ void xfs_btree_get_keys(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, union xfs_btree_key *key);
 union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 		union xfs_btree_key *key);
+int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
+		union xfs_btree_irec *high, bool *exists);
 
 #endif	/* __XFS_BTREE_H__ */

