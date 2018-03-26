Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeCZX4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 19:56:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2QNknSm130841
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:22 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2gyau3g0mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:22 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuLaW029403
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:21 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2QNuKv0020491
        for <linux-xfs@vger.kernel.org>; Mon, 26 Mar 2018 23:56:21 GMT
Subject: [PATCH 04/20] xfs: add repair helpers for the reference count btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 26 Mar 2018 16:56:19 -0700
Message-ID: <152210857946.13184.11202190514229464537.stgit@magnolia>
In-Reply-To: <152210855435.13184.6475770131389744177.stgit@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the refcount btree and generic btree code
that will be used to repair the refcountbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c    |   21 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h    |    1 +
 fs/xfs/libxfs/xfs_refcount.c |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    2 ++
 4 files changed, 41 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ec6a464..07bc8bd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5028,3 +5028,24 @@ xfs_btree_has_record(
 	*exists = false;
 	return error;
 }
+
+/* Are there more records in this btree? */
+bool
+xfs_btree_has_more_records(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+	/* There are still records in this block. */
+	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
+		return true;
+
+	/* There are more record blocks. */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
+	else
+		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7b5f1db..3d094ed 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -549,5 +549,6 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 		union xfs_btree_key *key);
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
+bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 100532d..9103be0 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -88,6 +88,23 @@ xfs_refcount_lookup_ge(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
+/*
+ * Look up the first record equal to [bno, len] in the btree
+ * given by cur.
+ */
+int
+xfs_refcount_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 5856abb..a92ad90 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -24,6 +24,8 @@ extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
+extern int xfs_refcount_lookup_eq(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 

