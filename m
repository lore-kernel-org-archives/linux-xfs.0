Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88546C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70630613CE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhFBAyx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229739AbhFBAyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71885613CA;
        Wed,  2 Jun 2021 00:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595191;
        bh=JhCvzxI3wujItmWyugVhq6eSnBX58uPzSGKHV0s4DFI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NE+1pmlACbPyiTVH/leOQBvWdDuj64/KfIyaKD+pHhQt6kZsPsCF2os2jC8opaK2d
         9LM8QHcn3gIzNLgb9XoARGRqi1t/OtWfNN3RSnw3eKXAllQ90NAd3sNrzMqUTpQSuw
         52D9Vap1bGnTdfA8/vKqBFFqwf4y9zCiztMhdQK6dX4SQ6YA93DmwP57d3HrRtZVD9
         L5yi6EnZWk1I0bRMlOkkmbvKlkWOfq4Nt6IRImFAsyzZxrpwCOj2A9OD1+fuGRyBsd
         AIrEJb6mK0YTCOv5ckLoCboGPutuLBd2ma/p3BY054JoM/l7rP8mRvqUy7Dj/q4q70
         6lWRmz7iRprGQ==
Subject: [PATCH 07/14] xfs: remove iter_flags parameter from xfs_inode_walk_*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:11 -0700
Message-ID: <162259519113.662681.9888544412918017319.stgit@locust>
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

The sole iter_flags is XFS_INODE_WALK_INEW_WAIT, and there are no users.
Remove the flag, and the parameter, and all the code that used it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   33 ++++++++++++---------------------
 fs/xfs/xfs_icache.h |    5 -----
 2 files changed, 12 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b22a3fe20c4a..2e13e9347147 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -49,10 +49,10 @@ xfs_icwalk_tagged(enum xfs_icwalk_goal goal)
 	return goal != XFS_ICWALK_DQRELE;
 }
 
-static int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+static int xfs_inode_walk(struct xfs_mount *mp,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, enum xfs_icwalk_goal goal);
-static int xfs_inode_walk_ag(struct xfs_perag *pag, int iter_flags,
+static int xfs_inode_walk_ag(struct xfs_perag *pag,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, enum xfs_icwalk_goal goal);
 
@@ -265,7 +265,7 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
-static void
+static inline void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
 {
@@ -844,7 +844,7 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
-	return xfs_inode_walk(mp, 0, xfs_dqrele_inode, &eofb,
+	return xfs_inode_walk(mp, xfs_dqrele_inode, &eofb,
 			XFS_ICWALK_DQRELE);
 }
 #else
@@ -1527,11 +1527,9 @@ xfs_blockgc_start(
  */
 static bool
 xfs_blockgc_igrab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
 
 	ASSERT(rcu_read_lock_held());
 
@@ -1541,8 +1539,7 @@ xfs_blockgc_igrab(
 		goto out_unlock_noent;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -1594,7 +1591,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
+	error = xfs_inode_walk_ag(pag, xfs_blockgc_scan_inode, NULL,
 			XFS_ICWALK_BLOCKGC);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
@@ -1613,7 +1610,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+	return xfs_inode_walk(mp, xfs_blockgc_scan_inode, eofb,
 			XFS_ICWALK_BLOCKGC);
 }
 
@@ -1688,12 +1685,11 @@ xfs_blockgc_free_quota(
 static inline bool
 xfs_grabbed_for_walk(
 	enum xfs_icwalk_goal	goal,
-	struct xfs_inode	*ip,
-	int			iter_flags)
+	struct xfs_inode	*ip)
 {
 	switch (goal) {
 	case XFS_ICWALK_BLOCKGC:
-		return xfs_blockgc_igrab(ip, iter_flags);
+		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_DQRELE:
 		return xfs_dqrele_igrab(ip);
 	default:
@@ -1708,7 +1704,6 @@ xfs_grabbed_for_walk(
 static int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	enum xfs_icwalk_goal	goal)
@@ -1754,7 +1749,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_grabbed_for_walk(goal, ip, iter_flags))
+			if (done || !xfs_grabbed_for_walk(goal, ip))
 				batch[i] = NULL;
 
 			/*
@@ -1782,9 +1777,6 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
@@ -1829,7 +1821,6 @@ xfs_inode_walk_get_perag(
 static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	enum xfs_icwalk_goal	goal)
@@ -1842,7 +1833,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, goal))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, goal);
+		error = xfs_inode_walk_ag(pag, execute, args, goal);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index bc0998a2f7d6..6f6260c91ba0 100644
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
 

