Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06FE36A033;
	Tue, 14 Jul 2026 06:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009128; cv=none; b=gb0f22Rc55R7SHb5mYkPg5tXEMF41xTO4pWBQWz32gTFv+hvZi9wfnfXxdpKz+M5VTMzKJE86N36iMAcBHfHxUWLId9jmlOnXIYG9bFjixohbB/+dnqebnyVLMUtFimzbVjAG8njNHclVf3ggZdn5chqQscd8w8QM995FJBfNAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009128; c=relaxed/simple;
	bh=s2YjLy7yJLaYvD1Vyf79m/xJ4rbdSAPmDboV1yWJ8UE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIMESXOZ9WWoJyz1ekTnfRWW1W+wtGOkb8eS+ItQ8QcXri1mAp8pOaZUIvs5vAOWhJRL/329fmvZCYDkIUsHZhsM6uFPufXgD448t/Jxx8Zgzn/c0o/lAIs6Dgv4P6YzuxIFEarjapFD+UTg3nK6YM9GcP2y75Kirxoxq85cCXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BM9IJD4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BM9IJD4J"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 903861F000E9;
	Tue, 14 Jul 2026 06:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009126;
	bh=050siUOTgWiPSmWq54OI+FW7Xh+qogw4IQj65GpaE/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BM9IJD4JNoLjArNi9Xk2DbnAyvGF63X++nR8I0f4+keI1rAd6q2Ee+GMSOFMAEX0g
	 cPQcUYsjpyydeLv8GLz9BcC8IdcmZzBjvOkSGhHOpdkEUUnZEAeQAuORYwhZbijFpN
	 T7Vcr9pNTJlbHQTdCCVJBtucOoRrfuLjQjEybDU/bA577GD5b49NE3ZPumTy1qdSFg
	 b9otfO29PdSRtc9RxhuYQ19HPqHftpMUckpeDyIVC1zSNf8cL8mmeTm1HhHY6vUxHB
	 7P7nPhWVg9mI6gciE8XUyt82eq8mpzpYH2S4YgzZ4kotiXZzmYzdPsN9q55WzStjxU
	 5wQDvNZ7aP0lQ==
Date: Mon, 13 Jul 2026 23:05:26 -0700
Subject: [PATCH 6/8] xfs: use the rt version of the cow staging checker
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716499.267810.18280309511282201387.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM also noticed that xchk_rtrmapbt_xref ought to be using the rtdev
version of the "is this a cow extent?" helper function, not the datadev
one.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 91683bb3f264c0 ("xfs: cross-reference checks with the rt refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 043be93c714884..b3b2cf17ba2c08 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -209,7 +209,7 @@ xchk_rtrmapbt_xref(
 			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
 			irec->rm_blockcount);
 	if (irec->rm_owner == XFS_RMAP_OWN_COW)
-		xchk_xref_is_cow_staging(sc, irec->rm_startblock,
+		xchk_xref_is_rt_cow_staging(sc, irec->rm_startblock,
 				irec->rm_blockcount);
 	else
 		xchk_rtrmapbt_xref_rtrefc(sc, irec);

