Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63898C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9B920CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qHNIh9br"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgEGMUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9B1C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fMOAN3D/1wLReLCLth+OxB6iF/+yFPRYov2SHrOIs+Q=; b=qHNIh9brc4CGtK8v7vAu0XEKol
        ZkQpnKsHb8CdbhVhO/Ks2w9JHzSgSEPREHCB+ad3EQRKa6/eveEpKK8DYfuDC4kA+p5CsEdXf78PF
        AzerU1aDhINEeL/odIowQ0slswfbIB2DzEjK7+tEFsMWNBttnGeCl4sNAWIz2FM+Was9dyG2/bCqo
        gleIUqbN75IPZoOpWbkNfD+zpg2eoWy4mgFvTx3lCuyFDE1Gi3tP0mjrCXOQrVVS4Iw31Qq2NaSEt
        DcgfVVp1uaZ9xnDD7ytlE9XGGNb5gmxML69BG9fJEsZJFKwikuVzRM3Mt5zykq8FCsBNNBeHMN/T+
        giwqKkYg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWH-0007vV-IP; Thu, 07 May 2020 12:20:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 49/58] xfs: introduce fake roots for inode-rooted btrees
Date:   Thu,  7 May 2020 14:18:42 +0200
Message-Id: <20200507121851.304002-50-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 349e1c0380dbb7f552e4ea61b479c293eb076b3f

Create an in-core fake root for inode-rooted btree types so that callers
can generate a whole new btree using the upcoming btree bulk load
function without making the new tree accessible from the rest of the
filesystem.  It is up to the individual btree type to provide a function
to create a staged cursor (presumably with the appropriate callouts to
update the fakeroot) and then commit the staged root back into the
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h        |  1 +
 libxfs/xfs_btree.c         | 14 ++++++-
 libxfs/xfs_btree.h         |  3 ++
 libxfs/xfs_btree_staging.c | 84 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree_staging.h | 28 +++++++++++++
 5 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index bb409444..277a1448 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -47,6 +47,7 @@
 #define trace_xfs_btree_updkeys(a,b,c)		((void) 0)
 #define trace_xfs_btree_overlapped_query_range(a,b,c)	((void) 0)
 #define trace_xfs_btree_commit_afakeroot(cur)	((void) 0)
+#define trace_xfs_btree_commit_ifakeroot(cur)	((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a2ab7cf3..a376cc9c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -642,6 +642,17 @@ xfs_btree_ptr_addr(
 		((char *)block + xfs_btree_ptr_offset(cur, n, level));
 }
 
+struct xfs_ifork *
+xfs_btree_ifork_ptr(
+	struct xfs_btree_cur	*cur)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	if (cur->bc_flags & XFS_BTREE_STAGING)
+		return cur->bc_ino.ifake->if_fork;
+	return XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
+}
+
 /*
  * Get the root block which is stored in the inode.
  *
@@ -652,9 +663,8 @@ STATIC struct xfs_btree_block *
 xfs_btree_get_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
-	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 82b906b5..07b1d280 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_ifork;
 
 extern kmem_zone_t	*xfs_btree_cur_zone;
 
@@ -198,6 +199,7 @@ struct xfs_btree_cur_ag {
 /* Btree-in-inode cursor information */
 struct xfs_btree_cur_ino {
 	struct xfs_inode		*ip;
+	struct xbtree_ifakeroot		*ifake;	/* for staging cursor */
 	int				allocated;
 	short				forksize;
 	char				whichfork;
@@ -509,6 +511,7 @@ union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
+struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
 /* Does this cursor point to the last block in the given level? */
 static inline bool
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 247683c6..d4c52d4f 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -177,3 +177,87 @@ xfs_btree_commit_afakeroot(
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
+
+/*
+ * Bulk Loading for Inode-Rooted Btrees
+ * ====================================
+ *
+ * For a btree rooted in an inode fork, pass a xbtree_ifakeroot structure to
+ * the staging cursor.  This structure should be initialized as follows:
+ *
+ * - if_fork_size field should be set to the number of bytes available to the
+ *   fork in the inode.
+ *
+ * - if_fork should point to a freshly allocated struct xfs_ifork.
+ *
+ * - if_format should be set to the appropriate fork type (e.g.
+ *   XFS_DINODE_FMT_BTREE).
+ *
+ * All other fields must be zero.
+ *
+ * The _stage_cursor() function for a specific btree type should call
+ * xfs_btree_stage_ifakeroot to set up the in-memory cursor as a staging
+ * cursor.  The corresponding _commit_staged_btree() function should log the
+ * new root and call xfs_btree_commit_ifakeroot() to transform the staging
+ * cursor into a regular btree cursor.
+ */
+
+/*
+ * Initialize an inode-rooted btree cursor with the given inode btree fake
+ * root.  The btree cursor's bc_ops will be overridden as needed to make the
+ * staging functionality work.  If new_ops is not NULL, these new ops will be
+ * passed out to the caller for further overriding.
+ */
+void
+xfs_btree_stage_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xbtree_ifakeroot		*ifake,
+	struct xfs_btree_ops		**new_ops)
+{
+	struct xfs_btree_ops		*nops;
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_tp == NULL);
+
+	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
+	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
+	nops->free_block = xfs_btree_fakeroot_free_block;
+	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
+	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
+
+	cur->bc_ino.ifake = ifake;
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ops = nops;
+	cur->bc_flags |= XFS_BTREE_STAGING;
+
+	if (new_ops)
+		*new_ops = nops;
+}
+
+/*
+ * Transform an inode-rooted staging btree cursor back into a regular cursor by
+ * substituting a real btree root for the fake one and restoring normal btree
+ * cursor ops.  The caller must log the btree root change prior to calling
+ * this.
+ */
+void
+xfs_btree_commit_ifakeroot(
+	struct xfs_btree_cur		*cur,
+	struct xfs_trans		*tp,
+	int				whichfork,
+	const struct xfs_btree_ops	*ops)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(cur->bc_tp == NULL);
+
+	trace_xfs_btree_commit_ifakeroot(cur);
+
+	kmem_free((void *)cur->bc_ops);
+	cur->bc_ino.ifake = NULL;
+	cur->bc_ino.whichfork = whichfork;
+	cur->bc_ops = ops;
+	cur->bc_flags &= ~XFS_BTREE_STAGING;
+	cur->bc_tp = tp;
+}
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index 5d78e13d..f50dbbb5 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -24,4 +24,32 @@ void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
 void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
 
+/* Fake root for an inode-rooted btree. */
+struct xbtree_ifakeroot {
+	/* Fake inode fork. */
+	struct xfs_ifork	*if_fork;
+
+	/* Number of blocks used by the btree. */
+	int64_t			if_blocks;
+
+	/* Height of the new btree. */
+	unsigned int		if_levels;
+
+	/* Number of bytes available for this fork in the inode. */
+	unsigned int		if_fork_size;
+
+	/* Fork format. */
+	unsigned int		if_format;
+
+	/* Number of records. */
+	unsigned int		if_extents;
+};
+
+/* Cursor interactions with with fake roots for inode-rooted btrees. */
+void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
+		struct xbtree_ifakeroot *ifake,
+		struct xfs_btree_ops **new_ops);
+void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
+		int whichfork, const struct xfs_btree_ops *ops);
+
 #endif	/* __XFS_BTREE_STAGING_H__ */
-- 
2.26.2

