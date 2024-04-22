Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F389846F
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804036; cv=none; b=OJ8qVKDqgbqqx1XsuTwJgK2CdUkQ760fdUr7bavrjyBc1mN5VUEhIUnEcMEwV4pzFRTuKv4WefcQeOtuI6SXQ/RgR1qjzAVz9hrSVx3byxt4WwD9OAnIa4yqeXtEsSVYY+mAYwOspK0OFat6GZlS6UGpAQNJH6GtlhNpOIVjavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804036; c=relaxed/simple;
	bh=v8tflW5pRmo4mktX0td1SaMPWikCVb3ejTJ4YaGdJUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOmyyqTkCJZx5gtDbyOVJF0EZz5dQHxzOHJNf9d7iWb4KDNz0rq0rFDW5biWjACUdEJFYR2pzw4NGySeE0itZC2uCBnoipUGx1V6EwyqS3IG2OqIg+gchbo22KoAohbJYbVcRJYevJOSay0q/hojgjDI3diil5vk333NNc1of00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hH0NyRDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hH0NyRDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA64C113CC;
	Mon, 22 Apr 2024 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804036;
	bh=v8tflW5pRmo4mktX0td1SaMPWikCVb3ejTJ4YaGdJUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hH0NyRDkG7eazDQXdQSAc68DJKkU0+cOQxyH0lMZlIiJzZoLA0W7LHtjOinD5nMMH
	 90n6+tNmQjS+rJdtjV7UiThpXZnZunnpKOZIbwe/gQUbMUdMx1M1L7Y9Zb+/qz5dju
	 A5CKgPOmdLV5zDm5vFqOIAY5Dqsu9wk2EqUWghIgyGNsFXLpQCWgpee57LJbwl3DZv
	 xlmQRjUQc5d3YD9zBBKT6vx/bkyTwXHcxOnw0avDk6shMnCNWv/F5ufJCjYl6oHCOe
	 VzDXtt4JwvoKFF4lUkCwMLM2ZJIP9mo3eYn3eE+kxVtoROCXql9skrwBjZSBtxvkEI
	 Y8tHCEv8rSMaw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 58/67] xfs: remove xfs_attr_shortform_lookup
Date: Mon, 22 Apr 2024 18:26:20 +0200
Message-ID: <20240422163832.858420-60-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 22b7b1f597a6a21fb7b3791a55f3a7ae54d2dfe4

xfs_attr_shortform_lookup is only used by xfs_attr_shortform_addname,
which is much better served by calling xfs_attr_sf_findname.  Switch
it over and remove xfs_attr_shortform_lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c      | 21 +++++++--------------
 libxfs/xfs_attr_leaf.c | 24 ------------------------
 libxfs/xfs_attr_leaf.h |  1 -
 3 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d5a5ae6e2..a383024db 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1064,19 +1064,14 @@ xfs_attr_shortform_addname(
 	struct xfs_da_args	*args)
 {
 	int			newsize, forkoff;
-	int			error;
 
 	trace_xfs_attr_sf_addname(args);
 
-	error = xfs_attr_shortform_lookup(args);
-	switch (error) {
-	case -ENOATTR:
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return error;
-		break;
-	case -EEXIST:
+	if (xfs_attr_sf_findname(args)) {
+		int		error;
+
 		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			return error;
+			return -EEXIST;
 
 		error = xfs_attr_sf_removename(args);
 		if (error)
@@ -1089,11 +1084,9 @@ xfs_attr_shortform_addname(
 		 * around.
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
-		break;
-	case 0:
-		break;
-	default:
-		return error;
+	} else {
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			return -ENOATTR;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6ea364059..8f1678d29 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -834,30 +834,6 @@ xfs_attr_sf_removename(
 	return 0;
 }
 
-/*
- * Look up a name in a shortform attribute list structure.
- */
-/*ARGSUSED*/
-int
-xfs_attr_shortform_lookup(
-	struct xfs_da_args		*args)
-{
-	struct xfs_ifork		*ifp = &args->dp->i_af;
-	struct xfs_attr_shortform	*sf = ifp->if_data;
-	struct xfs_attr_sf_entry	*sfe;
-	int				i;
-
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return -EEXIST;
-	}
-	return -ENOATTR;
-}
-
 /*
  * Retrieve the attribute value and length.
  *
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 56fcd689e..35e668ae7 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -47,7 +47,6 @@ struct xfs_attr3_icleaf_hdr {
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
-int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
-- 
2.44.0

