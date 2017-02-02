Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdBBSjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 13:39:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 36/51] xfs: dont rely on ->total in xfs_alloc_space_available
Date: Thu,  2 Feb 2017 19:37:55 +0100
Message-Id: <20170202183346.993154632@linuxfoundation.org>
In-Reply-To: <20170202183345.067336143@linuxfoundation.org>
References: <20170202183345.067336143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 12ef830198b0d71668eb9b59f9ba69d32951a48a upstream.

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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1995,7 +1995,7 @@ xfs_alloc_space_available(
 	int			flags)
 {
 	struct xfs_perag	*pag = args->pag;
-	xfs_extlen_t		longest;
+	xfs_extlen_t		alloc_len, longest;
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 
@@ -2005,15 +2005,16 @@ xfs_alloc_space_available(
 	reservation = xfs_ag_resv_needed(pag, args->resv);
 
 	/* do we have enough contiguous free space for the allocation? */
+	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
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


