Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8581E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389815; cv=none; b=NRw4RCIKch1/6NwPV2TBCns8CR7y2SwwIreQXrse0cXKcJ3W56CnXtIktDseJ0jZM9iZsnoLLIATO5Cq1O7qyCuF+e79tgzgJLw+9EmYttdfW5HJMnPDs7ldMmxfHJEHqw1/2mx8+LRmYUZPGSmgzkyY1PaMAI9ZJ9UJ68q+sBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389815; c=relaxed/simple;
	bh=JaRcgnhuBMGfMIUsSNThroB+1McLohh5cyKZ2EURfu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTRLBBLGkfF2ixasBvupzfN7y1OdWoiOoPx80YsoX1wQNprlViF8Pxbp/qlvvJytFMoqpwDn5q/xejSLFeIvV2mDpOx0hYChjMEbdOoqAHcdb5zYX2safxZlNkWIbaX2Dhy+3P7TCObVbHoigLkv7nVu/y4zXlxsUpzcQgcXw1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFR9Iv6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFR9Iv6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F080C072AA;
	Wed, 17 Apr 2024 21:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389815;
	bh=JaRcgnhuBMGfMIUsSNThroB+1McLohh5cyKZ2EURfu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fFR9Iv6DviHSgMbvUpFvqCDCg4ZiOQNzm9li337cpyx1n5y9bYSocJeK4EJCYoG8d
	 jXu+lmVbR0N/oinGAt0JSUMUE58IYCdMEojlAtWt6m5PKkxemEUAaVF7rqUK0m7TtV
	 ajcO7hwJE9JDXH+V3otbHP7e4oBOwxr9EXBRbmYcbv05CAMkASlGt+2WLNgEfGOyiV
	 zBV8BLsKg4Ma0cR+UYge9tiB6VhLem3omhvEs85xjEsgBbU+Q46YTWOdd05xAU704N
	 x9GA2pXH9gfwzkb0jiEX3Q7eiW4sy4CpbtnMPNbWSU7nb5qkRgabk2SAW7xWONT3p+
	 9ZCkYovCJhKVA==
Date: Wed, 17 Apr 2024 14:36:54 -0700
Subject: [PATCH 58/67] xfs: remove xfs_attr_shortform_lookup
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843211.1853449.8700085740456925651.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c      |   21 +++++++--------------
 libxfs/xfs_attr_leaf.c |   24 ------------------------
 libxfs/xfs_attr_leaf.h |    1 -
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

