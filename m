Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD3146588
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784865; cv=none; b=Hys6TGlsx6lvfHk7R7xyCp3FDG7so+yUEfGbAbVgXY9D4UlKqfkDwasoGdAufEubAigTf3+v9pRFDS/Ya3X1QV3lD0fVyCsR88H4lSs1UQJSG5RoM6hW2apQYXRcVsq3cuVJyySCbx67Sdxd0DTGI+Z/h9310ix0tOyqh3G4LXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784865; c=relaxed/simple;
	bh=wwwJuRKqfxMI0ImPjAY5UAlsI9kZHdiuvszstcNKpAc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AGPg2cCnhvfAedZ/Ws5Mb+O4s1GILuifWon/X4ICU2vX1IXbg3S6590RDNvo63pxL2TO9Q3BEXNZwYwQPkdzYuctPVWo5Dzd8EdsI1Yv7Tk/ckYnqD4T4NhQ03iUhi/gHVQMY6DRGATKcU5TM7LN4xgvZ/+uvVAijQ/6Ram61Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m+l9OvuN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+l9OvuN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oj7nP/cHrdmd1yMZ7/6ZhS6u4YuXyVwhfYIRXH2vtdw=; b=m+l9OvuNDghprgrCb1kwne62Lk
	YFvUCO41Ersz/Ehf0C6UE80cB2LNkZ2aRIR2O8Wx/UQOjpyVsTiNeTPm17m8wMQoqqbcBDHfb1OyN
	mKeoI2eLppeTkur7oeiAGE8ao6qOSzoSPHEvVjhvOh8KAf5/wWtarkvDAqiLnYaITgD6C6Ik9F6sh
	+A7DyzDgfwwF1rCWP5wBOcJcOPFVTcCiBS/v37wnjsyi+8HkVLSw4DCFSYnwdma0WwF1sOs2LysMF
	wyMs2+L+86+aWErmYSDMyJQpxWE8/9fau9YmrJ8pGSYNGewbh4LKOo9oDKbv0Ja2DuBcRb6o5Sn5I
	F096hrfg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjK-0000000DLOo-3Oce;
	Mon, 22 Apr 2024 11:21:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 11/13] xfs: rework splitting of indirect block reservations
Date: Mon, 22 Apr 2024 13:20:17 +0200
Message-Id: <20240422112019.212467-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a2b715450ec23e..fe33254ca39074 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4831,31 +4831,17 @@ xfs_bmapi_remap(
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
@@ -4900,8 +4886,6 @@ xfs_bmap_split_indlen(
 
 	*indlen1 = len1;
 	*indlen2 = len2;
-
-	return stolen;
 }
 
 int
@@ -4917,7 +4901,7 @@ xfs_bmap_del_extent_delay(
 	struct xfs_bmbt_irec	new;
 	int64_t			da_old, da_new, da_diff = 0;
 	xfs_fileoff_t		del_endoff, got_endoff;
-	xfs_filblks_t		got_indlen, new_indlen, stolen;
+	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	uint64_t		fdblocks;
 	int			error = 0;
@@ -4996,8 +4980,19 @@ xfs_bmap_del_extent_delay(
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
 
@@ -5009,7 +5004,6 @@ xfs_bmap_del_extent_delay(
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, &new, state);
 
-		da_new = got_indlen + new_indlen - stolen;
 		del->br_blockcount -= stolen;
 		break;
 	}
-- 
2.39.2

