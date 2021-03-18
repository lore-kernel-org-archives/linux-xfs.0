Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDEEC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5573E64E89
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhCRWe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRWd5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA7664E02;
        Thu, 18 Mar 2021 22:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106836;
        bh=isMKDOucUAPZiYoxG6tViWiJFOxV9+N4TPVzqAsvgg8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lk6nNN7BZumiXlvhxPL8eDVGWnFErL0tH82aMjfWM03i6UNLigE/rbRfM1Mn8zLlV
         h7KnPdHLahOK9bu8nZgnvvVTu7WQKiVbKGQ1LrbBL4xPYo4TN9FI6LbzxlJrJ26QHR
         tkpu6pktqPxfy8ZwyyTWzB5tWDMNQ+N7zc38JEk3SYjlcqqDVBGX/UQMNiOW/LawJ9
         5fa4NHs9rY0W+vwUKymR3DhR90F+/tsvmNemcXymPMskkPaV+d/r4AEsYNJr76mSj0
         xbADTH1MbEw1W2/XvYCoIzTzHzHCIV/qsXybD29S6fEOEIMryE69PUM0j9Tgj8JxsT
         LjYC1NT/4eP+w==
Subject: [PATCH 3/3] xfs: remove iter_flags parameter from xfs_inode_walk_*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:56 -0700
Message-ID: <161610683632.1887634.9330923612964175378.stgit@magnolia>
In-Reply-To: <161610681966.1887634.12780057277967410395.stgit@magnolia>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The sole user of the INEW_WAIT flag to xfs_inode_walk is a caller that
is external to the inode cache.  Since external callers have no business
messing with INEW inodes or inode radix tree tags, we can get rid of the
iter_flag entirely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   20 ++++++++------------
 fs/xfs/xfs_icache.h      |    7 +------
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 3 files changed, 10 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9198c7a7c3ca..563865140a99 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -732,10 +732,9 @@ xfs_icache_inode_is_allocated(
 STATIC bool
 xfs_inode_walk_ag_grab(
 	struct xfs_inode	*ip,
-	int			flags)
+	int			tag)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -745,7 +744,7 @@ xfs_inode_walk_ag_grab(
 		goto out_unlock_noent;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
+	if ((tag != XFS_ICI_NO_TAG && __xfs_iflags_test(ip, XFS_INEW)) ||
 	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
@@ -781,7 +780,6 @@ inode_walk_fn_to_tag(int (*execute)(struct xfs_inode *ip, void *args))
 STATIC int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args)
 {
@@ -827,7 +825,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+			if (done || !xfs_inode_walk_ag_grab(ip, tag))
 				batch[i] = NULL;
 
 			/*
@@ -855,15 +853,14 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
 			switch (tag) {
 			case XFS_ICI_BLOCKGC_TAG:
 				error = xfs_blockgc_scan_inode(batch[i], args);
 				xfs_irele(batch[i]);
 				break;
 			case XFS_ICI_NO_TAG:
+				if (xfs_iflags_test(batch[i], XFS_INEW))
+					xfs_inew_wait(batch[i]);
 				error = execute(batch[i], args);
 				xfs_irele(batch[i]);
 				break;
@@ -914,7 +911,6 @@ xfs_inode_walk_get_perag(
 int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args)
 {
@@ -927,7 +923,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args);
+		error = xfs_inode_walk_ag(pag, execute, args);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1636,7 +1632,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL);
+	error = xfs_inode_walk_ag(pag, xfs_blockgc_scan_inode, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
@@ -1654,7 +1650,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb);
+	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a20bb89e3a38..04e59b775432 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,11 +34,6 @@ struct xfs_eofblocks {
 #define XFS_IGET_DONTCACHE	0x4
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
-/*
- * flags for AG inode iterator
- */
-#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
-
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
@@ -68,7 +63,7 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+int xfs_inode_walk(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, void *args),
 	void *args);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 2f42ea8a09ab..dad4d3fc3df3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -795,5 +795,5 @@ xfs_qm_dqrele_all_inodes(
 	uint			flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode, &flags);
+	xfs_inode_walk(mp, xfs_dqrele_inode, &flags);
 }

