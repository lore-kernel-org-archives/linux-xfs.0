Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13B0C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930C3619F2
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 07:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhCXHDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 03:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhCXHDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 03:03:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7327FC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 00:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=wt+Iy8p6krxjWIFnyUZ292NkHI6f3ZGXwR3QopuArNE=; b=OjrJnkMt2Kzn20zV2935Dx7IT7
        AoZNkJ4MUVecaufJs9fFsYxWcf2hekiumu5dt749M1Z+AFIW/esDs8yK3VSmZM2NmWclQDBO31M/O
        L4Ufp/wWR/JK92Q45EOAxH5+vjJPHX+1tTBOniKZUT72q7QFkeXixVJ5B1zD0nlSJe+VQn7JmcMNI
        s/oW/dLzG5uHXcRHBXbyRX+f36q621ave5O3mMSgYScpQVbxF/03VyxIKMn3MoKMPXDSZ51a4Zrtq
        yV98NR6O/nTs2r3/uXJwroe6RnWMVdlSo46VtZWPOQr9xg7auz+HxLQWphbIFI2YYU6rQcYqkARMB
        bnekOpzA==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOxXu-003uiq-Nf
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 07:03:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: simplify the perage inode walk infrastructure
Date:   Wed, 24 Mar 2021 08:03:06 +0100
Message-Id: <20210324070307.908462-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324070307.908462-1-hch@lst.de>
References: <20210324070307.908462-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the generic xfs_inode_walk and just open code the only caller.
Note that this leads to a somewhat ugly forward delcaration for
xfs_blockgc_scan_inode, but with other changes in that area pending
it seems like the lesser evil.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 103 +++++++++++++-------------------------------
 fs/xfs/xfs_icache.h |  11 -----
 2 files changed, 30 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c0d084e3526a9c..7fdf77df66269c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -728,11 +728,9 @@ xfs_icache_inode_is_allocated(
  */
 STATIC bool
 xfs_inode_walk_ag_grab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -742,8 +740,7 @@ xfs_inode_walk_ag_grab(
 		goto out_unlock_noent;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -763,17 +760,19 @@ xfs_inode_walk_ag_grab(
 	return false;
 }
 
+static int
+xfs_blockgc_scan_inode(
+	struct xfs_inode	*ip,
+	void			*args);
+
 /*
  * For a given per-AG structure @pag, grab, @execute, and rele all incore
  * inodes with the given radix tree @tag.
  */
 STATIC int
-xfs_inode_walk_ag(
+xfs_blockgc_free_space_ag(
 	struct xfs_perag	*pag,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -793,17 +792,9 @@ xfs_inode_walk_ag(
 		int		i;
 
 		rcu_read_lock();
-
-		if (tag == XFS_ICI_NO_TAG)
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		else
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
-
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+				(void **) batch, first_index,
+				XFS_LOOKUP_BATCH, XFS_ICI_BLOCKGC_TAG);
 		if (!nr_found) {
 			rcu_read_unlock();
 			break;
@@ -816,7 +807,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+			if (done || !xfs_inode_walk_ag_grab(ip))
 				batch[i] = NULL;
 
 			/*
@@ -844,10 +835,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], args);
+			error = xfs_blockgc_scan_inode(batch[i], eofb);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -872,49 +860,6 @@ xfs_inode_walk_ag(
 	return last_error;
 }
 
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_inode_walk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	int			tag)
-{
-	if (tag == XFS_ICI_NO_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
-/*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
- */
-int
-xfs_inode_walk(
-	struct xfs_mount	*mp,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == -EFSCORRUPTED)
-				break;
-		}
-	}
-	return last_error;
-}
-
 /*
  * Grab the inode for reclaim exclusively.
  *
@@ -1617,8 +1562,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
-			XFS_ICI_BLOCKGC_TAG);
+	error = xfs_blockgc_free_space_ag(pag, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1634,10 +1578,23 @@ xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		ag = 0;
+	int			error = 0, last_error = 0;
+
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
-			XFS_ICI_BLOCKGC_TAG);
+	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_BLOCKGC_TAG))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_blockgc_free_space_ag(pag, eofb);
+		xfs_perag_put(pag);
+		if (error) {
+			if (error == -EFSCORRUPTED)
+				return error;
+			last_error = error;
+		}
+	}
+	return last_error;
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d70d93c2bb1084..da390097546c67 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -20,8 +20,6 @@ struct xfs_eofblocks {
 /*
  * tags for inode radix tree
  */
-#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_walk */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1
@@ -34,11 +32,6 @@ struct xfs_eofblocks {
 #define XFS_IGET_DONTCACHE	0x4
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
-/*
- * flags for AG inode iterator
- */
-#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
-
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
@@ -68,10 +61,6 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
-	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
-
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-- 
2.30.1

