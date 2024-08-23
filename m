Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36970AD4C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372956; cv=none; b=O16kW2+fdCEC+KQpel7c4LXkxa9GQJ14Ma613FVBjq/C7WgVMR5mR/4Zyv+b65f1G/IeX/ucpOKHvqZq7q7PsGpaQ+kAodRrRNkYgL9GA/UHaE9xN27HjAxZ+TIvrtrW+uy7hKCycgWoZ0phy4X0E5aFpp22BvnjU2KTiEt6AYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372956; c=relaxed/simple;
	bh=J5hgRtUl0ujTW+M/sIs0vKlCiL8Pm/Qw0VQe0k90DQ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0UyRk405FjAgA1st3ZXp2Zd98u5Ruy83kAJdfGPsGZPqKWdz0BssclHpryjnJfKYA36/3W6Foyvs+CxkIHs57mcZshExG4aqzk2tie9zmV1BMOs14x4GFV4JodDNfbGVzXcOL/ot2pStwR0WIOqwO0yiAgZwQ7BMpF6Ef/tokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5E5p3XM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5E5p3XM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB708C32782;
	Fri, 23 Aug 2024 00:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372955;
	bh=J5hgRtUl0ujTW+M/sIs0vKlCiL8Pm/Qw0VQe0k90DQ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e5E5p3XMjlCFdmNoybDf8w6dm7IjPMyxQwnMnbRx8tzhyO2wAbkkXwKGbwlhCp+yd
	 NFht37IJJX5dZDkhst0ZeqA9odvqe3IvaLzQJDzvmoQCfhnoII6JssvmRvpoy/U1KZ
	 V7IZx9S+wzPvSr9fj/FcwplBjt739n1dE7sUuY4SYLhTcgARBtRmuazMCHlnCuLiS/
	 7/rMdMKeUzFpG9VKZo7AVNKmEm+d9WdkBb04txYI0bsU8A/xTIu/P3+FyDn2bRnFER
	 spOYrooGzf13yT9yf4aGMggdOU9cR+TdE4Ku+wCTwm0SrbTwk96XwY4zfuoSQ5V0iE
	 TRgc4IrvIx3uw==
Date: Thu, 22 Aug 2024 17:29:15 -0700
Subject: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
In-Reply-To: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
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

When metadir is enabled, we want to check the two new rtgroups fields,
and we don't want to check the old inumbers that are now in the metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index cad997f38a424..0d22d70950a5c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -147,14 +147,14 @@ xchk_superblock(
 	if (xfs_has_metadir(sc->mp)) {
 		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
 			xchk_block_set_preen(sc, bp);
+	} else {
+		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
+			xchk_block_set_preen(sc, bp);
+
+		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
+			xchk_block_set_preen(sc, bp);
 	}
 
-	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
-		xchk_block_set_preen(sc, bp);
-
-	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
-		xchk_block_set_preen(sc, bp);
-
 	if (sb->sb_rextsize != cpu_to_be32(mp->m_sb.sb_rextsize))
 		xchk_block_set_corrupt(sc, bp);
 
@@ -229,11 +229,13 @@ xchk_superblock(
 	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
 	 */
 
-	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
-		xchk_block_set_preen(sc, bp);
+	if (!xfs_has_metadir(mp)) {
+		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
+			xchk_block_set_preen(sc, bp);
 
-	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
-		xchk_block_set_preen(sc, bp);
+		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
+			xchk_block_set_preen(sc, bp);
+	}
 
 	/*
 	 * Skip the quota flags since repair will force quotacheck.
@@ -342,8 +344,10 @@ xchk_superblock(
 		if (sb->sb_spino_align != cpu_to_be32(mp->m_sb.sb_spino_align))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
-			xchk_block_set_preen(sc, bp);
+		if (!xfs_has_metadir(mp)) {
+			if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
+				xchk_block_set_preen(sc, bp);
+		}
 
 		/* Don't care about sb_lsn */
 	}
@@ -354,6 +358,14 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 	}
 
+	if (xfs_has_metadir(mp)) {
+		if (sb->sb_rgcount != cpu_to_be32(mp->m_sb.sb_rgcount))
+			xchk_block_set_corrupt(sc, bp);
+
+		if (sb->sb_rgextents != cpu_to_be32(mp->m_sb.sb_rgextents))
+			xchk_block_set_corrupt(sc, bp);
+	}
+
 	/* Everything else must be zero. */
 	if (memchr_inv(sb + 1, 0,
 			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))

