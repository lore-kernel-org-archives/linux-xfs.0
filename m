Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28591F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440755; cv=none; b=q4A42WBILTPT5hZcfq2aZCJe1whfGvkf4qqmmQ7moNsxYfhS4pv0u6yyXqilyTXMrOq/4OtsQYB4WbiaAj/Y7IZOnX1IpvTC58aJ1vgGvDVM3wPcQCReB6P9gPID6agk6GtrsL9KEP1+COrHRqK2CL4R1meGfReY21NwZws5Hpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440755; c=relaxed/simple;
	bh=YVJRkOg2PMEki02TkzSErjq10WR/++NMkVOICYN2iv0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mIvKoyADGEbK/ljyTnk4Wqxve0OZ0azvR4YSTbcPaT2B/ZN8MrDjh9b4kQshHxvCbkYNPGko4HC2Hx3Ol5VGMJsPKwKlhw/p0CJvr2K/rN8VgHd6kG02KtYFFV9/YzyIXRQrKHNULmgXKRiFaNGjAaW/MfdUGN3yn2OFBgfTKbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7iOhVut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7iOhVut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F146FC2BD10;
	Mon,  3 Jun 2024 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440755;
	bh=YVJRkOg2PMEki02TkzSErjq10WR/++NMkVOICYN2iv0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i7iOhVut6VgXVeX2bsHmqGuHXbB4IVUtkE+7nUgSGdzen2LfNG+bLQaWXVhEeU+Ge
	 m10TlL6mJQAQ84wvwu3qRdbr+OalZhzlmQ3OQUkEh2JFGlGIqqhTGc60EG7Z1WxXux
	 0F+desjqY4M27E1lEKRtc1PcqLDbwIHFjxlBoDNLWih1dUszyfiDBQXpHrxcJO3cBC
	 tGZXjFVRDz/69wi7J7iQiuIzIIe4+OoFVFS5AltPMz2ayuJlaZpFwi2RELH9RKxBf+
	 tIezLP2Jb9xATiitA3zxtSvc/CcH+SHDTGoSEvz89eq2yj+hMGz99yrA6JtTdT+3Uz
	 EjHMhBvIwWT/A==
Date: Mon, 03 Jun 2024 11:52:34 -0700
Subject: [PATCH 002/111] xfs: convert kmem_alloc() to kmalloc()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744039396.1443973.12082076232479137636.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: f078d4ea827607867d42fb3b2ef907caf86ce49d

kmem_alloc() is just a thin wrapper around kmalloc() these days.
Convert everything to use kmalloc() so we can get rid of the
wrapper.

Note: the transaction region allocation in xlog_add_to_transaction()
can be a high order allocation. Converting it to use
kmalloc(__GFP_NOFAIL) results in warnings in the page allocation
code being triggered because the mm subsystem does not want us to
use __GFP_NOFAIL with high order allocations like we've been doing
with the kmem_alloc() wrapper for a couple of decades. Hence this
specific case gets converted to xlog_kvmalloc() rather than
kmalloc() to avoid this issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_attr_leaf.c     |    7 +++----
 libxfs/xfs_btree_staging.c |    4 ++--
 libxfs/xfs_da_btree.c      |    3 ++-
 libxfs/xfs_dir2.c          |    2 +-
 libxfs/xfs_dir2_block.c    |    2 +-
 libxfs/xfs_dir2_sf.c       |    8 ++++----
 libxfs/xfs_inode_fork.c    |   15 ++++++++-------
 7 files changed, 21 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8a0a7c219..0d7dc789c 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -876,8 +876,7 @@ xfs_attr_shortform_to_leaf(
 
 	trace_xfs_attr_sf_to_leaf(args);
 
-	tmpbuffer = kmem_alloc(size, 0);
-	ASSERT(tmpbuffer != NULL);
+	tmpbuffer = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, ifp->if_data, size);
 	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
 
@@ -1056,7 +1055,7 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
+	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	if (!tmpbuffer)
 		return -ENOMEM;
 
