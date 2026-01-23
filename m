Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DF633345A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151756; cv=none; b=hK1kGmPQJ+C/L53qa6dEsy6FgVy59AwTK1mzmZJZENsbMyIQ8t1FVp45AEvaOKtgwpbFYR0FaD41SoioZMcXPYfTAO6KN0q1Q8TStpbWKZQjd1z/aKnFv+mALSaBeEJKh/gicoPSXN9lJpbBUry2DE5Oz5LRrlSvY2QvhaeVolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151756; c=relaxed/simple;
	bh=sMTgjQRNWmLMXRrGL10iBgBVdvt4AGE8hEE0V1ilQhU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWGQcnUM/NnZO39fvViuRF5Gj5R5PdVzqMQWhwnvPjIaWwA/pnTM7GtcMzTFt6+nIEovzgY53tp9mh4HTkakkEn0e6400j/lQmA0wfIkDbZDclhGrCTH6HTqG9922jkN9KOoypBcm/gWYXJqtk6FcnFR+YYwU1opWj7QWAUpTkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MN6Mi62W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MN6Mi62W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DDCC4CEF1;
	Fri, 23 Jan 2026 07:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151755;
	bh=sMTgjQRNWmLMXRrGL10iBgBVdvt4AGE8hEE0V1ilQhU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MN6Mi62WryHGHtG9wBGKyFolykSJHow52u4Q8hRUkpgE/ZR/p4C81woiyuEmWEtTX
	 DgAveH6EpTNmZsVW6sNjjetJD6eGGujD9GRIZQQhv/iB4Y+byWKwEGJ1CLffVC/Qvj
	 j9BC8OtrbMCKcIS69Ka7FWVT9dgyk2XWFnZGdLvPsKiFP3WQSz9Ne2+A/UdrCjxyhn
	 sIOmpVDCdNbiPKM59aD7sjk4fHfRPjLucgYY5keJCEf+v3FNYe5l6oxSgm3L69q5Hw
	 c0V9ABqdCNpc+u7aKURlE+li6wtmn8nyKYXLi5ivfcPYREovOuXeFle2u/H9MU+MUN
	 9DwyN7XPzUmxw==
Date: Thu, 22 Jan 2026 23:02:35 -0800
Subject: [PATCH 1/3] xfs: reduce xfs_attr_try_sf_addname parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176915153405.1677678.11425661640278366871.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153369.1677678.8151270167939415602.stgit@frogsfrogsfrogs>
References: <176915153369.1677678.8151270167939415602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The dp parameter to this function is an alias of args->dp, so remove it
for clarity before we go adding new callers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d489c..c500fb6672f583 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -351,16 +351,14 @@ xfs_attr_set_resv(
  */
 STATIC int
 xfs_attr_try_sf_addname(
-	struct xfs_inode	*dp,
 	struct xfs_da_args	*args)
 {
-
 	int			error;
 
 	/*
 	 * Build initial attribute list (if required).
 	 */
-	if (dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
+	if (args->dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
 		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
@@ -372,9 +370,9 @@ xfs_attr_try_sf_addname(
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
 	if (!error)
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(args->trans, args->dp, XFS_ICHGTIME_CHG);
 
-	if (xfs_has_wsync(dp->i_mount))
+	if (xfs_has_wsync(args->dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -385,10 +383,9 @@ xfs_attr_sf_addname(
 	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
-	error = xfs_attr_try_sf_addname(dp, args);
+	error = xfs_attr_try_sf_addname(args);
 	if (error != -ENOSPC) {
 		ASSERT(!error || error == -EEXIST);
 		attr->xattri_dela_state = XFS_DAS_DONE;

