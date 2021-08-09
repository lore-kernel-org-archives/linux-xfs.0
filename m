Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE50C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 07:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A1B61055
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 07:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhHIHBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhHIHBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 03:01:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4408CC0613CF
        for <linux-xfs@vger.kernel.org>; Mon,  9 Aug 2021 00:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=s9SX72oB9f5kbrjEp4A80MqqVP9mu6xsuldq0cPG18Q=; b=mj/uHTp7UqWTT0DHex4TTh1Cas
        Tg9DZlwwHmlYbr+ZJ/qtBG7zv9W88y3/4P4CPJdy1VvjYaZwRTPALzsPklhE3vzocYnt5oivSqno1
        LKD/Wtr2t5s4rqSgaVsZuDVHKxcWzea2an29U5YlNXifiIYF4bXnCx3kUa1sap0gwgAvVKduDHHp/
        4qt5krtuijwE7mjCVvpOowi5colGJOpIRgTbFWNEUrx0ZWCMTWdeRSh4x5SG0uglrEVs+K+lCxpUh
        yvEcRKHgbAorB+UFTmPVWCsTC1NZGnTKzmeVqFVIAkqvIlbcGBDfe3f0xM66qeIfpHs1JYOwnOaKQ
        Zva0Umow==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCzGx-00Ajbm-QX
        for linux-xfs@vger.kernel.org; Mon, 09 Aug 2021 07:00:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: remove xfs_dqrele_all_inodes
Date:   Mon,  9 Aug 2021 08:59:36 +0200
Message-Id: <20210809065938.1199181-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809065938.1199181-1-hch@lst.de>
References: <20210809065938.1199181-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_dqrele_all_inodes is unused now, remove it and all supporting code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 107 +-------------------------------------------
 fs/xfs/xfs_icache.h |   6 ---
 2 files changed, 1 insertion(+), 112 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6007683482c625..086a88b8dfdb39 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -38,9 +38,6 @@
  * radix tree tags when convenient.  Avoid existing XFS_IWALK namespace.
  */
 enum xfs_icwalk_goal {
-	/* Goals that are not related to tags; these must be < 0. */
-	XFS_ICWALK_DQRELE	= -1,
-
 	/* Goals directly associated with tagged inodes. */
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
 	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
@@ -64,9 +61,6 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
  * Private inode cache walk flags for struct xfs_icwalk.  Must not
  * coincide with XFS_ICWALK_FLAGS_VALID.
  */
-#define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
-#define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
-#define XFS_ICWALK_FLAG_DROP_PDQUOT	(1U << 29)
 
 /* Stop scanning after icw_scan_limit inodes. */
 #define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
@@ -74,10 +68,7 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 #define XFS_ICWALK_FLAG_RECLAIM_SICK	(1U << 27)
 #define XFS_ICWALK_FLAG_UNION		(1U << 26) /* union filter algorithm */
 
-#define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
-					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
-					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
-					 XFS_ICWALK_FLAG_SCAN_LIMIT | \
+#define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_SCAN_LIMIT | \
 					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
 					 XFS_ICWALK_FLAG_UNION)
 
@@ -817,97 +808,6 @@ xfs_icache_inode_is_allocated(
 	return 0;
 }
 
-#ifdef CONFIG_XFS_QUOTA
-/* Decide if we want to grab this inode to drop its dquots. */
-static bool
-xfs_dqrele_igrab(
-	struct xfs_inode	*ip)
-{
-	bool			ret = false;
-
-	ASSERT(rcu_read_lock_held());
-
-	/* Check for stale RCU freed inode */
-	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
-		goto out_unlock;
-
-	/*
-	 * Skip inodes that are anywhere in the reclaim machinery because we
-	 * drop dquots before tagging an inode for reclamation.
-	 */
-	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
-		goto out_unlock;
-
-	/*
-	 * The inode looks alive; try to grab a VFS reference so that it won't
-	 * get destroyed.  If we got the reference, return true to say that
-	 * we grabbed the inode.
-	 *
-	 * If we can't get the reference, then we know the inode had its VFS
-	 * state torn down and hasn't yet entered the reclaim machinery.  Since
-	 * we also know that dquots are detached from an inode before it enters
-	 * reclaim, we can skip the inode.
-	 */
-	ret = igrab(VFS_I(ip)) != NULL;
-
-out_unlock:
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-/* Drop this inode's dquots. */
-static void
-xfs_dqrele_inode(
-	struct xfs_inode	*ip,
-	struct xfs_icwalk	*icw)
-{
-	if (xfs_iflags_test(ip, XFS_INEW))
-		xfs_inew_wait(ip);
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
-		xfs_qm_dqrele(ip->i_udquot);
-		ip->i_udquot = NULL;
-	}
-	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
-		xfs_qm_dqrele(ip->i_gdquot);
-		ip->i_gdquot = NULL;
-	}
-	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
-		xfs_qm_dqrele(ip->i_pdquot);
-		ip->i_pdquot = NULL;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_irele(ip);
-}
-
-/*
- * Detach all dquots from incore inodes if we can.  The caller must already
- * have dropped the relevant XFS_[UGP]QUOTA_ACTIVE flags so that dquots will
- * not get reattached.
- */
-int
-xfs_dqrele_all_inodes(
-	struct xfs_mount	*mp,
-	unsigned int		qflags)
-{
-	struct xfs_icwalk	icw = { .icw_flags = 0 };
-
-	if (qflags & XFS_UQUOTA_ACCT)
-		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
-	if (qflags & XFS_GQUOTA_ACCT)
-		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
-	if (qflags & XFS_PQUOTA_ACCT)
-		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
-
-	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
-}
-#else
-# define xfs_dqrele_igrab(ip)		(false)
-# define xfs_dqrele_inode(ip, priv)	((void)0)
-#endif /* CONFIG_XFS_QUOTA */
-
 /*
  * Grab the inode for reclaim exclusively.
  *
@@ -1647,8 +1547,6 @@ xfs_icwalk_igrab(
 	struct xfs_icwalk	*icw)
 {
 	switch (goal) {
-	case XFS_ICWALK_DQRELE:
-		return xfs_dqrele_igrab(ip);
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
@@ -1672,9 +1570,6 @@ xfs_icwalk_process_inode(
 	int			error = 0;
 
 	switch (goal) {
-	case XFS_ICWALK_DQRELE:
-		xfs_dqrele_inode(ip, icw);
-		break;
 	case XFS_ICWALK_BLOCKGC:
 		error = xfs_blockgc_scan_inode(ip, icw);
 		break;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index c751cc32dc4634..d0062ebb3f7ac8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -68,12 +68,6 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-#ifdef CONFIG_XFS_QUOTA
-int xfs_dqrele_all_inodes(struct xfs_mount *mp, unsigned int qflags);
-#else
-# define xfs_dqrele_all_inodes(mp, qflags)	(0)
-#endif
-
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-- 
2.30.2

