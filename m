Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F9B1A76BB
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122931; cv=none; b=m2V2a+HOtJeapaLDyZKKFJUvRRV+eDygrMWoTxSlvEAFlXldBt0R+NVMFhE2ePeYQXIXu/lNc33ma1L9aeJTPRpyRJswYzQOPKRad6GQSnjk1DwNYtxnu8aNwk3yI6boWif81+QS9YUIkawk1QI22kqR4RgAN4yjC30Z9YxlSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122931; c=relaxed/simple;
	bh=OerOCDsq/Ra7gtoE2PGuOEoO/vP9b4GPMITUXH+Dy/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4ZwzpHK5mVZt1kpAWxoT8ZKXyhUkWRA/c6LfhzWpzrzmuARpmSDevroF4bMi+fV8cEGsVoNOmU29RFbSw7Wsd2dunMi10QFaS5TeBU5C+RbawPexqEX16uqBnxg1Agx5yiiESZDBEA1MStY7gHBQLZQ3CEF2kzy3jYI+zg7CgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4SuaKDk6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4SuaKDk6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZwImlf8efZL09UBst7Ux8riNuPQfgkLTRGjL/nhAsW0=; b=4SuaKDk6AgCNhew6zupyWNy1bb
	z4P7rZaMPY6HmCJWcl1MPa9zHEiriUwHUAo3/emSbFhRCZpe+XjfNYcPFuYzfGnvytEw9IMe4ZLtZ
	gN+1bPkMX+bn+PxnzTiNEEyMzka5bmsFpo5ytVzggBFm8liUifFyrch33xXnl2TOnOO60ZxA3Ut7Z
	XDEqfVWbb6Wh3t5bFFa+N3o8RzTG1HEV5hhp5OTIzpB5LmH2Vyl0JqFIQja+97tJUWmff0IEekHFF
	pyqVE8iI9GjNZZDEEiuoi3oso+X7gD6UCSg0Ky6gCf/cYvDlMF0ug11VI7AnX+WJDnsRx67PPrF7G
	Wfg9p7TQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTFh-00000009fHf-2zDB;
	Fri, 19 Dec 2025 05:42:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: rename xfs_linux.h to xfs_platform.h
Date: Fri, 19 Dec 2025 06:41:44 +0100
Message-ID: <20251219054202.1773441-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251219054202.1773441-1-hch@lst.de>
References: <20251219054202.1773441-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Rename xfs_linux.h to prepare for including including it directly
from source files including those shared with xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs.h                           | 2 +-
 fs/xfs/{xfs_linux.h => xfs_platform.h} | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename fs/xfs/{xfs_linux.h => xfs_platform.h} (98%)

diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index 9355ccad9503..b335a471c088 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -23,6 +23,6 @@
 #endif
 
 
-#include "xfs_linux.h"
+#include "xfs_platform.h"
 
 #endif	/* __XFS_H__ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_platform.h
similarity index 98%
rename from fs/xfs/xfs_linux.h
rename to fs/xfs/xfs_platform.h
index 4dd747bdbcca..ec8cd71fc868 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_platform.h
@@ -3,8 +3,8 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#ifndef __XFS_LINUX__
-#define __XFS_LINUX__
+#ifndef _XFS_PLATFORM_H
+#define _XFS_PLATFORM_H
 
 #include <linux/types.h>
 #include <linux/uuid.h>
@@ -281,4 +281,4 @@ kmem_to_page(void *addr)
 	return virt_to_page(addr);
 }
 
-#endif /* __XFS_LINUX__ */
+#endif /* _XFS_PLATFORM_H */
-- 
2.47.3

