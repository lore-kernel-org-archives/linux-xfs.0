Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC49E390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497184; cv=none; b=o2LG0ycgfLTIwU4xt4vY8a8j6v6dL8zFBSsjPP8S7w6PXd+ADnk9vqr4rF1B4QJwM/TbcmooQfpZiA1nGOdJgQc3iwbVP9rcp8s8O7FD8rS9jq9awfRD+NzQlMZS46MYZsfh4/h6+iknHzd59tjPwUGdPJdU2SjMPAy8B5O8aZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497184; c=relaxed/simple;
	bh=TTKuQqVGnHqPU8iDp18C6RL9RCXc+8zdVIeZkWM/stU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqc3JB0Vs6BAukkLFtiJ43BJXy9Tb26FKOhmAisTLTSOmn7hrcGxETl+7mIJawQxt7aOrJmUb2gfRpV8YIYywsXaUSgmRea2GZe3FBWuw5VovgKzftn0ZbRwQx76uE6529+bCqLX0a6/a57JYQzs+ivzSxye+0dtp/7vzGY6zfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3CXgKP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3CXgKP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D75C19423;
	Tue,  3 Mar 2026 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497184;
	bh=TTKuQqVGnHqPU8iDp18C6RL9RCXc+8zdVIeZkWM/stU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u3CXgKP06v0l15AVi0vV7JrpMmTl3iN8U6gEvdDz7tuNw7v3V7ms0ycYWK5KaxsYz
	 OWe4cESdBvkQiH8K6ghXQ4JbxxuCFUOk0GmVC0TD0qu6N/BIyv3RpIeV5XyMBwFdoI
	 L8alkuZaQKhZ7DkrcFZpSPTPVpUudpIy3kNVhXwkOQzUi8pLQ9W7p1n21RlbrxPU4w
	 ohMW4MFG3FD0gM5EuE8XW2EDMa6qiBlFwAQnhkUf6K/ZbEQqwZ6nlxVZD3jQpI2j4Y
	 jyRQZqlO4Ij39+GWre987Lt3YBSPWBTZ9+rvqEVrCn/Hbvu0Co1aVr1ZbjSa/gQqNv
	 Oy8ZLZbvM+4Vw==
Date: Mon, 02 Mar 2026 16:19:44 -0800
Subject: [PATCH 29/36] treewide: Replace kmalloc with kmalloc_obj for
 non-scalar types
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: kees@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249638311.457970.11002432782642333341.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
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
 include/kmem.h        |   34 ++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.c       |    2 +-
 libxfs/xfs_defer.c    |    2 +-
 libxfs/xfs_dir2.c     |   19 +++++++++----------
 libxfs/xfs_refcount.c |    4 ++--
 libxfs/xfs_rtgroup.c  |    2 +-
 6 files changed, 48 insertions(+), 15 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index d66310ececec80..52a2b1f068b555 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -63,6 +63,40 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 #define kmalloc_array(n, size, gfp)	kvmalloc((n) * (size), (gfp))
 #define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
 
+/**
+ * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
+ * @factor1: first factor
+ * @factor2: second factor
+ *
+ * Returns: calculate @factor1 * @factor2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
+ */
+static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(factor1, factor2, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,b,...) b
+#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
+
+#define kzalloc_obj(P, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kmalloc_obj(VAR_OR_TYPE, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), 1)
+
 static inline void kfree(const void *ptr)
 {
 	free((void *)ptr);
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
 

