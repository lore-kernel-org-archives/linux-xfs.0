Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531AE4746A5;
	Thu, 23 Jul 2026 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818260; cv=none; b=k3e/tYs64vefXdv5oxcXio470sDk+eZz55w9lF50nG1k1gsKGNdmDCchDJPU1g34iZz5dITwqCD2ihW6+ESL+RvIas2/DlYLirFG/8aN0R+nMwvw2jdbAVU6kUib/evfJBGYUokHOAQ9uYXx1SO782MyaspORED/hBd+LgQ8F74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818260; c=relaxed/simple;
	bh=Vt/AEzBMtPfGLWpVhpXZ/Q8RGrfJbRyYN5PR/V1TEEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCkGfDmNMHvqVgGJ23b9jbBRcQthXgz0vW8VdLpSuEOglTHrbcibJMFiEoOkakMWEZ9yvk/7sESbo8UIWjAc15toXrKYONrNeohAjwunbZ7BGGyDYD8VIIWFYlM4hhPvQd02hDQZVFwSUNFuNLbbl97a3lWDEY2LgtFpiOFP2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L4vdM0Rz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L4vdM0Rz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pzFfhB1iTcOk9qxfIOuPlXEK9N+9DCAW68e80MLqD+0=; b=L4vdM0Rzh4sI8xWnYYoA1RypwM
	zJ7cw5HtwjLLDo7qhrjBMzTipkLp/z2eK8KyRvdyhnypqWpDE30CJihUXFPK3bIqOwoJ0IM6N0Ha+
	xhafdScwwvjOuAt73/udlApGBwyvM9Tm+mfz3M7RlrOrlADD86QOllKkER/WYhU8FGK90Mgu6W5px
	WDShdLBJj/mrd8Gmmhfbfoj4eYjRlZWtBA+QeguV0CW8mR6Z3M24qC9Ej/C4UQgEAwmu07NShiPjB
	mPe74TDgavKxPRNQsUWDz68ODjOg8EUhOtrc9IsZYRtR7Rh8U3quFjtdpvU2zvGw5Pu5XwicIHIrM
	wnJFmuJg==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulD-0000000EXLK-2xf9;
	Thu, 23 Jul 2026 14:50:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/22] block: don't include blk-integrity.h in bdev.c
Date: Thu, 23 Jul 2026 16:49:36 +0200
Message-ID: <20260723145000.116419-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not needed, probably since this file was split out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 85ce57bd2ae4..90baef0bd174 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -12,7 +12,6 @@
 #include <linux/major.h>
 #include <linux/device_cgroup.h>
 #include <linux/blkdev.h>
-#include <linux/blk-integrity.h>
 #include <linux/backing-dev.h>
 #include <linux/module.h>
 #include <linux/blkpg.h>
-- 
2.53.0

