Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA510C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA2764DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhA1GFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhA1GEx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD4164DD8;
        Thu, 28 Jan 2021 06:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813851;
        bh=sbjfru7fnvXmWFKx4ZCN0DF9rQVdrC/lLJ22oiubbSg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U8VDYWuuJPcAOqH0zrUwe1lWrhiWxU//5M8Gdf1knU0Jm4kKwlZEzstje82qn7joF
         lbQ+ORxG92wAJ4E+xvPr3mstXxr+nXIF1ZpwK1IC/bJ4kOjxiF/OmyLVjzNoGpYpH+
         5CCog8fpSeNmXwpk0t7gWwa+9Kz24h6TPH4MMoV3UQpaWcbdak3aUr+AC8f6liwYiU
         8D3Qm8E4UhVZw0kgazGS1zTcYXtxxZDxSHy/2vHWBRwVVhHvaAn5qzwhD3TziDpu2q
         I5cq1EMxzT86qLrY1taPjTZ4MQIkryV/kAdERLo6AwcfsBBLOk2N7uAJqdwd4IBc0q
         Hbj+NvPremV8g==
Subject: [PATCH 05/11] xfs: consolidate incore inode radix tree
 posteof/cowblocks tags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:07 -0800
Message-ID: <161181384757.1525433.16407356734723256739.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |  114 ++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_icache.h |    4 +-
 fs/xfs/xfs_trace.h  |    6 +--
 3 files changed, 58 insertions(+), 66 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7440ae93b204..1009556fb8b2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1291,6 +1291,9 @@ xfs_inode_free_eofblocks(
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
+	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
+		return 0;
+
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
 		trace_xfs_inode_free_eofblocks_invalid(ip);
@@ -1333,7 +1336,7 @@ xfs_queue_eofblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_eofblocks_work,
 				   msecs_to_jiffies(xfs_eofb_secs * 1000));
@@ -1350,67 +1353,54 @@ xfs_eofblocks_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 	xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, NULL,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_ICI_BLOCKGC_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_eofblocks(mp);
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
-__xfs_inode_set_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*execute)(struct xfs_mount *mp),
-	void		(*set_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				  int error, unsigned long caller_ip),
-	int		tag)
+xfs_blockgc_set_iflag(
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
+	tagged = radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG);
 	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino), tag);
+			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+			   XFS_ICI_BLOCKGC_TAG);
 	if (!tagged) {
-		/* propagate the eofblocks tag up into the perag radix tree */
+		/* propagate the blockgc tag up into the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
 				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   tag);
+				   XFS_ICI_BLOCKGC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
 		execute(ip->i_mount);
 
-		set_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1422,38 +1412,43 @@ xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
-			trace_xfs_perag_set_eofblocks,
-			XFS_ICI_EOFBLOCKS_TAG);
+	return xfs_blockgc_set_iflag(ip, xfs_queue_eofblocks, XFS_IEOFBLOCKS);
 }
 
 static void
-__xfs_inode_clear_blocks_tag(
-	xfs_inode_t	*ip,
-	void		(*clear_tp)(struct xfs_mount *mp, xfs_agnumber_t agno,
-				    int error, unsigned long caller_ip),
-	int		tag)
+xfs_blockgc_clear_iflag(
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
+			     XFS_ICI_BLOCKGC_TAG);
+	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
+		/* clear the blockgc tag from the perag radix tree */
 		spin_lock(&ip->i_mount->m_perag_lock);
 		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
 				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     tag);
+				     XFS_ICI_BLOCKGC_TAG);
 		spin_unlock(&ip->i_mount->m_perag_lock);
-		clear_tp(ip->i_mount, pag->pag_agno, -1, _RET_IP_);
+		trace_xfs_perag_clear_blockgc(ip->i_mount, pag->pag_agno, -1,
+				_RET_IP_);
 	}
 
 	spin_unlock(&pag->pag_ici_lock);
@@ -1465,8 +1460,7 @@ xfs_inode_clear_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_eofblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
+	return xfs_blockgc_clear_iflag(ip, XFS_IEOFBLOCKS);
 }
 
 /*
@@ -1524,6 +1518,9 @@ xfs_inode_free_cowblocks(
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
 
+	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
+		return 0;
+
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
@@ -1569,7 +1566,7 @@ xfs_queue_cowblocks(
 	struct xfs_mount *mp)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(mp->m_eofblocks_workqueue,
 				   &mp->m_cowblocks_work,
 				   msecs_to_jiffies(xfs_cowb_secs * 1000));
@@ -1586,7 +1583,7 @@ xfs_cowblocks_worker(
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
 	xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, NULL,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICI_BLOCKGC_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_cowblocks(mp);
@@ -1597,9 +1594,7 @@ xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
-			trace_xfs_perag_set_cowblocks,
-			XFS_ICI_COWBLOCKS_TAG);
+	return xfs_blockgc_set_iflag(ip, xfs_queue_cowblocks, XFS_ICOWBLOCKS);
 }
 
 void
@@ -1607,8 +1602,7 @@ xfs_inode_clear_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_clear_cowblocks_tag(ip);
-	return __xfs_inode_clear_blocks_tag(ip,
-			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
+	return xfs_blockgc_clear_iflag(ip, XFS_ICOWBLOCKS);
 }
 
 /* Disable post-EOF and CoW block auto-reclamation. */
@@ -1638,12 +1632,12 @@ xfs_blockgc_scan(
 	int			error;
 
 	error = xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_EOFBLOCKS_TAG);
+			XFS_ICI_BLOCKGC_TAG);
 	if (error)
 		return error;
 
 	error = xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_COWBLOCKS_TAG);
+			XFS_ICI_BLOCKGC_TAG);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 8566798d42ab..d2ef1ef75e7a 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -23,8 +23,8 @@ struct xfs_eofblocks {
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
 					   in xfs_inode_walk */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
-#define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
-#define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
+/* Inode has speculative preallocations (posteof or cow) to clean. */
+#define XFS_ICI_BLOCKGC_TAG	1
 
 /*
  * Flags for xfs_iget()
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 27929c6ca43a..e74bbb648f83 100644
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

