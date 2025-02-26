Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2CC223709
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596252; cv=none; b=pXGrPuqzWhe3VmXIkqLqWYBDtn9z1/tqWQtMYWQ4kEUkywCYnle2o4UoYINyyMxyj3OnynibPLOx/kh8BX8WuHvInQFqMLtPBs/aKLSZNGDNtxgmH1lYwnz12Y2qbcLojJqisr5cKRR4pz9zqruXXLeDH/Y0Pd6VkgGzv5vgI5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596252; c=relaxed/simple;
	bh=3M1HwJaCSla0BZYzZe9Qq5Zejg/XgTzMAZ7tj2T+PxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRMhLGL02OEp+JqT1IklQkS7wGXCNDWOAuNyOhvxysmf5AUx/0t2UpZVn6JGKzAHTZhIcEBTzILGQiHxUnYE8ZNoU8eSL5NFe58UppV2cQBakY4pNFAKLK7UYnn5JHXb36icbfNHkRTlTYUDDI9XLkNZCRG8sWCKDkxsS/e08bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vAdoorLX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vAdoorLX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7//z9VHDWJQ6TXRvVWRo6+DnIAjDFNx9wIj1xzCxLPo=; b=vAdoorLXVm2jrw/SWVPa62AoxL
	3RttS2SwWIS9x55ItYCBsMTwu72nEuXR2PA3SVVv8iNlbTnTlX0nlPprJmFOjMd33qLQz8cjulJOt
	ZLBKNDIgLi4YI3ljloSefuUdcxGWCdmLw+pk5JWHgzdx39QYBvsK0GXrmgRAtW57ZUFz6yzmzJblR
	0rMaQQ9g3satZK7OVkhCSPSy3wrAXDQGNeCphEWpmwakGRHgm0f38PaqpVmo7yWxzO24/6si+EtT5
	xfWt4S9yQwE4uQ6Etce9Qr4d+5RqDhobJVXuo1DnpzuZpoclH7sGGsxcla3Uq3tAOhy8Bg45lWfHd
	8YGiOL9g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb4-000000053u5-04kr;
	Wed, 26 Feb 2025 18:57:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/44] xfs: disable FITRIM for zoned RT devices
Date: Wed, 26 Feb 2025 10:56:51 -0800
Message-ID: <20250226185723.518867-20-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 3f2403a7b49c..c1a306268ae4 100644
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

