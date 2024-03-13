Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A65AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296174; cv=none; b=aBMsSoO09mVo3vF/FmpxMBIhUIh2ebcgeAB8ZeXJnnl+8jNXHUQfJzVFfc0PtSE3HY9oXtRiZDFcs7pYFDRL1RBPe5wx3Fb6CPwi1Nouws67PBlKaVPmkc4CWz9d0ifxYZk0TcW1fs9G35HjGythZiWhPw3KEyK7VEZB4NdFI9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296174; c=relaxed/simple;
	bh=W15nGSIuWd74hviyJHjc98vDvpHZV0616efXaXUCMM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2oaVNVkanaQhe7MeEWPJ+9hasHsplQ0bZ8iZP/8V6df+beJbzMQ/KlVgSPWEUwQI7MKDOq8lsmlwDjMwECdWtWpMtBHloKL8mJyak9uQbIKtWPg83wZ71Pw/mJfiB3xG84lrID2m6vwBamAQvMU7AVmUxKsLAy+plKz9wh7fVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7iapB9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7iapB9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E81C43390;
	Wed, 13 Mar 2024 02:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296174;
	bh=W15nGSIuWd74hviyJHjc98vDvpHZV0616efXaXUCMM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F7iapB9ys8E71O7xuc+0e6+5RzAyJFKZoNS3jpVQ/Kz6m4E6IlmvQJX9hesPctDWw
	 YPHZmO3FWfnIiGpj8PZCr8MPTiK010V5KPN7bdaiK8XUXIl8OuDz9rt4i5CNCRzCgg
	 GrD8YOBIyTpvyFbmObV4eB9zBxljiGWkBdB41q2Hsz1cCz4F+qU1pfPtSawjezh/Oy
	 njuvPP0Cg6UN3DybcAqq0Hr6qFnWMNFp+EC9+YzE9rniYzCPD+YTBhYLiZLq/x9zgC
	 kuHoEesVXYm2w6cPdsSl7/cCQ2jnjcUuYY8z7mCILWZUy4gHECyDooN8JjcMC7FmbM
	 EayMORZvgnLmA==
Date: Tue, 12 Mar 2024 19:16:14 -0700
Subject: [PATCH 6/8] xfs_repair: constrain attr fork extent count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029434815.2065824.10714570666464102685.stgit@frogsfrogsfrogs>
In-Reply-To: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
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

Don't let the attr fork extent count exceed the maximum possible value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index b8f5bf4e550e..bf93a5790877 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2050,6 +2050,7 @@ process_inode_attr_fork(
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
 	struct blkmap		*ablkmap = NULL;
+	xfs_extnum_t		max_nex;
 	int			repair = 0;
 	int			err;
 	int			try_rebuild = -1; /* don't know yet */
@@ -2071,6 +2072,11 @@ process_inode_attr_fork(
 	}
 
 	*anextents = xfs_dfork_attr_extents(dino);
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dino),
+			XFS_ATTR_FORK);
+	if (*anextents > max_nex)
+		*anextents = 1;
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 

