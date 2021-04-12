Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4665C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771426128B
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbhDLNb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241773AbhDLNbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618234264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNdguYJ4ojtuvTeLX/VK2e02+W0+j+EBQa5Xd1vyygc=;
        b=hEWgSPbI+JFa86d2qONgtm8xjv+GbrIjiqBhEn6wZXvv0jze4FyXYwDWrDwDaMhsgBZW6n
        VR6UshlOHu2cHd4vCXIlOJ8JsJqMN06+ics66lTCt6QJG+wtXp9s2oB0kzO/TivacTc/pt
        cxSE1RTF2zphWJI/PM9vpBuFWXguITs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-Q4i6q5nXOcSKp4428_zdIg-1; Mon, 12 Apr 2021 09:31:02 -0400
X-MC-Unique: Q4i6q5nXOcSKp4428_zdIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7015A10054F6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:01 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28FAA5C1BB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/2] xfs: set aside allocation btree blocks from block reservation
Date:   Mon, 12 Apr 2021 09:30:59 -0400
Message-Id: <20210412133059.1186634-3-bfoster@redhat.com>
In-Reply-To: <20210412133059.1186634-1-bfoster@redhat.com>
References: <20210412133059.1186634-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

To address this problem, introduce an in-core counter to track the
sum of all allocbt blocks in use by the filesystem. Use the new
counter to set these blocks aside at reservation time and thus
ensure they cannot be reserved until truly available. Since this is
only necessary when perag reservations are active and the counter
requires a read of each AGF to fully populate, only enforce on perag
res enabled filesystems. This allows initialization of the counter
at ->pagf_init time because the perag reservation init code reads
each AGF at mount time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
 fs/xfs/xfs_mount.h              |  6 ++++++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..144e2d68245c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
 	struct xfs_agf		*agf;		/* ag freelist header */
 	struct xfs_perag	*pag;		/* per allocation group data */
 	int			error;
+	uint32_t		allocbt_blks;
 
 	trace_xfs_alloc_read_agf(mp, agno);
 
@@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		pag->pagf_init = 1;
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
+
+		/*
+		 * Update the global in-core allocbt block counter. Filter
+		 * rmapbt blocks from the on-disk counter because those are
+		 * managed by perag reservation.
+		 */
+		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
+			allocbt_blks = pag->pagf_btreeblks -
+					be32_to_cpu(agf->agf_rmap_blocks);
+			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
+		}
 	}
 #ifdef DEBUG
 	else if (!XFS_FORCED_SHUTDOWN(mp)) {
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 8e01231b308e..9f5a45f7baed 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
 		return 0;
 	}
 
+	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
 	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
@@ -95,6 +96,7 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
+	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cb1e2c4702c3..1f835c375a89 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	uint64_t		set_aside;
 
 	if (delta > 0) {
 		/*
@@ -1227,8 +1228,23 @@ xfs_mod_fdblocks(
 	else
 		batch = XFS_FDBLOCKS_BATCH;
 
+	/*
+	 * Set aside allocbt blocks because these blocks are tracked as free
+	 * space but not available for allocation. Technically this means that a
+	 * single reservation cannot consume all remaining free space, but the
+	 * ratio of allocbt blocks to usable free blocks should be rather small.
+	 * The tradeoff without this is that filesystems that maintain high
+	 * perag block reservations can over reserve physical block availability
+	 * and fail physical allocation, which leads to much more serious
+	 * problems (i.e. transaction abort, pagecache discards, etc.) than
+	 * slightly premature -ENOSPC.
+	 */
+	set_aside = mp->m_alloc_set_aside;
+	if (mp->m_has_agresv)
+		set_aside += atomic64_read(&mp->m_allocbt_blks);
+
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
+	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8847ffd29777..80b9f37f65e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -171,6 +171,12 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+	/*
+	 * Global count of allocation btree blocks in use across all AGs. Only
+	 * used when perag reservation is enabled. Helps prevent block
+	 * reservation from attempting to reserve allocation btree blocks.
+	 */
+	atomic64_t		m_allocbt_blks;
 
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
-- 
2.26.3

