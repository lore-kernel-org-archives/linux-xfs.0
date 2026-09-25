Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62FD4CCDC6
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349682; cv=none; b=DYdMBTAv5xNubed5QYy7GEJ2m+ZatCyhf4EtXPb2LOmkXlCcrJPcTv4o09Pk9So+DqO2ltw8E9aToaI8T52DLtjENBy79tUud8kARloa2UZ/RN6dSTpDSoBh/pWDcSlgGxyZ9D3GyfrAuRTdNZbMdZLwCl8Lhnv8ykQB1yIhaKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349682; c=relaxed/simple;
	bh=koYpaFDMbCuLIS9JVk/0icEI6zN6eL1ncd29oLRWC+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruELKIOUNJfvknXpBbfq3RkRIrpp3e1hjmsuSNaPvUuGtN1BeHfAL4ISPCqhWeV4OZUXY8SfCIQneaNfz3E7q0BvX4NpeyG3BlCStHkNpOPiX1/mjf9s8zMwcoDqJmJwd1xAgwxmL1It1X6J4Cn+Cpye/bPSDh1ZLIGK4e9f9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JBOaQVl4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JBOaQVl4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4QyEV7rcQTm2yMBsmYDaQP+KGkSUdNLWxuEdYI7PAc0=; b=JBOaQVl4IBLIuq7NVhP5s5bUgM
	xaGsqqB9qaYkPSJzAn3PRT6/9/yWYWC12PzUlfAdSD5QBb2FKDO0I1AxANGjOqTdS8rI9sLdlLN/l
	bqCnVnKXiHyo0wDief+2qJsIpPedee8P0D3NiCeYZjLKSY3Th7dxzJ11pxWr6PmEAnGaEpe/Fnxo6
	Z0A1WjF/DNftPzP/QtizKKpRG2U4e6rsEgsOpOzJUqxC6KnQRjam9c/h2vYNjziVpKft2Ab9jVVak
	inVS34ftkZ1chMacFSdQkpBgaSuNywl6ESpOAFjmenF3rWM2rTutiLpI0WNMtr9vPH+fNmTs+5ITG
	SWTiVfGQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jk-0000000Dlcf-09Gr;
	Fri, 25 Sep 2026 15:21:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] libxfs: move the xfs_rtbitmap.h include in xfs_bmap.c
Date: Fri, 25 Sep 2026 17:20:23 +0200
Message-ID: <20260925152107.3386097-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To better align with the kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cec59446711b..cfce4358e2bf 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -20,6 +20,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -30,7 +31,6 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
-#include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_symlink_remote.h"
-- 
2.53.0

