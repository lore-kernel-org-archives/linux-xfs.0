Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14897BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295690; cv=none; b=VA/0558qRY6dsPGmbWUTyXWhGModA86UY5eD3Qq1l+zyO172KFkToPwEcj5M7gfwTb4Ao9NqrcCdV5oGW9uN6yCnorrsViWBzSyA16A/jSRV8eRzn1Ayi+oR3iNSQZvouoHVhuEHUjquWSQMiBLCi+TQKQo3m2Pr5Lu0XvkaXyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295690; c=relaxed/simple;
	bh=qhhd2kcCn2PmyXVvDC2qrGVb+kMyaXwp/hrdG/IPeAc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8qf14xbETzCiKpmvCJoblkAiF36ezUzaAfmc3i9RznDHNeHwljcRAEJ+AGkkuzYR+E7ytQc2M9v5EIccX0MC9BhfLW32oBIkSPAnf3/Ewx4fWXqbLVvxkQcN80BuNj0GFMsBGoKsALaVG32j6T/5YRK2qcaUPkMPKNk8kGcYVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fd3ZLYZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fd3ZLYZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D2EC433C7;
	Wed, 13 Mar 2024 02:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295689;
	bh=qhhd2kcCn2PmyXVvDC2qrGVb+kMyaXwp/hrdG/IPeAc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fd3ZLYZhzlhJ9euIuvQHnMsApXImwfZcaPn45l+kyWejOfcbf3eGSHuRIzpNQO+ld
	 qjbzytopCRjy6JSV+qyC/OaMYDxEwfWMcrope7bjhFd2o5qWq7GuWsbPzHT5oBkFMa
	 RDYN/Xkf4I8EnJYceCMq4CF4muSuu2f3SNltJPTe5DRk7PNQykIThV7a0coo6pVDF8
	 uEru70szRTVYRZTgct9zI63te5dwVie9BoXLMh0MvPOCSZc/v5BX5YC6asAV5eMZU6
	 kqA2Xnh9V26sVPS9wf4Y4ErW72vAgy3peJ7NA6uZMwZD9aJ64rTy2Zg4X+F9Oq+cWn
	 xpLAFZSaBWuxg==
Date: Tue, 12 Mar 2024 19:08:09 -0700
Subject: [PATCH 58/67] xfs: remove xfs_attr_shortform_lookup
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432031.2061787.2932885239966257817.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 22b7b1f597a6a21fb7b3791a55f3a7ae54d2dfe4

xfs_attr_shortform_lookup is only used by xfs_attr_shortform_addname,
which is much better served by calling xfs_attr_sf_findname.  Switch
it over and remove xfs_attr_shortform_lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr.c      |   21 +++++++--------------
 libxfs/xfs_attr_leaf.c |   24 ------------------------
 libxfs/xfs_attr_leaf.h |    1 -
 3 files changed, 7 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d5a5ae6e219f..a383024dbd7f 100644
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
index 6ea364059a4e..8f1678d296a7 100644
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
index 56fcd689eedf..35e668ae744f 100644
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

