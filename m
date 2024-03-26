Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F21292D0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423736; cv=none; b=GSbg/6gms5b7VEzkWbHwUosFOYhz/rUTpgl9rsoiFe/gF5vSFephRqPKcxXarWi7mhIB75GucBjKp25gv+1a2iA4DOL/17XFxOPJGA8CIhDKAjJ/oM55MNMPNdhmW7SX8Mo6LdXoux00A6AJan10FJibDdTkK+681P93ekjHKHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423736; c=relaxed/simple;
	bh=qilKaNr50XugDA2f9boaEkZrI8NSzb9RnY2/XXQRaoM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUwGD0mIMCeAvCmnGVyku4bjStH1knGomj6mJ+PFh6UJQNQ7gXeuHaeZvEwcc7VuC91docXKVQuAHIXBUhNu3rISsgGYffuFgJFPEcQEk2oRH1qTPscMttXqJS/QQsBz65nsLZLQyKnN3m5d2FvR7MApoLwInwTGlamMMD3uqII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhW6MbOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhW6MbOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C0AC433F1;
	Tue, 26 Mar 2024 03:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423736;
	bh=qilKaNr50XugDA2f9boaEkZrI8NSzb9RnY2/XXQRaoM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PhW6MbOmMGfLbRbUbzFp971bINPzR2NRAcCl0qikQiAkrgh3uh6IArxnHQliy4LpS
	 YH5nYPSrLxZKUVBil/Rj8KsfIb0CiulOmT5cN0GCqOWxGABOkc9Y6YCXg3tHwpX+1W
	 Jc5zKoeZGrLZ2neb45nXaLYcnqgoRPVJ4bQRSC4SKOOe974k9o/uGwFyICr5O+vMV1
	 F0DmyXLxV/llOMay92S6dfO4fCPHgflIywASvweXFJJ6Tnq7n6Dy1olDOMgEAtmd49
	 clP2lO+p13Syh135sX8CJEuBa/6IWXYdOhT5iO+4BL04OIXbiipUVI0XvTL9S6gCXT
	 4FcVGJc15nvag==
Date: Mon, 25 Mar 2024 20:28:55 -0700
Subject: [PATCH 002/110] xfs: convert kmem_alloc() to kmalloc()
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142131414.2215168.2013938706920921488.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 8a0a7c21932c..0d7dc789ce48 100644
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
index 45b793559b06..da6e9fa8e8aa 100644
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
index 0864cb5ed74e..33ac8d13c0c5 100644
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
index cb299a6ed500..52f0461ef07f 100644
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
index bf950c7001f8..b694e62198b5 100644
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
index 37c7e1d5cc8a..9e0c15f9993e 100644
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
index 208b283ba338..7de346e87c10 100644
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

