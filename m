Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16338C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9C8613CE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhFBAzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFBAzc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9F5613CA;
        Wed,  2 Jun 2021 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595230;
        bh=H92vjQeafVZhCCZi4aOrW7IBBY1D74fxmqkr7PcVUXg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uYFm8MEW3MdDIyIzm1/kW4WrB8JcDBS4wBqvmm1rf1+K2p0Mrs8bhFMnxWMTyQOG/
         ZAK6K4LpIn3CiSIncLJ20rygo8w+LKNQbEjWtTZ56CYIOZCPJVNu225iNz0pRLUizP
         XJxWJ8FWc/usyKa4UCqYUY5r2LZIozsjhxqdU+nk8Xspxk86HMFtmRRkSH+M0GIc9l
         qmVIulRBcs2SlCe6rcTa8ry7A2EikFJAcBe3ahrmMubFyF9MNR+9ZwNnfNCQfi+aMS
         pMG1lJaXy0IS7cJJR7hKheXXJcnE2U4bmil2iNDPqef/zUjRCmP9gFEh5FXHrPM/7g
         OaSYKU0qTfVjg==
Subject: [PATCH 14/14] xfs: refactor per-AG inode tagging functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:49 -0700
Message-ID: <162259522967.662681.2128059699058630959.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for adding another incore inode tree tag, refactor the
code that sets and clears tags from the per-AG inode tree and the tree
of per-AG structures, and remove the open-coded versions used by the
blockgc code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  158 +++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_icache.h |    2 -
 fs/xfs/xfs_super.c  |    2 -
 fs/xfs/xfs_trace.h  |    6 +-
 4 files changed, 80 insertions(+), 88 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f6e54e638cf4..dae8a3d24c83 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -186,46 +186,94 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
-static void
-xfs_perag_set_reclaim_tag(
+/*
+ * Background scanning to trim preallocated space. This is queued based on the
+ * 'speculative_prealloc_lifetime' tunable (5m by default).
+ */
+static inline void
+xfs_blockgc_queue(
 	struct xfs_perag	*pag)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
+		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
+				   &pag->pag_blockgc_work,
+				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
+	rcu_read_unlock();
+}
+
+/* Set a tag on both the AG incore inode tree and the AG radix tree. */
+static void
+xfs_perag_set_inode_tag(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	unsigned int		tag)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	bool			was_tagged;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
-	if (pag->pag_ici_reclaimable++)
+
+	was_tagged = radix_tree_tagged(&pag->pag_ici_root, tag);
+	radix_tree_tag_set(&pag->pag_ici_root, agino, tag);
+
+	if (tag == XFS_ICI_RECLAIM_TAG)
+		pag->pag_ici_reclaimable++;
+
+	if (was_tagged)
 		return;
 
-	/* propagate the reclaim tag up into the perag radix tree */
+	/* propagate the tag up into the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
-	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
-			   XFS_ICI_RECLAIM_TAG);
+	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
 
-	/* schedule periodic background inode reclaim */
-	xfs_reclaim_work_queue(mp);
+	/* start background work */
+	switch (tag) {
+	case XFS_ICI_RECLAIM_TAG:
+		xfs_reclaim_work_queue(mp);
+		break;
+	case XFS_ICI_BLOCKGC_TAG:
+		xfs_blockgc_queue(pag);
+		break;
+	}
 
-	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
+	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
+/* Clear a tag on both the AG incore inode tree and the AG radix tree. */
 static void
-xfs_perag_clear_reclaim_tag(
-	struct xfs_perag	*pag)
+xfs_perag_clear_inode_tag(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	unsigned int		tag)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
-	if (--pag->pag_ici_reclaimable)
+
+	/*
+	 * Reclaim can signal (with a null agino) that it cleared its own tag
+	 * by removing the inode from the radix tree.
+	 */
+	if (agino != NULLAGINO)
+		radix_tree_tag_clear(&pag->pag_ici_root, agino, tag);
+	else
+		ASSERT(tag == XFS_ICI_RECLAIM_TAG);
+
+	if (tag == XFS_ICI_RECLAIM_TAG)
+		pag->pag_ici_reclaimable--;
+
+	if (radix_tree_tagged(&pag->pag_ici_root, tag))
 		return;
 
