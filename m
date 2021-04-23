Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D69C43462
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 615596145F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhDWNLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 09:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242557AbhDWNLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 09:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619183454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0qYqYpi2xzHFRBB+5rhDFERrrHTPV8bdAbJVe0EQMU=;
        b=QHwrm6Wwg5PLNCikLTLvHTei6FGtKuhGURMvn6BfYhciG45pgaflufO7EAd+ErZCLVEErR
        5myn6O5pO4NYiBNM0UyeX/lywPzutme3Vfocfg1URrHUUzNxnQvKehrqWUHf1K5dRJpKhX
        L6E4N+qCKqitOn751j4zFtCkw7Ye6zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-HPjKuRF9Oh-HDz3bbld2Aw-1; Fri, 23 Apr 2021 09:10:52 -0400
X-MC-Unique: HPjKuRF9Oh-HDz3bbld2Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD75A343A5
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C18260854
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt blocks
Date:   Fri, 23 Apr 2021 09:10:49 -0400
Message-Id: <20210423131050.141140-3-bfoster@redhat.com>
In-Reply-To: <20210423131050.141140-1-bfoster@redhat.com>
References: <20210423131050.141140-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
---
 fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.h              |  6 ++++++
 3 files changed, 20 insertions(+)

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

