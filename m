Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E8DC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 15:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C1C64E74
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 15:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBVPgT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:36:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhBVPgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 10:36:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614008086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f1wPVr6IJP9vz7MbHcroHtnrSTjoaNDutaC/fHOtt70=;
        b=Vuua3F1JCIILtcXqXkZst6QE7rHzoP/Ncog6ypTzzvRjgSyu+eWoxwMJZdptvv/Cc+WoER
        In//vZzEuU5AMfJkdTKChK+15XMLXdpfASKsbrzaRh496QRsS+y5SyY22njY02L8vy3oMB
        MukexnJlKud8h7JMj6jtXn/pAm1wJhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-sRP1GXlqM0O4tYQJ2_5dkg-1; Mon, 22 Feb 2021 10:34:44 -0500
X-MC-Unique: sRP1GXlqM0O4tYQJ2_5dkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6356AFA80
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 15:34:43 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6625D5D9D3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 15:34:43 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't reuse busy extents on extent trim
Date:   Mon, 22 Feb 2021 10:34:42 -0500
Message-Id: <20210222153442.897089-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Freed extents are marked busy from the point the freeing transaction
commits until the associated CIL context is checkpointed to the log.
This prevents reuse and overwrite of recently freed blocks before
the changes are committed to disk, which can lead to corruption
after a crash. The exception to this rule is that metadata
allocation is allowed to reuse busy extents because metadata changes
are also logged.

As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
has allowed modification or complete invalidation of outstanding
busy extents for metadata allocations. This implementation assumes
that use of the associated extent is imminent, which is not always
the case. For example, the trimmed extent might not satisfy the
minimum length of the allocation request, or the allocation
algorithm might be involved in a search for the optimal result based
on locality.

generic/019 reproduces a corruption caused by this scenario. First,
a metadata block (usually a bmbt or symlink block) is freed from an
inode. A subsequent bmbt split on an unrelated inode attempts a near
mode allocation request that invalidates the busy block during the
search, but does not ultimately allocate it. Due to the busy state
invalidation, the block is no longer considered busy to subsequent
allocation. A direct I/O write request immediately allocates the
block and writes to it. Finally, the filesystem crashes while in a
state where the initial metadata block free had not committed to the
on-disk log. After recovery, the original metadata block is in its
original location as expected, but has been corrupted by the
aforementioned dio.

This demonstrates that it is fundamentally unsafe to modify busy
extent state for extents that are not guaranteed to be allocated.
This applies to pretty much all of the code paths that currently
trim busy extents for one reason or another. Therefore to address
this problem, drop the reuse mechanism from the busy extent trim
path. This code already knows how to return partial non-busy ranges
of the targeted free extent and higher level code tracks the busy
state of the allocation attempt. If a block allocation fails where
one or more candidate extents is busy, we force the log and retry
the allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extent_busy.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 3991e59cfd18..ef17c1f6db32 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 
-- 
2.26.2

