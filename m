Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6B4FBF6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608126; cv=none; b=hTVf+HgcULNe21Qel1n+QWhfrOnzre1xF+NLOGldaDLM1QA1iBnedbGPCQWUrOjn321LOkFFhQ5Mio2KlcsmWg1Ldzp/3JdJTduInDDpd/U9/IvXzFinu0uBQCTOKpqyxngR19S9mdJdcTGxZtdk0TMWTVFxQO2aguK4tRdyn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608126; c=relaxed/simple;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXe5zN5tUV89Iu70ORyuhOcq7eiD2/V4HEqPnMHXYJ2Wqy2iXjgEnhrqJjGHwtaBWz9w12skoAxoa2TOw5JzAqmFHBaibqqCI7c79kDJTpHUTGxSvEtjPXjGWRMU0CCimzPJGCZxoZ4UVxjBgNH8Tpqc8ya6bWLdM2SLqw8q5TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eb78HPm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eb78HPm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31378C4CEC5;
	Fri, 11 Oct 2024 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608126;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eb78HPm5fpQc377fNLZ6UAyC4KZjX6EC3hWxsZzUma1Bwfq6zkQeMSQkWNC09ghPq
	 si72i0t8YjWzbH8nXd6lRahjVOZRrr/UMSoiSRLSjBUgyrdVyUW32qWQbV3zbdlLEN
	 MWj1Jy72kmvt1EIfdoo9E+Hk5xhMa5uqsJR5a2vRxMOi2NZk4aQrfuJe5jKkFQwHRW
	 Em3INPslJYSPD4ASQTfcgJnkCuTBf2fAgyDn0xlxml3p91P+6/uDs78GgnSiHXb6FY
	 cN5IaUwUgnblH8bI4dxf8rzrec8X6V3jBNUNbOUGVQxpDGOwOeCGSeeVQrJ/lvb+u2
	 oJTaq1d/dafKg==
Date: Thu, 10 Oct 2024 17:55:25 -0700
Subject: [PATCH 27/28] xfs: confirm dotdot target before replacing it during a
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642483.4176876.14672994042991988584.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

xfs_dir_replace trips an assertion if you tell it to change a dirent to
point to an inumber that it already points at.  Look up the dotdot entry
directly to confirm that we need to make a change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2456cf1cb74411..24931388210872 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1638,6 +1638,7 @@ xrep_dir_swap(
 	struct xrep_dir		*rd)
 {
 	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		ino;
 	bool			ip_local, temp_local;
 	int			error = 0;
 
@@ -1655,14 +1656,17 @@ xrep_dir_swap(
 
 	/*
 	 * Reset the temporary directory's '..' entry to point to the parent
-	 * that we found.  The temporary directory was created with the root
-	 * directory as the parent, so we can skip this if repairing a
-	 * subdirectory of the root.
+	 * that we found.  The dirent replace code asserts if the dirent
+	 * already points at the new inumber, so we look it up here.
 	 *
 	 * It's also possible that this replacement could also expand a sf
 	 * tempdir into block format.
 	 */
-	if (rd->pscan.parent_ino != sc->mp->m_rootip->i_ino) {
+	error = xchk_dir_lookup(sc, rd->sc->tempip, &xfs_name_dotdot, &ino);
+	if (error)
+		return error;
+
+	if (rd->pscan.parent_ino != ino) {
 		error = xrep_dir_replace(rd, rd->sc->tempip, &xfs_name_dotdot,
 				rd->pscan.parent_ino, rd->tx.req.resblks);
 		if (error)

