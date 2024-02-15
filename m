Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214212BF0A
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998992; cv=none; b=FGnP87UibS9U7qDXqnjiPTfSug64CC3eEQU0LPB7d3ily1fMD5w5K5PMJtmAt3kxmJ/Q6eNCV+ysr231au4jaq6GyGTTrqWCF0vfxX2mwJ5zc/7tTsKN+pdFxeTYfvi61pgnN8k9kS/miXSrYc10tndlZ4VjcqQrMM2wIz9uX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998992; c=relaxed/simple;
	bh=3rnLT1Ahuz/kvVWZz9pzrW828ZRP4WMTH7uYl/ELZOg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTaiXmlTGFsyql7B57CMbcz7gA/nQ3IGCP60ODlahw7DjsAbo5YaTbEhQhF+4CzskWjC9eFTPkeFT8RyRRXqCvO0iOhugb8IUffl9hvEf0VC3Vv9Gq4iQFvAVdx8DoU4B1oqKgjbAEFZejOIhly/SeiGu45osrAz19V1cu4XNnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeS1kfSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeS1kfSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFDCC433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998992;
	bh=3rnLT1Ahuz/kvVWZz9pzrW828ZRP4WMTH7uYl/ELZOg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UeS1kfSqafcLQEEQSEWohDcgs+Ucf+a9ViYFCX2qtD7cYrMgaGSHvG/RgR9/b8VOH
	 EJZCmMHOZnXuOp8Pa3wO8Sarma+NJc6lMVAcrs9quiO6Z//1zN75m2H/uhaowuFBAs
	 FRA45fCb4zJR4Yoe3cWSvp6k98sJFdn5QL9kLpjItfJSn3eEHP54Q7Vm8mKYsY+Ws3
	 CWdN8uDe4G0+k2KPOAzgmxSOBnf0x0mPjZVCFozhHN45VEOXswqtlbzK0TLpApgxl6
	 sOABSiegpgqvjYar45N5q5VcWhDcR6E9iPMlkyT0XL1cCp0uZjNkRkIjP/y+FSmrnI
	 XUPcMf6LM0Q8Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 34/35] xfs: fix internal error from AGFL exhaustion
Date: Thu, 15 Feb 2024 13:08:46 +0100
Message-ID: <20240215120907.1542854-35-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

Source kernel commit: f63a5b3769ad7659da4c0420751d78958ab97675

We've been seeing XFS errors like the following:

XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
...
Call Trace:
xfs_corruption_error+0x94/0xa0
xfs_btree_insert+0x221/0x280
xfs_alloc_fixup_trees+0x104/0x3e0
xfs_alloc_ag_vextent_size+0x667/0x820
xfs_alloc_fix_freelist+0x5d9/0x750
xfs_free_extent_fix_freelist+0x65/0xa0
__xfs_free_extent+0x57/0x180
...

This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
xfs_btree_insrec() fails.

After converting this into a panic and dissecting the core dump, I found
that xfs_btree_insrec() is failing because it's trying to split a leaf
node in the cntbt when the AG free list is empty. In particular, it's
failing to get a block from the AGFL _while trying to refill the AGFL_.

If a single operation splits every level of the bnobt and the cntbt (and
the rmapbt if it is enabled) at once, the free list will be empty. Then,
when the next operation tries to refill the free list, it allocates
space. If the allocation does not use a full extent, it will need to
insert records for the remaining space in the bnobt and cntbt. And if
those new records go in full leaves, the leaves (and potentially more
nodes up to the old root) need to be split.

Fix it by accounting for the additional splits that may be required to
refill the free list in the calculation for the minimum free list size.

P.S. As far as I can tell, this bug has existed for a long time -- maybe
back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
...") in April 1994! It requires a very unlucky sequence of events, and
in fact we didn't hit it until a particular sparse mmap workload updated
from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
exposed by some other change in allocation or writeback patterns. It's
also much less likely to be hit with the rmapbt enabled, since that
increases the minimum free list size and is unlikely to split at the
same time as the bnobt and cntbt.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 4519a0555..7ac7c2f6c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2271,16 +2271,37 @@ xfs_alloc_min_freelist(
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
 
+	/*
+	 * For a btree shorter than the maximum height, the worst case is that
+	 * every level gets split and a new level is added, then while inserting
+	 * another entry to refill the AGFL, every level under the old root gets
+	 * split again. This is:
+	 *
+	 *   (full height split reservation) + (AGFL refill split height)
+	 * = (current height + 1) + (current height - 1)
+	 * = (new height) + (new height - 2)
+	 * = 2 * new height - 2
+	 *
+	 * For a btree of maximum height, the worst case is that every level
+	 * under the root gets split, then while inserting another entry to
+	 * refill the AGFL, every level under the root gets split again. This is
+	 * also:
+	 *
+	 *   2 * (current height - 1)
+	 * = 2 * (new height - 1)
+	 * = 2 * new height - 2
+	 */
+
 	/* space needed by-bno freespace btree */
 	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels);
+				       mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels);
+						mp->m_rmap_maxlevels) * 2 - 2;
 
 	return min_free;
 }
-- 
2.43.0

