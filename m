Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726AF86AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423783; cv=none; b=ib1q6lyMdRxymhOUGbQ/oCBIc8rvgGcZfXjxukzz3vxyh/wnJlEcyrE7va5SpZontMTtinn1TAurxla9RRtHeUCVPv7+xrOaJTrdNoPGvTixXzPKf1TkhMb6mUEcEE4XHfdxYXteGdQh2KBMVmwf6Qy8DiwElPaiS2y8nbtCUxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423783; c=relaxed/simple;
	bh=utaSic7xNJXtU6FsdqA2hW5e8o9Z5Tiv+Iyuzq//+Go=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLs9ZzXeQGn1EYf4iXMd8XmhQyrZ2Ze60dFGnfyiRqsWrc5daJMFTl3vmtg5rxyFksO/d/ijQ3Aq84CFAqvebrBqPXB7AxXRQJAGrdzj0v+xQ6LOcdWOnk28Tv5+iBduFkDO9inwIABeHHXAuJhopZz8lbm+QhCHLNWtnzEZbdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl9yEwyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl9yEwyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED09C433F1;
	Tue, 26 Mar 2024 03:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423783;
	bh=utaSic7xNJXtU6FsdqA2hW5e8o9Z5Tiv+Iyuzq//+Go=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kl9yEwyK4/c603TP/oS+fTNi5g1d37+AuD1+sqyNpW07Qh8bYaoHtDTJed9lj8iwH
	 rClveZRDQk8uTSiZ1q+TlMPGxx/mHreaUSFSrnWn/e1MnlG9nCBAPWjDxh1DbdiJMk
	 KjTd68C9Fphzh/GN8Bgcz/SliAT/6w58NYdgShWTMMcUo8GWIflaQ6Gu6f9F3Rw/Ny
	 IVHE96xS3uRAPDJV1xdhkmyav1TRamRnQ5U1xzMxW8lQiaBEIP0JOwkTW3JDKGqgwj
	 rtFLyjn6+5kqo2ehVWZSNmQT1iMfN/TJmFi730ixu0gsLYI//5sw7p/c0UWtKn0S0O
	 PCM53api05rmA==
Date: Mon, 25 Mar 2024 20:29:42 -0700
Subject: [PATCH 005/110] xfs: use GFP_KERNEL in pure transaction contexts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142131458.2215168.11103177709469156857.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0b3a76e955ebe3d71a2bcd5990404ed522b40e17

When running in a transaction context, memory allocations are scoped
to GFP_NOFS. Hence we don't need to use GFP_NOFS contexts in pure
transaction context allocations - GFP_KERNEL will automatically get
converted to GFP_NOFS as appropriate.

Go through the code and convert all the obvious GFP_NOFS allocations
in transaction context to use GFP_KERNEL. This further reduces the
explicit use of GFP_NOFS in XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr.c       |    3 ++-
 libxfs/xfs_bmap.c       |    2 +-
 libxfs/xfs_defer.c      |    6 +++---
 libxfs/xfs_dir2.c       |    8 ++++----
 libxfs/xfs_inode_fork.c |    8 ++++----
 libxfs/xfs_refcount.c   |    2 +-
 libxfs/xfs_rmap.c       |    2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 630065f1a392..8356d4a3c679 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -889,7 +889,8 @@ xfs_attr_defer_add(
 
 	struct xfs_attr_intent	*new;
 
-	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 494994d360e4..ee4e6c766144 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6092,7 +6092,7 @@ __xfs_bmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
 	bi->bi_owner = ip;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1de3faf5ed2d..dae9ad57fb2e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -819,7 +819,7 @@ xfs_defer_alloc(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
@@ -882,7 +882,7 @@ xfs_defer_start_recovery(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
@@ -973,7 +973,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
+	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 1a2fb999ab08..914c75107753 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -235,7 +235,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -272,7 +272,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -434,7 +434,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -495,7 +495,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index cb1964189f5c..f8f6a7364d57 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -400,7 +400,7 @@ xfs_iroot_realloc(
 		if (ifp->if_broot_bytes == 0) {
 			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
 			ifp->if_broot = kmalloc(new_size,
-						GFP_NOFS | __GFP_NOFAIL);
+						GFP_KERNEL | __GFP_NOFAIL);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -415,7 +415,7 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_KERNEL | __GFP_NOFAIL);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -441,7 +441,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
+		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -510,7 +510,7 @@ xfs_idata_realloc(
 
 	if (byte_diff) {
 		ifp->if_data = krealloc(ifp->if_data, new_size,
-					GFP_NOFS | __GFP_NOFAIL);
+					GFP_KERNEL | __GFP_NOFAIL);
 		if (new_size == 0)
 			ifp->if_data = NULL;
 		ifp->if_bytes = new_size;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index de321ab9d91d..36dd06e63887 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1448,7 +1448,7 @@ __xfs_refcount_add(
 			blockcount);
 
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 4731e10d2101..e7681c7c852d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2558,7 +2558,7 @@ __xfs_rmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_owner = owner;