@@ -1530,7 +1529,7 @@ xfs_attr3_leaf_compact(
 
 	trace_xfs_attr_leaf_compact(args);
 
-	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
+	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 	memset(bp->b_addr, 0, args->geo->blksize);
 	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 45b793559..da6e9fa8e 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
 	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
@@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 0864cb5ed..33ac8d13c 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2178,7 +2178,8 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
+		mapp = kmalloc(sizeof(*mapp) * count,
+				GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
 			nmap = min(XFS_BMAP_MAX_NMAP, c);
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index cb299a6ed..52f0461ef 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -332,7 +332,7 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
+	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index bf950c700..b694e6219 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1105,7 +1105,7 @@ xfs_dir2_sf_to_block(
 	 * Copy the directory into a temporary buffer.
 	 * Then pitch the incore inode data so we can make extents.
 	 */
-	sfp = kmem_alloc(ifp->if_bytes, 0);
+	sfp = kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(sfp, oldsfp, ifp->if_bytes);
 
 	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 37c7e1d5c..9e0c15f99 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -276,7 +276,7 @@ xfs_dir2_block_to_sf(
 	 * format the data into.  Once we have formatted the data, we can free
 	 * the block and copy the formatted data into the inode literal area.
 	 */
-	sfp = kmem_alloc(mp->m_sb.sb_inodesize, 0);
+	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
 
 	/*
@@ -524,7 +524,7 @@ xfs_dir2_sf_addname_hard(
 	 * Copy the old directory to the stack buffer.
 	 */
 	old_isize = (int)dp->i_disk_size;
-	buf = kmem_alloc(old_isize, 0);
+	buf = kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
 	memcpy(oldsfp, dp->i_df.if_data, old_isize);
 	/*
@@ -1151,7 +1151,7 @@ xfs_dir2_sf_toino4(
 	 * Don't want xfs_idata_realloc copying the data here.
 	 */
 	oldsize = dp->i_df.if_bytes;
-	buf = kmem_alloc(oldsize, 0);
+	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 	ASSERT(oldsfp->i8count == 1);
 	memcpy(buf, oldsfp, oldsize);
 	/*
@@ -1223,7 +1223,7 @@ xfs_dir2_sf_toino8(
 	 * Don't want xfs_idata_realloc copying the data here.
 	 */
 	oldsize = dp->i_df.if_bytes;
-	buf = kmem_alloc(oldsize, 0);
+	buf = kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 	ASSERT(oldsfp->i8count == 0);
 	memcpy(buf, oldsfp, oldsize);
 	/*
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 208b283ba..7de346e87 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -48,7 +48,7 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		char *new_data = kmem_alloc(mem_size, KM_NOFS);
+		char *new_data = kmalloc(mem_size, GFP_NOFS | __GFP_NOFAIL);
 
 		memcpy(new_data, data, size);
 		if (zero_terminate)
@@ -75,7 +75,7 @@ xfs_iformat_local(
 	/*
 	 * If the size is unreasonable, then something
 	 * is wrong and we just bail out rather than crash in
-	 * kmem_alloc() or memcpy() below.
+	 * kmalloc() or memcpy() below.
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
@@ -114,7 +114,7 @@ xfs_iformat_extents(
 
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
-	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
+	 * we just bail out rather than crash in kmalloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
 		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
@@ -203,7 +203,7 @@ xfs_iformat_btree(
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_NOFS);
+	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -397,7 +397,8 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
+			ifp->if_broot = kmalloc(new_size,
+						GFP_NOFS | __GFP_NOFAIL);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -438,7 +439,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_NOFS);
+		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -486,7 +487,7 @@ xfs_iroot_realloc(
  *
  * If the amount of space needed has decreased below the size of the
  * inline buffer, then switch to using the inline buffer.  Otherwise,
- * use kmem_realloc() or kmem_alloc() to adjust the size of the buffer
+ * use krealloc() or kmalloc() to adjust the size of the buffer
  * to what is needed.
  *
  * ip -- the inode whose if_data area is changing

