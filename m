Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03761D172A
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846497; cv=none; b=BTZamM/J8MGbTx6UB6XXREsoZY14MAjmQI1Q8zTinv57O5V91I24fSF+bUVMykqZfjdW27oyAwCe4Wu9HB+GvsLKdqOSzZqlDImN6ofWUr6nN1Z9nWwbHX8GPhk3TtMd45a2Jt4SekYaM4senFRIW1hmrYwSD8ezoMwV4lr7PpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846497; c=relaxed/simple;
	bh=zgHGnTpLBnOuvxD5VvyzvhO+reRxOFKI9udb4kZVTwM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPFN7SUnzo056wqcIuGEIvopzHMGbSnUikpo4aWrSTljkwkmWF0sBDQ0Q7KMF18mMoA4xhuHJ0+9N73IFWRfPcsKHyfBK7z5WU2RtPHatl4dIdO8dV/2i8Hb7q5o0gAvpvwZh1hA95NiL6k08t8Q3esSk+jcbcDqs/wlrmSLbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtrHZ0+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtrHZ0+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497F5C4CECF;
	Tue,  5 Nov 2024 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846497;
	bh=zgHGnTpLBnOuvxD5VvyzvhO+reRxOFKI9udb4kZVTwM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PtrHZ0+QYd64ThtYf0sYntSau6DfLx5iBimsCW8RGEbjDI/RlhUO6hBQuzCZVmTE3
	 Rd0RaUziRWUaiD6+qZtK4xm+Ntfp4Cdyy1jCy5YGTs9VlAHheO8CGpDMdTaMRAKtwK
	 dpivxvv/8YsnmYe/q/AKUoaJzkwRWa3AUZflJuwN4KR/pcHecQVbOAtoElUwgAGwHT
	 kErQY4FMnNujW6rcFjkXp9pbNtdg0jNxJCsC9K0Zp/RbSMh02hDuXEHoZqfCXsS5SM
	 qIEqdPTjsIOtjfjR7MZrvCmyDstnG3nvpV2tf3BH9U7NqdmzwscIanyh/BpkEIw0fG
	 2YSdwZYFvkW9w==
Date: Tue, 05 Nov 2024 14:41:36 -0800
Subject: [PATCH 1/2] xfs: update sb field checks when metadir is turned on
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084400030.1873485.16503742350279644656.stgit@frogsfrogsfrogs>
In-Reply-To: <173084400008.1873485.5807628318264601379.stgit@frogsfrogsfrogs>
References: <173084400008.1873485.5807628318264601379.stgit@frogsfrogsfrogs>
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

