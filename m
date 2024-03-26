Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316C221353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425460; cv=none; b=fquCpls9pyDyu9YSHMFXdHGml3tOlFdUNk8FoPS1pQ3pw1Di1ZsXkCICRH7CsM8w88nxzFq5NBRvu3qaSVEhnoLsc8U2kOUF2PNekTbMm3rYxyiaCdgqBgX11Bb7MJl0RWADHQ16KRvCIMSbyikUbxTYJ4dhxZjEv/QgvtPmY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425460; c=relaxed/simple;
	bh=m3iG23jPfN+2jGmxV3hvXNApBsJ6jMco+r+2IfAZuQQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMdc6CxlaUPCqcJjPPFuwMH61umEYq5AvUycEOnZXwtOnu6gh6HifpMbOplrIWuOWvT2n6JkBct/SobaxQ5tJzcF0r1gfZDoU3qQskrb4RQUHmgWP9fLat9aFUuigEteG58dipJapQTWU2B+IOiO9KO3hIJES9ssJwdFrITl8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFO8e6SP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFO8e6SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0364CC433C7;
	Tue, 26 Mar 2024 03:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425460;
	bh=m3iG23jPfN+2jGmxV3hvXNApBsJ6jMco+r+2IfAZuQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UFO8e6SPngvzW31rMuo5ZE6r9syWAL9ba4XPIcoKlbXP67B1p7zNTkGI7YAFU2MbL
	 7pZjL/Ay1qIj/3ImGuUHJNT8vt+Jnp70eXHW80b6381UPxmFANbYfMNNdDBz8snJTu
	 EZv3qk511WYNavdsuPHwmd5i/mT0LCHDhx1BxhgAWW/8hcEnktWngSbL8Bh54u1rM7
	 vUvHKUnUMOMmpinIiHOZGhvOfrADiCgBaK9sWUV2B7jUpS3GsF0MmbwUyzNTxgMcoY
	 zSqLhj2FE8oTSQgHYj1M8a47ZV1NiG2IVrwzMWpkLF/BSBIKaY/lLmwJdb0ZFogimx
	 CfLjVSu4FYMYA==
Date: Mon, 25 Mar 2024 20:57:39 -0700
Subject: [PATCH 2/4] libxfs: add a bi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133320.2217863.10523483539378615179.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
References: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a helper to translate from the item list head to the bmap_intent
structure and use it so shorten assignments and avoid the need for extra
local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 680a72664746..d19322a0b255 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -439,6 +439,11 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 
 /* Inode Block Mapping */
 
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -446,11 +451,9 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_bmap_intent	*ba;
-	const struct xfs_bmap_intent	*bb;
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
@@ -527,10 +530,9 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bi;
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 	int				error;
 
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
 	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
@@ -554,9 +556,7 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bi;
-
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);

