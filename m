Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D391A32ED40
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 06:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020064; cv=none; b=rCmFCJXaqIObSoyejnfPFT7OLyBWMuelCBlFmvx8BlAMEg4fT92UH5SURVxXLDCwDWUvJsMH8lK0JvOgqleKrU1lqmmXHP+eTb0Prgh80JTsMr/7QrFO/92yTam/TVdppjJwyytXPzIR257wxWv2mCJkUzhacSiN2Yr+C3+aCSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020064; c=relaxed/simple;
	bh=IlcNcJzYz5O8IoVJUQhG89/BR2uEq4O6cCxS5vHAAIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sII/g4F389i6W5AqYmZlNrK3EcC+/8162uoei9djyto5w4Jr7YMAhyB9MRvObOmbzrfC9A6e9HwZekfJs+xQB4uM1++6+QKd7u8pp2NRe4pfcLh/fz0eM+0oazb5DcFWEv6pgcKkxs8Wn95zYiPr19sFI+H0fjnBAJEniD+BGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAmp2I9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAmp2I9E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 50D871F000FF;
	Thu, 10 Sep 2026 06:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020063;
	bh=GiEy1igs0A6OyzlrsAkvAzg2DG+sLAM3d04qjFndgmE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hAmp2I9EtTsvmG7yUotXMyK+bdRu9/ka9SY3pujRiDMg7zbtkMfeD0s3scqPvyv+e
	 u0a3P38P36GQpgMcQFXFzcQjjRfFCXgRBK6ZYPBlRWdGXRfb/+32mclZCZ3Bid58nv
	 ogphlnBNqtFMR3oxwO+QcT7PEwjSKnEMGkj4loT/PqyrF0F7mKzEyNnZBItwdUzKb1
	 ntYdo0FLsdn3MLgMCnApLlUIkCwD6iYCjB9EQ7oAash9taQ/UQY66bGG2627trbTvQ
	 ig0Ma9Ze6mQodBh9//Nz6mw96W2lAh8Lhlbh171uEQM5UN0f2IiGFlpq9SosRa/68F
	 RibyprACxYK2w==
Date: Wed, 09 Sep 2026 23:01:03 -0700
Subject: [PATCH 5/6] xfs: release AGFL after walking it during rmapbt repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178901989937.361651.12871680046411144305.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM suggests that we not hold the AGFL locked to the scrub transaction
for any longer than we have to when we're rebuilding the rmapbt.  Since
we only took it to generate an rmap record for the AGFL blocks, I think
we can safely release it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rmap_repair.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 590f9f41856ef7..725035bf490329 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1109,6 +1109,7 @@ xrep_rmap_try_reserve(
 		return error;
 
 	error = xfs_agfl_walk(sc->mp, agf, agfl_bp, xrep_rmap_walk_agfl, &ra);
+	xfs_trans_brelse(sc->tp, agfl_bp);
 	if (error)
 		return error;
 

