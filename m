Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3D2C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJBScD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBScC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C083C156
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5DA60EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8704AC433D6;
        Sun,  2 Oct 2022 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735520;
        bh=oAt+mMBfFEdeA2ZC+viDdPLsveS8wBtyQ7BoqyAk2wY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DpoK/s/t6ADkO7o/hBC5NqPYuXolnqP8Jq1Vnx4lU0Hmgfjn17tR6iur9iUUSZFBT
         fHnpDDBQaoobrz4qG/GgVKjdUynTnCScCzl0dY9/UgJu41d56dqVCNJ/RlHZbSEXb5
         YaunFIjS5hiw8QuLPSvUgGFtRBXOfZlljKpZCwKd5iib/5z4Kb6u/1DxcBGNJGJhbZ
         q3GyBKXp3pLCzCRxP43JcARgVRseHIZEO9NCknlGgsJjQtwCLzo8fpcPOJ07qb3c19
         uxNFJYhyKndIfGwWj16fkNGBVvBgLmcrJY65Jeqn79hMg+TlADX0yj9InIqGiewmTZ
         J9/YABprd36sA==
Subject: [PATCH 1/2] xfs: fix rmap key comparison functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:12 -0700
Message-ID: <166473481263.1084112.1077820948503334734.stgit@magnolia>
In-Reply-To: <166473481246.1084112.5533985608121370791.stgit@magnolia>
References: <166473481246.1084112.5533985608121370791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Keys for extent interval records in the reverse mapping btree are
supposed to be computed as follows:

(physical block, owner, fork, is_btree, offset)

This provides users the ability to look up a reverse mapping from a file
block mapping record -- start with the physical block; then if there are
multiple records for the same block, move on to the owner; then the
inode fork type; and so on to the file offset.

However, the key comparison functions incorrectly remove the fork/bmbt
information that's encoded in the on-disk offset.  This means that
lookup comparisons are only done with:

(physical block, owner, offset)

This means that queries can return incorrect results.  On consistent
filesystems this isn't an issue because bmbt blocks and blocks mapped to
an attr fork cannot be shared, but this prevents us from detecting
incorrect fork and bmbt flag bits in the rmap btree.

A previous version of this patch forgot to keep the (un)written state
flag masked during the comparison and caused a major regression in
5.9.x since unwritten extent conversion can update an rmap record
without requiring key updates.

Note that blocks cannot go directly from data fork to attr fork without
being deallocated and reallocated, nor can they be added to or removed
from a bmbt without a free/alloc cycle, so this should not cause any
regressions.

Found by fuzzing keys[1].attrfork = ones on xfs/371.

Fixes: 4b8ed67794fe ("xfs: add rmap btree operations")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7f83f62e51e0..e2e1f68cedf5 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -219,6 +219,15 @@ xfs_rmapbt_init_ptr_from_cur(
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
 
+/*
+ * Fork and bmbt are significant parts of the rmap record key, but written
+ * status is merely a record attribute.
+ */
+static inline uint64_t offset_keymask(uint64_t offset)
+{
+	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
+}
+
 STATIC int64_t
 xfs_rmapbt_key_diff(
 	struct xfs_btree_cur		*cur,
@@ -240,8 +249,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
-	y = rec->rm_offset;
+	x = offset_keymask(be64_to_cpu(kp->rm_offset));
+	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -272,8 +281,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
-	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	x = offset_keymask(be64_to_cpu(kp1->rm_offset));
+	y = offset_keymask(be64_to_cpu(kp2->rm_offset));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -387,8 +396,8 @@ xfs_rmapbt_keys_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
+	a = offset_keymask(be64_to_cpu(k1->rmap.rm_offset));
+	b = offset_keymask(be64_to_cpu(k2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;
@@ -417,8 +426,8 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
+	a = offset_keymask(be64_to_cpu(r1->rmap.rm_offset));
+	b = offset_keymask(be64_to_cpu(r2->rmap.rm_offset));
 	if (a <= b)
 		return 1;
 	return 0;

