Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C30C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE38D64DD8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhA1GEF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhA1GEE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A455764DD1;
        Thu, 28 Jan 2021 06:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813828;
        bh=m8Qh7VKkX1Rs8QNA/v6iLHdDI1w6AptEeDAgveOeLEk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FD+oX2f7f1dsVAlUNerO9tFOnQfZJZXjdSG/Hxpd81ngR6nxhgM0bDapwkfPsO2xM
         nco2S/1ShsbbDjaZ7T6RnMScf0LxlD/OwvNJ/t6qTYAW7uByqo5DV/0WqORWIE6R4d
         5xgziVYPu5CZmjv6PAHKhnDN+8gK8jrhaqJ9Odjy48EgYfrhXHfGrz6Cy1w6n+43jf
         T6LvplC/gkYlZJHBG2XKBHgZ0Iv+JBgi86IOd8bgfm0KsvjyyM4EfBPDcNw2Xb6irS
         qeKnTVYcSIAEX9MCUXIvpw94k6SmOa+TD0ztRHlbIk/bUAmQBI3k7vSBo7ZpKyi3Zr
         YI3INcghU/5rA==
Subject: [PATCH 01/11] xfs: relocate the eofb/cowb workqueue functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:44 -0800
Message-ID: <161181382488.1525433.10026562489938948192.stgit@magnolia>
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
index 97c15fcdd6f7..15dcf57b4b19 100644
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

