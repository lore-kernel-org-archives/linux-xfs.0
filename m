Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C73264CC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291764; cv=none; b=s3I0b7OHjMTSLogWIepjDGg0U7m5WshYfTTvscp5cDNUdyqqSm8YxeyB3D3RfIiUtKIPLDGthdespTVwXhLNQq8cQi00BnECsu1POOokaFYIlT/nGX3TUnw1vyYOt1eo/LwK/W9k8NW0P4eVgKPqKTL3XBrUQhgxO6hE1NIE0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291764; c=relaxed/simple;
	bh=kOvJVzX2EnSf37smTUH+zfZjv50UBEfubWjhYwBPKHk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMPN4zSua0Idh+2bgvO6gzDFzHKEIx8kUliMOsUNp0NmtAYdP9e1T5IceWP+MVhHs5aP59V3u2Dg4PMkpHlsQN4du/tkSHA01YAHqu2prgvHy2SXzf6xbm2M3B9EmLbO8L+32Ut65ingqSicuOqy2wTopjSABmYPDE03IUubpiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJf2flNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJf2flNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED9AC4CEF7;
	Mon, 23 Mar 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291764;
	bh=kOvJVzX2EnSf37smTUH+zfZjv50UBEfubWjhYwBPKHk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YJf2flNa5wtmYt/llt0Y7ytW7G8ggigWaEBSfBYd3SB3xGHUcKFKLevpBuJCzT3Is
	 bRTktCtFXqf2YD/L77NZ6t6wQN15BB586xiLumYFgL/ro0wsvc10LfkBzKq6f/3xeo
	 KMecBtBePUgxZYL/9TedwiSoPhXiGpHY9Kh6u1qfFhbxVBDQj53q3rkt3QAmLtV4g0
	 dKEO6m22OaykE4A6sUTHlQfyxtUzdmJkpZSFAigLx2gZumK7PaWoqlGzQyyamDB4tp
	 JS7XozFW/wtlqvbLAaBdgKrZxfxSMKuFXiCCyuvi0m+q3TNApPaUTg3TWo0Tec7/ct
	 txmLNYc3bsxEw==
Date: Mon, 23 Mar 2026 11:49:23 -0700
Subject: [PATCH 31/40] treewide: Replace kmalloc with kmalloc_obj for
 non-scalar types
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: kees@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177429121310.2266274.7411180869161611244.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Kees Cook <kees@kernel.org>

Source kernel commit: 69050f8d6d075dc01af7a5f2f550a8067510366f

This is the result of running the Coccinelle script from
scripts/coccinelle/api/kmalloc_objs.cocci. The script is designed to
avoid scalar types (which need careful case-by-case checking), and
instead replace kmalloc-family calls that allocate struct or union
object instances:

Single allocations:     kmalloc(sizeof(TYPE), ...)
are replaced with:      kmalloc_obj(TYPE, ...)

Array allocations:      kmalloc_array(COUNT, sizeof(TYPE), ...)
are replaced with:      kmalloc_objs(TYPE, COUNT, ...)

Flex array allocations: kmalloc(struct_size(PTR, FAM, COUNT), ...)
are replaced with:      kmalloc_flex(*PTR, FAM, COUNT, ...)

(where TYPE may also be *VAR)

The resulting allocations no longer return "void *", instead returning
"TYPE *".

Signed-off-by: Kees Cook <kees@kernel.org>
---
 libxfs/xfs_ag.c       |    2 +-
 libxfs/xfs_defer.c    |    2 +-
 libxfs/xfs_dir2.c     |   19 +++++++++----------
 libxfs/xfs_refcount.c |    4 ++--
 libxfs/xfs_rtgroup.c  |    2 +-
 5 files changed, 14 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 8ccd67672b4e00..0f1eaf5d6e39b8 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -222,7 +222,7 @@ xfs_perag_alloc(
 	struct xfs_perag	*pag;
 	int			error;
 
-	pag = kzalloc(sizeof(*pag), GFP_KERNEL);
+	pag = kzalloc_obj(*pag, GFP_KERNEL);
 	if (!pag)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index c0d3aa401cbab5..e4d17177f67faf 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -975,7 +975,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL | __GFP_NOFAIL);
+	dfc = kzalloc_obj(*dfc, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 2ca6bf198ba54f..1a13fec25e15b3 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -115,10 +115,10 @@ xfs_da_mount(
 	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
 
-	mp->m_dir_geo = kzalloc(sizeof(struct xfs_da_geometry),
-				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
-				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	mp->m_dir_geo = kzalloc_obj(struct xfs_da_geometry,
+				    GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	mp->m_attr_geo = kzalloc_obj(struct xfs_da_geometry,
+				     GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!mp->m_dir_geo || !mp->m_attr_geo) {
 		kfree(mp->m_dir_geo);
 		kfree(mp->m_attr_geo);
@@ -247,7 +247,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
+	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -340,7 +340,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
+	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -436,8 +436,7 @@ xfs_dir_lookup(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
-	args = kzalloc(sizeof(*args),
-			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -502,7 +501,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
+	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -562,7 +561,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
+	args = kzalloc_obj(*args, GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 5c362e0e901124..036497dbb22b70 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2031,8 +2031,8 @@ xfs_refcount_recover_extent(
 		return -EFSCORRUPTED;
 	}
 
-	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
-			GFP_KERNEL | __GFP_NOFAIL);
+	rr = kmalloc_obj(struct xfs_refcount_recovery,
+			 GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index af4eafb20bc138..69e71494057a1e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -95,7 +95,7 @@ xfs_rtgroup_alloc(
 	struct xfs_rtgroup	*rtg;
 	int			error;
 
-	rtg = kzalloc(sizeof(struct xfs_rtgroup), GFP_KERNEL);
+	rtg = kzalloc_obj(struct xfs_rtgroup, GFP_KERNEL);
 	if (!rtg)
 		return -ENOMEM;
 

