Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F591215F50
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845420; cv=none; b=re1zf/Hb0/WyfkNeSTrcfulOipwcBa/x2cDD2vjBPCU/9ZM3BY4eiqyc+0xPuxYqT+QnqQfFyVVBT8ne0RLb1f5zG14mksfmoyw8L7t4hb52z2l9mwfu73cR/8aoSEy/nADLo6qt0LHndJgviVczBDIcN/fKVBOV0VCVFnBQHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845420; c=relaxed/simple;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+RjTbLUQoXFiJSfLKspFHTo9Dt6dNUz7HMdfB35PhrKDrBjVZfY3hX1HFI0iIwLspdX8pwEKnvrWJEGtzWTWSoo/QfUx0WSwt3RGnzy9UAz/h3BSs7P7QiDJGqXp2ikRE3SJk+vWx4NZRuJTv2ZcTrvPrg7Uzo3s9rRuGZtspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj6neTd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj6neTd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DACC4CECF;
	Tue,  5 Nov 2024 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845420;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yj6neTd9WMBhvKm1PvOHrCQIej3RPUKMbrb4c0Jk5bEeexmd2p4A/wlwBoAFrwy64
	 o2JkVskpdEEgeLCECTAyuCjBfkSkRLSTN5vIPvb6oXtpncxcsAN8dcjq4TzTirpGpl
	 Ktk5gTOBqeXMC64S+FmphEEq937XoFzokqX8rY+h/YPOTbszFABTWjvsAxFu2U7+Om
	 ACYG4DawaoIn7kIRdp5jqInGCo5jxW2fm1x7PI3GptPiK3qpjfK2Gu41egD5OWaVt7
	 lguNuQVzi1S/hjlUYK96+DbtEq4/KdxEM7ot+oDsg4btyLzIizUwjdlnAU+TSJoLE+
	 QO3Ot7MZ+nDag==
Date: Tue, 05 Nov 2024 14:23:39 -0800
Subject: [PATCH 27/28] xfs: confirm dotdot target before replacing it during a
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396482.1870066.10342829934899341446.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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

