Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F6DDA9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609235; cv=none; b=gnfLIMfflLuA/I6UlFTUAEQUnA3PPvMryPaF47Bde3nDfUMaL/FSsjXZsBJOo2ewXNW48Zit8mntXlSlOKqNXbiErHSl+krRsTZO/Eo2cS9qHdV881q1WO4tS0oDctOwYh+8Zi6zHNE0FwRQFBkFMmVEQu48u8JdaJR6jxRsiLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609235; c=relaxed/simple;
	bh=KlrnvFeIQCpo8xVlrKxfKj+UeyKsLOvJqqqShS4Jb+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2BpGS39+EWRT104RdjKDxh6OYj7Yte7e2CSNSX/Z6M92PpDJ9KORU6CHyhtC6Cu17Wp4eV39BMY5Jshying5FGoc1xYg9M6d+oGj9amFOAHdLgwpXzgZ1v34CoVWxLARjmlH8NexDaEpoU2jDuSfCpcPOltb6lXTGV4AY+8eKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHP5FTu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHP5FTu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF23C4CEC5;
	Fri, 11 Oct 2024 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609235;
	bh=KlrnvFeIQCpo8xVlrKxfKj+UeyKsLOvJqqqShS4Jb+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LHP5FTu8/pzhYwkTIxGplvMrh1HnrMEm7sGcRfKBd88dtz443eQnYMklnwvQWBwoZ
	 Rh+OEEbPlATarEhf2xtsfmo6jl0g2JsqduIOEw1AcESaWT98vIeB+aO6PU9HPW17/y
	 Vq2ysBEpUJjg9Od2ZOXifVcCxHZN5vN81Ue3qZcRGPw33zr2vMzay6Hwk80AAusovv
	 Y0zl6r48GetjLEBalrETfp4Vd4/+3nwQZGXGpVS9vs9DfLQ49aF9S/cpuyLDyxqbVp
	 HLhwTw9BWRDkeDUwSgW1HFFjIGeUGEnHLZuZSBy50C2q4XHRSOJMOcHxpNC9qYMyCn
	 jv5mijFazMA1g==
Date: Thu, 10 Oct 2024 18:13:54 -0700
Subject: [PATCH 1/2] xfs: update sb field checks when metadir is turned on
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860646151.4180365.15428671911280201642.stgit@frogsfrogsfrogs>
In-Reply-To: <172860646128.4180365.15337586086476354855.stgit@frogsfrogsfrogs>
References: <172860646128.4180365.15337586086476354855.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e6df4bd9792112..0fc5bd7b378cae 100644
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

