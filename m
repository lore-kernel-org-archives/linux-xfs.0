Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8986AC4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F36B61078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhHECHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238097AbhHECHJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A2B6105A;
        Thu,  5 Aug 2021 02:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129216;
        bh=Z5KP3H8wowaJAPs3hCDEwyo78OVcUSwanwVAqmoVPVU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uXv/juroFUicFfsCr+Eb/tAsmYO32wYgNm51RCRoI0BDp8VcOj/DTbKflNpU654Wr
         Q80g/GWw9cd3qhArWlZRH/aAYbfXhcOTbABMb6/xTLrQmxMB5n3EKyc38qParegfmX
         hDAkqpxgYpH37URNl+lkVCHad/4ryb1zuKu9TaOBLChfglR5ZeQwN223IE65mK9SDi
         lPuwO3QeJoBi5/DU4sLTMQJDQqH+DZuPUhyHroJqVv43W3t7dN759a5HlS3IwrGxQY
         ePWDsd97eFtB+PGW7zJsGm81DM600vdvM5s53Zl7IwbVmbPeQTNrccY8Dye043+jGP
         hEipc264C/nsQ==
Subject: [PATCH 06/14] xfs: queue inactivation immediately when free space is
 tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:06:55 -0700
Message-ID: <162812921593.2589546.139493086066282940.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have made the inactivation of unlinked inodes a background
task to increase the throughput of file deletions, we need to be a
little more careful about how long of a delay we can tolerate.

On a mostly empty filesystem, the risk of the allocator making poor
decisions due to fragmentation of the free space on account a lengthy
delay in background updates is minimal because there's plenty of space.
However, if free space is tight, we want to deallocate unlinked inodes
as quickly as possible to avoid fallocate ENOSPC and to give the
allocator the best shot at optimal allocations for new writes.

Therefore, queue the percpu worker immediately if the filesystem is more
than 95% full.  This follows the same principle that XFS becomes less
aggressive about speculative allocations and lazy cleanup (and more
precise about accounting) when nearing full.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    6 ++++++
 fs/xfs/xfs_mount.c  |    8 --------
 fs/xfs/xfs_mount.h  |    9 +++++++++
 3 files changed, 15 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fedfa40e3cd6..0332acaad6f3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1928,6 +1928,7 @@ xfs_inodegc_start(
  * Schedule the inactivation worker when:
  *
  *  - We've accumulated more than one inode cluster buffer's worth of inodes.
+ *  - There is less than 5% free space left.
  */
 static inline bool
 xfs_inodegc_want_queue_work(
@@ -1939,6 +1940,11 @@ xfs_inodegc_want_queue_work(
 	if (items > mp->m_ino_geo.inodes_per_cluster)
 		return true;
 
+	if (__percpu_counter_compare(&mp->m_fdblocks,
+				mp->m_low_space[XFS_LOWSP_5_PCNT],
+				XFS_FDBLOCKS_BATCH) < 0)
+		return true;
+
 	return false;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1f7e9a608f38..5fe6f1db4fe9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1077,14 +1077,6 @@ xfs_fs_writable(
 	return true;
 }
 
-/*
- * Deltas for the block count can vary from 1 to very large, but lock contention
- * only occurs on frequent small block count updates such as in the delayed
- * allocation path for buffered writes (page a time updates). Hence we set
- * a large batch count (1024) to minimise global counter updates except when
- * we get near to ENOSPC and we have to be very accurate with our updates.
- */
-#define XFS_FDBLOCKS_BATCH	1024
 int
 xfs_mod_fdblocks(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 03d59a023bbb..750297498a09 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -343,6 +343,15 @@ extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
+/*
+ * Deltas for the block count can vary from 1 to very large, but lock contention
+ * only occurs on frequent small block count updates such as in the delayed
+ * allocation path for buffered writes (page a time updates). Hence we set
+ * a large batch count (1024) to minimise global counter updates except when
+ * we get near to ENOSPC and we have to be very accurate with our updates.
+ */
+#define XFS_FDBLOCKS_BATCH	1024
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);

