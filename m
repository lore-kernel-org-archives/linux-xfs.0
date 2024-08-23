Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62A13C2F
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371939; cv=none; b=gNqFSjOFkUnm3d4L6I234GTu4T6GbZ3YvtYG+pkfFrnbZ1q1pAkvBjzUWF5XOufw5HCTSv2oQDEl+9CGtUEpPvF3iy84hdIgbwH4O/lxmoJYsTWbIX2KS6v7bcw0/cXd+dxlq1DL+HYb2NkZf2N0BozcXaCQLLMG//2QDj5wJec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371939; c=relaxed/simple;
	bh=6XSc2FNe7ajf6ik47a7pe4xlQi+N/kJdjGCgOQ0ZQcY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQHLd663/iOVn4nw+pBTva5rVJZCah9DjHNqOA2/fp6RmLExur3jqz9e8U5pWTCeRpDqTm3rQFaJKDF7iuxLg5xeUABaYm7VU8Il/4hDHXJcJfw1SHrtaRJ8jqKZZq2zoyoXXRIvP58gtPylZnnuDnj6qgQvkI+hCbJ59dz7YLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts6KRnt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts6KRnt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B341C32782;
	Fri, 23 Aug 2024 00:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371939;
	bh=6XSc2FNe7ajf6ik47a7pe4xlQi+N/kJdjGCgOQ0ZQcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ts6KRnt38KCt/+DLv2lFTNab0FioFfqVqWTmduAzIQgVdCKbLW5KPyWJbOfkJtePP
	 PSpfBJl2ZKfjPChbe08E51NJe07s0Qdl9gtyja7pTrH7yMM7SVjXVCqLvROCKA/JS0
	 +HtQ2z3p2wFQU4R4T+L+WMIDf54OWCrJM+LJldPcp4OQc7ekYZ9KNnLMmsoXUZLKcH
	 /OISZptiSwKutu9xNDiyfGWBnWLQjiTUjLfo89M9NG3OMri+MJhWOvgqUvQALaEn0q
	 bXzwZFLOE8lXbJ7AsNt4IIQz+yqHeEOv6pvN9KWbhPOdTqHLHq+CPGSZ3XrwUaFwas
	 wXCo5LuUFAwoQ==
Date: Thu, 22 Aug 2024 17:12:19 -0700
Subject: [PATCH 01/10] xfs: use the recalculated transaction reservation in
 xfs_growfs_rt_bmblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086634.59070.2069214237731150756.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

After going great length to calculate the transaction reservation for
the new geometry, we should also use it to allocate the transaction it
was calculated for.

Fixes: 578bd4ce7100 ("xfs: recompute growfsrtfree transaction reservation while growing rt volume")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e809a8649c60c..1f31b08c95a06 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -732,10 +732,12 @@ xfs_growfs_rt_bmblock(
 		xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
 			nmp->m_sb.sb_rbmblocks));
 
-	/* recompute growfsrt reservation from new rsumsize */
+	/*
+	 * Recompute the growfsrt reservation from the new rsumsize, so that the
+	 * transaction below use the new, potentially larger value.
+	 * */
 	xfs_trans_resv_calc(nmp, &nmp->m_resv);
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtfree, 0, 0, 0,
+	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_growrtfree, 0, 0, 0,
 			&args.tp);
 	if (error)
 		goto out_free;

