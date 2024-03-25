Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7A7156665
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333489; cv=none; b=HAL2JTIphhqIQ+P3rBJBHlgufzDdV47iBpLGvWqyiZmV+0A4k895uqyWy0kdlsIcfdoVMFqA1sM9J23M3WLyvnhrR91qxMwtQQVgfi3YbEGpCuYK6YyfrwtBN1YJ/yneDZQg4UqvGhqtydcvml9e3ebxaW5nNOCaw/XQMfXrjFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333489; c=relaxed/simple;
	bh=TTBpS8n3mWnsY/pvLjvSIH/x+lLXcddJRkdW7UzCwd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rIMy3VCwHRqgLgwzIPk6q4IwEAhlbWeRU8QoLidwMDUaTHgLOu1TisktRTzeoa6QmpOubh3yovQABHVkp38G1gouG1y7Cfq2xO+NsL5X5G7mfLEfMxM2NAD9OcxT1K7VJyy0dWyy8ztxppQn0BxT/HsLAs7fKt6NCE/PK0Hph/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jQwdeklM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jQwdeklM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HvdJbqPsaSxcRTVJxIVtN/yLuEdGQxgOf20X/HGyXMk=; b=jQwdeklMKo5LQ1GBMTRVrpXUXV
	lL7XIVsVCWIfL0jGSx1Y8onFZxBURx7YhX9a0Yp2Y6nKpF7lQUFbz0lMf/k2PVPsKsKjM0V0Fka0R
	IEaQ+zTnG0QhvpPhRU6lZPWXhfQNW+J3rkl2A54gC1h0LMZviKuX6seXN2xAhX8q2pmIvQ4ROje33
	9E5IKY+FXfd8kVhQKQhQz+SI+R4PT87CoOEw36Vb/Dvv4YyUQcG88MJ5BgKCJk0EEd1ntmy5mu1SK
	yS26yOC6GLOCvo52FZvhNDbXB4KXy6cMAucqRpawEbOknhKvcJs8kfIsZ+EbaSm3XEMQoYuKMF4Gp
	BJiby1bQ==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa11-0000000EeYB-1Wbj;
	Mon, 25 Mar 2024 02:24:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/11] xfs: rework splitting of indirect block reservations
Date: Mon, 25 Mar 2024 10:24:09 +0800
Message-Id: <20240325022411.2045794-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
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
index cc250c33890bac..dda25a21100836 100644
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
+						 new.br_blockcount);
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

