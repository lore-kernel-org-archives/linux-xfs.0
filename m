Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B754C4457CD
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244343; cv=none; b=NVOskPJ0LgggTTOAflmExOLBm43l38aBp5rneGNA2elhbUVKdTTeA2XOTxLL7SLeGgl/Hq1W0vnIM+6qfU5kzB0C/UNvzJj8hR6Jc18zO8IqPSm59B7KpMoPh4+Cbzfjzw1fPR8sVI1PSsw2xO3tQOg9vxyRsoPM0oQMibbS/Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244343; c=relaxed/simple;
	bh=scqG3Id50MTC9uGzvlqs8bXM2fACatPiwbc2rxP6gGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mARXEqRUHwuUdp9MpJFXmRyaJb70UdEEpPUjIyAymIGrr6EHAgxUiw9GQCjeJDugRyk1DsIMBVT0AkYynIp1MFp+T3z/dYRsG1i7mZ+nlvCa5gqMmb2E5buCUD4ZGQ87HLJCDdYy+9OqgCkUdoKEfOGEp5ybjN9IVpgofRaQrpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=flBesLML; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="flBesLML"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k5rLpkaJV59HNhktxWs4pXbUMWoDyxXZAVScLzrDL1Q=; b=flBesLMLQrbmVkI4htDVJqJWDa
	BhHcHJBQhdBpkwb48tImE1NPscJVNmbtNf4UCxnQFtUfkn6gNvlh3Yuc0GWaVXxp+hKW5Onfr56ZO
	p4H0eAjelRUnKf/g9JYcP3wepndo+n+CdobM9rXblIg9gvqeJfWhvaj9h7GfXXEqp3vc3cHWHdAjw
	lx2+KSxt13X4C4LtXoiE3pSb7EDh/LZABVGRWH3Hkmv4FWS3vOGlqZ5j4oa127dNS6ujfB06QEOWj
	OA4kL1igwenZhsZoWiWAZihaUcsrTgP9X32rc+1Os9mMbO2n0abX3fj1qSTXlg7UGc2/9uioYRJP1
	b0CL3HFg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKZ-0000000AfCI-04CP;
	Thu, 24 Sep 2026 10:05:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/32] libxfs: remove a spurious xfs_rtbitmap.h include in xfs_sb.c
Date: Thu, 24 Sep 2026 12:03:55 +0200
Message-ID: <20260924100512.2733748-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
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
 libxfs/xfs_sb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ea99f8b5eee5..cccbcd153316 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -27,7 +27,6 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
-#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
-- 
2.53.0

