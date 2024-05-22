Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2135234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346220; cv=none; b=YECdrkFw2UKiGP2LVDlnK4t7YurdjlN4ctlNIjMRKFINJcKIlGS54qATWjMgSdBJsEsNbp+uCUlS2e3pOlftQIq+E2BE1Zah+YE/oPpvCe6sSxJQNDk3kQm7sikcx1S6ju8eel33jK8HCbG7e10TbKGjz/aXaPjdfmUW75qvaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346220; c=relaxed/simple;
	bh=WFrSFu+Je0wb8uLDHjUnkSAwh16FbviAmT7ZK3npfHc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFxe2NDMRWCPAEMHS9LFlHCTNMUrcpLY+ITHlDQ1vb6hvxxLh4KXGCVBo/NuqQKVWGWrjDM2iXOcIM0F0ejSYvXGyCaR5hhFaCHHHhQtYpoJ81MSz9s1yN9LB8ZBxoyda5hx3cya7racj61lu7OzB98xWl/cnZiraCQsiwLkOfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n79dedqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n79dedqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58416C2BD11;
	Wed, 22 May 2024 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346220;
	bh=WFrSFu+Je0wb8uLDHjUnkSAwh16FbviAmT7ZK3npfHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n79dedqPDBiwujeqYcMXTFflPByIBzvIbQc152b8SmnSHRFmjkkOY7h1oZ3+FLEuw
	 KxMUqIoH7jz+dsMq7emvD+a8QjMp8cycpyA0WTP3Z2SEbrLaX1JIFhaxeZvNzaPXo+
	 gHFbWUHhaJIUZZyjsYhWDkwTlKwW3Woa3BLozURLYPJCk8VNqTn84qHdoul4dtFNtf
	 KvnQlnTzvwb5zp6K/flmY8gvlJbxmfAtCMh/tcSf+KgJruhNrs4d0R54zQUUjw1upq
	 lDervrSfU7EkD+HUGusvS2ViAu/llIqVOrRiyjohNdSYfc11yAlmSCCiVXAWRqUZy1
	 BNrdikVRy2rig==
Date: Tue, 21 May 2024 19:50:19 -0700
Subject: [PATCH 006/111] xfs: clean up remaining GFP_NOFS users
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634531801.2478931.5426445673053937088.stgit@frogsfrogsfrogs>
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

Source kernel commit: 204fae32d5f7b9ac673d3d4f636dcef8697db2f0

These few remaining GFP_NOFS callers do not need to use GFP_NOFS at
all. They are only called from a non-transactional context or cannot
be accessed from memory reclaim due to other constraints. Hence they
can just use GFP_KERNEL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 0828cc7e3..45ef6aba8 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
 	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
@@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;

