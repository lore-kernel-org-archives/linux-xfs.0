Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F12C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D02122DBF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbhAWSyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbhAWSyH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EACF422DBF;
        Sat, 23 Jan 2021 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428006;
        bh=dHDOOTCdxAdI5L+TSwMpNV4HXzGJKDvyuNsAxb5xIbo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HU8Fao2TpVh+JOlxwM0Ak5b75q/FG9WTf+eZgdoIEgYhhXvl8AFmYe5LMxrKo32vT
         VD+5QvwxES1dj67suHA2BigbMg5KIAb5CuY4xi+GlCidop2nhoiIhLuNPHEtzho/LD
         ixue9c5hdGvNJRSNHkba9PG0zvje7oyxZS1yr4x1tMqdyaXLTsZgAFeQNtNpWczoWu
         zj3i2IP61lC/pDE06HMORBU8gfdUmzjl+1q6/D49gEgjbKBgCX2n7jicpwqv2EwFdV
         CKZrioVceNK9v42PdEPVGChkebv2C2pwvril+GHxTvdlphzJ5wQuObMPelB8lhEZIZ
         TebQz6bpMQU3g==
Subject: [PATCH 1/9] xfs: relocate the eofb/cowb workqueue functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:27 -0800
Message-ID: <161142800757.2173480.5105909989904915251.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |  126 ++++++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0d228a5e879f..5dda039b1433 100644
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

