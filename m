Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364521219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844421; cv=none; b=R1wJTFu3lx1V9NZfkx9aHT2NLkQ4xPn8y6xqmKbQhiycTbcHKjOFPbVwrw5ffWtUYgCgasLlg3hH+q4hemVPWrVHczVzl2r1jzBToFUwuhZatRR718URyZ7JtsSyltXAaw5qHBp6YelBt+iZFk1kNJjCwEBxJOcetOYnsElNbEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844421; c=relaxed/simple;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoIXbzwPbklfugiJF0J5G37cyKedxmpiOv6J67UuBj29GgFWd6pb8Ilvuqk3cq+eyr24atSY8HFHfUuSmixWGLXVipMTia5n4tzuiCttHM0Q/pKJpG7Gm2ecWIDMb6Uk7Du9PaAyxy9DfeKgLiCny6ap58t+jccYlchDRDLVTvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFfh1ADU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFfh1ADU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE63AC4CECF;
	Tue,  5 Nov 2024 22:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844420;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZFfh1ADUG3uWzpIzQqx0+O+96NX/JWxA1rcYEvS9UR53m6q+yTMh9rh6eIhuGGqs9
	 cxHdcv5fl1cK6rDU3H2h4Zr1avdjyvIDpDYEC0vg3FowXvu5dd0OghxGh3lhMispLY
	 1FspK3zGCvqgTN4I+rFpq3D+ou9IIv3Cc4RjO/LR5YRc7IqhB3qeh9k4BFHQ7wHRdJ
	 EWuG6JxwZfKsQmfOjUr11QLLJKAudZkeIvQi+EpkkMS4xc/tVOKCIV4moQn+ISSljV
	 P+OogGk8T2cnscsOCObjk7E/fvFivBVk0thNjnnig0Uw6Luxpe+y+37F2CsuIoE9Hi
	 hx89maBcNgRnw==
Date: Tue, 05 Nov 2024 14:07:00 -0800
Subject: [PATCH 02/23] xfs: fix superfluous clearing of info->low in
 __xfs_getfsmap_datadev
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394483.1868694.2010985926775335728.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The for_each_perag helpers update the agno passed in for each iteration,
and thus the "if (pag->pag_agno == start_ag)" check will always be true.

Add another variable for the loop iterator so that the field is only
cleared after the first iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index ae18ab86e608b5..67140ef8c3232c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -471,8 +471,7 @@ __xfs_getfsmap_datadev(
 	struct xfs_btree_cur		*bt_cur = NULL;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
-	xfs_agnumber_t			start_ag;
-	xfs_agnumber_t			end_ag;
+	xfs_agnumber_t			start_ag, end_ag, ag;
 	uint64_t			eofs;
 	int				error = 0;
 
@@ -520,7 +519,8 @@ __xfs_getfsmap_datadev(
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
-	for_each_perag_range(mp, start_ag, end_ag, pag) {
+	ag = start_ag;
+	for_each_perag_range(mp, ag, end_ag, pag) {
 		/*
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.

