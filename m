Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D021208A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537449; cv=none; b=sfFdTU0Zkn0R5He4x1OOZRBWI23lN+fjasaSu8m2usy0k6+5FX3XEEEjBD0FvAeKDzwyyToxrAhCfF7tvrAI3dZauqBnveplhukWo9U6XvEsTOTFHwm34N3xzWMPXikL3X4CpOYWTEo6YRRKOs/d87jH/E8os0YLo6J61O+1LGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537449; c=relaxed/simple;
	bh=IGUorogw4jnqEfQQqCrlB8QHhAzST7NY0uWKR3Pgwe8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0xqy4fwWGSkRnROkPJa9sNMeWEfWWrRi3z+zTFLRFcF0zvf46jyGzVQxfKyMoQYnu5HPOQVZTZcyIGnZVY2kp9Qm0nXwqPPkqtaN3j/t607FcnhxSa7zyAsbnXVdt4wIkycsWd0MqRk6zl1/EumMneSTXIfO2HMBFh7UkcKTog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EZKp2cbm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZKp2cbm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hbvGUb7BnnypZWAUN4ZQdrwo3DShIj0+IHSeRkEHc0k=; b=EZKp2cbmCpM4ZvnFSlzfFKYILC
	G2xI5scouTi+gr1pOWiwZ1KOhAlUjZJOz0w7/ISLvmHrNYodJ3UWt4marokBNI6zurAYkyLbp9Exe
	6hkfF1rgmkBHUHGLZSTO3McnbWNGSDAT0m2igRTTja/GLmcl1IUAKWwCEfxhPuPCRHOReGS7PoCwu
	vAhm6rgTNSQaZKp8/yU+G9TE+uX09j92HhD8xT+z0WtaxPx4BOyuIqtUpF6/k20McV1hZ+AC3ohDX
	324QRtc2ct6RIbLyNQ7YKq9MbQKojUl5mthULkNgJkmJi9FbEVByYoYLCknBd7coWdp/2nsBzvJRT
	8oTj673A==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4g-00000008Wmo-35OW;
	Wed, 27 Mar 2024 11:04:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] xfs: rework splitting of indirect block reservations
Date: Wed, 27 Mar 2024 12:03:16 +0100
Message-Id: <20240327110318.2776850-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the check if we have enough indirect blocks and the stealing of
the deleted extent blocks out of xfs_bmap_split_indlen and into the
caller to prepare for handling delayed allocation of RT extents that
can't easily be stolen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 131d4f063b660a..9d0b7caa9a036c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4829,31 +4829,17 @@ xfs_bmapi_remap(
  * ores == 1). The number of stolen blocks is returned. The availability and
  * subsequent accounting of stolen blocks is the responsibility of the caller.
  */
-static xfs_filblks_t
+static void
 xfs_bmap_split_indlen(
 	xfs_filblks_t			ores,		/* original res. */
 	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
-	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
-	xfs_filblks_t			avail)		/* stealable blocks */
+	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
 {
 	xfs_filblks_t			len1 = *indlen1;
 	xfs_filblks_t			len2 = *indlen2;
 	xfs_filblks_t			nres = len1 + len2; /* new total res. */
-	xfs_filblks_t			stolen = 0;
 	xfs_filblks_t			resfactor;
 
-	/*
-	 * Steal as many blocks as we can to try and satisfy the worst case
-	 * indlen for both new extents.
-	 */
-	if (ores < nres && avail)
-		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
-	ores += stolen;
-
-	 /* nothing else to do if we've satisfied the new reservation */
-	if (ores >= nres)
-		return stolen;
-
 	/*
 	 * We can't meet the total required reservation for the two extents.
 	 * Calculate the percent of the overall shortage between both extents
@@ -4898,8 +4884,6 @@ xfs_bmap_split_indlen(
 
 	*indlen1 = len1;
 	*indlen2 = len2;
-
-	return stolen;
 }
 
 int
@@ -4915,7 +4899,7 @@ xfs_bmap_del_extent_delay(
 	struct xfs_bmbt_irec	new;
 	int64_t			da_old, da_new, da_diff = 0;
 	xfs_fileoff_t		del_endoff, got_endoff;
-	xfs_filblks_t		got_indlen, new_indlen, stolen;
+	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	uint64_t		fdblocks;
 	int			error = 0;
@@ -4994,8 +4978,19 @@ xfs_bmap_del_extent_delay(
 		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
 
 		WARN_ON_ONCE(!got_indlen || !new_indlen);
-		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
-						       del->br_blockcount);
+		/*
+		 * Steal as many blocks as we can to try and satisfy the worst
+		 * case indlen for both new extents.
+		 */
+		da_new = got_indlen + new_indlen;
+		if (da_new > da_old) {
+			stolen = XFS_FILBLKS_MIN(da_new - da_old,
+						 del->br_blockcount);
+			da_old += stolen;
+		}
+		if (da_new > da_old)
+			xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen);
+		da_new = got_indlen + new_indlen;
 
 		got->br_startblock = nullstartblock((int)got_indlen);
 
@@ -5007,7 +5002,6 @@ xfs_bmap_del_extent_delay(
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, &new, state);
 
-		da_new = got_indlen + new_indlen - stolen;
 		del->br_blockcount -= stolen;
 		break;
 	}
-- 
2.39.2

