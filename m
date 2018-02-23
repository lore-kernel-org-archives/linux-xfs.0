Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWCOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:14:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N2CPEB076319
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:14:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2ga9bpg3qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:14:20 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N22AkO018081
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:02:10 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1N22ALW016237
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:02:10 GMT
Subject: [PATCH 04/20] xfs: add repair helpers for the reference count btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:02:09 -0800
Message-ID: <151935132967.22097.3139627527681154429.stgit@magnolia>
In-Reply-To: <151935130484.22097.9694510081310029779.stgit@magnolia>
References: <151935130484.22097.9694510081310029779.stgit@magnolia>
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
 

