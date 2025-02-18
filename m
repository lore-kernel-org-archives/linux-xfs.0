Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A04F1DDC07
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866370; cv=none; b=mHHOs8MkHpJQ0OwNO0f/jG6fyOCGGnqY/tvedeqTtbn6jx/7XbSJ7OkJBx5nIV0Wk8mihQpQt1ETddm926ZFHcADIdRI1codi3tbSDJijYjFktJXkfuaYIxpV+NXrno8k2E5pchGi/d6DMhbTf2WNUxifEC+wanTH/tYLZt37ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866370; c=relaxed/simple;
	bh=3M1HwJaCSla0BZYzZe9Qq5Zejg/XgTzMAZ7tj2T+PxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU4UI7RgZInGwudZxaI6RcGpacj67hLp4n3+Din4yDPRgmngUUSNfKkw5t8C4QtAPnApork5dx6WHbUFJcz8rNyKjSW5chUkbhcve/I8urqGn2iWQjY/ZnCvDnyhGAFvMkQjh3lITdGS7pIYzdIKp7SUbqR4ySEktkis0FADB1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lxu3A379; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lxu3A379"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7//z9VHDWJQ6TXRvVWRo6+DnIAjDFNx9wIj1xzCxLPo=; b=Lxu3A379d0130jGFPqQNEfhgkQ
	6ujXwBHZUErts3b+BzQOYFRbi2MlK3r+oKBtcJTHnjfAZvI/40kY7Ydz+BgDxga+keAUEnIm6WuYW
	QwMYQmrSok9v9SvQokt1t4tGOYw7FVT4BoTYpQFN9qJcDFc9uALDdNd6CRIMaZV8s+JziQOkyoyrs
	KfLkTY7QD3DM0oweazGKFe6guXSnWDyym2BUmD59pW/Cu1t53er2bkX2W9vcHGL2IFsHCyD6F6itH
	WUWThI4N7nDDffepXxjwJgZt7JpCSDDUuykDjsdkilhKlfPk+THkSctiuujfRS543/a/TLz8TNBdn
	ChspNnuw==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIim-00000007CXw-2VRD;
	Tue, 18 Feb 2025 08:12:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/45] xfs: disable FITRIM for zoned RT devices
Date: Tue, 18 Feb 2025 09:10:23 +0100
Message-ID: <20250218081153.3889537-21-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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

