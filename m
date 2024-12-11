Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FCC1F2367
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907421; cv=none; b=CXYr5mXQAaZGpaWxO7kYpz20IFabaIWfIJquHQCaI+m2ctNuTnMgbjsMQ5B1SQX4xOTDNwL4HNymA35CLtyzSe3r8gyJQJHyhrdlQrchm6g+O6QpN9r9HBVOpJsVW5H/YVSytelKtZA5AWKi8TYebl37+ujEFbFuRLN+ICaKX7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907421; c=relaxed/simple;
	bh=01/eGOf6EAGoUm8to1BLPrU3xvXmAsQRT3Dq+Xqu2dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEpp7w1Dn8IQLKTJS+MmoRjhC3ddR3n0pbPV6BKjGkgKUCLpWLkFROat7olx59bR3/UAn9OkR1rp6IEmS1IhbnW58wqeoRyZUlXrOTSukRMCUdWWqPFVWoeaxG6yprgA4V4QXI4jsQRx564WSS1Ohyh7XKJAWBecns/YHSj0IMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SzzgwltR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SzzgwltR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HbCNmEpllxnACwbfdQ41zwfFiesGPndjSzYU99fftxU=; b=SzzgwltRGF7CqZgyZXe9rnSw4O
	Q3B6+Xwbmf5YOVs+nndCwIbncbOLtqBPFxQMkz557nUZiVwThiSNGi3tSj1ocLWvyR9t0PHiUvzc1
	2nBBcyMJH9c7SzuMdhqEnPWv4jIOk+6LEkXeWQPf9WZtLCKHzt0fLDUX7JCtt7VGYyEeW/s9e9ddr
	EV/8ioWDgjkuHtorIdVHZqNcurOrKOf2XoddWF7B5fXpb1oDTAr54/nr8Fs166FRRR6Mt0UYnsl42
	r2h2zGHuvrJvs6/u65d4zanB65L7oUvaW+pXNE5a0uuJaKlGU8Cixp/zGUkzNLHSAyLi8GpmWaMQw
	/MU0+MRw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWh-0000000EJ3n-1bW1;
	Wed, 11 Dec 2024 08:56:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/43] xfs: report the correct dio alignment for COW inodes
Date: Wed, 11 Dec 2024 09:54:33 +0100
Message-ID: <20241211085636.1380516-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For I/O to reflinked blocks we always need to write an entire new
file system block, and the code enforces the file system block alignment
for the entire file if it has any reflinked blocks.

Unfortunately the reported dio alignment can only report a single value
for reads and writes, so unless we want to trigger these read-modify
write cycles all the time, we need to increase both limits.

Without this zoned xfs triggers the warnings about failed page cache
invalidation in kiocb_invalidate_post_direct_write all the time when
running generic/551 when running on a 512 byte sector device, and
eventually fails the test due to miscompares.

Hopefully we can add a separate read alignment to statx eventually.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c |  6 +++++-
 fs/xfs/xfs_iops.c  | 15 ++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 726282e74d54..de8ba5345e17 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1213,7 +1213,11 @@ xfs_file_ioctl(
 		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 		struct dioattr		da;
 
-		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
+		da.d_mem = target->bt_logical_sectorsize;
+		if (xfs_is_cow_inode(ip))
+			da.d_miniosz = mp->m_sb.sb_blocksize;
+		else
+			da.d_miniosz = target->bt_logical_sectorsize;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6b0228a21617..990df072ba35 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -582,7 +582,20 @@ xfs_report_dioalign(
 
 	stat->result_mask |= STATX_DIOALIGN;
 	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
-	stat->dio_offset_align = bdev_logical_block_size(bdev);
+
+	/*
+	 * On COW inodes we are forced to always rewrite an entire file system
+	 * block.
+	 *
+	 * Because applications assume they can do sector sized direct writes
+	 * on XFS we provide an emulation by doing a read-modify-write cycle
+	 * through the cache, but that is highly inefficient.  Thus report the
+	 * natively supported size here.
+	 */
+	if (xfs_is_cow_inode(ip))
+		stat->dio_offset_align = ip->i_mount->m_sb.sb_blocksize;
+	else
+		stat->dio_offset_align = bdev_logical_block_size(bdev);
 }
 
 static void
-- 
2.45.2

