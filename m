Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331D3C43470
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21DD6145F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbhDWNLc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 09:11:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242553AbhDWNLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 09:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619183455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgZYB4SLAUbIi3sgf3Zod6Dg1nYjFTKfblRvRnRidYE=;
        b=MpKEyFuYFrjQRfi+T3EjzkxuUngQmknk0ganRwgIDvhrUhYd7bFbNQjImGXga9sn+B27vl
        NiKAWURdzqu9b78yums97O9GCI++EnqVSeEuu027+JTtHnyACVGN5bifDA6tikzRigtfcM
        ybgr03LWpVOY7WIxSJbJWmXg1TQ8piU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-ngwWPiaNP5GHam4kcuPoJQ-1; Fri, 23 Apr 2021 09:10:53 -0400
X-MC-Unique: ngwWPiaNP5GHam4kcuPoJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F29B83DD25
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:52 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F04F60854
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 3/3] xfs: set aside allocation btree blocks from block reservation
Date:   Fri, 23 Apr 2021 09:10:50 -0400
Message-Id: <20210423131050.141140-4-bfoster@redhat.com>
In-Reply-To: <20210423131050.141140-1-bfoster@redhat.com>
References: <20210423131050.141140-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

To address this problem, set aside in-use allocbt blocks at
reservation time and thus ensure they cannot be reserved until truly
available for physical allocation. This allows alloc btree metadata
to continue to reside in free space, but dynamically adjusts
reservation availability based on internal state. Note that the
logic requires that the allocbt counter is fully populated at
reservation time before it is fully effective. We currently rely on
the mount time AGF scan in the perag reservation initialization code
for this dependency on filesystems where it's most important (i.e.
with active perag reservations).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cb1e2c4702c3..bdfee1943796 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1188,6 +1188,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	uint64_t		set_aside;
 
 	if (delta > 0) {
 		/*
@@ -1227,8 +1228,20 @@ xfs_mod_fdblocks(
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
+	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
+	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
-- 
2.26.3

