Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7E71A9FA7
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675344; cv=none; b=U/WlTXOBQ5s1fREm07Zp0/SFIYMsBtFUnqmB1ZyR/bZJQCD+ip1UpYjbIIFt3m8nRfXFkQ94QmOe4Ge/dzc464ayWVcewCK4XcZ9XE/vV2GAjmNCPmJcT3zit9tPjBQ3nXmkuTdD70E7J/Lx+R0rld8s8poxKOp0Uz2vx5knaqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675344; c=relaxed/simple;
	bh=97VYcBKiCNoNLavm1s3dlEbKrkaU7hvG4dFiyjWG3C8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mf5UqimnfBCTFQTXBYQicMbsuIvByIFkhUl44WHCy/gGlEcE8DQfZJholNEnKQIsZ9e3nz7ds0Wk9ZnU6Oy3CzgXzkm38zg5RTu2MnnKgk7AmqAtDrapgmSKY0RzcTBoxJ6CBozLhQJ58bigK1IepVCtJq61jzRgXZFe43PSqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dKzvRlgg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dKzvRlgg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JZIl7q25QtYHlAoo+Mo85ZTi9wM5RBmAa0n3fMO2vIc=; b=dKzvRlggpO5lWazAT+iulKVf2C
	nonbe5+aQG4/2i+mGFFkF+eoYUCDiuciWCm/pjRESEsTldDZ6zpwf3/rwFn0daAcerfvrdRWm26ra
	rd+Z77L9FKZb6FBpdpwE9uwzOK3nLVLnfYF3MUvPJnKalFG/dDIMkkXUXrOhbg3qJqo12GRoiiHTL
	n62L2CUeAu/tqjyoSnGaiSyUnM2v/m6lPtSsnYUb53KCDm1Tw3fUsBsU+3ocZYxLtaxOrrtQZjsSv
	bu7rhosQge4fdlvrUdRqCKtaYf6ezzouZ6JDLPDnAmrXgOonDYxUBfTXUN6p6g/Fdcyfhcn8rmvXz
	YDHyka1A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w29yl-00000004LbB-0EMk;
	Mon, 16 Mar 2026 15:35:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA
Date: Mon, 16 Mar 2026 16:35:29 +0100
Message-ID: <20260316153533.1580167-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The newly added XFS_IOC_VERIFY_MEDIA is a bit unusual in how it handles
buftarg fields.  Update it to be more in line with other XFS code:

 - use btp->bt_dev instead of btp->bt_bdev->bd_dev to retrieve the device
   number for tracing
 - use btp->bt_logical_sectorsize instead of
   bdev_logical_block_size(btp->bt_bdev) to retrieve the logical sector
   size
 - compare the buftarg and not the bdev to see if there is a separate
   log buftarg

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 8bbd4ec567f8..5ead3976d511 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -183,10 +183,9 @@ xfs_verify_iosize(
 			min_not_zero(SZ_1M, me->me_max_io_size);
 
 	BUILD_BUG_ON(BBSHIFT != SECTOR_SHIFT);
-	ASSERT(BBTOB(bbcount) >= bdev_logical_block_size(btp->bt_bdev));
+	ASSERT(BBTOB(bbcount) >= btp->bt_logical_sectorsize);
 
-	return clamp(iosize, bdev_logical_block_size(btp->bt_bdev),
-			BBTOB(bbcount));
+	return clamp(iosize, btp->bt_logical_sectorsize, BBTOB(bbcount));
 }
 
 /* Allocate as much memory as we can get for verification buffer. */
@@ -218,8 +217,8 @@ xfs_verify_media_error(
 	unsigned int		bio_bbcount,
 	blk_status_t		bio_status)
 {
-	trace_xfs_verify_media_error(mp, me, btp->bt_bdev->bd_dev, daddr,
-			bio_bbcount, bio_status);
+	trace_xfs_verify_media_error(mp, me, btp->bt_dev, daddr, bio_bbcount,
+			bio_status);
 
 	/*
 	 * Pass any error, I/O or otherwise, up to the caller if we didn't
@@ -280,7 +279,7 @@ xfs_verify_media(
 		btp = mp->m_ddev_targp;
 		break;
 	case XFS_DEV_LOG:
-		if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		if (mp->m_logdev_targp != mp->m_ddev_targp)
 			btp = mp->m_logdev_targp;
 		break;
 	case XFS_DEV_RT:
@@ -299,7 +298,7 @@ xfs_verify_media(
 
 	/* start and end have to be aligned to the lba size */
 	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
-			bdev_logical_block_size(btp->bt_bdev)))
+			btp->bt_logical_sectorsize))
 		return -EINVAL;
 
 	/*
@@ -331,8 +330,7 @@ xfs_verify_media(
 	if (!folio)
 		return -ENOMEM;
 
-	trace_xfs_verify_media(mp, me, btp->bt_bdev->bd_dev, daddr, bbcount,
-			folio);
+	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
 
 	bio = bio_alloc(btp->bt_bdev, 1, REQ_OP_READ, GFP_KERNEL);
 	if (!bio) {
@@ -400,7 +398,7 @@ xfs_verify_media(
 	 * an operational error.
 	 */
 	me->me_start_daddr = daddr;
-	trace_xfs_verify_media_end(mp, me, btp->bt_bdev->bd_dev);
+	trace_xfs_verify_media_end(mp, me, btp->bt_dev);
 	return 0;
 }
 
-- 
2.47.3