-	/* clear the reclaim tag from the perag radix tree */
+	/* clear the tag from the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
-	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
-			     XFS_ICI_RECLAIM_TAG);
+	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
-	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
-}
 
+	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+}
 
 /*
  * We set the inode flag atomically with the radix tree tag.
@@ -233,7 +281,7 @@ xfs_perag_clear_reclaim_tag(
  * can go away.
  */
 void
-xfs_inode_set_reclaim_tag(
+xfs_inode_mark_reclaimable(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -243,9 +291,8 @@ xfs_inode_set_reclaim_tag(
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
-	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			   XFS_ICI_RECLAIM_TAG);
-	xfs_perag_set_reclaim_tag(pag);
+	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 
 	spin_unlock(&ip->i_flags_lock);
@@ -253,17 +300,6 @@ xfs_inode_set_reclaim_tag(
 	xfs_perag_put(pag);
 }
 
-STATIC void
-xfs_inode_clear_reclaim_tag(
-	struct xfs_perag	*pag,
-	xfs_ino_t		ino)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
-			     XFS_ICI_RECLAIM_TAG);
-	xfs_perag_clear_reclaim_tag(pag);
-}
-
 static inline void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -462,7 +498,9 @@ xfs_iget_cache_hit(
 		 */
 		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 		ip->i_flags |= XFS_INEW;
-		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
+		xfs_perag_clear_inode_tag(pag,
+				XFS_INO_TO_AGINO(pag->pag_mount, ino),
+				XFS_ICI_RECLAIM_TAG);
 		inode->i_state = I_NEW;
 		ip->i_sick = 0;
 		ip->i_checked = 0;
@@ -938,7 +976,7 @@ xfs_reclaim_inode(
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ino)))
 		ASSERT(0);
-	xfs_perag_clear_reclaim_tag(pag);
+	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_RECLAIM_TAG);
 	spin_unlock(&pag->pag_ici_lock);
 
 	/*
@@ -1154,22 +1192,6 @@ xfs_inode_free_eofblocks(
 	return 0;
 }
 
-/*
- * Background scanning to trim preallocated space. This is queued based on the
- * 'speculative_prealloc_lifetime' tunable (5m by default).
- */
-static inline void
-xfs_blockgc_queue(
-	struct xfs_perag	*pag)
-{
-	rcu_read_lock();
-	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
-				   &pag->pag_blockgc_work,
-				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
-	rcu_read_unlock();
-}
-
 static void
 xfs_blockgc_set_iflag(
 	struct xfs_inode	*ip,
@@ -1177,7 +1199,6 @@ xfs_blockgc_set_iflag(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
-	int			tagged;
 
 	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
@@ -1194,24 +1215,8 @@ xfs_blockgc_set_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	tagged = radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG);
-	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			   XFS_ICI_BLOCKGC_TAG);
-	if (!tagged) {
-		/* propagate the blockgc tag up into the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
-				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   XFS_ICI_BLOCKGC_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-
-		/* kick off background trimming */
-		xfs_blockgc_queue(pag);
-
-		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
-				_RET_IP_);
-	}
+	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
@@ -1247,19 +1252,8 @@ xfs_blockgc_clear_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			     XFS_ICI_BLOCKGC_TAG);
-	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
-		/* clear the blockgc tag from the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
-				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     XFS_ICI_BLOCKGC_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-		trace_xfs_perag_clear_blockgc(ip->i_mount, pag->pag_agno, -1,
-				_RET_IP_);
-	}
+	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 63e116c339a8..9c3c1cbf17ef 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -52,7 +52,7 @@ void xfs_reclaim_inodes(struct xfs_mount *mp);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
-void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..db61e9cdc013 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -667,7 +667,7 @@ xfs_fs_destroy_inode(
 	 * reclaim path handles this more efficiently than we can here, so
 	 * simply let background reclaim tear down all inodes.
 	 */
-	xfs_inode_set_reclaim_tag(ip);
+	xfs_inode_mark_reclaimable(ip);
 }
 
 static void
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae337b222..e785b475715b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -153,10 +153,8 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

