Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C9115381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803968; cv=none; b=vGNXXuU5ZUT9VX3AWr4bOmmdSd6J7NSKocRQYU6SBUpzMb5yfGK9POq4uMr7bNjgGTbrg+nP6cojzTO6sxfHxqiEWUdmELQUkFvZD8UVrUSiks011sEpQb6Q6M54QOgfOmidkVgAUmbgJQgALWwRsyh/+cHImDGPts0jsOzzD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803968; c=relaxed/simple;
	bh=SsbkW/nDB4LrmXy4NJ3a7+CVTLKra3ZgHu7AjUdXaB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK1EZ/NJvoy1WMaUBSS9pRB9tOkOjJJo59+eQ3KQ7MxS8NtuZC6nZV2L+1gDPldEih4dNxaCP8ZUqrELj0srtRqgt1P5rO1K41QLFBCqr2Q6pmaeEMn5GqAeF4JPmLMIzDB6HrU9i2asJUdl4wKf2AZgjmRhzzDXFNWr0VBwKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8ptaThz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8ptaThz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D034BC32781;
	Mon, 22 Apr 2024 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803967;
	bh=SsbkW/nDB4LrmXy4NJ3a7+CVTLKra3ZgHu7AjUdXaB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8ptaThzaphTjMbJvDMxL5N9s3GiMPRqDmlrm+vOZfz9iGgJJDo5FfoBtFuqu+1x8
	 MIVMQQb4CqHxZQHbzUNWuf3D2IFB5LtUPNlT6nby+IkoGhv2vz2nRAlcXYQqJ8c3Zl
	 RsdVvaOO2dB9pjzEWVDrkOsAtDLLTlSe4J81ptjkRGEUFO5hzVcHyS8zJ+PoTgooe6
	 kcS5zp1u9TvC5othPpAqKiy3xWcAXGw37j3oAiTA0pa+HBS+xnH7xmWx6g+EwAJ2LS
	 X2bq01oCrTiUJ209OK/u5NuAR9cQT42RvV2Sq3EOkfEH/oSC5mItOGuRlvci0mjcFX
	 KLdNWili1Fn/Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 13/67] xfs: don't allow overly small or large realtime volumes
Date: Mon, 22 Apr 2024 18:25:35 +0200
Message-ID: <20240422163832.858420-15-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e14293803f4e84eb23a417b462b56251033b5a66

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.h | 13 +++++++++++++
 libxfs/xfs_sb.c       |  3 ++-
 mkfs/xfs_mkfs.c       |  6 ++++++
 repair/sb.c           |  3 +++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 6e5bae324..1c84b52de 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -353,6 +353,18 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -372,6 +384,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_compute_rextslog(rtx)			(0)
+# define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 95a29bf1f..7a72d5a17 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -507,7 +507,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e48624bbd..d19f2a2fb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3025,6 +3025,12 @@ reported by the device (%u).\n"),
 	}
 
 	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+	if (cfg->rtextents == 0) {
+		fprintf(stderr,
+_("cannot have a rt subvolume with zero extents\n"));
+		usage();
+	}
+
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
 						NBBY * cfg->blocksize);
 }
diff --git a/repair/sb.c b/repair/sb.c
index 384840db1..a26fc149f 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -475,6 +475,9 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_rblocks / sb->sb_rextsize != sb->sb_rextents)
 			return(XR_BAD_RT_GEO_DATA);
 
+		if (sb->sb_rextents == 0)
+			return(XR_BAD_RT_GEO_DATA);
+
 		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 
-- 
2.44.0

