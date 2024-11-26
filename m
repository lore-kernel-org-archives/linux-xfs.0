Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CC8BA27
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584315; cv=none; b=phUiUKfYKPYaUdkkx5IDmS4HGPBQNk8T1M+1GQU7RxDiXSpJAX//1/b0X2jPabza89rk37xlz1nwoDaEQaJQPbh9bJPtNTIIze/662sNRjqai5XngAThAb9ncdV05x0zfTzw4VOewoxKQ493K6CzJ41FNHhH/4bLSIzVQNyroOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584315; c=relaxed/simple;
	bh=36ADRXqr99px5o5LNsS5+a1CZt14KdYi+ujGXtVocJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t8jjjpN0JDtp0Iz5xc7I5rhx08A0c6hU/vP6WrnF34CBBhmVod5qvKfkhuxZKkcHrI8c/9N+91f+1Hj7qlIacbLRpADPtRMMRMoBRkL72BSAMP3Um5zOgKEbCpxGIMUG4IJTVLu9wVUMH7faeOdGeeny0cOahdZc8uY0KygXkzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beQeK20O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beQeK20O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9480C4CECE;
	Tue, 26 Nov 2024 01:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584314;
	bh=36ADRXqr99px5o5LNsS5+a1CZt14KdYi+ujGXtVocJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=beQeK20OeKG1atUJ1H8QIt6PVt3rtfNdfCvaocu9WweqdpBbT2vtAihnYEXZNWkdM
	 KRYNCQ2R6cS2TyOdOwcSp9X1cNkOh991fkcPDBD2ko+xYFS9DHzUN/5Sdp3+KjX5VD
	 kHYpI2Cpizv0wlafzGb6357YNhSgcI0uQKQA7+wfJV3tCGvCEEwxFRR64aTfE7VTyV
	 tRqwp2XlIn++LG8uRBbuMLjnhxgekOK3LtsZTDyIzLlWcdZeQ9AY3+DFwWY8zvlovS
	 oLuRZ7934nB3AvFj2O3PcOAoxz01c9ZuR+j3Nj8hvv9iGLUw7XC07NV4qJWSs+0E7B
	 qk7fpJYjfYPqA==
Date: Mon, 25 Nov 2024 17:25:14 -0800
Subject: [PATCH 02/21] xfs: metapath scrubber should use the already loaded
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397837.4032920.10276485588764375439.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't waste time in xchk_setup_metapath_dqinode doing a second lookup of
the quota inodes, just grab them from the quotainfo structure.  The
whole point of this scrubber is to make sure that the dirents exist, so
it's completely silly to do lookups.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/metapath.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index b78db651346518..80467d6bc76389 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -196,36 +196,45 @@ xchk_setup_metapath_dqinode(
 	struct xfs_scrub	*sc,
 	xfs_dqtype_t		type)
 {
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*dp = NULL;
 	struct xfs_inode	*ip = NULL;
-	const char		*path;
 	int			error;
 
+	if (!qi)
+		return -ENOENT;
+
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		ip = qi->qi_uquotaip;
+		break;
+	case XFS_DQTYPE_GROUP:
+		ip = qi->qi_gquotaip;
+		break;
+	case XFS_DQTYPE_PROJ:
+		ip = qi->qi_pquotaip;
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+	if (!ip)
+		return -ENOENT;
+
 	error = xfs_trans_alloc_empty(sc->mp, &tp);
 	if (error)
 		return error;
 
 	error = xfs_dqinode_load_parent(tp, &dp);
-	if (error)
-		goto out_cancel;
-
-	error = xfs_dqinode_load(tp, dp, type, &ip);
-	if (error)
-		goto out_dp;
-
 	xfs_trans_cancel(tp);
-	tp = NULL;
+	if (error)
+		return error;
 
-	path = kasprintf(GFP_KERNEL, "%s", xfs_dqinode_path(type));
-	error = xchk_setup_metapath_scan(sc, dp, path, ip);
+	error = xchk_setup_metapath_scan(sc, dp,
+			kstrdup(xfs_dqinode_path(type), GFP_KERNEL), ip);
 
-	xfs_irele(ip);
-out_dp:
 	xfs_irele(dp);
-out_cancel:
-	if (tp)
-		xfs_trans_cancel(tp);
 	return error;
 }
 #else

