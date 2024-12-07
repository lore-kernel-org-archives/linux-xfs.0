Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083517FE;
	Sat,  7 Dec 2024 00:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531500; cv=none; b=eJsCuDeRwMPIgqTz8j+Ovc39yQmLGW+0dlAbk3TFrgslp1cBepP+YtnnO8LLnFk7Z73dG+xXPvruYunwmAHUwvMIvXayjgIAWw0IHGGqWF+45wAU1Q+JZZR6I+MvLCO97ovdCl5e1mCPQoIk9+ypq912iEaYCAeiVXB4ozJ6Pv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531500; c=relaxed/simple;
	bh=9IWf77lrk7H8zbrW+W0y6OObHF2pbcOytSxzgwnz0sE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ky7yC/KqG99tyonHLa4lB2+bj1+MTPRqv5dtZE7UxE78Xy+wV4fLgfU7Cp4WPffmL7Y0D7aJ0NmTaMt5Ac9IH1JvvOlfy2z8CGvNv5H9oce9i50blBB9DxR0QYb2UlxOLCFxUzTdP3c1zn42DHD1vxAxDandRPn8kNKcWBrSN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0KKqnfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0KKqnfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF924C4CED1;
	Sat,  7 Dec 2024 00:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531498;
	bh=9IWf77lrk7H8zbrW+W0y6OObHF2pbcOytSxzgwnz0sE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b0KKqnfPVjLgfovwlF0PF6M1+9LcxTPX3GNncyu9a8t21YrHdL/+37zA59DWCIRDV
	 p2l1OS5ryb3u3+h8MFh9t9tlBvIsYJ7v6ubufo3sVbZSZcUhkn6T3KtSPkYXztSiP8
	 natGg5pjFVQkvxp5awLAxLpvVWp7aqJMGtrBvUr7grPBg+Dv8Hnx0PDczqyHrd3j0P
	 8tIdThuVq3Kwy2pcb5TlxZHyJmFoRZQHZJ4hpci5riJNpeYcUK7bt1L8AX8bYr7Bj6
	 mxdYfa33wXehCVueOl9wRcl8gb1YYugC0/ytmMAjuC/TAn39DGzmzgBXK2Q6Kgqtlv
	 uTMNAenkgmSnw==
Date: Fri, 06 Dec 2024 16:31:38 -0800
Subject: [PATCH 3/6] xfs: check pre-metadir fields correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139351.192136.8465362180134347529.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
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

