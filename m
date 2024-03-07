Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F3312EBED;
	Thu,  7 Mar 2024 15:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824323; cv=none; b=VhEtaQyw2GW06pLuz09Qj2eam/3lYfbxHSwOAc+p69b93SuiYBXg6iPlF7Hi0jzzDfdKFcke6dYG+GI8TG+Vpl+mKPSDi4pY818ZzLWPG8Q6GJybtzk4xEWOkJpOYZ1SVNb7K1o5hKNggF7tlyYn8oJiDuQOYM7+FmGz3UUBeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824323; c=relaxed/simple;
	bh=CeGGphwbZ+bq0L35X3yMxqag4sALR5PsqLC8iS3hr0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GsgDVt7/zkjtx9kV1Da6DpDz5X+k9OG5X1iMWCQs/U9mCQCF6ikYprkDZ8fzLsqm3DaMYpuDDObKpUnZgrrBqAPEQbehuxc5kg2lf4g208kqwzazTagk239NgDx0qFdblj2d4fxxWF/e4OlvzXdBCSQxY0184b5aG9nMJDBncFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lZDGtDO+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lZDGtDO+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=21fX9Gy5zvQsI495qmSlpVuI+exSTES9Ynq5330qoqE=; b=lZDGtDO+9RTu0cd1OXyWZO8T8n
	cP1/gnlzQ4B6ycpLF9bRLw350OecH8V4NIan7ZpyFwao5K4bvbI+yzXysHtQO5z4IeFT1D7bCuHVj
	/XD4M4d7XnVL1kSHjYrFKLJ9+UqGm58BeDd9o50XUVW8p/CFT72exRUGquG0pFoPAgruIQoPdoC7K
	Ns8tbPzdYwsCuse5BTx83qMGl2PX0FcKlC7ggZ3Wop8b2qlk029CCxSNqjQPXPAzeSWMDIkvOE15j
	h/6CXdkGjHot+Xs4S6cYBkPJSkYAo3PNZDizNAdZqXfWVYEuav8kTcpYKbP+ZZLK4p8T3pHCoDTSG
	1cxBKBZA==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1riFPd-00000005D7C-0zCe;
	Thu, 07 Mar 2024 15:12:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] block: remove the discard_granularity check in __blkdev_issue_discard
Date: Thu,  7 Mar 2024 08:11:48 -0700
Message-Id: <20240307151157.466013-2-hch@lst.de>
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

We now set a default granularity in the queue limits API, so don't
bother with this extra check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index dc8e35d0a51d6d..f873eb9a886f63 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -66,13 +66,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!bdev_max_discard_sectors(bdev))
 		return -EOPNOTSUPP;
 
-	/* In case the discard granularity isn't set by buggy device driver */
-	if (WARN_ON_ONCE(!bdev_discard_granularity(bdev))) {
-		pr_err_ratelimited("%pg: Error: discard_granularity is 0.\n",
-				   bdev);
-		return -EOPNOTSUPP;
-	}
-
 	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
 	if ((sector | nr_sects) & bs_mask)
 		return -EINVAL;
-- 
2.39.2

