Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42104 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbeHHGOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Aug 2018 02:14:48 -0400
Subject: [PATCH 1/4] xfs: xrep_findroot_block should reject root blocks with
 siblings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 Aug 2018 20:57:06 -0700
Message-ID: <153370062610.25077.16005158396857920623.stgit@magnolia>
In-Reply-To: <153370061966.25077.161884080659267764.stgit@magnolia>
References: <153370061966.25077.161884080659267764.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In xrep_findroot_block, if we find a candidate root block with sibling
pointers or sibling blocks on the same tree level, we should not return
that block as a tree root because root blocks cannot have siblings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 85b048b341a0..6c199e2ebb81 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -727,6 +727,23 @@ xrep_findroot_block(
 	bp->b_ops->verify_read(bp);
 	if (bp->b_error)
 		goto out;
+
+	/* Root blocks can't have siblings. */
+	if (btblock->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) ||
+	    btblock->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK))
+		goto out;
+
+	/*
+	 * If we find a second block at this level, ignore this level because
+	 * it can't possibly be a root level.  Maybe we'll find a higher level,
+	 * or maybe the rmap information is garbage.
+	 */
+	if (fab->root != NULLAGBLOCK &&
+	    fab->height == xfs_btree_get_level(btblock) + 1) {
+		fab->root = NULLAGBLOCK;
+		goto out;
+	}
+
 	fab->root = agbno;
 	fab->height = xfs_btree_get_level(btblock) + 1;
 	*found_it = true;

