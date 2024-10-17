Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F7321C18B
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192309; cv=none; b=AR69Opm81huq93VOHYm764cbyPfVaG+D3QYrJpmrdv80jzgtletnbCMr9v9M80BoXQN8ityaSJhvnGhuTUWGoBUtxea1UJ27UDsrzfkPdxbr90BQ2GnhZ0Vz8/cKsok2AThCoAEJQvHcEVZIasqsOBcXgNJwwp3jWIe5Gn+asR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192309; c=relaxed/simple;
	bh=zgHGnTpLBnOuvxD5VvyzvhO+reRxOFKI9udb4kZVTwM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p2cg/env047DIz+y3LctfXIQGc7NMlWFnwE+ETmAulABuiLPjFMUCnMo7x0Ag6rBrF8YsAbdYnegv3QyS/FxE8ElcWSSCtxcZ4R9nGuJrNpqjuAN9/fGRySiidB1yH5D09/g0o4DhVn5Eb8YyT1iuy7m0RoI8uAt5GfshpixgSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3TgSx9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3TgSx9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F1FC4CEC3;
	Thu, 17 Oct 2024 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192309;
	bh=zgHGnTpLBnOuvxD5VvyzvhO+reRxOFKI9udb4kZVTwM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N3TgSx9Nwovj/h4h0Ufjv68qNWcgfCtZjrdBBXjHDFO2N3ceR/Gh9rQUFozUMEZ3i
	 8/U42+VfGNKSURl1ykLom45uiP1AdGrPERMecmgYeYyxMN+nEYsIHdf9CCwjYG6SNY
	 fxw8X0s2qu2DmPglK3HntNq8G1Izbw9foZtiLTTa+Uh6xaiBrFJGCHMI3aGzuTxXF+
	 88sQIC1ofZtoQ8et7HVyw8pnphgZnReIvGwOBZ8GwASVEbTLc1hDhcFo1ocbU4Bg/t
	 7CmbuBws2tFGJB2ONtExSWaqIUNkgYsCJWQvbaOgMaWEgFmKYY9WPPGyLkB0kb7bJJ
	 d9Ek4prvOBwzg==
Date: Thu, 17 Oct 2024 12:11:48 -0700
Subject: [PATCH 1/2] xfs: update sb field checks when metadir is turned on
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073559.3456438.17776258383674928210.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073537.3456438.5908736022117741188.stgit@frogsfrogsfrogs>
References: <172919073537.3456438.5908736022117741188.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index d037de6dd821d2..61f80a6410c738 100644
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
@@ -349,8 +351,10 @@ xchk_superblock(
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
@@ -361,6 +365,14 @@ xchk_superblock(
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

