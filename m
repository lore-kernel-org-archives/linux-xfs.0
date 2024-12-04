Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935C7FC1D;
	Wed,  4 Dec 2024 03:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281381; cv=none; b=U8pJhC2HCuxOrxuGoq7+eUvwb2uWOtinZZfe1Cu+wFidhIAMv/LwnarvwQqfjW5Duww422xByige2ZuqEw80Jz8orLkJ7ODRytVJ/0qpRr2Y+SyGWe0z8IgvW78n/y9evhUSzHGjSWr7MRUDn1K+sivbDCyUCGeYBA5UhtqYob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281381; c=relaxed/simple;
	bh=9iGuTJO/rl2OpDJ9rNe5GFvAjKqlfOGEI+Q83/4F9N8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCHLap4hleVAfc8uY9k1GGwf3SCWfyrhTNNmYBUkTwsUBAjO+/vnbVgiB4t5lyXStuLnK8gziLMpq/B9vGGtTMinZHad8fGmuEaODk3QkAD9JK43ojGYVho/FRG60AJg9trPJIDj8lYNFmrUqzY57WEn5Tz7v/lN4HXdThshdb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIclZqWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIclZqWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682E6C4CEDC;
	Wed,  4 Dec 2024 03:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281381;
	bh=9iGuTJO/rl2OpDJ9rNe5GFvAjKqlfOGEI+Q83/4F9N8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BIclZqWD81XtGQzJrNcFuxrJXe4iI2w2+y1xTH1XsHzbeqAnQZ3au54wX3uHWPeuG
	 IIq/KGBngDoHf8gQOk5sOAnSfTopa6e+X3qaSPS/QCs2OFnwkFswN+8ZmawMvPaRFf
	 Hnir0bGORqz/FpJ71hGNeydEqttc0yKTIgP/EAp64Rb+S8hlExCMAM+KI6Sm20jkCM
	 CeV1Sk4wJKjC4GF+DEwoi1tlCcdEB46PKHm5upmQ04yXZX/lfzGxEm8hQUWSqP9S0Q
	 LY3g8sYZrmTlX135w6aRvOd7fSgJesFY9QOfBRAl/4lz06Qkodxn9yC4IucgleeMBw
	 snbgbJboTnbWQ==
Date: Tue, 03 Dec 2024 19:03:00 -0800
Subject: [PATCH 3/6] xfs: check pre-metadir fields correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173328106635.1145623.13324476061274052225.stgit@frogsfrogsfrogs>
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
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

