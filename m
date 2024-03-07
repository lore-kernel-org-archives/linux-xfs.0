Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC1212F388;
	Thu,  7 Mar 2024 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824328; cv=none; b=pHOH6DLdbkfVBANPqc3bUGMp0IcgrfoVsD8Hz5QjBieiMua7hLwDGq+VMYe2vc8X/g9wdWOM4vU44B0HfaYhoU39NH1PptM3UMG9HvCc4Edx4ShaX2EH/bMJ/zkReDuZGAcc7OaBSR2NwHkblVMoUeA+TGPLTLiSsk/6KJnmiUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824328; c=relaxed/simple;
	bh=xCe+xklm9baPXz5w5r5u0Mvfv0h4wRfFKbRMgYxRqeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lmw6XZcDZuKf9o+E5UeMXCkvVivsxDMaviFnt1cATCl8xJPcfD3VjfKsNdnvxeYeNFtwTo91w71+KLBTCWMv/IACMPC5x7heRSt4Bo0NCgheTZzGcx/GfvUair0WQodadzCw5kdBVVq5K8HFgKATtg74iIkEeNt+0Gyzw34XdYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rJa+Tq1L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rJa+Tq1L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K6dAOpH3HfvroaSB45ET9VQSXQtJU2v4720kk0k4xZk=; b=rJa+Tq1Laip28+c966zEelI785
	Qn0F6MIBM8vVn9g5s2e+7ZigMrwgXcy1C9h1PlZXWWv9XfWddnLpPLXDfP5XzFykujPrqIoVXgEUT
	8bfv0rHQdJisWFZLq/6JH6glv+/biYReNfuRW20SXaZ0kYmsl1EtZqTzb+Zow0xmeDKmFOVuFAaCy
	zQbwp7A8fQhJcKMuaOBprBhtu3wmfm1KEm1NHiO4iCm13uk45ZM2r+/CTsWTC/N6fMIRVYguB4vQ8
	ODgb8hmkIPRo+V4S9r5DgmkVRNsAw3CsDHBYZ1gyP4C8VQaPdQs/+8vySFA3PdvdgsrXBwbl9wadN
	rpdNWBvA==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPi-00000005DA8-0s2Q;
	Thu, 07 Mar 2024 15:12:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/10] nvmet: switch to using blk_next_discard_bio directly
Date: Thu,  7 Mar 2024 08:11:54 -0700
Message-Id: <20240307151157.466013-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240307151157.466013-1-hch@lst.de>
References: <20240307151157.466013-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fixes fatal signals getting into the way and corrupting the bio
chain and removes the need to handle synchronous errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/target/io-cmd-bdev.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f11400a908f269..c1345aaf837d93 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -363,17 +363,13 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
 		struct nvme_dsm_range *range, struct bio **bio)
 {
-	struct nvmet_ns *ns = req->ns;
-	int ret;
+	sector_t sector = nvmet_lba_to_sect(req->ns, range->slba);
+	sector_t nr_sects = le32_to_cpu(range->nlb) <<
+		(req->ns->blksize_shift - SECTOR_SHIFT);
 
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
+	while (blk_next_discard_bio(req->ns->bdev, bio, &sector, &nr_sects,
+			GFP_KERNEL))
+		;
 	return NVME_SC_SUCCESS;
 }
 
-- 
2.39.2

