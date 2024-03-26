Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B7821353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424802; cv=none; b=kFTTjxZj3Bm7fPPg/BYkYUdOd/d5GoBLBc1B2DuH5mi6yZGpZPHL2ZxDfBV+c/pWMAGjvUVIYrHcZQRFeuOuoLfqkxgcsmBsR+1mOcJS52gqWmU/Bj5j94qwbikcvMos8PJK8znc8TDFffLVpQWFt/apidT895zskoMH4/5sgKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424802; c=relaxed/simple;
	bh=O9aYcP2mgeMLUZY1jeU0EiRL4o/wzDQSvTQP7YLp+Pk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=siF/Lo1btJq68Ju5R15ee+DhtrmENanWNsvw+ND2nG6dh03z8YWs4AUricmwFFPbZyOVvCJZ+PKrATtnC15n3WbSPj9ac9qOxjutyRDOW307erIZZZhbchE1wldKaEJXnMaowcfGF1RJPNbASjyzxumDrqOOM1iQ4ERXV3JFseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbMpZPcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbMpZPcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF44DC433C7;
	Tue, 26 Mar 2024 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424801;
	bh=O9aYcP2mgeMLUZY1jeU0EiRL4o/wzDQSvTQP7YLp+Pk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YbMpZPcmwdXX97jeKFkXTKTayYfnNEKhz6gkaufRE/8w3sXfhxue7JhkEraoYM58G
	 L2I8wUXnFs8UBvM9m3eyGG/wTv9cAodTFsoRj/+J99lDMura4qN75YTot/CBMPXYQW
	 xkp6dTq0mmFChdIpAZ3BPDu+EUzxYLx2kHw3in76AfspAh+jYCiIoukaL1FrdJoh8q
	 eQMx74zQBrDxEDkilOgLgxXYDCTfEzf9y5h2sAVnXUX0EA80gj8umhiU3TPOmNSWOI
	 sJogYU1ABrjsx9jt57hNpvmTEBr0f4fOB3aAWyMqrATLtk+F2WxPHoez9w6GDSHTAP
	 K+913BXQ/oT1g==
Date: Mon, 25 Mar 2024 20:46:41 -0700
Subject: [PATCH 070/110] xfs: remove the btnum argument to
 xfs_inobt_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132388.2215168.5292306129182640155.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bfb028a4c00d0a079a625d7867325efb3c37de2

xfs_inobt_count_blocks is only used for the finobt.  Hardcode the btnum
argument and rename the function to match that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc_btree.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index cf59530ea2d6..609f62c65cea 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -710,10 +710,9 @@ xfs_inobt_max_size(
 }
 
 static int
-xfs_inobt_count_blocks(
+xfs_finobt_count_blocks(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum,
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp = NULL;
@@ -724,7 +723,7 @@ xfs_inobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
@@ -772,8 +771,7 @@ xfs_finobt_calc_reserves(
 	if (xfs_has_inobtcounts(pag->pag_mount))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(pag, tp, XFS_BTNUM_FINO,
-				&tree_len);
+		error = xfs_finobt_count_blocks(pag, tp, &tree_len);
 	if (error)
 		return error;
 

