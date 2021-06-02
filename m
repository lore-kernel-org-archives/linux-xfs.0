Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30CFC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDAB613DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFBW1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFBW1Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE386138C;
        Wed,  2 Jun 2021 22:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672741;
        bh=c4q3EaMeh5EfcI5mEi5B4wuqUzVA4MKPxCzlv9KMmpU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DvNG5dGk1NxyPIC9PaC9X6RbZOcgeURhxBpVYcS3BSB8ALP3F8VcHzswu6UKKzeNR
         MTH8BWFBeNr4K2Gij5Yv8c5ln6ukSe/a9XrLZ/f5ceGGi0oDV+WrRP9rPQExNa9CfO
         702taBiOpANwOf49CRboJJcBqXaKKGzxrEdjA0PJ6XRHb+EwqidDh5CUV+F+b3ng/w
         4Vom7bcEAqRHd7wmuJClUAE0D71eeEmSkZRPf9TEDZQVNyLmiXEJZEHxXPCLqxNk/n
         +dOEj580cbZZq2R1KTQQ86rpXrt/f6baQ1501gpKnna1F2upRyzAsVFnoci4xbB6y6
         7xOif01DssLSA==
Subject: [PATCH 08/15] xfs: remove iter_flags parameter from xfs_inode_walk_*
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:41 -0700
Message-ID: <162267274125.2375284.12510919349339700753.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
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
index 5f52948f9cfa..b5ce9580934f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -54,10 +54,10 @@ xfs_icwalk_tag(enum xfs_icwalk_goal goal)
 	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
 }
 
-static int xfs_icwalk(struct xfs_mount *mp, int iter_flags,
+static int xfs_icwalk(struct xfs_mount *mp,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, enum xfs_icwalk_goal goal);
-static int xfs_icwalk_ag(struct xfs_perag *pag, int iter_flags,
+static int xfs_icwalk_ag(struct xfs_perag *pag,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, enum xfs_icwalk_goal goal);
 
@@ -282,7 +282,7 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
-static void
+static inline void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
 {
@@ -859,7 +859,7 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_icwalk(mp, 0, xfs_dqrele_inode, &eofb, XFS_ICWALK_DQRELE);
+	return xfs_icwalk(mp, xfs_dqrele_inode, &eofb, XFS_ICWALK_DQRELE);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
@@ -1541,11 +1541,9 @@ xfs_blockgc_start(
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
 
@@ -1555,8 +1553,7 @@ xfs_blockgc_igrab(
 		goto out_unlock_noent;
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -1608,7 +1605,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_icwalk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
+	error = xfs_icwalk_ag(pag, xfs_blockgc_scan_inode, NULL,
 			XFS_ICWALK_BLOCKGC);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
@@ -1627,7 +1624,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_icwalk(mp, 0, xfs_blockgc_scan_inode, eofb,
+	return xfs_icwalk(mp, xfs_blockgc_scan_inode, eofb,
 			XFS_ICWALK_BLOCKGC);
 }
 
@@ -1707,14 +1704,13 @@ xfs_blockgc_free_quota(
 static inline bool
 xfs_icwalk_igrab(
 	enum xfs_icwalk_goal	goal,
-	struct xfs_inode	*ip,
-	int			iter_flags)
+	struct xfs_inode	*ip)
 {
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
 		return xfs_dqrele_igrab(ip);
 	case XFS_ICWALK_BLOCKGC:
-		return xfs_blockgc_igrab(ip, iter_flags);
+		return xfs_blockgc_igrab(ip);
 	default:
 		return false;
 	}
@@ -1727,7 +1723,6 @@ xfs_icwalk_igrab(
 static int
 xfs_icwalk_ag(
 	struct xfs_perag	*pag,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	enum xfs_icwalk_goal	goal)
@@ -1774,7 +1769,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip, iter_flags))
+			if (done || !xfs_icwalk_igrab(goal, ip))
 				batch[i] = NULL;
 
 			/*
@@ -1802,9 +1797,6 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
@@ -1851,7 +1843,6 @@ xfs_icwalk_get_perag(
 static int
 xfs_icwalk(
 	struct xfs_mount	*mp,
-	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
 	void			*args,
 	enum xfs_icwalk_goal	goal)
@@ -1863,7 +1854,7 @@ xfs_icwalk(
 
 	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, iter_flags, execute, args, goal);
+		error = xfs_icwalk_ag(pag, execute, args, goal);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c4274c45d914..3ec00f1fea86 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -25,11 +25,6 @@ struct xfs_eofblocks {
 #define XFS_IGET_DONTCACHE	0x4
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
-/*
- * flags for AG inode iterator
- */
-#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
-
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 

