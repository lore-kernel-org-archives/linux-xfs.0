Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C271514CA
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804028; cv=none; b=QSZElBvxlEYrSu3cP6H7Plbmk4uEOZmqVnyRKUvuITddM3t0aCgKp+hxzTlnws2v8iNxHqsQrlcLupvxe/bAe1ejaYJ5yVGfyFoAYtPJ6eNKoGxYIq36mLtGH01YnuQdBw+JqxH1mqvFTAAghkTayEWWM0+ABwRWIEFh6rpreYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804028; c=relaxed/simple;
	bh=vVDmQmPSVw2PG6AWXYnniLPSDpzqhEraqZL2YmoLUWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX8XZ5pEG5E+DZFQkJKmJD9yhCJLdiSBCQcXaLQtHoaBV6uBAgJMOtHME4U88ehce/TBQ+JQ1c58iFoUmxxFNx1GT6GS26ur5rZvPATmT6jAYXt+1a7IS0J4ORPYaY6RtYywUeJAYV1nacMdl5PykGzF2z49LE5vJB5/sewg2Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQRWxV7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQRWxV7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4306DC113CC;
	Mon, 22 Apr 2024 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804028;
	bh=vVDmQmPSVw2PG6AWXYnniLPSDpzqhEraqZL2YmoLUWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQRWxV7E4mBkrHxW09lkxVgSZZgv19+glCyRJWuqWomi48RN/SxIZEhqiIYDQbhvT
	 jk/CS3vd6RgrVJLsGI7JctBGzrkIAbH9Q+9pTOI2zAbFZKRVnjFfcSzXgAo87xuhDy
	 WgJv/3X4RU/78NrZa6elX7byV92fZ7dJb9DHvEb/FGUzjWFtaamLji2hqmeAaSSPd5
	 Ica5cGY2OZ+tPGZ4HNjpZLdorPO/W1UvxKOBlwIWP1OWmoBJ91rU554fxVuhJahnHo
	 zavJ+HOy0vBFmGKRwJdrI7zwoVCOlRqZm28y+rf1Mhvn320ufRKxdOoiCutvj+aMn/
	 SfCIJ0+Sz5BRg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 53/67] xfs: remove XFS_RTMIN/XFS_RTMAX
Date: Mon, 22 Apr 2024 18:26:15 +0200
Message-ID: <20240422163832.858420-55-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a39f5ccc30d5a00b7e6d921aa387ad17d1e6d168

Use the kernel min/max helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   | 6 ------
 libxfs/xfs_rtbitmap.c | 8 ++++----
 mkfs/proto.c          | 3 +--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7d2873a79..382ab1e71 100644
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
index eefc45c64..79af7cda3 100644
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
index e9c633ed3..ec28728d4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -780,8 +780,7 @@ rtinit(
 		if (i)
 			res_failed(i);
 		libxfs_trans_ijoin(tp, rbmip, 0);
-		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
-			bno + NBBY * mp->m_sb.sb_blocksize);
+		ebno = min(mp->m_sb.sb_rextents, bno + NBBY * mp->m_sb.sb_blocksize);
 		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
 		if (error) {
 			fail(_("Error initializing the realtime space"),
-- 
2.44.0

