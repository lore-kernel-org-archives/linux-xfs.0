Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8676E2D12F5
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157572; cv=none; b=o5C0DDZS8OMqB/OTOSI4Op+igE7yXKrFXs7x69AkXGPzWNw5QvxG1lpgdk30krN3JS9jcacXYLwZlIy6peB8NG+nEXRmdF73HabY2fmiUlDPSzvcrREfYrzjDP+7/+KRkI0q5MmP5If6S/9vwRvYvplTsVUAcDXjy8d/6DY7TBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157572; c=relaxed/simple;
	bh=uTWs8uUyxcV16ZSSsIkcXFlvpo+GW53jeK4GqxHN0Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmI85ZG9w9ikcZwiLRGv+E63uwT2SOUvqw+AydxsGcoU021SOB5/3LE0X/EXb9EzbW+YcKXvV2xIXm+qnignIL+KdlbJ8FPWUKfyk8N5igVjX0zim+7QhxFKOWQwj+deUQM8HHO+NXU1I7b3FtdufCd6181q/9xNA7//H6TeCZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nsr0OzIg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nsr0OzIg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r5vekoB+OH5oJ60Qo40iEwoYPXq/G9UbYkDEJg7s+2o=; b=nsr0OzIgntDoU3KTQ5EYFT4VD5
	HGVP5scCVod62x6Bj0lcYNkxPRx6JsdM53s4OnLfLFKQ0n2uTLORnhivoZEar6ckMtTqYx3ZSUtST
	kTOIy5L+DDhLLKqGfaT8PJwvGBP2pc1PSTcLfUVmS1i25Js9vOWvpDNOxE5h32IAiPHiyStDEzr1j
	uDnYhMYOG0aGptigyFi4j0XN8+Xz4rCJV6pEcsjiUtSl9H6q07fD3MGAHWCas/CnQjuvznbfI/gdI
	bRWtayWVhSp3pxJIWHF6mNzMacvEn4pWDLc9z6zlKI/jvg4JYIHDrwk/sIPV3MTHp3EvtCmvC+zBE
	NH2UYgow==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvu-00000006yQO-3aEe;
	Tue, 17 Jun 2025 10:52:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: remove the call to bdev_validate_blocksize in xfs_configure_buftarg
Date: Tue, 17 Jun 2025 12:52:01 +0200
Message-ID: <20250617105238.3393499-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617105238.3393499-1-hch@lst.de>
References: <20250617105238.3393499-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All checks the checks done in bdev_validate_blocksize are already
performed in xfs_readsb and xfs_validate_sb_common.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 91647a43e1b2..0f15837724e7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1722,22 +1722,12 @@ xfs_configure_buftarg(
 	struct xfs_buftarg	*btp,
 	unsigned int		sectorsize)
 {
-	int			error;
-
 	ASSERT(btp->bt_bdev != NULL);
 
 	/* Set up metadata sector size info */
 	btp->bt_meta_sectorsize = sectorsize;
 	btp->bt_meta_sectormask = sectorsize - 1;
 
-	error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
-	if (error) {
-		xfs_warn(btp->bt_mount,
-			"Cannot use blocksize %u on device %pg, err %d",
-			sectorsize, btp->bt_bdev, error);
-		return -EINVAL;
-	}
-
 	/*
 	 * Flush the block device pagecache so our bios see anything dirtied
 	 * before mount.
-- 
2.47.2

