Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3FAC48BE8
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FAE561284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhFMRXP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRXP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3031661107;
        Sun, 13 Jun 2021 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604874;
        bh=HsSEZQ0jQ4HEgeetc+Oia8BIIZwLyfhrj/q9hfygaTI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KBU9ubZSUSKZ+4B+8t5X83aS1ojOQNIgyq74gwUpTiPsJUWPEU/+gSjdYAf1xn5Kn
         S10JWxhKSHCE7xmPobqTnlI0XluIZeblnV8HG24IdW3CSc/M0TLAzJTsiz4JrrqjO6
         xP1yplj2UiKNWq9om10onEQk7AcB3+Z0a92rWXag88NSx6NuQdevhw9m4BjoSxTtJR
         ku2PHySoNEdz6AOCW+Qi/NZzHbCVw8fiMaueWsLmUTRVwjOWBtyzIbyvesyGYcfyA2
         hMwPPyBwGfOqZf1w/R6JFLeikhE9kwfCoG55wzpPxcvlnsOE3mwoWNvEYS7jA/vRpb
         uEmWGeuOZEnCA==
Subject: [PATCH 14/16] xfs: scale speculative preallocation gc delay based on
 free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:21:13 -0700
Message-ID: <162360487389.1530792.11066249469501881271.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to scale down the lag between scheduling
and executing background cleanup work for inode inactivations, apply the
same logic to speculative preallocation gc.  In other words, be more
proactive about trimming unused speculative preallocations if space is
low.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 780100756738..f530dc2803ed 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -365,7 +365,8 @@ xfs_worker_delay_ms(
  */
 static inline void
 xfs_blockgc_queue(
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount        *mp = pag->pag_mount;
 
@@ -374,8 +375,9 @@ xfs_blockgc_queue(
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
-		unsigned int	delay = xfs_blockgc_secs * 1000;
+		unsigned int	delay;
 
+		delay = xfs_worker_delay_ms(pag, ip, xfs_blockgc_secs * 1000);
 		trace_xfs_blockgc_queue(mp, pag->pag_agno, delay, _RET_IP_);
 		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_blockgc_work,
 				msecs_to_jiffies(delay));
@@ -383,6 +385,36 @@ xfs_blockgc_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Reschedule the background speculative gc worker immediately if space is
+ * getting tight and the worker hasn't started running yet.
+ */
+static void
+xfs_blockgc_queue_sooner(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	unsigned int		blockgc_ms = xfs_blockgc_secs * 1000;
+
+	if (!XFS_IS_QUOTA_ON(mp) ||
+	    !delayed_work_pending(&pag->pag_blockgc_work) ||
+	    !test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	rcu_read_lock();
+	if (!radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
+		goto unlock;
+
+	if (xfs_worker_delay_ms(pag, ip, blockgc_ms) == blockgc_ms)
+		goto unlock;
+
+	trace_xfs_blockgc_queue(mp, pag->pag_agno, 0, _RET_IP_);
+	mod_delayed_work(mp->m_gc_workqueue, &pag->pag_blockgc_work, 0);
+unlock:
+	rcu_read_unlock();
+}
+
 /*
  * Queue a background inactivation worker if there are inodes that need to be
  * inactivated and higher level xfs code hasn't disabled the background
@@ -475,7 +507,7 @@ xfs_perag_set_inode_tag(
 		xfs_reclaim_work_queue(mp);
 		break;
 	case XFS_ICI_BLOCKGC_TAG:
-		xfs_blockgc_queue(pag);
+		xfs_blockgc_queue(pag, ip);
 		break;
 	case XFS_ICI_INODEGC_TAG:
 		xfs_inodegc_queue(pag, ip);
@@ -1594,6 +1626,7 @@ xfs_blockgc_set_iflag(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	bool			already_queued;
 
 	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
@@ -1610,9 +1643,13 @@ xfs_blockgc_set_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_BLOCKGC_TAG);
+	already_queued = xfs_perag_set_inode_tag(pag, ip, XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
+
+	if (already_queued)
+		xfs_blockgc_queue_sooner(pag, ip);
+
 	xfs_perag_put(pag);
 }
 
@@ -1798,7 +1835,7 @@ xfs_blockgc_start(
 
 	trace_xfs_blockgc_start(mp, 0, _RET_IP_);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
-		xfs_blockgc_queue(pag);
+		xfs_blockgc_queue(pag, NULL);
 }
 
 /* Don't try to run block gc on an inode that's in any of these states. */
@@ -1889,7 +1926,7 @@ xfs_blockgc_worker(
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	xfs_blockgc_queue(pag);
+	xfs_blockgc_queue(pag, NULL);
 }
 
 /*

