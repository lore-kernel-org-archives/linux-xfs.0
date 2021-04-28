Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5672C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AAA6143C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbhD1Q6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 12:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241290AbhD1Q6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 12:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619629035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhUaTSG60tV03CeL18Ng02gSlAVcGREHwA5JsSzD59o=;
        b=QpgnS92OcycZAhUs8iCtNCHywq+rugFcIkRKvWry4yleSQXMQ1jM+30lC7pSZJzPeMImAW
        w+YJPtHpPJc61XBMb7+b7QUnsjiWOksr8/PSDPD7UnW66lR21SpgJjire+321xZq7D8Fv2
        lChkEOm3aE3s7l+SLaOzdlfsDjsEgio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-wOVemTeHNlCw3BD_8-EIRQ-1; Wed, 28 Apr 2021 12:57:13 -0400
X-MC-Unique: wOVemTeHNlCw3BD_8-EIRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 131F08049CC
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:12 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-229.rdu2.redhat.com [10.10.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C61F75F9C5
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 2/3] xfs: introduce in-core global counter of allocbt blocks
Date:   Wed, 28 Apr 2021 12:57:09 -0400
Message-Id: <20210428165710.385872-3-bfoster@redhat.com>
In-Reply-To: <20210428165710.385872-1-bfoster@redhat.com>
References: <20210428165710.385872-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Introduce an in-core counter to track the sum of all allocbt blocks
used by the filesystem. This value is currently tracked per-ag via
the ->agf_btreeblks field in the AGF, which also happens to include
rmapbt blocks. A global, in-core count of allocbt blocks is required
to identify the subset of global ->m_fdblocks that consists of
unavailable blocks currently used for allocation btrees. To support
this calculation at block reservation time, construct a similar
global counter for allocbt blocks, populate it on first read of each
AGF and update it as allocbt blocks are used and released.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.h              |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..b6a082348e46 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
 	struct xfs_agf		*agf;		/* ag freelist header */
 	struct xfs_perag	*pag;		/* per allocation group data */
 	int			error;
+	int			allocbt_blks;
 
 	trace_xfs_alloc_read_agf(mp, agno);
 
@@ -3066,6 +3067,19 @@ xfs_alloc_read_agf(
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		pag->pagf_init = 1;
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
+
+		/*
+		 * Update the in-core allocbt counter. Filter out the rmapbt
+		 * subset of the btreeblks counter because the rmapbt is managed
+		 * by perag reservation. Subtract one for the rmapbt root block
+		 * because the rmap counter includes it while the btreeblks
+		 * counter only tracks non-root blocks.
+		 */
+		allocbt_blks = pag->pagf_btreeblks;
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
+		if (allocbt_blks > 0)
+			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 81829d19596e..bb67274ee23f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -170,6 +170,12 @@ typedef struct xfs_mount {
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

