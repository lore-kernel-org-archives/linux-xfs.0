Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C72DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Feb 2021 13:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5433164E2F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Feb 2021 13:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhBQNZY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 08:25:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231856AbhBQNZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Feb 2021 08:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613568223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XfbQ7ypMe3Q9G6TCOW7ZI3gxTxWdYJcxf5fdA5trg8U=;
        b=FeWdDjM188VESQmIxTX2G/Quk2mC5M35a/WQ/x/mPjhAPiCKUo8AdHIC66sSzXNQOe88TH
        zFGYiL268scPTNVQVQ2NP/lH2YcViBVyLtd2SfYnMHgYf8Imo+u4Y2vEZ/UebhkuI4TSur
        6/focNmTQ2azmHAm27KzNbTfzBIub5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-48pVClyBOr6E98EhtOjnDQ-1; Wed, 17 Feb 2021 08:23:41 -0500
X-MC-Unique: 48pVClyBOr6E98EhtOjnDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FA78107ACE3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 13:23:40 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0203910016DB
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 13:23:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: set aside allocation btree blocks from block reservation
Date:   Wed, 17 Feb 2021 08:23:39 -0500
Message-Id: <20210217132339.651020-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The blocks used for allocation btrees (bnobt and countbt) are
technically considered free space. This is because as free space is
used, allocbt blocks are removed and naturally become available for
traditional allocation. However, this means that a significant
portion of free space may consist of in-use btree blocks if free
space is severely fragmented.

On large filesystems with large perag reservations, this can lead to
a rare but nasty condition where a significant amount of physical
free space is available, but the majority of actual usable blocks
consist of in-use allocbt blocks. We have a record of a (~12TB, 32
AG) filesystem with multiple AGs in a state with ~2.5GB or so free
blocks tracked across ~300 total allocbt blocks, but effectively at
100% full because the the free space is entirely consumed by
refcountbt perag reservation.

Such a large perag reservation is by design on large filesystems.
The problem is that because the free space is so fragmented, this AG
contributes the 300 or so allocbt blocks to the global counters as
free space. If this pattern repeats across enough AGs, the
filesystem lands in a state where global block reservation can
outrun physical block availability. For example, a streaming
buffered write on the affected filesystem continues to allow delayed
allocation beyond the point where writeback starts to fail due to
physical block allocation failures. The expected behavior is for the
delalloc block reservation to fail gracefully with -ENOSPC before
physical block allocation failure is a possibility.

To address this problem, introduce a percpu counter to track the sum
of the allocbt block counters already tracked in the AGF. Use the
new counter to set these blocks aside at reservation time and thus
ensure they cannot be allocated until truly available. Since this is
only necessary when large reflink perag reservations are in place
and the counter requires a read of each AGF to fully populate, only
enforce on reflink enabled filesystems. This allows initialization
of the counter at ->pagf_init time because the refcountbt perag
reservation init code reads each AGF at mount time.

Note that the counter uses a small percpu batch size to allow the
allocation paths to keep the primary count accurate enough that the
reservation path doesn't ever need to lock and sum the counter.
Absolute accuracy is not required here, just that the counter
reflects the majority of unavailable blocks so the reservation path
fails first.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This survives my initial regression tests with more ongoing.
Unfortunately I've not been able to recreate the problematic conditions
from scratch. I suspect it's caused by a reflink/COW heavy workload
where COW remaps have severely fragmented free space and depleted the
reserved block pool over time. I have confirmed that this allows -ENOSPC
to occur gracefully on a metadump image of the originally affected
filesystem. Thoughts, reviews, flames appreciated.

Brian

 fs/xfs/libxfs/xfs_alloc.c | 13 +++++++++++++
 fs/xfs/xfs_mount.c        | 13 ++++++++++++-
 fs/xfs/xfs_mount.h        |  6 ++++++
 fs/xfs/xfs_super.c        |  7 +++++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0c623d3c1036..81ebcddcba7a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,6 +36,13 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
+/*
+ * Use a small batch size for the btree blocks counter since modifications
+ * mainly occur in the block allocation path. This allows the read side to
+ * remain lockless.
+ */
+#define XFS_BTREE_BLOCKS_BATCH	4
+
 STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
@@ -2746,6 +2753,8 @@ xfs_alloc_get_freelist(
 	if (btreeblk) {
 		be32_add_cpu(&agf->agf_btreeblks, 1);
 		pag->pagf_btreeblks++;
+		percpu_counter_add_batch(&mp->m_btree_blks, 1,
+					 XFS_BTREE_BLOCKS_BATCH);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
@@ -2853,6 +2862,8 @@ xfs_alloc_put_freelist(
 	if (btreeblk) {
 		be32_add_cpu(&agf->agf_btreeblks, -1);
 		pag->pagf_btreeblks--;
+		percpu_counter_add_batch(&mp->m_btree_blks, -1,
+					 XFS_BTREE_BLOCKS_BATCH);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
@@ -3055,6 +3066,8 @@ xfs_alloc_read_agf(
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
+		percpu_counter_add_batch(&mp->m_btree_blks, pag->pagf_btreeblks,
+					 XFS_BTREE_BLOCKS_BATCH);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 52370d0a3f43..41ec14aafbff 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1178,6 +1178,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	uint64_t		set_aside = mp->m_alloc_set_aside;
 
 	if (delta > 0) {
 		/*
@@ -1217,8 +1218,18 @@ xfs_mod_fdblocks(
 	else
 		batch = XFS_FDBLOCKS_BATCH;
 
+	/*
+	 * Set aside allocbt blocks on reflink filesystems because COW remaps
+	 * can dip into the reserved block pool. This is problematic if free
+	 * space is fragmented and m_fdblocks tracks a significant number of
+	 * allocbt blocks. Note this also ensures the counter is populated since
+	 * perag reservation reads all AGFs at mount time.
+	 */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		set_aside += percpu_counter_read_positive(&mp->m_btree_blks);
+
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
+	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 659ad95fe3e0..2f94088b4170 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -170,6 +170,12 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+	/*
+	 * Optional count of btree blocks in use across all AGs. Only used when
+	 * reflink is enabled and is not 100% accurate. Helps prevent block
+	 * reservation from attempting to reserve allocation btree blocks.
+	 */
+	struct percpu_counter	m_btree_blks;
 
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 21b1d034aca3..6d035b7c0d0b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1001,8 +1001,14 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	error = percpu_counter_init(&mp->m_btree_blks, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc;
+
 	return 0;
 
+free_delalloc:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1031,6 +1037,7 @@ xfs_destroy_percpu_counters(
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
+	percpu_counter_destroy(&mp->m_btree_blks);
 }
 
 static void
-- 
2.26.2

