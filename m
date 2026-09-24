Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426843F1ADA
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244346; cv=none; b=oN2G4f5WzCuQfctjaeIbk7hrP4xEL3xrcuXTZGq2viLs3vkVE03z4RVOqq1h0ZiVVgkUlzylWzHOKf5vmK9ivl4BtD6Y1OAH2ZHlmwcCV35Pte2CNZzzSXzc2ObSN6HxQy0v0mHGDJ7OqAw3UCHkH2B+3lQG6YP4ffA2esDZwos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244346; c=relaxed/simple;
	bh=sYepVRTJI94CD1A4kD36Jh2/uEAztCyW+PoOPlJvkCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec5m5sv2kpBrAUV3fNnxu5HIlQ7PZbwXetn+L6DX/nOw6qgodvWNb6xwyJvsPaOr6O97MVdLBR0Q5ne2EJaEm2Vey72prTlY4oMXKYz1qUsFpc9ruVlDNRyZxRo5MeQqOOpK8iQK2qXLZpeAIvKWnYnpwqU0eM6dIH9AlUSsqGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BdBVdZXY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BdBVdZXY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IBWmnmjkdu8NJABEvybnUdmu8MYmIDsjWzdWN/UdXCU=; b=BdBVdZXYHFKXipxVB/ZjC4oou9
	RYBwVfBbxiLqCftjTyYk3TYU5ZTUaMZFR+/0xeCDFR13zCxmJK/CekBs0hWFJD2ilgpYHdi+KmWJM
	e5JRZqtiubhZEdvxa0zsdOUCdxBHx9djjzwXmCeoYkmlWXyD3ejrF6uZU8qR7nBmbWmuirCsV5Al8
	8RzuHi2rIbjoBBx5AWdXCIyVmA6YSDwZyYvTzQ+allX5M+MyVY0oB0a6xiFlI9stBxX3CEMHJ35ee
	AJMWHL/gt8FjraZNMNkXEdUXNB2r49TszwIjybSO0+wM3uSHUGCeZ5AXSxgNHdgMyP2IBY9GUFQC1
	Lmga2/fA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKc-0000000AfCs-0THJ;
	Thu, 24 Sep 2026 10:05:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/32] libxfs: add SZ_* constants
Date: Thu, 24 Sep 2026 12:03:56 +0200
Message-ID: <20260924100512.2733748-7-hch@lst.de>
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

Import a slightly adapted version of <linux/sizes.h> from the kernel so that
we can use these constants in shared libxfs code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h      |  1 +
 include/sizes.h       | 67 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_platform.h |  1 +
 3 files changed, 69 insertions(+)
 create mode 100644 include/sizes.h

diff --git a/include/libxfs.h b/include/libxfs.h
index 7f0c22ef4991..34dd267831c0 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -18,6 +18,7 @@
 #include "platform_defs.h"
 #include "xfs.h"
 
+#include "sizes.h"
 #include "list.h"
 #include "hlist.h"
 #include "cache.h"
diff --git a/include/sizes.h b/include/sizes.h
new file mode 100644
index 000000000000..69075e8f3370
--- /dev/null
+++ b/include/sizes.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __SIZES_H__
+#define __SIZES_H__
+
+#define SZ_1				0x00000001
+#define SZ_2				0x00000002
+#define SZ_4				0x00000004
+#define SZ_8				0x00000008
+#define SZ_16				0x00000010
+#define SZ_32				0x00000020
+#define SZ_64				0x00000040
+#define SZ_128				0x00000080
+#define SZ_256				0x00000100
+#define SZ_512				0x00000200
+
+#define SZ_1K				0x00000400
+#define SZ_2K				0x00000800
+#define SZ_4K				0x00001000
+#define SZ_8K				0x00002000
+#define SZ_16K				0x00004000
+#define SZ_24K				0x00006000
+#define SZ_32K				0x00008000
+#define SZ_64K				0x00010000
+#define SZ_128K				0x00020000
+#define SZ_192K				0x00030000
+#define SZ_256K				0x00040000
+#define SZ_384K				0x00060000
+#define SZ_512K				0x00080000
+
+#define SZ_1M				0x00100000
+#define SZ_2M				0x00200000
+#define SZ_3M				0x00300000
+#define SZ_4M				0x00400000
+#define SZ_6M				0x00600000
+#define SZ_8M				0x00800000
+#define SZ_12M				0x00c00000
+#define SZ_16M				0x01000000
+#define SZ_18M				0x01200000
+#define SZ_24M				0x01800000
+#define SZ_32M				0x02000000
+#define SZ_64M				0x04000000
+#define SZ_128M				0x08000000
+#define SZ_256M				0x10000000
+#define SZ_512M				0x20000000
+
+#define SZ_1G				0x40000000
+#define SZ_2G				0x80000000
+
+#define SZ_4G				0x100000000ULL
+#define SZ_8G				0x200000000ULL
+#define SZ_16G				0x400000000ULL
+#define SZ_32G				0x800000000ULL
+#define SZ_64G				0x1000000000ULL
+#define SZ_128G				0x2000000000ULL
+#define SZ_256G				0x4000000000ULL
+#define SZ_512G				0x8000000000ULL
+
+#define SZ_1T				0x10000000000ULL
+#define SZ_2T				0x20000000000ULL
+#define SZ_4T				0x40000000000ULL
+#define SZ_8T				0x80000000000ULL
+#define SZ_16T				0x100000000000ULL
+#define SZ_32T				0x200000000000ULL
+#define SZ_64T				0x400000000000ULL
+#define SZ_128T				0x800000000000ULL
+
+#endif /* __SIZES_H__ */
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index a61d50de9dc0..0aeb80fb8244 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -45,6 +45,7 @@
 #include "platform_defs.h"
 #include "xfs.h"
 
+#include "sizes.h"
 #include "list.h"
 #include "hlist.h"
 #include "cache.h"
-- 
2.53.0

