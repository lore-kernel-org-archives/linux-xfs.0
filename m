Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B5FC1D;
	Wed,  4 Dec 2024 03:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281397; cv=none; b=vCRTMbsb1lxcIO9/yVIY01AnhCpxWnfzWmTNFY+NdaGIiyLMV3bb+OFVo/0H9l+XozCn4QoUKHPW3PMgLHUm6A2fFcjZm/QTeiK5sbf3REaQ3m2txEnpveDQ/FDmtpZFfb3cYpGT2bV9DSuFqGWKN9kklUNqLUDYSmH/3md1Lsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281397; c=relaxed/simple;
	bh=an7p+4u86RlIlN3+7Wcv/Bu85sUwKbDRmU/gF7pb5Qc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVloXLiQAJXjvdaN3OR/NfUWY0aRumnGwPtTdZaYEe8LpZcPJuq0sN1AesWMBFvakRFaLW0pDKYnwdehkJ+1U0vXL4+A7VRrHS+4zGADI1iFTDFn5qkWjklb8pIuaSq4R7ViTmbn5Jkzg5qyFA58SpvuzVVGPsboYp5wuQjmFqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtBwwnxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtBwwnxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07349C4CEDC;
	Wed,  4 Dec 2024 03:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281397;
	bh=an7p+4u86RlIlN3+7Wcv/Bu85sUwKbDRmU/gF7pb5Qc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TtBwwnxMC2JlrD0KYo9kLdrGWO400Gt63qh8nkQ8chKnO1s4e8XXE87Nz39AcVv+T
	 NWsBilf5olWpInXZvmwcR4t6h6pcibGeCkbgJohHJDzVhEnZl3/CWi0X49wSB/Ce23
	 LInC8QWxHwtG8p2IwGQ5Wh9pwV9yaGsLz2iI+yp4vJ3L1Jyz04+WtFvobuHjiPHL+l
	 aCQ2Wy9Nm1y60PDVl8AD2Pti7dFIg0X7KrcDPoclrWIhRHxAbT9ER7nWBM/WF4triN
	 gmVa8/AyV5y07EBrMgX76hXaEkhXKgGlFT0cjL+LN+95CzAa/SmZQ4+5xFp7qbrI+n
	 +BA47r8Z1qUCg==
Date: Tue, 03 Dec 2024 19:03:16 -0800
Subject: [PATCH 4/6] xfs: fix zero byte checking in the superblock scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173328106652.1145623.7325198732846866757.stgit@frogsfrogsfrogs>
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

The logic to check that the region past the end of the superblock is all
zeroes is wrong -- we don't want to check only the bytes past the end of
the maximally sized ondisk superblock structure as currently defined in
xfs_format.h; we want to check the bytes beyond the end of the ondisk as
defined by the feature bits.

Port the superblock size logic from xfs_repair and then put it to use in
xfs_scrub.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 21fb4cb1981ef7 ("xfs: scrub the secondary superblocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 88063d67cb5fd4..190d56f8134463 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -59,6 +59,27 @@ xchk_superblock_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/* Calculate the ondisk superblock size in bytes */
+STATIC size_t
+xchk_superblock_ondisk_size(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_metadir(mp))
+		return offsetofend(struct xfs_dsb, sb_pad);
+	if (xfs_has_metauuid(mp))
+		return offsetofend(struct xfs_dsb, sb_meta_uuid);
+	if (xfs_has_crc(mp))
+		return offsetofend(struct xfs_dsb, sb_lsn);
+	if (xfs_sb_version_hasmorebits(&mp->m_sb))
+		return offsetofend(struct xfs_dsb, sb_bad_features2);
+	if (xfs_has_logv2(mp))
+		return offsetofend(struct xfs_dsb, sb_logsunit);
+	if (xfs_has_sector(mp))
+		return offsetofend(struct xfs_dsb, sb_logsectsize);
+	/* only support dirv2 or more recent */
+	return offsetofend(struct xfs_dsb, sb_dirblklog);
+}
+
 /*
  * Scrub the filesystem superblock.
  *
@@ -75,6 +96,7 @@ xchk_superblock(
 	struct xfs_buf		*bp;
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
+	size_t			sblen;
 	xfs_agnumber_t		agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
@@ -388,8 +410,8 @@ xchk_superblock(
 	}
 
 	/* Everything else must be zero. */
-	if (memchr_inv(sb + 1, 0,
-			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
+	sblen = xchk_superblock_ondisk_size(mp);
+	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
 	xchk_superblock_xref(sc, bp);

