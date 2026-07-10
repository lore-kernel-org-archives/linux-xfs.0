Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A13321445;
	Fri, 10 Jul 2026 05:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660995; cv=none; b=Gdf+/CMhaSeIzw5X8wNM5qP/WUbl3zUuOyc3tsCbahDMM54iZ587pFWyZg0EdLXgOUPh6W/2cTMVGk1WqjO2M00fS1EMNPUQndubumtwaAd9Wl6y6zgCNBvSFEWZE5vKnI5GgA0Nmr26AuWed2Z+Sg/RJbE8OPr9P0bK0JNjmck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660995; c=relaxed/simple;
	bh=s2YjLy7yJLaYvD1Vyf79m/xJ4rbdSAPmDboV1yWJ8UE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGcIPRObQdKCUWDMMJjvwjLWyfLfnURvEhIDUFQ2g8dEYN95j+y5/WWi6RTPNDS6AE6BnpY0ZwNKgK+VU+u9rf1csk3D1d3PCvBBj/aojbGiHVJPrmjvcmho/QXKlsVynYk8Y4DHttChZnyL92avkzxlO5s0l8Q8bUpR2os9XpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keZU1oF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keZU1oF/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F8951F00A3A;
	Fri, 10 Jul 2026 05:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660994;
	bh=050siUOTgWiPSmWq54OI+FW7Xh+qogw4IQj65GpaE/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=keZU1oF/+eyy5OiE1z0Q6XiKG4BgF5RPMHbB2cF0i37F0Q13yEz3No5vqo6kj8OqW
	 Ija6FES1VYY98X5wRjnXxxoXKaxwngmGruxqAtfbSPZ/EIywql9rOYlsHuTSAad6WN
	 0UEBbCgTrhmZwfZnZPtIswHY5iLXBtbGwExa3AWH+/cpEGdX5h8y3Nb5p86Fbbgpx3
	 IbRWhS0soh0wUFR6OWwo//HdelVdRrw3zwATXAVPO78LHCwgDDkAMy3RYon3LeUdxT
	 Iq9qAWbGTiW+CCuY11illg2svZ8F5UfuLQumEco7Hbua53IOmOcaBS/RO5QxkBugTX
	 NanAfnpbt0p5w==
Date: Thu, 09 Jul 2026 22:23:14 -0700
Subject: [PATCH 6/8] xfs: use the rt version of the cow staging checker
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178366081120.1173468.6221210858309097703.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
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

