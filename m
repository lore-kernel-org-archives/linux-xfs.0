Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40533 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933192AbcLMP7v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2016 10:59:51 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfs: don't rely on ->total in xfs_alloc_space_available
Date: Tue, 13 Dec 2016 16:59:27 +0100
Message-Id: <1481644767-9098-5-git-send-email-hch@lst.de>
In-Reply-To: <1481644767-9098-1-git-send-email-hch@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

->total is a bit of an odd parameter passed down to the low-level
allocator all the way from the high-level callers.  It's supposed to
contain the maximum number of blocks to be allocated for the whole
transaction [1].

But in xfs_iomap_write_allocate we only convert existing delayed
allocations and thus only have a minimal block reservation for the
current transaction, so xfs_alloc_space_available can't use it for
the allocation decisions.  Use the maximum of args->total and the
calculated block requirement to make a decision.  We probably should
get rid of args->total eventually and instead apply ->minleft more
broadly, but that will require some extensive changes all over.

[1] which creates lots of confusion as most callers don't decrement it
once doing a first allocation.  But that's for a separate series.
---
 fs/xfs/libxfs/xfs_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 87328a8..85039e5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1998,7 +1998,7 @@ xfs_alloc_space_available(
 	int			flags)
 {
 	struct xfs_perag	*pag = args->pag;
-	xfs_extlen_t		longest;
+	xfs_extlen_t		alloc_len, longest;
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 
@@ -2008,15 +2008,16 @@ xfs_alloc_space_available(
 	reservation = xfs_ag_resv_needed(pag, args->resv);
 
 	/* do we have enough contiguous free space for the allocation? */
+	alloc_len = args->minlen + (args->alignment - 1)+ args->minalignslop;
 	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free,
 			reservation);
-	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
+	if (longest < alloc_len)
 		return false;
 
 	/* do we have enough free space remaining for the allocation? */
 	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
 			  reservation - min_free - args->minleft);
-	if (available < (int)args->total)
+	if (available < (int)max(args->total, alloc_len))
 		return false;
 
 	/*
-- 
2.1.4

