Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CBD19C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497075; cv=none; b=OwL6VxmSXQ5y7O+jEiwV1tQEWN+7+RUOb3qTVtm6KjrwHu92+ZB0Qj4dAavaLoe5r4WrrHd/KoWjQD3HkLZv+A28sFY3CUoFYfncI2tXq3t4CU+U2sbPcPJz31yRWoqlp+pV0ZCMXqMAD5YJJEyPvJPc7q7J5Kj8GIKX/9lFSe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497075; c=relaxed/simple;
	bh=O6T0JzH4mxM5o7cHfXj/nJnzEjzGCa9FKhM5FSil7tI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+WLYF4BtkYcHrMZz7ZSA++9jkJn/NCNVmPaGgHNHat4MUh+DczInK/3u45ELsoJCNPRML/JCj0CTK0zZKjH+U07Aj+yvC6m6dZOpMhSiEoyyHGCxN9VB4AHhyD4q5IhrMJj2KaRTGZr1mITe2Aky21PhbmbawreabArFe8u8wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4n4eub0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4n4eub0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A99C2BC86;
	Tue,  3 Mar 2026 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497075;
	bh=O6T0JzH4mxM5o7cHfXj/nJnzEjzGCa9FKhM5FSil7tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g4n4eub0mOmjf5/ITcrsXatA0eZUZ09APJgza1ENFDlwharcWBedJLIDIHH/UtqPi
	 m3Ma+1Excq2bKmKl2RN/LsIQNcCMilLpS3KcoTE8gfoNcFyGRcurVYspMbhuGP+1Kp
	 ZnKXlIMs3buVtrrR36mu/RZ5SwcixATwoQaD/pJ85GOzOrX9xlqfAFaDirUFT72dDW
	 fs6+FpLcywoOCdG5CwknLUrqWjfkMkRLjj9Xs815Zz/fZWJbLwjU8wNgD/33/rVzwt
	 6sa/LKaNk30yGOMkz7OSd/RwH+NUY1KHvgBDSQB0DeZV54CG++qRdSOciIZNjFLKlX
	 kpQUzHnuZqimA==
Date: Mon, 02 Mar 2026 16:17:54 -0800
Subject: [PATCH 22/36] xfs: reduce xfs_attr_try_sf_addname parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638183.457970.15775615572741963298.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 1ef7729df1f0c5f7bb63a121164f54d376d35835

The dp parameter to this function is an alias of args->dp, so remove it
for clarity before we go adding new callers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index baf617cfeabe00..175f8572b0f930 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -349,16 +349,14 @@ xfs_attr_set_resv(
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
@@ -370,9 +368,9 @@ xfs_attr_try_sf_addname(
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
 	if (!error)
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(args->trans, args->dp, XFS_ICHGTIME_CHG);
 
-	if (xfs_has_wsync(dp->i_mount))
+	if (xfs_has_wsync(args->dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -383,10 +381,9 @@ xfs_attr_sf_addname(
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

