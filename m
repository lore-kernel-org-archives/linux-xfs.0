Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356241D0E04
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031409; cv=none; b=qxdzIL2NoRXxmf5QSFz8VVRu1eoXpqmhAHITTODSG/MgddwkNVU80QHw9wq4CUR5b8KoqBz+cNlhVCiBSUughVfd0aVfbEO+QhV2dJCUbeBEdpBwpGEcywhRjXUHtIDz6JjvO49TAtjjoSAr2hwLOA+mW2g9lT0M0LICctWrWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031409; c=relaxed/simple;
	bh=Q/WHEL2oJLmBArAAUI/3G3u+ZcSgkwpDup1blMdSIlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EABfSMbASS31+WoNZ/Sp5BiuLOqTfLZ2PkKrjw7q5IMbCd+6Tf4GvW4Gur3F6a/pg/8AcAU3gITddZk3+gS3KZYpZu1jLky8767ywoi/H1AboxtITSFMJeySgAesXh0d7L65BbC1z3Fd2hBIP6wdCO7ccZV8kaoceMDF23QIOZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MWqtcUL1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MWqtcUL1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1uWR0Qw/8RQ9NwHC20OrFX8/rYKnMn+gJupvi34fJtQ=; b=MWqtcUL1hknbB0hY+AGIEZPUe5
	KN2yTl7vrRI6kGfAiUJkpD1elFpFWIBlEBSg6GYt5+YGxWExnUgUSuhZWCmEDoD3DpkM+Ij1W5ols
	vCrQYGJEQT8Wes50yBI+cERKIyeNWQMwGXs1bRDOixFCyrlWd7wi9E68AXjpCMdND+FOALTnaOaaN
	KZvCf4WYgCSR51lOkbl0yVgt+1l+aa1CCVJD7L+exRf0Kmks6V/6CeWAzRFZUWedEXEooC13mlVcm
	CwWUWg8BRW6MZfxUy6pNYiKf7qVnZY2rCMCKLxXiU4+fzaRfdP3VHJfSnrWWyhb7zoeB77h5I/Esp
	cc7BQrHg==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDQUQ-0000000CvdJ-1yqE;
	Tue, 19 Nov 2024 15:50:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: factor out a xfs_rt_check_size helper
Date: Tue, 19 Nov 2024 16:49:47 +0100
Message-ID: <20241119154959.1302744-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119154959.1302744-1-hch@lst.de>
References: <20241119154959.1302744-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to check that the last block of a RT device is readable
to share the code between mount and growfs.  This also adds the mount
time overflow check to growfs and improves the error messages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0cb534d71119..90f4fdd47087 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1225,6 +1225,34 @@ xfs_grow_last_rtg(
 			mp->m_sb.sb_rgextents;
 }
 
+/*
+ * Read in the last block of the RT device to make sure it is accessible.
+ */
+static int
+xfs_rt_check_size(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		last_block)
+{
+	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
+		xfs_warn(mp, "RT device size overflow: %llu != %llu",
+			XFS_BB_TO_FSB(mp, daddr), last_block);
+		return -EFBIG;
+	}
+
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp, daddr,
+			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		xfs_warn(mp, "cannot read last RT device block (%lld)",
+				last_block);
+	else
+		xfs_buf_relse(bp);
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1236,7 +1264,6 @@ xfs_growfs_rt(
 	xfs_rgnumber_t		old_rgcount = mp->m_sb.sb_rgcount;
 	xfs_rgnumber_t		new_rgcount = 1;
 	xfs_rgnumber_t		rgno;
-	struct xfs_buf		*bp;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
 
@@ -1273,15 +1300,10 @@ xfs_growfs_rt(
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
 	if (error)
 		goto out_unlock;
-	/*
-	 * Read in the last block of the device, make sure it exists.
-	 */
-	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, in->newblocks - 1),
-				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+
+	error = xfs_rt_check_size(mp, in->newblocks - 1);
 	if (error)
 		goto out_unlock;
-	xfs_buf_relse(bp);
 
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
@@ -1408,10 +1430,6 @@ int				/* error */
 xfs_rtmount_init(
 	struct xfs_mount	*mp)	/* file system mount structure */
 {
-	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
-	xfs_daddr_t		d;	/* address of last block of subvolume */
-	int			error;
-
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 	if (mp->m_rtdev_targp == NULL) {
@@ -1422,25 +1440,7 @@ xfs_rtmount_init(
 
 	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, &mp->m_rsumlevels);
 
-	/*
-	 * Check that the realtime section is an ok size.
-	 */
-	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
-		xfs_warn(mp, "realtime mount -- %llu != %llu",
-			(unsigned long long) XFS_BB_TO_FSB(mp, d),
-			(unsigned long long) mp->m_sb.sb_rblocks);
-		return -EFBIG;
-	}
-	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
-					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
-	if (error) {
-		xfs_warn(mp, "realtime device size check failed");
-		return error;
-	}
-	xfs_buf_relse(bp);
-	return 0;
+	return xfs_rt_check_size(mp, mp->m_sb.sb_rblocks - 1);
 }
 
 static int
-- 
2.45.2

