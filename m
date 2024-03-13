Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4133EB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294924; cv=none; b=GWRQYq261QB9txoaTC+F4MX7TRf237jf3k7J6p2zKbmOEljLNGgVkRSu7G2nQ/ZeI0Q2Ox9UyNaOfW+3e8uiYwuOUj7Yueo1+jBs86/l/OCvisw8n3gghKTBp7QXaLzRtM3OZboX5xnLpTyNfkiDeGV6HAsJMoG4Inbn8+6bheQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294924; c=relaxed/simple;
	bh=1U8BZNIyDLQI5OgH0DiLBWrHi61hMBsv9+eFhYCjQbU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VVb1Y4MVW9Zs88TTYHbLaaRweKWGbLBEVt4bE2jfrFAOkinlULwL6OLvd5NNrZBPzG5HePI8Ra7PTM89zaXhraSN8Ou5c8Qwl4epyW9akj3Dc6Ckhow3ocoMSg2iK7AZrSxPobHUr9r0E6EoMDDJE2ZOpgZvmgX9gd0uYe9PohY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8Uwjppt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8Uwjppt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E3AC433C7;
	Wed, 13 Mar 2024 01:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294923;
	bh=1U8BZNIyDLQI5OgH0DiLBWrHi61hMBsv9+eFhYCjQbU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B8UwjpptTkRTSSmXrD4DYO6icikkax1LSGhduBx2GBGrmX2jrk/8VIcrom25ZLsPO
	 n/2DdZ27VYR3sgMwaCa0WSIffc+PQweZI5pkO7XTNdavtwzdCZWTK09naXMdkT99Dp
	 azlxkWlK6LXN+qP9GM+PHSp7l7Fcl1nbhm7TSgkUS1cdOXGhK+JKLKRDXHPXFq1cBo
	 7365v2tsVJ3W/O1v/AcUlK3BgW+2m1t9eMY5Dp8h4cWfiQe9yxmT/AY1/xVZOP6Dh3
	 zJZE2OF69NeOhNkCXRE2mUhMhXykQ6u1Mepkkgi4phyksSwsNX/MeHj2Uy8ITconlT
	 YcJP/EoBnIVNw==
Date: Tue, 12 Mar 2024 18:55:23 -0700
Subject: [PATCH 09/67] xfs: hoist xfs_trans_add_item calls to defer ops
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431323.2061787.1840599759257133605.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b28852a5bd08654634e4e32eb072fba14c5fae26

Remove even more repeated boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 42e1c9c0c9a4..27f9938a08d7 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -208,6 +208,7 @@ xfs_defer_create_done(
 		return;
 
 	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_done = lip;
 }
@@ -236,6 +237,7 @@ xfs_defer_create_intent(
 		return PTR_ERR(lip);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
@@ -501,8 +503,10 @@ xfs_defer_relog(
 		xfs_defer_create_done(*tpp, dfp);
 		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
 				*tpp);
-		if (lip)
+		if (lip) {
+			xfs_trans_add_item(*tpp, lip);
 			set_bit(XFS_LI_DIRTY, &lip->li_flags);
+		}
 		dfp->dfp_done = NULL;
 		dfp->dfp_intent = lip;
 	}

