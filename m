Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED2442A14D
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556567; cv=none; b=ub2FtGWpRpHC3iLhrNXt3coZYbz8O8+OkyPwNaFp+zu8onKoIOUAl4hITjqQka8RlBIkpg7/UqrZF6h+Qk1QrA6zbqOysCx7LI3tf3FkLKsrr/wimsn7Q34Bq/oWe/RDMUPagaHRN0RnZE3+vlgyCiTqzpLOyTOxTN0aKD9OSpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556567; c=relaxed/simple;
	bh=A6rgtTsTj/gz2dxYhCMfOi/YwPY3EGtQZ2KSeytqjE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N9RsHqJGSs/b+AhNAOvp34hFGRUfuvVUlKQJZdv8I/uQcRG2tsmzU+gFOkTJHnZsy/GxBJxtyDSrS8wUlIL2VrwUcQFOnQm9P9MPeWRIIc4nLpMruyFOrc8XD6c39YDJs5QE37oCn78SDPa5d1rCCM5eRy/roMpZfrJ0ayD5/RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kk85bszZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kk85bszZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CMLsBjpDq0XPoSzbFaPKvOP17l1w7qfdSoH4c/Xzy+E=; b=kk85bszZezoRvxSkYV9EWzNdzs
	sJXbk2z/8uTAMviOrdXEnJXI2grDrzLV0FalNOKMHH/XTQ3jqjLgt/yEtkUqBPekY7eBCUNAGbF1q
	foK6kKfOWNMNAoheuLUj4Fr+CTnxFIly+qtSrOjVmIrDZJ+ZzRJwhmpDJt6yqmbADXmpGXYdCGPE3
	XPT5PeISRPzo1JGfyT14q1LQj9JTkE+si9epgLAeNG8oL2KI9CH2YedrePisTGvu4tZfkFc3Z0927
	8f43ckWwdIFAjhKYidfvMbryg7/cuA2OhQCHaLuDCsc3zrD1v5MvDl4PrGCXaWbFNsXP7oBpXjlgp
	9IoBRdSA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlogN-00000006ucW-2XrS;
	Mon, 20 Jul 2026 14:09:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't flush and invalidate internal RT device twice in xfs_shutdown_devices
Date: Mon, 20 Jul 2026 16:09:21 +0200
Message-ID: <20260720140921.2269927-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check for an internal RT device to remove a bit of extra work.

Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 63c4bcbe6c2b..d96f3781d791 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -445,7 +445,7 @@ xfs_shutdown_devices(
 		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev);
 		invalidate_bdev(mp->m_logdev_targp->bt_bdev);
 	}
-	if (mp->m_rtdev_targp) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
 		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
 	}
-- 
2.53.0

