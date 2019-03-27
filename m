Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfC0OuB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:50:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C8FE307E078
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 14:50:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 564205DF28
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2019 14:50:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: don't account extra agfl blocks as available
Date: Wed, 27 Mar 2019 10:50:00 -0400
Message-Id: <20190327145000.10756-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The block allocation AG selection code has parameters that allow a
caller to perform multiple allocations from a single AG and
transaction (under certain conditions). The parameters specify the
total block allocation count required by the transaction and the AG
selection code selects and locks an AG that will be able to satisfy
the overall requirement. If the available block accounting
calculation turns out to be inaccurate and a subsequent allocation
call fails with -ENOSPC, the resulting transaction cancel leads to
filesystem shutdown because the transaction is dirty.

This exact problem can be reproduced with a highly parallel space
consumer and fsstress workload running long enough to a large
filesystem against -ENOSPC conditions. A bmbt block allocation
request made for inode extent to bmap format conversion after an
extent allocation is expected to be satisfied by the same AG and the
same transaction as the extent allocation. The bmbt block allocation
fails, however, because the block availability of the AG has changed
since the AG was selected (outside of the blocks used for the extent
itself).

The inconsistent block availability calculation is caused by the
deferred block freeing behavior of the AGFL. This immediately
removes extra blocks from the AGFL to free up AGFL slots, but rather
than immediately freeing such blocks as was done in the past, the
block free is deferred such that said blocks are not available for
allocation until the current transaction commits. The AG selection
logic currently considers all AGFL blocks as available and executes
shortly before any extra AGFL blocks are freed. This means the block
availability of the current AG can change before the first
allocation even occurs, but in practice a failure is more likely to
manifest via a subsequent allocation because extent allocation
usually has a contiguity requirement larger than a single block that
can't be satisfied from the AGFL.

In general, XFS prefers operational robustness to absolute
allocation efficiency. In other words, we prefer to return -ENOSPC
slightly earlier at the expense of not being able to allocate every
last block in an AG to avoid this kind of problem. As such, update
the AG block availability calculation to consider extra AGFL blocks
as unavailable since they are immediately removed following the
calculation and will not become available until the current
transaction commits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This problem is reasonably difficult to reproduce. Zorro put together a
system/test that could reproduce fairly reliably, even then it takes
several hours. I eventually reproduced a shutdown once with this fix in
place, but I was never able to reproduce again during about a week of
attempts to try and further root cause. So I think it's possible there
are still problems in this area, but I suspect it's a separate problem
from this one.

Brian

 fs/xfs/libxfs/xfs_alloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index bc3367b8b7bb..857a53e58b94 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2042,6 +2042,7 @@ xfs_alloc_space_available(
 	xfs_extlen_t		alloc_len, longest;
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
+	xfs_extlen_t		agflcount;
 
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
@@ -2054,8 +2055,13 @@ xfs_alloc_space_available(
 	if (longest < alloc_len)
 		return false;
 
-	/* do we have enough free space remaining for the allocation? */
-	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
+	/*
+	 * Do we have enough free space remaining for the allocation? Don't
+	 * account extra agfl blocks because we are about to defer free them,
+	 * making them unavailable until the current transaction commits.
+	 */
+	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
+	available = (int)(pag->pagf_freeblks + agflcount -
 			  reservation - min_free - args->minleft);
 	if (available < (int)max(args->total, alloc_len))
 		return false;
-- 
2.17.2
