Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8106A311597;
	Thu,  3 Sep 2026 05:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414667; cv=none; b=jAx9eitobUJ9vKa09qUVZTlW3uqmb/uort4RK2/RHxrL+B9PDTnmQE1zAXIW49vOpRR2nkjgycUal2C7DSzsCo1H859xW3KaP0e35qI1Sx8QJIfr1vJkZxq8fvGcI5UTecUZlD8YiQR0fNdSmR7ol/y67efnl78R/1MVVxxK+00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414667; c=relaxed/simple;
	bh=mBgXclfb/qQfgr597BuikgWPKz/y1fvZC9cbraOd36E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gl5Vd36zYEQFWEtnfCSmbj1aHqumAp4Lr6vyfFi5+66QFEuyzAxCbED1TuVFPaGOLU8msLXa/hbypMr3D1IoyBzkqnp+zD2hBD4U0zQHm6gKtqOCkqeUglsUcccpWn4vhDXICHCpOgmXv2O5MFQ+XetoHM4hsHdDaPQMlGLwjjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyOsEC07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyOsEC07"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 10C831F000E9;
	Thu,  3 Sep 2026 05:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414666;
	bh=DQfo2JJNySAzq367tdlcblwNZxPD2P6a7JnKXYs6G4E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NyOsEC07jQjx2J7dOqxzsqxODjs+aV+9e//I9+ZNWLraTKljTeo+BnUCi3qCbcJ7E
	 wM/z2KUhVou6124V84NGHBlYhnQclw9JyVKR8+TLjspPzNkcdMSrxqCA5nFkPx1N9l
	 ZkpU51DwAZQTu5Nx6AKssv2Q2/hGNem0nFWgZHEXkHtGgASG2XRkGraJ9STpBKoZfj
	 ipzCgaxTk00tl0lU0MIXJTaU9Ic865rHSrJBCObKkXBuQG+WmfUO74kr9c2rODUHnm
	 Bl8+P6wPiiLCETmA9xCZxUho6usk7bTe5/k99IJQSaIgZG5GI7sd5yerGY5zhLIBvn
	 aRtCoyj+chuNw==
Date: Wed, 02 Sep 2026 22:51:05 -0700
Subject: [PATCH 1/6] xfs: cross-reference the rtgroup superblock extent,
 not block
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969850.484660.6737366204336091136.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that when libxfs creates a realtime superblock, it will
create an rtrmapbt record covering the entire rtextent in which the
superblock lives.  However, the cross-referencing checks only look for
the first block, which means that we can miss a corrupt rtrmap record.
That will get picked up by the rtrmap scrubber, but we should make the
rgsuper scrubber more robust anyway.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 3f1bdf50ab1b9c ("xfs: scrub the realtime group superblock")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rgsuper.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 2bd2c0351b35f7..6e2abe5dc27cd5 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -36,8 +36,10 @@ xchk_rgsuperblock_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0), 1);
-	xchk_xref_is_only_rt_owned_by(sc, 0, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0),
+			sc->mp->m_sb.sb_rextsize);
+	xchk_xref_is_only_rt_owned_by(sc, 0, sc->mp->m_sb.sb_rextsize,
+			&XFS_RMAP_OINFO_FS);
 }
 
 int

