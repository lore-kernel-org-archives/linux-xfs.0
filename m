Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751901AbdK0UYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:24:36 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE72681DF1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B370E5D9C6
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: amortize agfl block frees across multiple transactions
Date: Mon, 27 Nov 2017 15:24:33 -0500
Message-Id: <20171127202434.43125-4-bfoster@redhat.com>
In-Reply-To: <20171127202434.43125-1-bfoster@redhat.com>
References: <20171127202434.43125-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've had rare reports of transaction overruns in
xfs_inactive_ifree() for quite some time. Analysis of a reproducing
metadump has shown the problem is essentially caused by performing
too many agfl block frees in a single transaction.

For example, an inode chunk is freed and the associated agfl fixup
algorithm discovers it needs to free a single agfl block before the
chunk free occurs. This single block ends up causing a space btree
join and adds one or more blocks back onto the agfl. This causes
xfs_alloc_fix_freelist() to free up to 3 blocks just to rectify a
single block discrepency.

The transaction overrun occurs under several other unfortunate
circumstances:

 - Each agfl block free is left+right contiguous. This requires 2
   record deletions and 1 insertion for the cntbt and thus requires
   more log reservation than normal.
 - The associated transaction is the first in the CIL ctx and thus
   the ctx header reservation is consumed.
 - The transaction reservation is larger than a log buffer and thus
   extra split header reservation is consumed.

As a result of the agfl and free space state of the filesystem, the
agfl fixup code has dirtied more cntbt buffer space than allowed by
the portion of the reservation allotted for block allocation. This
is all before the real allocation even starts!

Note that the log related conditions above are correctly covered by
the existing transaction reservation. The above demonstrates that
the reservation allotted for the context/split headers may help
suppress overruns in the more common case where that reservation
goes unused for its intended purpose.

To address this problem, update xfs_alloc_fix_freelist() to amortize
agfl block frees over multiple transactions. Free one block per
transaction so long as the agfl is less than half free. The agfl
minimum allocation requirement is dynamic, but is based on the
geometry of the associated btrees (i.e., level count) and therefore
should be easily rectified over multiple allocation transactions.
Further, there is no real harm in leaving extraneous blocks on the
agfl so long as there are enough free slots available for btree
blocks freed as a result of the upcoming allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0da80019a917..d8d58e35da00 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2117,11 +2117,6 @@ xfs_alloc_fix_freelist(
 	 * appropriately based on the recursion count and dirty state of the
 	 * buffer.
 	 *
-	 * XXX (dgc): When we have lots of free space, does this buy us
-	 * anything other than extra overhead when we need to put more blocks
-	 * back on the free list? Maybe we should only do this when space is
-	 * getting low or the AGFL is more than half full?
-	 *
 	 * The NOSHRINK flag prevents the AGFL from being shrunk if it's too
 	 * big; the NORMAP flag prevents AGFL expand/shrink operations from
 	 * updating the rmapbt.  Both flags are used in xfs_repair while we're
@@ -2151,6 +2146,16 @@ xfs_alloc_fix_freelist(
 			goto out_agbp_relse;
 		}
 		xfs_trans_binval(tp, bp);
+
+		/*
+		 * Freeing all extra agfl blocks adds too much log reservation
+		 * overhead to a single transaction, particularly considering
+		 * that freeing a block can cause a btree join and put one right
+		 * back on the agfl. Try to free one block per tx so long as
+		 * we've left enough free slots for the upcoming modifications.
+		 */
+		if (pag->pagf_flcount <= (XFS_AGFL_SIZE(mp) >> 1))
+			break;
 	}
 
 	targs.tp = tp;
-- 
2.13.6

