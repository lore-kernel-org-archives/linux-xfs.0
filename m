Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA44688
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371721; cv=none; b=BKl+ZLoXp9m23ZF83mk+8mfhCZhizREsKivxmB5ffPSs+pwd561f/rBCTdqZXmsd3KnDtDB9X348amQKX/rtPe8U/F6AvHJHJmO+rB8tY9jNzR+yo5nHv7ksXImVooL7rFnhO/GaHyY4eMLY6Nql+uHANBYDxcche6c1/6U1tQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371721; c=relaxed/simple;
	bh=JQDZ+jL6DGv/etQtxVdTVWivXqlrFzWvmih2O/yA4aQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azKFa3wHGNy8mliNrXUarbMt5a27PgoGDiVpZwryRhRFCDY4/gzQfUyKXkb8UGKxmBykbNK5hFhCmRyk9ZUlcqTbZSupZt0AcR+v88KLnUtTTGcpjn6MkXPTSHrOJYEI3v9ykbfuh8hqo7H+QoNUaI9e6Bbkg4I74MY913CptMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dvy7ay0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dvy7ay0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80A0C32782;
	Fri, 23 Aug 2024 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371720;
	bh=JQDZ+jL6DGv/etQtxVdTVWivXqlrFzWvmih2O/yA4aQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dvy7ay0yf7yu5n3UWMydXyk+ZxbulVSKiJU6NYi7dkRjhZgo13I5BZylAFqwKiOLN
	 zWxAONNd7pZWgK0v0zp8VUalKDPvAAgIYBmcZVNyXb3aW18X6jtHduuISVXcrn85ko
	 BNmb8ofNxSix0Vxj+kQLc9DGHoqxFCdvccwDuJbMKvvs/CVQ8hCUY2bMZ1mraY4GEM
	 xsxLxErK3+Ky+JqR3WWIy2jms0GKYzdFSdWIMWHT2JpGiteT4pdoOXs+5cHA3vumDY
	 6D6WDH6IJJkRO+x8v5j1INJX4lgakdK89ycbzG/Si8az/6aVnSkjKax0vjQeRJurZU
	 yb7R0iN7qyv9Q==
Date: Thu, 22 Aug 2024 17:08:40 -0700
Subject: [PATCH 25/26] xfs: confirm dotdot target before replacing it during a
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085606.57482.15990942213279998510.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/dir_repair.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2456cf1cb7441..2493138821087 100644
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

