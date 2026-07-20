Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112030567C
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540776; cv=none; b=UNIxADwPQrzeXfVuNoVk13ksYCUbYUQwen7lgaqwZzfQLfKRugwg1zLNN6QUIH4DTNT8aGea1CvBBRXPEKQ81lPYcMBc/AwSsoyJdTOuBZ5xlcGPrWhQ5lYjGvuM2qb8Y3i3cMxarjhvX0pTpoCsrlRdfgDPH8/HhSNg30hs/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540776; c=relaxed/simple;
	bh=iHKK+Enqefc7nZg8iqgpHmmdtesXNfji+H0T+y5V5W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+4gu9+lQe223ksEXH4R44LRFv8RqwSMJzVm1WN2BjfC5nRJxPR6Ad2nMjLgI86++cNfQQOMSofpOPXWAbp4N3q4wH4NaUWUaAXLD5nJdzzMmGhwM9kBDWg2XYUChrXECNt+KfgO4vCkEqThvDTLbXCeTLwBputHd/CiTRaUqPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yp5C2MIE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yp5C2MIE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=adTuvJdR573VfUACtsOs1IlyLypRdop8UZsFhT6AFrA=; b=yp5C2MIE+p6uTKSM/VMRZT6Q/F
	zI8kSne5PmOgK7IA+bUspDhMR2o+I4CfeIoX42+UEHspnM45PvDlkjc/vK3u9cDQq+yvwfuIzqHpv
	lXAxm6wx0IMGykU7RIWBKjwbslgTROjMSgEcpkMzBKFom8LiRDp+8DJnTCgiIv27glk2QpPEmOrC/
	K9rgWMnVgQij37v8zZbyjmtgpU2KGN/HProKarc8Fzqjlqj5px2jp+8NBJ/TKgiipqQxz7bNhIB2I
	5h3J4jE6ncOI/URy27Z1hLX1D1MqwDW7/zRKhXnD0vw49KIwCbvztm6yZmJFYRrKe5DuIB7UlvGyN
	x7h+3Lhw==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZi-00000006MhP-1SFh;
	Mon, 20 Jul 2026 09:46:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: fix the lock annotation on xfs_iget_cache_hit
Date: Mon, 20 Jul 2026 11:45:38 +0200
Message-ID: <20260720094609.2191633-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The newer clang context analysis requires __releases_shared for the RCU
pseudo-lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9d8dd30bd927..340fd95dfcdf 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -501,7 +501,8 @@ xfs_iget_cache_hit(
 	struct xfs_inode	*ip,
 	xfs_ino_t		ino,
 	int			flags,
-	int			lock_flags) __releases(RCU)
+	int			lock_flags)
+		__releases_shared(RCU)
 {
 	struct inode		*inode = VFS_I(ip);
 	struct xfs_mount	*mp = ip->i_mount;
-- 
2.53.0

