Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78020646
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300576; cv=none; b=a/rFSwL0QrT7OLwgATB4i9WcSnTVtVhNa5/CfdqsTJAtjmHEGjpANxJC72DcGhy6O8iH0LIBIaBbpkmbnJacAI96vjN1/xaX1jbaGAkUHJ/5lravOhFYWFYdGuq3mCStYRLMxwbh4b9+RdILkfDoLsKMibxPTb2yapGJICKJ8Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300576; c=relaxed/simple;
	bh=3GLc+ABbuJ73pljgz0CJ27nyviXnMBDEBFuzqzArkgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kxiqjr4M2ZQziL9CxF97YEMKGEQxzTgLD/Wmns+pNVT+c9q+rqM8VeSQIcwr1P09YVTJeqJwSdHLj+6AalSPUbL7tp8cgR7e2f5qx294Q6sZwk/y84r9WcclCo3jJoScHg5eC9JYwOOGKMQqY4s0HVc8R+OtiezF3dfqIIj4iJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YH82boF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YH82boF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5361CC32786;
	Tue, 30 Jul 2024 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300576;
	bh=3GLc+ABbuJ73pljgz0CJ27nyviXnMBDEBFuzqzArkgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YH82boF5xS/zYPh6hk/s9Vluo2B19euJilvrRYax6JMeI9ACQjnJiDS4d5pIglMT9
	 p29Eq3Xmbpk2mLSkp27I4p8UxVsTHOuIGB9ZUMl3GWTt4i6aMZCe/jMKGsHDQyr9PG
	 3gevq1JetaJ9MiowVjQQP+5xIlNfYn/NkYa5aTpALPxGia4jZmHdC7wTRPjWpD3/k6
	 VdCHZfHNQV/VJJ+27R7+Mf2wkCEJalyubxAer5GHIORl5+ykt3yXSRgCc+tIxTAAwj
	 ha+a321QKblksGK3Ybeq+Mq6EUXOtoLiU1JhRwLsDf65BQftZ6f+5s/AxUsYwA7UER
	 yPC1YCKEhXyfg==
Date: Mon, 29 Jul 2024 17:49:35 -0700
Subject: [PATCH 099/115] xfs: remove the xfs_iext_peek_prev_extent call in
 xfs_bmapi_allocate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843853.1338752.3161520143092544832.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: a8bb258f703f42c322638022afa16808ca4a7d25

Both callers of xfs_bmapi_allocate already initialize bma->prev, don't
redo that in xfs_bmapi_allocate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    5 -----
 1 file changed, 5 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a498894fc..4279ab83d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4181,11 +4181,6 @@ xfs_bmapi_allocate(
 	ASSERT(bma->length > 0);
 	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
 
-	if (bma->wasdel) {
-		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
-			bma->prev.br_startoff = NULLFILEOFF;
-	}
-
 	if (bma->flags & XFS_BMAPI_CONTIG)
 		bma->minlen = bma->length;
 	else

