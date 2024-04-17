Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B14597B
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389204; cv=none; b=AmaggUS4DxVP0tAhy7mxG7Vi5n5yClkbqhMVDPHFioNYN/Lb54uE5cE3MPlkhxSHDyhyqglNIihQAHZVnMoTQeVoxnROoDUfR5U3ya8T5Cz2vrSleU3p0J+PXYi6e3pYiKtFfAHDrxgrLo4Fh+YENlWwDhq2PqIWSufb3NreYkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389204; c=relaxed/simple;
	bh=pGPD9ExpYLpNYHsiPok/ffLbTzn18uUGciy1Y2xHGuw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXlQtpIgbVuTCTey/kAww+6VlexiSWz8yyPJPrsnQ0lD4XqrtlyX/b4RupQiTKkDbmU7Vu4uBVUoGp6f2hyQXfOn/SO7ZOzRhiu8NwXKEOuYn5TLVkYyHMMqnzsResDU+I74QW9q/D0MGbCeh7bp6CebuawlI5XGuz0EaDfyg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rs2liX1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rs2liX1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418B5C072AA;
	Wed, 17 Apr 2024 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389204;
	bh=pGPD9ExpYLpNYHsiPok/ffLbTzn18uUGciy1Y2xHGuw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rs2liX1mYGs4iTrGc+e8jdLhDsykFVCrWhmXUq/XIZVqVTE7820WgVp0eQHRPKlrQ
	 FsGIHryqNcS80riggas17sqcdkju94ccSu8ePkZdAVdQPhUY5rvd9dmB5Oa8gNyTv6
	 vAfX2MFVo/4q6urtgZ/WsO1Sr9xS8querNFxg5YP6zNfTvYnpNyIlclyvE+v/d4PQc
	 EfICOsswmyGmPr4Zo4cfw9AGvSNQg74u9PTieZ1vpQRlMUQaRYtmewsyVe/15VoAnp
	 xIPGR/BCoJWzxzByFu7CWjAJlUP28i23g0eQxZCtPb8KB7YfjYIf+hcyovxZvM6ifY
	 GKKu8RpULjC6w==
Date: Wed, 17 Apr 2024 14:26:43 -0700
Subject: [PATCH 19/67] xfs: remove unused fields from struct xbtree_ifakeroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842625.1853449.17182264170008578838.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4c8ecd1cfdd01fb727121035014d9f654a30bdf2

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_btree_staging.h |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index f0d297605..5f638f711 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */

