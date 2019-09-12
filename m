Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9ACC4CEC6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDBC2081B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbfILOc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 10:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732444AbfILOc2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Sep 2019 10:32:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67F8C3082E57
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EABD5D712;
        Thu, 12 Sep 2019 14:32:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on bmap allocs
Date:   Thu, 12 Sep 2019 10:32:22 -0400
Message-Id: <20190912143223.24194-2-bfoster@redhat.com>
In-Reply-To: <20190912143223.24194-1-bfoster@redhat.com>
References: <20190912143223.24194-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The bmap block allocation code issues a sequence of retries to
perform an optimal allocation, gradually loosening constraints as
allocations fail. For example, the first attempt might begin at a
particular bno, with maxlen == minlen and alignment incorporated. As
allocations fail, the parameters fall back to different modes, drop
alignment requirements and reduce the minlen and total block
requirements.

For large extent allocations with an args.total value that exceeds
the allocation length (i.e., non-delalloc), the total value tends to
dominate despite these fallbacks. For example, an aligned extent
allocation request of tens to hundreds of MB that cannot be
satisfied from a particular AG will not succeed after dropping
alignment or minlen because xfs_alloc_space_available() never
selects an AG that can't satisfy args.total. The retry sequence
eventually reduces total and ultimately succeeds if a minlen extent
is available somewhere, but the first several retries are
effectively pointless in this scenario.

Beyond simply being inefficient, another side effect of this
behavior is that we drop alignment requirements too aggressively.
Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
unit:

 # xfs_io -c "falloc 0 1g" /mnt/file
 # <xfstests>/src/t_stripealign /mnt/file 32
 /mnt/file: Start block 347176 not multiple of sunit 32

Despite the filesystem being completely empty, the fact that the
allocation request cannot be satisifed from a single AG means the
allocation doesn't succeed until xfs_bmap_btalloc() drops total from
the original value based on maxlen. This occurs after we've dropped
minlen and alignment (unnecessarily).

As a step towards addressing this problem, insert a new retry in the
bmap allocation sequence to drop minlen (from maxlen) before tossing
alignment. This should still result in as large of an extent as
possible as the block allocator prioritizes extent size in all but
exact allocation modes. By itself, this does not change the behavior
of the command above because the preallocation code still specifies
total based on maxlen. Instead, this facilitates preservation of
alignment once extra reservation is separated from the extent length
portion of the total block requirement.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 054b4ce30033..eaa965920a03 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3573,6 +3573,14 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
+	if (args.fsbno == NULLFSBLOCK && nullfb &&
+	    args.minlen > ap->minlen) {
+		args.minlen = ap->minlen;
+		args.fsbno = ap->blkno;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			return error;
+	}
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * allocation failed, so turn off alignment and
@@ -3584,9 +3592,7 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb &&
-	    args.minlen > ap->minlen) {
-		args.minlen = ap->minlen;
+	if (args.fsbno == NULLFSBLOCK && nullfb) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.fsbno = ap->blkno;
 		if ((error = xfs_alloc_vextent(&args)))
-- 
2.20.1

