Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E438B47F7C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389737; cv=none; b=m0/d9ORws2xJ0id+ofmkBZ1+9DIQRuhua/M1DKsxjValfKGWfMQwSPk/hdQq+7wXWdYNHnax/wr4KRGnpoTo9wxFGk82kMA2k4/xtda5KHd2B4g57ehabqI375VpD2Km9h0mS0pd6nrBepbPS7p9dxLzTpuD7qRYe8JWoWkw0bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389737; c=relaxed/simple;
	bh=17e6SfzMbV23DeuJY6sodlN355XrJIUS7Dbs+NAi3oM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRiSZC7GG20WwmkzV6UEcQUH+pw1mPSYv2FosO/JH6w3wimI5MMNr6gZVHwa9J9GK1nyVsJwTDtEnt71lImvmcxSdC/Gx1PxxAYHYkE00PRkF6iS94VBxKmfO+AL06PIgNC32hWbtR1DV2U+njTjNydPz31OuoBFe3rAvBdBUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FipIug0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FipIug0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C93C072AA;
	Wed, 17 Apr 2024 21:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389736;
	bh=17e6SfzMbV23DeuJY6sodlN355XrJIUS7Dbs+NAi3oM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FipIug0FCZxr7MqcWRtRMLL18wlzn61opqDoruitlGQ8JtyBfashSrHaDvU7g9eAC
	 NGldqlILOBO6DJVbc0Xl/kPOzlx5rfcRMOkLnOfRJ0JiqOAmNfyO/+TEE9EpefVO27
	 2oIp2v3/olaviS2vW5HnMq3mDDIRLEcNHqEQoXIzKobqV/Arp348PZBPN1r8RaDCs1
	 mFyIptRhghMsGz2BQCUhtuC2uidvP48fPX0Fi0XHiewr4Cxx1cTl8Z1FGjj7ESzhsX
	 5zH+t79P8an89Y06PmX72fk66EEIxeX4mMRrW1vuvXif8DZm0DgHTTkqiJv7Zc6top
	 5NafcLwku70ug==
Date: Wed, 17 Apr 2024 14:35:36 -0700
Subject: [PATCH 53/67] xfs: remove XFS_RTMIN/XFS_RTMAX
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843135.1853449.14162243262449821992.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h   |    6 ------
 libxfs/xfs_rtbitmap.c |    8 ++++----
 mkfs/proto.c          |    4 ++--
 3 files changed, 6 insertions(+), 12 deletions(-)


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
index f8e00c4b5..10b929b2e 100644
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

