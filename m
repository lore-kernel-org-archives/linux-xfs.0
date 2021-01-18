Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCF6C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A877720707
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbhARWOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388191AbhARWNs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186F8230FB;
        Mon, 18 Jan 2021 22:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007987;
        bh=17SFwvlobQod73HbpJOAGHYdklHb3bdZg0geWxuXQ9E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LeO7kZbgiN3pJ0dhwPG+pDajVyVypye5F2XwXxpeTp8Xtbhls0jWzm1m795FRiOPJ
         Y0s/FdlfYKZjlfTx4bYiVoa5w75Ct1nazvRIF8eJ7JzzEfOAxbFA1M45nJwW2GRfO6
         ai7JcHkGzt+dVEpVxelYkCsuWdHcnLFH4yxn3t4qjZjtye6B1QIvc9TTJZj4xg+71M
         a5aOq58GEemrGdTcdXTwpKrMjeNqMLB8rHg1a0kojc96ZtUMSQVhIEgFjFltX5DPMF
         To86I/Ngxo9ithxLpl3RI5o/2hd6gOjuYRfoQpQyEq5Js3yrgTvx/a/y5WFQKc4PnQ
         AxjOum5jE9c2Q==
Subject: [PATCH 01/10] xfs: relocate the eofb/cowb workqueue functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:06 -0800
Message-ID: <161100798676.90204.16460265222758873473.stgit@magnolia>
In-Reply-To: <161100798100.90204.7839064495063223590.stgit@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the xfs_{eof,cow}blocks_worker and xfs_queue_{eof,cow}blocks
functions further down in the file so that the cleanups in the next
patches won't have to pre-declare static functions.  No functional
changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  126 ++++++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index acf67384e52f..7d33bdd5ed86 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -915,69 +915,6 @@ xfs_inode_walk(
 	return last_error;
 }
 
-/*
- * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
- */
-void
-xfs_queue_eofblocks(
-	struct xfs_mount *mp)
-{
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_eofblocks_work,
-				   msecs_to_jiffies(xfs_eofb_secs * 1000));
-	rcu_read_unlock();
-}
-
-void
-xfs_eofblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_eofblocks_work);
-
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
-	xfs_icache_free_eofblocks(mp, NULL);
-	sb_end_write(mp->m_super);
-
-	xfs_queue_eofblocks(mp);
-}
-
-/*
- * Background scanning to trim preallocated CoW space. This is queued
- * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
- * (We'll just piggyback on the post-EOF prealloc space workqueue.)
- */
-void
-xfs_queue_cowblocks(
-	struct xfs_mount *mp)
-{
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_cowblocks_work,
-				   msecs_to_jiffies(xfs_cowb_secs * 1000));
-	rcu_read_unlock();
-}
-
-void
-xfs_cowblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_cowblocks_work);
-
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
-	xfs_icache_free_cowblocks(mp, NULL);
-	sb_end_write(mp->m_super);
-
-	xfs_queue_cowblocks(mp);
-}
-
 /*
  * Grab the inode for reclaim exclusively.
  *
@@ -1396,6 +1333,37 @@ xfs_icache_free_eofblocks(
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
+/*
+ * Background scanning to trim post-EOF preallocated space. This is queued
+ * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
+ */
+void
+xfs_queue_eofblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
+		queue_delayed_work(mp->m_eofblocks_workqueue,
+				   &mp->m_eofblocks_work,
+				   msecs_to_jiffies(xfs_eofb_secs * 1000));
+	rcu_read_unlock();
+}
+
+void
+xfs_eofblocks_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_eofblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+	xfs_icache_free_eofblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
+	xfs_queue_eofblocks(mp);
+}
+
 static inline unsigned long
 xfs_iflag_for_tag(
 	int		tag)
@@ -1608,6 +1576,38 @@ xfs_icache_free_cowblocks(
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
+/*
+ * Background scanning to trim preallocated CoW space. This is queued
+ * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
+ * (We'll just piggyback on the post-EOF prealloc space workqueue.)
+ */
+void
+xfs_queue_cowblocks(
+	struct xfs_mount *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_COWBLOCKS_TAG))
+		queue_delayed_work(mp->m_eofblocks_workqueue,
+				   &mp->m_cowblocks_work,
+				   msecs_to_jiffies(xfs_cowb_secs * 1000));
+	rcu_read_unlock();
+}
+
+void
+xfs_cowblocks_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+				struct xfs_mount, m_cowblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+	xfs_icache_free_cowblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
+	xfs_queue_cowblocks(mp);
+}
+
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)

