Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69231D63DC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989984; cv=none; b=G8Ypu9QzxopE3dLX/CayZByxDvHuXORgbhvM+5PeahF6RjBFLrYAjrJiUIrAk889VdFuiNb04lpc8B/VHY17bbSV7UJaZW49rK4OFoM+bxjGC+oWuIDHLlFvF990mqGJ2vZCb9yIe6XbxNFMWbZ8LQMCd1PcOHqNdJWR6apDYvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989984; c=relaxed/simple;
	bh=xUZu1ul2GCQgwOdOsKkv11vTyaiSSy1qWRUSStF+dRo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9IfEuNphRBF4ewAnLx5bI3Avze/bf4CtndXgu2DKSiERxWX4XhPmRL10+DtTu2qTkxAMzhFRj60TqLiVf/G9nZFKpWhJgBkLVrHeSumJnEIIpSCme57ESehMhBnnRtXQuO0Sa4b7r8rzFqYgD49bLODoCQvq8WvW1Y7NPFR10E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvR1mD5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvR1mD5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F9C4CED3;
	Mon, 23 Dec 2024 21:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989984;
	bh=xUZu1ul2GCQgwOdOsKkv11vTyaiSSy1qWRUSStF+dRo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OvR1mD5myZyYJhZw+r2Vn0qv+qvaSQSwYCC6Ar1ngh/wHEIY/eVaK7dE/T+FjuuQj
	 spXQ4CYZWl3FXRkrC9D4gd1j4UPvI1nMM0kqwF5NK8/g23Nydmf/OAJcaUF9buD0mt
	 WXEUsxSYoOmSCW3cmFtmcytscAb8VHH3FeLlKy3txhPvfcMG7NASTKQ3crRgPYazOL
	 CwkaSooHcnuyyIvq0oDF1OCu/zGQ0R+bb2TmW5rEXl4w67Ch8BgJaSd0n51A0bmx86
	 oCSwuNbQnStdnIb5mvUlJhT3N6XzOstjWGtW87aBJA4amAe/onwr7WtbkbCtIhaT9s
	 jDP9Y5e3L1qSw==
Date: Mon, 23 Dec 2024 13:39:43 -0800
Subject: [PATCH 10/36] xfs: pass a perag structure to the
 xfs_ag_resv_init_error trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940100.2293042.8768030502110956248.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 835ddb592fab75ed96828ee3f12ea44496882d6b

And remove the single instance class indirection for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag_resv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 7e5cbe0cb6afd3..d1657d6c636546 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -205,8 +205,7 @@ __xfs_ag_resv_init(
 	else
 		error = xfs_dec_fdblocks(mp, hidden_space, true);
 	if (error) {
-		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_ag_resv_init_error(pag, error, _RET_IP_);
 		xfs_warn(mp,
 "Per-AG reservation for AG %u failed.  Filesystem may run out of space.",
 				pag->pag_agno);

