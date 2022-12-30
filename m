Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC96C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiL3WlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WlB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:41:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5EF78
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5543CB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1875BC433EF;
        Fri, 30 Dec 2022 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440058;
        bh=jQlLoirxobamOk5zSpBHRZWL0OdV4jUBLF6zcVRag7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g7EXGGOw0ebCe0iYtdsI167fog387nWq1qWwm1z17A1lba6bLaWwjGbPiTVk54fJS
         boG/NBxE8a5c0qiSH8mSBQ2lRIKEFO6FTLBCFCRZfqjm+JxWSqyI4V7AhKU3aADEB/
         ER+gPRFKzug3CcAIay1ts/9lWxvQZFqPl+0d+MVs/t22XJsAY7BuBtlo3X8ylfLR5u
         J4wp8yzv3gJFuTDdhE/zQJ70KrQagNXU0LFUWw+LbY3MbR9vslp/ecr+GDHHE3UIfE
         W114qZfl5oRYozHU1OOvWzeFTA6HhHyFEAlBlpLfPb8t+wLyIe95kDKLzjjUgokfNf
         L2BNyjGxxhirg==
Subject: [PATCH 1/2] xfs: fix rm_offset flag handling in rmap keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:18 -0800
Message-ID: <167243827887.684208.1803581018355949162.stgit@magnolia>
In-Reply-To: <167243827872.684208.12327644447561431612.stgit@magnolia>
References: <167243827872.684208.12327644447561431612.stgit@magnolia>
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

Unfortunately, the code that creates rmap lookup keys from rmap records
forgot to mask off the record attribute flags, leading to ondisk keys
that look like this:

(physical block, owner, fork, is_btree, unwritten state, offset)

Fortunately, this has all worked ok for the past six years because the
key comparison functions incorrectly ignore the fork/bmbt/unwritten
information that's encoded in the on-disk offset.  This means that
lookup comparisons are only done with:

(physical block, owner, offset)

Queries can (theoretically) return incorrect results because of this
omission.  On consistent filesystems this isn't an issue because xattr
and bmbt blocks cannot be shared and hence the comparisons succeed
purely on the contents of the rm_startblock field.  For the one case
where we support sharing (written data fork blocks) all flag bits are
zero, so the omission in the comparison has no ill effects.

Unfortunately, this bug prevents scrub from detecting incorrect fork and
bmbt flag bits in the rmap btree, so we really do need to fix the
compare code.  Old filesystems with the unwritten bit erroneously set in
the rmap key struct will work fine on new kernels since we still ignore
the unwritten bit.  New filesystems on older kernels will work fine
since the old kernels never paid attention to the unwritten bit.

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
 fs/xfs/libxfs/xfs_rmap_btree.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 12c26c42c162..e18f89a68da9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -156,6 +156,16 @@ xfs_rmapbt_get_maxrecs(
 	return cur->bc_mp->m_rmap_mxr[level != 0];
 }
 
+/*
+ * Convert the ondisk record's offset field into the ondisk key's offset field.
+ * Fork and bmbt are significant parts of the rmap record key, but written
+ * status is merely a record attribute.
+ */
+static inline __be64 ondisk_rec_offset_to_key(const union xfs_btree_rec *rec)
+{
+	return rec->rmap.rm_offset & ~cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
+}
+
 STATIC void
 xfs_rmapbt_init_key_from_rec(
 	union xfs_btree_key		*key,
@@ -163,7 +173,7 @@ xfs_rmapbt_init_key_from_rec(
 {
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
 	key->rmap.rm_owner = rec->rmap.rm_owner;
-	key->rmap.rm_offset = rec->rmap.rm_offset;
+	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
 }
 
 /*
@@ -186,7 +196,7 @@ xfs_rmapbt_init_high_key_from_rec(
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
 	be32_add_cpu(&key->rmap.rm_startblock, adj);
 	key->rmap.rm_owner = rec->rmap.rm_owner;
-	key->rmap.rm_offset = rec->rmap.rm_offset;
+	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
 	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
 	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rmap.rm_offset)))
 		return;
@@ -219,6 +229,16 @@ xfs_rmapbt_init_ptr_from_cur(
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
 
+/*
+ * Mask the appropriate parts of the ondisk key field for a key comparison.
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
@@ -240,8 +260,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
-	y = rec->rm_offset;
+	x = offset_keymask(be64_to_cpu(kp->rm_offset));
+	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -272,8 +292,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
-	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	x = offset_keymask(be64_to_cpu(kp1->rm_offset));
+	y = offset_keymask(be64_to_cpu(kp2->rm_offset));
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -387,8 +407,8 @@ xfs_rmapbt_keys_inorder(
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
@@ -417,8 +437,8 @@ xfs_rmapbt_recs_inorder(
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

