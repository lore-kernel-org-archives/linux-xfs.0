Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A414413B59B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574707; cv=none; b=WqgMj/akCQu2DAOFUA+phfvZNnLfDsuXW6wwUzf6h5Gz7o5YTfV3uJSM89S6ywq5kZqWvTzfGbe9rHahThGBsT4bSwjtj/d4vCWYA3NCJuoAfr/627yOIVSn5Ay1fiQLIY/fuda1k7LO3Ee1aAQizm+I0qhNMo8pnBlgQK5Kytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574707; c=relaxed/simple;
	bh=ldPD/FzP71CUOYs4mfRUot2HVoJRk1MkpM5nHctBfQ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JePlYj2pLofy3P3bBFFvSNhAkitmn23NJzyIWE5ZyzPasYyKDrYmtQtxRZgZaIWy6Dmp5hcsiApn+6vILn7GMoRQkgOpM9kUtJJYUlxv1OtkfQ9kYHQYOmXDPYsSSZMrzdlIA+PX8lZ+BXkR3oNh7AWwIVLlAIvZxQ9vcR/R2sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJkcjCrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJkcjCrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A3DC4CEE3;
	Fri, 21 Mar 2025 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574707;
	bh=ldPD/FzP71CUOYs4mfRUot2HVoJRk1MkpM5nHctBfQ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HJkcjCrCpy3uE42LGtu6npRH1QO0FHqdA0LF6IZkZaKNXBxB/Elq6UD8tOaAuP+0S
	 UzECrM+nNnCxUr57xINeK528voEz3BW6ShsrTTcsc6oy12XVrfbVBvl1duOAlwgV9u
	 blILOwkM9mxX3c5WeAAKIyBTwP40RvQ3ahvJCj1RGqBcs+uiDRRHAguQK9G8zFH22u
	 B/azEvHibtCNSdDRe27+X56tVu84Fi7LkbBQoQltEc44vI18xuzCVGhxSgqbpkPYHU
	 O7qTijot2OederkOKag0W7EVFm71lJTVQMdTPcFf5UpVqYAlwFTj1lMueIMFkgOi4M
	 CQzSmoyWnPywg==
Date: Fri, 21 Mar 2025 09:31:46 -0700
Subject: [PATCH 2/4] xfs_repair: fix crash in reset_rt_metadir_inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453632.474645.11619039334465128305.stgit@frogsfrogsfrogs>
In-Reply-To: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I observed that xfs_repair -n segfaults during xfs/812 after corrupting
the /rtgroups metadir inode because mp->m_rtdirip isn't loaded.  Fix the
crash and print a warning about the missing inode.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 7c541c90fd77a2 ("xfs_repair: support realtime groups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 2d526dda484293..c16164c171d07d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3397,15 +3397,21 @@ reset_rt_metadir_inodes(
 		unload_rtgroup_inodes(mp);
 
 	if (mp->m_sb.sb_rgcount > 0) {
-		if (!no_modify) {
+		if (no_modify) {
+			if (!mp->m_rtdirip)
+				do_warn(_("would recreate realtime metadir\n"));
+		} else {
 			error = -libxfs_rtginode_mkdir_parent(mp);
 			if (error)
 				do_error(_("failed to create realtime metadir (%d)\n"),
 					error);
 		}
-		mark_ino_inuse(mp, mp->m_rtdirip->i_ino, S_IFDIR,
-				mp->m_metadirip->i_ino);
-		mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
+
+		if (mp->m_rtdirip) {
+			mark_ino_inuse(mp, mp->m_rtdirip->i_ino, S_IFDIR,
+					mp->m_metadirip->i_ino);
+			mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
+		}
 	}
 
 	/*

