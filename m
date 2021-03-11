Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB96C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFDF64FC6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhCKDGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhCKDF5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:05:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1D964EDB;
        Thu, 11 Mar 2021 03:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431957;
        bh=WG+ja7N7H8Y/QGkwfK6rVDuuSZO88XfisSFbrls4Mgg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BgXruYdrnm1cqSI6u/FS3hc/1VsqANNk5Oh14+YSWpIBQXOrmirACLWYDIiq91Yp2
         6cXVZcvOZ+1igG7VlpwHEwd02kXRfl09+B+oe1k6fjrXXL9s8rFKQhubsDcKITYKsP
         1SwZbFedIoYaumR71WTBXEJuARwxGnJPtjz75gQYme21nhAd8Bz9hf0VxqxnenZiL7
         S/++Gb7dQmp+i+P11xhXaVmNv3l2DSP5W1ox5k2dQrmFJlqkzqgyFIUS+gNSQPGIEG
         IMNHBhxdvKziBPdE6KtP7WZ/atK8V0r3EUO96T+OY42cRZq85MHnQVsDdnJ418uCwY
         EaHYFMPcOwIyQ==
Subject: [PATCH 03/11] xfs: don't reclaim dquots with incore reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:05:57 -0800
Message-ID: <161543195719.1947934.8218545606940173264.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a dquot has an incore reservation that exceeds the ondisk count, it
by definition has active incore state and must not be reclaimed.  Up to
this point every inode with an incore dquot reservation has always
retained a reference to the dquot so it was never possible for
xfs_qm_dquot_isolate to be called on a dquot with active state and zero
refcount, but this will soon change.

Deferred inode inactivation is about to reorganize how inodes are
inactivated by shunting all that work to a background workqueue.  In
order to avoid deadlocks with the quotaoff inode scan and reduce overall
memory requirements (since inodes can spend a lot of time waiting for
inactivation), inactive inodes will drop their dquot references while
they're waiting to be inactivated.

However, inactive inodes can have delalloc extents in the data fork or
any extents in the CoW fork.  Either of these contribute to the dquot's
incore reservation being larger than the resource count (i.e. they're
the reason the dquot still has active incore state), so we cannot allow
the dquot to be reclaimed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   29 ++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.h |   17 +++++++++++++++++
 2 files changed, 41 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index bfa4164990b1..b3ce04dec181 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -166,9 +166,14 @@ xfs_qm_dqpurge(
 
 	/*
 	 * We move dquots to the freelist as soon as their reference count
-	 * hits zero, so it really should be on the freelist here.
+	 * hits zero, so it really should be on the freelist here.  If we're
+	 * running quotaoff, it's possible that we're purging a zero-refcount
+	 * dquot with active incore reservation because there are inodes
+	 * awaiting inactivation.  Dquots in this state will not be on the LRU
+	 * but it's quotaoff, so we don't care.
 	 */
-	ASSERT(!list_empty(&dqp->q_lru));
+	ASSERT(!(mp->m_qflags & xfs_quota_active_flag(xfs_dquot_type(dqp))) ||
+	       !list_empty(&dqp->q_lru));
 	list_lru_del(&qi->qi_lru, &dqp->q_lru);
 	XFS_STATS_DEC(mp, xs_qm_dquot_unused);
 
@@ -411,6 +416,15 @@ struct xfs_qm_isolate {
 	struct list_head	dispose;
 };
 
+static inline bool
+xfs_dquot_has_incore_resv(
+	struct xfs_dquot	*dqp)
+{
+	return  dqp->q_blk.reserved > dqp->q_blk.count ||
+		dqp->q_ino.reserved > dqp->q_ino.count ||
+		dqp->q_rtb.reserved > dqp->q_rtb.count;
+}
+
 static enum lru_status
 xfs_qm_dquot_isolate(
 	struct list_head	*item,
@@ -427,10 +441,15 @@ xfs_qm_dquot_isolate(
 		goto out_miss_busy;
 
 	/*
-	 * This dquot has acquired a reference in the meantime remove it from
-	 * the freelist and try again.
+	 * Either this dquot has incore reservations or it has acquired a
+	 * reference.  Remove it from the freelist and try again.
+	 *
+	 * Inodes tagged for inactivation drop their dquot references to avoid
+	 * deadlocks with quotaoff.  If these inodes have delalloc reservations
+	 * in the data fork or any extents in the CoW fork, these contribute
+	 * to the dquot's incore block reservation exceeding the count.
 	 */
-	if (dqp->q_nrefs) {
+	if (xfs_dquot_has_incore_resv(dqp) || dqp->q_nrefs) {
 		xfs_dqunlock(dqp);
 		XFS_STATS_INC(dqp->q_mount, xs_qm_dqwants);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index e3dabab44097..78f90935e91e 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -105,6 +105,23 @@ xfs_quota_inode(struct xfs_mount *mp, xfs_dqtype_t type)
 	return NULL;
 }
 
+static inline unsigned int
+xfs_quota_active_flag(
+	xfs_dqtype_t		type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return XFS_UQUOTA_ACTIVE;
+	case XFS_DQTYPE_GROUP:
+		return XFS_GQUOTA_ACTIVE;
+	case XFS_DQTYPE_PROJ:
+		return XFS_PQUOTA_ACTIVE;
+	default:
+		ASSERT(0);
+	}
+	return 0;
+}
+
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
 				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);

