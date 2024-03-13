Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DE179C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295611; cv=none; b=gAzeb47HA7xSKOiMXEXGO6Aqp8o4bU1jsOXfbAHyfYHcPFlMgntb2hEaqZPiqaaWFLcOFDvyIGM0aTPSlqFhOAZoLUGmv6xhQrKIT8hdfiYBZVGied1Awe5LNwFSmHmKCZmoAfbQ9bAy43JqQlDpiZHyVlphjQOr1RH2e5eIqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295611; c=relaxed/simple;
	bh=B2EbIgeRtSa5Y2GXh7GeFxWa27tQ3HgCzCNnvz5+UEg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccr4/V86PTxBlWUNoXaDZS7+aEhLFFJz2Zf/0bAV2Sc54WBMkcOvgueceedR/vho6g4FcJVrecovq+oZfbv50XEkyQKeZGsdsORtEpAn4qWW2Gq2H7f8bqHAEkiOvFrB8yX6guGR89FUjint9kIbazfzd2HmhjjCcv/nkljv17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7Hpgb0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7Hpgb0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8166FC433C7;
	Wed, 13 Mar 2024 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295611;
	bh=B2EbIgeRtSa5Y2GXh7GeFxWa27tQ3HgCzCNnvz5+UEg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o7Hpgb0Jq6IR1FmIOdP4tR/b+ZH59ye9qp9p+R0eIrWkcuC48Q2eWDRI4QTt9nIVy
	 P4ZnozvyMb7eGcicG6eSuwJYP6hdJWFA1NlheTH9Ei7W6LwW3Sil6t6QLygY1HRD4F
	 ZWviAxD5cpU6FvPzUCiW8Nsr5zJbMLm7O7dRxK8jg8Gr9pzt0qxz2iZK5UXTrXUCvj
	 8IcfAP0NAccg98hMntr4SzUs/xNgOcpObdBHEKd3l4giRgxf2gDhPdLM1dLz+i4MQr
	 U1OIGELYqz1tflgflInr8AqR/AZuK9WL6+zuAc1IFyXMiE6l+1AyiERCbGCZq829It
	 PWINN1Y/WDk6Q==
Date: Tue, 12 Mar 2024 19:06:51 -0700
Subject: [PATCH 53/67] xfs: remove XFS_RTMIN/XFS_RTMAX
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431958.2061787.12672887305529191027.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a39f5ccc30d5a00b7e6d921aa387ad17d1e6d168

Use the kernel min/max helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_format.h   |    6 ------
 libxfs/xfs_rtbitmap.c |    8 ++++----
 mkfs/proto.c          |    4 ++--
 3 files changed, 6 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7d2873a79a48..382ab1e71c0b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1156,12 +1156,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-/*
- * RT bit manipulation macros.
- */
-#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
-#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index eefc45c64e20..79af7cda3441 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -182,7 +182,7 @@ xfs_rtfind_back(
 		 * Calculate first (leftmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
+		firstbit = max_t(xfs_srtblock_t, bit - len + 1, 0);
 		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
 			firstbit;
 		/*
@@ -336,7 +336,7 @@ xfs_rtfind_forw(
 		 * Calculate last (rightmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Calculate the difference between the value there
@@ -571,7 +571,7 @@ xfs_rtmodify_range(
 		/*
 		 * Compute first bit not changed and mask of relevant bits.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Set/clear the active bits.
@@ -785,7 +785,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute first bit not examined.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		/*
 		 * Mask of relevant bits.
 		 */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f8e00c4b56f0..10b929b2ec37 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -793,8 +793,8 @@ rtfreesp_init(
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
-		ertx = XFS_RTMIN(mp->m_sb.sb_rextents,
-			rtx + NBBY * mp->m_sb.sb_blocksize);
+		ertx = min(mp->m_sb.sb_rextents,
+			   rtx + NBBY * mp->m_sb.sb_blocksize);
 
 		error = -libxfs_rtfree_extent(tp, rtx,
 				(xfs_rtxlen_t)(ertx - rtx));

