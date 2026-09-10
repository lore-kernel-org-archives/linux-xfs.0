Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB13911C9
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046940; cv=none; b=qMm7Z0WLeQ833SQEq3mm55zrQ8/tADJ0Rnkjy/2p5KQy/UxecLHQ5x4gdwQPfwC5CsbsQPjdB2qcQ/NayPeYWO6tLZJQqE/ZuXlpaQZg20s28fBsGMT8L/FfqT7bHrlThamYtttt7r3B2/tU+KMAbx0fZJBdWJ3z7Ll3b7Asqug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046940; c=relaxed/simple;
	bh=16Z7XjaDGshk6AWdj2HDmfo1WXgJ/wOBBHntaEK44Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdpKi4y+yNHjv7MPuSc//ReEF10VCBUNl8Heu5WcE635hP+LLlVbpU+Ihv3af2xmhYb5oOGxOwl2Us3ygSE++uo9Uhz0e/OaiCgphxikN49OMRr6ixU4sb/53h6ub5zjzyfNZo0rjsrqBd8JqGJcuXyczlYRCqgGJoVqvBM+IN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KPdopVec; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KPdopVec"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BgpiP0+MmsIr3Zjwv3o+PWrYL9jOFVim0YQ2kO4qwCs=; b=KPdopVecO094/kmJ5BPH97VH6H
	r8hIpi0JogkTrnU+2agYQOKHDUyTxRmLVUbRMcrh1f2+qOqI0Kg1LTGeDg/SS0TvKCMvBvrJ6TTcW
	NvGcpuIQNtiF5/UN2hW3P3ElJBtHAJQcJrb1jsRAyglm/InnCGDsZYeZfSaFg4uSOcrthowCtWvuW
	aOOyvQa9mecDb7i+CR9yfldOO6KErorVwDrYaBAgkKPGmNYUKvnUIQi0cAt+8rXxp5DatOaiywE+K
	sD0VhtKAsl4CBxXew9Vn+A/93gallBm+d/0Qqw6pRZLv4Qe1MAjewT1KwPxsWQfBNvuuP139gWUgQ
	5Yg7cRmQ==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4epk-0000000ESsv-2liE;
	Thu, 10 Sep 2026 13:28:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] libxfs: remove a spurious xfs.h include in xfs_zones.c
Date: Thu, 10 Sep 2026 15:28:32 +0200
Message-ID: <20260910132840.1541283-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fully resyncs with the kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_zones.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 4f9820dc5419..24e350c31933 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -4,7 +4,6 @@
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
 #include "xfs_platform.h"
-#include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
-- 
2.53.0

