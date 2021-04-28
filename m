Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E24FC43470
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3F661440
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhD1Q6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 12:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241387AbhD1Q6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 12:58:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619629035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ins1jAmF7Ztk23RCPKy7JAK6iAm+aqeLfw/qJ4s5l4=;
        b=eD7C+3uat7S4tyqO3SKBDKRgwOXXYf6mMX5b6QC7/dBeEYv96tpeyW09MApbN9eJxTHJRJ
        1hMLmtiGfLN12uh4wh4iUL4Jw2G8llBCYdJcrvjbrqFPCZJN5xb+fHMmuFT1sCS4PIuyzT
        h8PlsdbrIhqgUEEWdyBiTp3wcy+LSUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-D-EM7QIzN9SL5WSFUpXgwg-1; Wed, 28 Apr 2021 12:57:13 -0400
X-MC-Unique: D-EM7QIzN9SL5WSFUpXgwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A15A19611A4
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:12 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-229.rdu2.redhat.com [10.10.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37AB85FC14
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:12 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 3/3] xfs: set aside allocation btree blocks from block reservation
Date:   Wed, 28 Apr 2021 12:57:10 -0400
Message-Id: <20210428165710.385872-4-bfoster@redhat.com>
In-Reply-To: <20210428165710.385872-1-bfoster@redhat.com>
References: <20210428165710.385872-1-bfoster@redhat.com>
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

