Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD51F238D
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907454; cv=none; b=lQO/mJPnoAEEsC+jgOUMMRZzAHZ3YOITyKskYLiqvrSEjUvB3Yh74988ptZNvRpd1vNimBn22abQkInMi741F7ye7KhJYPxh7y0BKHS67t+LoGCCcTIoAjeL5rUCNSvxWPAYBBVGqUDReWYgh7C68tUAYQNv2JBCKl9RACw5bp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907454; c=relaxed/simple;
	bh=/qpsJkwMM//FAfn7/rXA6AwW13kxY9Fe66sQgydfLoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmGFP+A/+6bCFFS0BELiqYaanM+kqzjOs+yV1kMMo+Y2D22nFh4SEZSjXtaVxH5hXBwgbqbzFXLKnYkm7ib6XhAPJ8WHzJAR0fXsZj/UPobSDgK+/FjsKkj7ksWXt87JvflxZdDTyy4znSgK4zRwStXWC/pG69TO/L/oPq14eJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1qqfJZwS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1qqfJZwS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZghjQHNpNn5t+tJ3DXtTjMR0o4Nw5nsgjE61K4XJaTk=; b=1qqfJZwSQRmqSJO8xgjD5+jk3M
	Rlj4Ifkgx8Jp+dnpUTu0huMiLGLlQrKy3m0jsDHXiFywOdSf1IJI00rw4s7A8Hrb2lWO8exTL0Ihb
	MtL08N5MI+6+t8Y4fH3oR5YiRypvBol5fnbM8GSuU2pnzu495kuuvNOfis0Xm/VYcXxN3CtWgaFrP
	nLqixugjuUx8W5DSpr9Z0An1SvswsQqxHAjGAOqWSm44ncBVsX2Du0RsOWjNWC/NfJw8Vt56bacGQ
	1wuVA5/4Zu2Mrrud+HWlgbxtHQakhx3FvZUypSSVTcRtt/2smmAnPOxntRRIBrsYyRAnPU0QVz7h1
	swvUCiiQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXE-0000000EJED-0lCM;
	Wed, 11 Dec 2024 08:57:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/43] xfs: disable FITRIM for zoned RT devices
Date: Wed, 11 Dec 2024 09:54:45 +0100
Message-ID: <20241211085636.1380516-21-hch@lst.de>
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

The zoned allocator unconditionally issues zone resets or discards after
emptying an entire zone, so supporting FITRIM for a zoned RT device is
not useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index c4bd145f5ec1..4447c835a373 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -844,7 +844,8 @@ xfs_ioc_trim(
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (mp->m_rtdev_targp &&
+
+	if (mp->m_rtdev_targp && !xfs_has_zoned(mp) &&
 	    bdev_max_discard_sectors(mp->m_rtdev_targp->bt_bdev))
 		rt_bdev = mp->m_rtdev_targp->bt_bdev;
 	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev) && !rt_bdev)
-- 
2.45.2

