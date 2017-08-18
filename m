Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdHRHFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 03:05:17 -0400
Date: Fri, 18 Aug 2017 00:05:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170818070516.GA15291@infradead.org>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 17, 2017 at 04:31:29PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This RFC combines all the random little fixes and improvements to the
> verifiers that we've been talking about for the past month or so into a
> single patch series!
> 
> We start by refactoring the long format btree block header verifier into
> a single helper functionn and de-macroing dir block verifiers to make
> them less shouty.  Next, we change verifier functions to return the
> approximate instruction pointer of the faulting test so that we can
> report more precise fault information to dmesg/tracepoints.

Just jumping here quickly because I don't have time for a detailed
review:

How good does this instruction pointer thing resolved to the actual
issue?  I'm currently watching a customer issue where a write verifier
triggers, and I gave them a patch to add a debug print to every failing
statement, including printing out the mismatch values if it's not
simply a binary comparism.  I though about preparing that patch as
well as others for mainline.  Here is the one I have at the moment:

---
>From 6c5e2efc6f857228461d439feb3c98be58fb9744 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 5 Aug 2017 16:34:15 +0200
Subject: xfs: print verbose information on dir leaf verifier failures

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b887fb2a2bcf..4386c68f72c6 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -113,27 +113,37 @@ xfs_dir3_leaf_check_int(
 	 * Should factor in the size of the bests table as well.
 	 * We can deduce a value for that from di_size.
 	 */
-	if (hdr->count > ops->leaf_max_ents(geo))
+	if (hdr->count > ops->leaf_max_ents(geo)) {
+		xfs_warn(mp, "count (%d) above max (%d)\n",
+			hdr->count, ops->leaf_max_ents(geo));
 		return false;
+	}
 
 	/* Leaves and bests don't overlap in leaf format. */
 	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
 	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
-	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
+	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp)) {
+		xfs_warn(mp, "ents overlappings bests\n");
 		return false;
+	}
 
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
 			if (be32_to_cpu(ents[i].hashval) >
-					be32_to_cpu(ents[i + 1].hashval))
+					be32_to_cpu(ents[i + 1].hashval)) {
+				xfs_warn(mp, "broken hash order\n");
 				return false;
+			}
 		}
 		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
-	if (hdr->stale != stale)
+	if (hdr->stale != stale) {
+		xfs_warn(mp, "incorrect stalte count (%d, expected %d)\n",
+			hdr->stale, stale);
 		return false;
+	}
 	return true;
 }
 
@@ -159,12 +169,21 @@ xfs_dir3_leaf_verify(
 		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
 							 : XFS_DIR3_LEAFN_MAGIC;
 
-		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
+		if (leaf3->info.hdr.magic != cpu_to_be16(magic3)) {
+			xfs_warn(mp, "incorrect magic number (0x%hx, expected 0x%hx)\n",
+					leaf3->info.hdr.magic, magic3);
 			return false;
-		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
+		}
+		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid)) {
+			xfs_warn(mp, "incorrect uuid, (%pUb, expected %pUb)\n",
+				&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 			return false;
-		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+		}
+		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn) {
+			xfs_warn(mp, "incorrect blkno, (%lld, expected %lld)\n",
+				be64_to_cpu(leaf3->info.blkno), bp->b_bn);
 			return false;
+		}
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
 			return false;
 	} else {
-- 
2.11.0

