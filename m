Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111C42253E0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824367; cv=none; b=ae1hSLxPsBmCiCAxXcmQEY5A3YJe/Nd5lhkKUEMNrRZ1u7X9uJmcUzTQwPhJYQh+6XYlf8dLo0lLWQFVIMGCuT2iZNUyRW6vx9jvkI5tDmQi+nT/VnLR+W8bh6j/vi1FxO3uMhFyrFZuKm5wn6nvro5Bs2/njcmYw/fwbD0AxEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824367; c=relaxed/simple;
	bh=3M1HwJaCSla0BZYzZe9Qq5Zejg/XgTzMAZ7tj2T+PxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kno5PWQDCCS8DGrTHVjyy0gBX38NYx8ekFHUg2gmyLy6HrvcYUaDJxo2rpcxkt29EZffA3bD9V7ui6+sFIbVpae8BTXNryIqqnU+xo/azbdIK1+oqvhIYn6m2aZ+hDliZReD/ZH4uXF+sA+oeUeOwaTEE3NfptjPZCqMRA0ybhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v6wiyOAk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v6wiyOAk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7//z9VHDWJQ6TXRvVWRo6+DnIAjDFNx9wIj1xzCxLPo=; b=v6wiyOAkTU8irfTOLHbc3hqyyn
	Zf5tMIohUxIBT2dT8OFQ0e3Qou4suVRh+slqCyADKzxNG7CXK6+lTvShABzSqn8ZhkPQniid4Chqs
	oV7I4ZgMRSkIAW5+57B2G+hfwtfGE/zWQ2+54lBdJxhDwtAx1RiWwIkOgayClWh9mb8efLu1MaDLg
	4xsgYkkofJaa4ftq6wL0aDb0wvIxQP6HY1S5wukVEkPFTd7UiXiRlTMxuJZds6iWUli5e8oU4vm+5
	aa2FwYMwmj4nF5BLy3/sUoO8T19e7naSHBfodvAWpo7o3fFgjLKJuzmAeyeKdyEqa9F502aCznJag
	rUSFlmoA==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveH-00000005QKU-1LKg;
	Thu, 06 Feb 2025 06:46:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/43] xfs: disable FITRIM for zoned RT devices
Date: Thu,  6 Feb 2025 07:44:34 +0100
Message-ID: <20250206064511.2323878-19-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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

