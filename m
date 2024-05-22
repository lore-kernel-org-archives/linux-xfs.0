Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F32DF5B
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346204; cv=none; b=n5D9JrFllO+yzsONBNt/eA+U3Zsx8aTvglctWKXEiGZuYu0ukOm4rYAIcZ9A418fHIHJxdsx83oYMSgVnkpAltAljUTYzvRxnxEchwJsqZAiC91O3Wtss8esM6mgGkmziMtcvMIt8tx6QFJ/JlD4uClOt9FSEFapZtKrI8LS9LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346204; c=relaxed/simple;
	bh=6kfn1t3uTh1vcZQGg9Kiyhq1i0jpBDMb3TTAH9fD82M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DButNFdcCPvJiA+cSYX8agLzLD2lpjk168DBM/Yjiuy6g7dDAPiqED1loiYiD++Is1Yajs7udCrWN8nN0fDURXEzbwx+yj/JRXrnEv3w3B81u08cyGdKEtsIZ93ju2WhxtZ8AqLB0t89LXBI5aYmyGiEABVQSGOrF31hvN1oV6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIiLf7Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIiLf7Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB24C2BD11;
	Wed, 22 May 2024 02:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346204;
	bh=6kfn1t3uTh1vcZQGg9Kiyhq1i0jpBDMb3TTAH9fD82M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hIiLf7BpFC1bJzFfkav1qi+Uat1nBphr0uHPT5hEmZVXlQT0eoOj6Lp9fBNBPEux1
	 aIyv1P25c+o54rJNCAefV9QCIOlKlzYH7QL0FEjQctAkmiPuREhUprOKwcntMtfUkJ
	 V7/bSySEGGis6GRKy0kDhqR4Q7+w1Ldqza/Rn1eMQ7siChI/qiWuKGgs0xiOaiJQUy
	 MZYSLmELjPG83vxNOP9Ma/8cePgGHumPDs2Ck3tk9bttjSB3lj0ftqxuQZkP3l4lET
	 V+4T0vtQyqTeATM9ky2Kx0m0nVoMa4dSn2iV8Ibllgu1T/VzLBYVk8hrowRXabq4ii
	 iAOJqB+zyDLzQ==
Date: Tue, 21 May 2024 19:50:04 -0700
Subject: [PATCH 005/111] xfs: use GFP_KERNEL in pure transaction contexts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634531785.2478931.15285746790534972923.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 630065f1a..8356d4a3c 100644
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
index 494994d36..ee4e6c766 100644
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
index 1de3faf5e..dae9ad57f 100644
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
index 1a2fb999a..914c75107 100644
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
index cb1964189..f8f6a7364 100644
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
index de321ab9d..36dd06e63 100644
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
index 4731e10d2..e7681c7c8 100644
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

