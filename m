Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D2D13A418
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 23:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718752929; cv=none; b=iUpbaJsR4w02lwPSI3hylVUuVJe/W+kmoI4Gq8H5kPCpS4AFcdpgWrgpKXQgJHWZwNdJB9yijc7+3XPfRN+ONarpUj/GrXoXZOfCovXq2Sbyam9/QHqbY1JzfdOuANxaw6EWhAHZZGuDI03soRY9DQKdICGg+x7qxIuxbDleT0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718752929; c=relaxed/simple;
	bh=uGJoe5DHoAbykplVMgp9IiXc8ciQoTNxlK//mZ/4MOM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GVpAMwGsRfZ1aNSSDq27OqQTqNxEwDs0yW3AxOJA5wtU0BsDbaC/IhQTCXpqVcKRtdMR67QRZktb+nlNSJOyCsTXwcUlcgCf/mxv+qo54Z9ueCbdIHAV7HfXzHqBQ8X7Nqlkg4YRVIKrHCfQpc45vm25AeyJE7Hl7mkct24U87g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjkNFygB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjkNFygB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C1C3277B;
	Tue, 18 Jun 2024 23:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718752928;
	bh=uGJoe5DHoAbykplVMgp9IiXc8ciQoTNxlK//mZ/4MOM=;
	h=Date:From:To:Cc:Subject:From;
	b=cjkNFygBIBT1PlMag/rZ3IUILMNy6NCXLQiGwHUiCNMPb4w+/pt8jtWKNUWvhJMRG
	 21qV9/U25emIWnfedAsMz6urBcWGSA0/z4P2Nx/61Q6oG/TyB8yApNwVPHqK+QXQSq
	 Ow0rz2r3o9ketXWqE7+IBW4U8G0vTTn2DNrtK/9SYov0UXL6NCdSZqFCPsFukROImY
	 kqgrRFJLrUPC2GhgNDIO4gM1wFvfEXJGUyPQXOI8M+ZoISuFQH1jre0/DbBDFfit6G
	 cUdW9jqLF6BcJUYbO6S66wPnLcDYmMnBAiSpHNhReN0RXufZ/G21VWUqee6FQ+D3Xk
	 DyM0k9ncyA8wg==
Date: Tue, 18 Jun 2024 16:22:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: don't leak the rootdir inode when orphanage
 already exists
Message-ID: <20240618232207.GG103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If repair calls mk_orphanage and the /lost+found directory already
exists, we need to irele the root directory before exiting the function.

Fixes: 6c39a3cbda32 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index ae8935a26420..e6103f768988 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -919,8 +919,10 @@ mk_orphanage(xfs_mount_t *mp)
 	xname.len = strlen(ORPHANAGE);
 	xname.type = XFS_DIR3_FT_DIR;
 
-	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
-		return ino;
+	/* If the lookup of /lost+found succeeds, return the inumber. */
+	error = -libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL);
+	if (error == 0)
+		goto out_pip;
 
 	/*
 	 * could not be found, create it
@@ -1012,6 +1014,7 @@ mk_orphanage(xfs_mount_t *mp)
 			ORPHANAGE, error);
 	}
 	libxfs_irele(ip);
+out_pip:
 	libxfs_irele(pip);
 
 	return(ino);
