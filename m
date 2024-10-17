Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2D219496
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191575; cv=none; b=d1O/ltBxlA6eHxYRPTvCCqK17a/oUqih9WdL0tSOa09L6pTWSxmMvTzT1UxXpshDrTLdWwu9Ui3Pm0XiDQJ3PCQ1s0e1mHFqvZUZ7ftgXTe+HfFhL5jluhs423sZ9DOCChLgiFOArcAKEcjoyac0V0XLq9J0F8BX872YQ1G45ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191575; c=relaxed/simple;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXvHfGUUh7srijn3BOoPAli50ZMGGHyKAZCHj/ZFqJr3vAOGFY9vcYv+odteOLA+pYs7OenkoGCqO+KIP6t5whCyFUtcZ9fhBAJwJEgJ+QpYahy3gSq3CMR2LHo81rO+6YYdGyE/814BmY+igBI/lBpcr+I6evjwbGYrX8Bc5Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=reRTnZpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="reRTnZpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C655C4CEC3;
	Thu, 17 Oct 2024 18:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191575;
	bh=35tdztF+3jhSDyRtzRaJuOuJgb9y7IqUKLEurjbbAY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=reRTnZpWcOIzOio0MisbFCXSjLha6HKDED0Be3Nsg0HfyOylZZIQGScU/YPRaAlcg
	 AC0mihaju30j8BlNMlRZQW5dAYd2963oBc0T83TLF4IbVj1egMzGPSvEaIdFK0nxNH
	 xXOl+UTm7kBQDQY5J4AA2tmwfikkaonYTBOCPKQNtEMP6bW6LK0tOQMSzwO/J/Pc1z
	 nfr55yQ0kZnmY6VmqJq0JIqTd6Np3SxWNwEW3oUlRqMGESrIlwjSKk1F00cHKg0BxE
	 hiUjNFeHMTxRCOuJZ9pmVMZgPoBVsOzdCmmNWW+edSstghlH0kWIUuZ/QvkwB+AwyR
	 7Nrkrqm/yFatw==
Date: Thu, 17 Oct 2024 11:59:34 -0700
Subject: [PATCH 28/29] xfs: confirm dotdot target before replacing it during a
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069933.3451313.6287527165191764890.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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

