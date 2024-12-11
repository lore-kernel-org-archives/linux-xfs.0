Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414182594B3;
	Wed, 11 Dec 2024 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947695; cv=none; b=Mv9/86qwgL02EFOhnip5xpQoAo96a3mLBsTvkglPPbxOm2Ip1wVzGqiaKeaqZAM1H3nVlQi5HhwOBGHxOsTf6HVJfsQ2eFk6tqJnPwTJiHHEkGwBDo+HB66ZkLSn32VIBE2lTVE/3HUtO7Oz8gV+o/qajD8oUjpLuLwQitWrYrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947695; c=relaxed/simple;
	bh=9IWf77lrk7H8zbrW+W0y6OObHF2pbcOytSxzgwnz0sE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/e02YkWToXaX+bdSZOMCYCi7tr2f0JbFgwIpN/OITK6q0J5KTkNKka9A1rmd/LL/VhqgaA5FRGPJibqtEBpAiWJy5uT0LANJIr0PQZmxHqJcdSJ4ih1ldf5qCF6BlZDxlUf3gODSpKZTwjS9tYzFBMo8Aiw6KcnJM/+Yfc3Oow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFXwVJo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFXwVJo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A60C4CED2;
	Wed, 11 Dec 2024 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947694;
	bh=9IWf77lrk7H8zbrW+W0y6OObHF2pbcOytSxzgwnz0sE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EFXwVJo8Fa+I6qRfDRbojjnriXcDaKrI9Rw8jv913I7z2gAPAMG0yedIUPKtU2X2D
	 JakMR4LLERk3VaKWjQ5KVK6zPq7VtQsRv/d4xBDNcRNC/adRPWy5GNzm670WwKTy2O
	 Nc3x1c6CPRAzzS/9ZiX5dhtzwGj/LAQVq+90zrNT6OCYSgvu0AQ22vGnBo+QdoK4lz
	 hexBKLTWVi99lTS9cOB0JooNWxubaTAMCKpGXi6uIRgaytVV+4hqrFeasdl/rLya9S
	 r0Yy3BQQq8AU0r1kbsZyamFgPMYdPnFdHe4MV+3jcB+3J5CGr80T878+8oGuspeDKf
	 2xoTRAesZ+xBA==
Date: Wed, 11 Dec 2024 12:08:14 -0800
Subject: [PATCH 3/6] xfs: check pre-metadir fields correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758120.171676.4704523076706311668.stgit@frogsfrogsfrogs>
In-Reply-To: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
References: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The checks that were added to the superblock scrubber for metadata
directories aren't quite right -- the old inode pointers are now defined
to be zeroes until someone else reuses them.  Also consolidate the new
metadir field checks to one place; they were inexplicably scattered
around.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 28d756d4d562dc ("xfs: update sb field checks when metadir is turned on")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1d41b85478da9d..88063d67cb5fd4 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -145,8 +145,11 @@ xchk_superblock(
 		xchk_block_set_preen(sc, bp);
 
 	if (xfs_has_metadir(sc->mp)) {
-		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
-			xchk_block_set_preen(sc, bp);
+		if (sb->sb_rbmino != cpu_to_be64(0))
+			xchk_block_set_corrupt(sc, bp);
+
+		if (sb->sb_rsumino != cpu_to_be64(0))
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
 			xchk_block_set_preen(sc, bp);
@@ -229,7 +232,13 @@ xchk_superblock(
 	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
 	 */
 
-	if (!xfs_has_metadir(mp)) {
+	if (xfs_has_metadir(mp)) {
+		if (sb->sb_uquotino != cpu_to_be64(0))
+			xchk_block_set_corrupt(sc, bp);
+
+		if (sb->sb_gquotino != cpu_to_be64(0))
+			xchk_block_set_preen(sc, bp);
+	} else {
 		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
 			xchk_block_set_preen(sc, bp);
 
@@ -281,15 +290,8 @@ xchk_superblock(
 		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (xfs_has_metadir(mp)) {
-			if (sb->sb_rgblklog != mp->m_sb.sb_rgblklog)
-				xchk_block_set_corrupt(sc, bp);
-			if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
-				xchk_block_set_preen(sc, bp);
-		} else {
-			if (sb->sb_features2 != sb->sb_bad_features2)
-				xchk_block_set_preen(sc, bp);
-		}
+		if (sb->sb_features2 != sb->sb_bad_features2)
+			xchk_block_set_preen(sc, bp);
 	}
 
 	/* Check sb_features2 flags that are set at mkfs time. */
@@ -351,7 +353,10 @@ xchk_superblock(
 		if (sb->sb_spino_align != cpu_to_be32(mp->m_sb.sb_spino_align))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (!xfs_has_metadir(mp)) {
+		if (xfs_has_metadir(mp)) {
+			if (sb->sb_pquotino != cpu_to_be64(0))
+				xchk_block_set_corrupt(sc, bp);
+		} else {
 			if (sb->sb_pquotino != cpu_to_be64(mp->m_sb.sb_pquotino))
 				xchk_block_set_preen(sc, bp);
 		}
@@ -366,11 +371,20 @@ xchk_superblock(
 	}
 
 	if (xfs_has_metadir(mp)) {
+		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
+			xchk_block_set_preen(sc, bp);
+
 		if (sb->sb_rgcount != cpu_to_be32(mp->m_sb.sb_rgcount))
 			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_rgextents != cpu_to_be32(mp->m_sb.sb_rgextents))
 			xchk_block_set_corrupt(sc, bp);
+
+		if (sb->sb_rgblklog != mp->m_sb.sb_rgblklog)
+			xchk_block_set_corrupt(sc, bp);
+
+		if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
+			xchk_block_set_corrupt(sc, bp);
 	}
 
 	/* Everything else must be zero. */

