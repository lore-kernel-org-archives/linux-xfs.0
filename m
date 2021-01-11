Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C8EC4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0D122D2B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404086AbhAKXYQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4604022D0B;
        Mon, 11 Jan 2021 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407414;
        bh=YHHIc3S/RfmulDU7HIW9PttQ+wdTcbt3ip+qMNxLBIY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d33u2x9Y4O7PCmwelX3/j6JHgkLn/aVW4IZEQpIn3gO+3fWHlTViM9taNZA+b/SvP
         fHms1Y01Hzmk7HHKwRv+uy65oYr43KmYnv+cVs/vjS/1o0uJxXcMAoQx+i1KKlpyit
         fThjd1oR1KVLJaE3/TYnsDBuzmzXRts45e3Zj1d1uTExB5/PRrnLPEXHzdM8oJ0sEM
         AZOFdrn34ox6k8Rca9o8wiKk8qLzKYYx9JzTyVEBz8emzkQ1+U7SktivqMO/GWBkLz
         4/KE7ut5TcefKThIOalasnASEFvZiHuhKr6My9QGejqVN+SSPvywNfWx2NHr7QW//Y
         bgyzhV7g6WuoQ==
Subject: [PATCH 3/7] xfs: consolidate incore inode radix tree
 posteof/cowblocks tags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:34 -0800
Message-ID: <161040741435.1582286.3950020739629626839.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The clearing of posteof blocks and cowblocks serve the same purpose:
removing speculative block preallocations from inactive files.  We don't
need to burn two radix tree tags on this, so combine them into one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  104 +++++++++++++++++++++++++--------------------------
 fs/xfs/xfs_icache.h |    4 +-
 fs/xfs/xfs_trace.h  |    6 +--
 3 files changed, 54 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c3867b25e362..da833f6e1fd9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -943,7 +943,7 @@ xfs_queue_eofblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_eofblocks_work,
 				   msecs_to_jiffies(xfs_eofb_secs * 1000));
@@ -990,7 +990,7 @@ xfs_queue_cowblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_cowblocks_work,
 				   msecs_to_jiffies(xfs_cowb_secs * 1000));
@@ -1388,6 +1388,9 @@ xfs_inode_free_eofblocks(
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
+	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
+		return 0;
+
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
 		trace_xfs_inode_free_eofblocks_invalid(ip);
@@ -1427,7 +1430,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_eofblocks	*eofb)
 {
 	return __xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 /*
@@ -1506,61 +1509,48 @@ xfs_inode_free_blocks(
 	return xfs_blockgc_scan(mp, &eofb);
 }
 
-static inline unsigned long
-xfs_iflag_for_tag(
-	int		tag)
-{
-	switch (tag) {
-	case XFS_ICI_EOFBLOCKS_TAG:
-		return XFS_IEOFBLOCKS;
-	case XFS_ICI_COWBLOCKS_TAG:
-		return XFS_ICOWBLOCKS;
-	default:
-		ASSERT(0);
-		return 0;
-	}
-}
-
 static void
 __xfs_inode_set_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*execute)(struct xfs_mount *mp),
-	void		(*set_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				  int error, unsigned long caller_ip),
-	int		tag)
+	struct xfs_inode	*ip,
+	void			(*execute)(struct xfs_mount *mp),
+	unsigned long		iflag)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
-	int tagged;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	int			tagged;
+
+	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
 	/*
 	 * Don't bother locking the AG and looking up in the radix trees
 	 * if we already know that we have the tag set.
 	 */
-	if (ip->i_flags & xfs_iflag_for_tag(tag))
+	if (ip->i_flags & iflag)
 		return;
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags |= xfs_iflag_for_tag(tag);
+	ip->i_flags |= iflag;
 	spin_unlock(&ip->i_flags_lock);
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	tagged = radix_tree_tagged(&pag->pag_ici_root, tag);
+	tagged = radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG);
 	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_BLOCK_GC_TAG);
 	if (!tagged) {
-		/* propagate the eofblocks tag up into the perag radix tree */
+		/* propagate the blockgc tag up into the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
 				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   tag);
+				   XFS_ICI_BLOCK_GC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
 		execute(ip->i_mount);
 
-		set_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1573,37 +1563,43 @@ xfs_inode_set_eofblocks_tag(
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
 	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
-			trace_xfs_perag_set_eofblocks,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_IEOFBLOCKS);
 }
 
 static void
 __xfs_inode_clear_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*clear_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				    int error, unsigned long caller_ip),
-	int		tag)
+	struct xfs_inode	*ip,
+	unsigned long		iflag)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	struct xfs_perag *pag;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	bool			clear_tag;
+
+	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~xfs_iflag_for_tag(tag);
+	ip->i_flags &= ~iflag;
+	clear_tag = (ip->i_flags & (XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	if (!clear_tag)
+		return;
+
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
 	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
-	if (!radix_tree_tagged(&pag->pag_ici_root, tag)) {
-		/* clear the eofblocks tag from the perag radix tree */
+			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			     XFS_ICI_BLOCK_GC_TAG);
+	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCK_GC_TAG)) {
+		/* clear the blockgc tag from the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
 				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     tag);
+				     XFS_ICI_BLOCK_GC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
-		clear_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_clear_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1615,8 +1611,7 @@ xfs_inode_clear_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_eofblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
+	return __xfs_inode_clear_blocks_tag(ip, XFS_IEOFBLOCKS);
 }
 
 /*
@@ -1674,6 +1669,9 @@ xfs_inode_free_cowblocks(
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
+	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
+		return 0;
+
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
@@ -1715,7 +1713,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_eofblocks	*eofb)
 {
 	return __xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 void
@@ -1724,8 +1722,7 @@ xfs_inode_set_cowblocks_tag(
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
 	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
-			trace_xfs_perag_set_cowblocks,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICOWBLOCKS);
 }
 
 void
@@ -1733,8 +1730,7 @@ xfs_inode_clear_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_cowblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
+	return __xfs_inode_clear_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
 
 /* Disable post-EOF and CoW block auto-reclamation. */
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2f230d273a54..fcee10dbfbe9 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -23,8 +23,8 @@ struct xfs_eofblocks {
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
 					   in xfs_inode_walk */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
-#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
-#define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
+/* Inode has speculative preallocations (posteof or cow) to clean. */
+#define XFS_ICI_BLOCK_GC_TAG	1
 
 /*
  * Flags for xfs_iget()
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9a29a5e18711..6bdd3eee2462 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -155,10 +155,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_cowblocks);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_cowblocks);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

