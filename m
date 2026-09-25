Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFAF4C224E
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349674; cv=none; b=QlnpMdVt5DcXoimBf89FlISuW6Mm/oDJGuWVCK6oyBx5QOmrWc3P9sjphSAnKHh9d5znbH5rgz1iTPBT+irhanhBYJsAXcXfxTM2g0VxvkLLCu/EGDBxCwP6Gu9L9xJlMdDDrNzKoDDEtBxiyLnbPtALL95Bbsk9i8AQeQPhQus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349674; c=relaxed/simple;
	bh=j96q3KXuilMv4pbcbIXK1O3m4WjWX3HpWdoU8c1rQOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7NfnmXgQD2lVkSRBjBKlvJawZNIqafPZmuDsfDZ9PLWUQ4cHn5q52R9FkI6VM9NlXhsDnj7MCfpVCNBvngMQVZR4joqfIPqrrvYToWZMhUdriQd1t6GvOY3ZM5kRSIcLyOKnXsJisOu/DvAqc6m07YuRVIKsmQCExhKHctYXFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pRLg362K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pRLg362K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Iqdy8BgNvBZAz5RKVAwX1dUHvT2B23pjS5GgpbE1FOA=; b=pRLg362KDhjSQMsCYKbNiFqMbe
	TR1DlknFJTMCxFwFz9oHiW0BSVZGw6KqWotdSvlRh5q3jq0A2nJaPugX/9oo6kacL4BJ990bo7rw5
	nK9OaiQMi6yXtpTsZ9WbAQcDMONaD9xVGXEi1R0S0Lq7x2hgARRk5AQX0cGGlxKzZ6u+FHocFXINK
	PXL3ddFCfNSpJDMNjNoKQ9ylqvwPAXTfuJq0WKh6B7wj33RExAgpKpg+i+0Jmr4EDZF5bE/S5Vl70
	MUGjAr1EYE/pYjaiWbswN41Q7BT/G6JAoiiSZTcEamg+E3NWAuaHxqnJ70UWhsgcs8nbMdhpOA6LK
	TuVLuFxw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jc-0000000Dlav-11zT;
	Fri, 25 Sep 2026 15:21:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] libxfs: use libxfs.h in xfs_platform.h
Date: Fri, 25 Sep 2026 17:20:20 +0200
Message-ID: <20260925152107.3386097-2-hch@lst.de>
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

xfs_platform.h duplicates a lot of the include chains and some of the
definitions in include/libxfs.h.  Use that header from xfs_plaform.h and
remove the duplication.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_platform.h | 37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index d09fb0aae00f..9aa898200da8 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -37,33 +37,9 @@
 #ifndef _XFS_PLATFORM_H
 #define _XFS_PLATFORM_H
 
-/* CONFIG_XFS_* must be defined to 1 to work with IS_ENABLED() */
-#define CONFIG_XFS_RT 1
-#define CONFIG_XFS_BTREE_IN_MEM 1
-
-#include "libxfs_api_defs.h"
-#include "platform_defs.h"
-#include "xfs.h"
-
-#include "list.h"
-#include "hlist.h"
-#include "cache.h"
-#include "bitops.h"
-#include "kmem.h"
-#include "libfrog/radix-tree.h"
-#include "libfrog/bitmask.h"
-#include "libfrog/div64.h"
-#include "libfrog/util.h"
-#include "atomic.h"
-#include "spinlock.h"
+#include "libxfs.h"
 #include "linux-err.h"
 
-#include "xfs_types.h"
-#include "xfs_arch.h"
-
-#include "xfs_fs.h"
-#include "libfrog/crc32c.h"
-
 #include <sys/xattr.h>
 
 /* Zones used in libxfs allocations that aren't in shared header files */
@@ -77,9 +53,6 @@ extern struct kmem_cache *xfs_trans_cache;
 #define IOMAP_F_SHARED				0x04
 #define xfs_bmbt_to_iomap(a, b, c, d, e, f)	((void) 0)
 
-/* CRC stuff, buffer API dependent on it */
-#define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
-
 /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
 struct iomap {
 	unsigned long long	offset;	/* do not use */
@@ -88,14 +61,6 @@ struct iomap {
 
 #define cancel_delayed_work_sync(work) do { } while(0)
 
-#include "xfs_cksum.h"
-
-/*
- * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
- * every files via a similar include in the kernel xfs_linux.h.
- */
-#include "libxfs_io.h"
-
 /* for all the support code that uses progname in error messages */
 extern char    *progname;
 
-- 
2.53.0

