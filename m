Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfEAOFF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 May 2019 10:05:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 732CD85543
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:05 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 300BC71932
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:05 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: drop minlen before tossing alignment on bmap allocs
Date: Wed,  1 May 2019 10:05:03 -0400
Message-Id: <20190501140504.16435-2-bfoster@redhat.com>
In-Reply-To: <20190501140504.16435-1-bfoster@redhat.com>
References: <20190501140504.16435-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

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
index 356ebd1cbe82..184ce11d9aee 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3586,6 +3586,14 @@ xfs_bmap_btalloc(
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
@@ -3597,9 +3605,7 @@ xfs_bmap_btalloc(
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
2.17.2
