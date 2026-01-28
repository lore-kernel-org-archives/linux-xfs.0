Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82163009C1
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769574823; cv=none; b=fd8ASW+hTVxfB+u1YHoxExuoAGyFm/SzZzsa45Xs7ac8dJD8Twxp0yiycJmQIlvP7QNITHG9jERix07MQsAXsuIP1+dFYig6QCicxz1gmASNdRuYQQJnDP/7jBWsKug4lENcOIzjufB5fUsm1iGwXdpWgG7uOwSCQA+r+PZeBB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769574823; c=relaxed/simple;
	bh=p/jnmnWIkkIKceXgom8aUhPRzmoid1/RdvpdGneBqJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLCQ9dNXN7cs7KBwA0XaX6PqVNhu3pBmF1qbPvz8nVCVP9FCF3vPu09wSO6/FOBwVEW6qZBX4i04Vy+01bYdr1FH1YV4n2Gd0wDmyGu2NAz02Zstqo1CKnLv1hyOScZVEZbl8yvzo43lE0ps00TYnK+XTQGnAGFeOKua6jziDZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ctu6Q6Gm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ctu6Q6Gm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cHtGzpu01kdcTY3RXDPI8Nn9oUqhKK9ZMYrYGdCAEpU=; b=Ctu6Q6Gm6yYnggJhC7m2kzp7NI
	1tSfUhbb8BCbG8SR5mH76ltGyPrkrzXUjbp9XA8Lucmshx7YNQs2bBT51NEbVCxN2KYUWA4xEpsxG
	JzzKjKkyPswjLu5gJplZ7F3ojKVHIG8H8XJwbK9+tA21xFM9wwcF/4zSvoyaNmcuSybyv56NWGvCu
	kCh/vfpJrzM2tePdD1hQRgD7lM+hAIw4A8Naq1PNA+f0MbMlGXIN05USuuP35i4GyjY2DJHtvgfCM
	dnbDc0Vn7sY9M4EAEYkS1zBVEJasdORq7HyY1g+kElhi7hXTuRfqLYuN29Cqmq4W/3KffC0Ura4tX
	VDOFwAIw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkxFM-0000000FQbP-45H4;
	Wed, 28 Jan 2026 04:33:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] libfrog: enable cached report zones
Date: Wed, 28 Jan 2026 05:32:59 +0100
Message-ID: <20260128043318.522432-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128043318.522432-1-hch@lst.de>
References: <20260128043318.522432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Modify the function xfrog_report_zones() to default to always trying
first a cached report zones using the BLKREPORTZONEV2 ioctl.
If the kernel does not support BLKREPORTZONEV2, fall back to the
(slower) regular report zones BLKREPORTZONE ioctl.

TO enable this feature even if xfsprogs is compiled on a system where
linux/blkzoned.h does not define BLKREPORTZONEV2, this ioctl is defined
in libfrog/zones.h, together with the BLK_ZONE_REP_CACHED flag and the
BLK_ZONE_COND_ACTIVE zone condition.

Since a cached report zone  always return the condition
BLK_ZONE_COND_ACTIVE for any zone that is implicitly open, explicitly
open or closed, the function xfs_zone_validate_seq() is modified to
handle this new condition as being equivalent to the implicit open,
explicit open or closed conditions.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[hch: don't try cached reporting again if not supported]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h |  6 ++++++
 libfrog/zones.c         | 22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index 1a9f401fc11c..09129e0f22dc 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -312,6 +312,12 @@ struct kvec {
  * Local definitions for the new cached report zones added in Linux 6.19 in case
  * the system <linux/blkzoned.h> doesn't provide them yet.
  */
+#ifndef BLKREPORTZONEV2
+#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
+#endif
+#ifndef BLK_ZONE_REP_CACHED
+#define BLK_ZONE_REP_CACHED	(1U << 31)
+#endif
 #ifndef BLK_ZONE_COND_ACTIVE
 #define BLK_ZONE_COND_ACTIVE	0xff
 #endif
diff --git a/libfrog/zones.c b/libfrog/zones.c
index 2276c56bec9c..c088d3240545 100644
--- a/libfrog/zones.c
+++ b/libfrog/zones.c
@@ -3,12 +3,15 @@
  * Copyright (c) 2025, Western Digital Corporation or its affiliates.
  */
 #include "platform_defs.h"
+#include "atomic.h"
 #include "libfrog/zones.h"
 #include <sys/ioctl.h>
 
 /* random size that allows efficient processing */
 #define ZONES_PER_REPORT		16384
 
+static atomic_t cached_reporting_disabled;
+
 struct xfrog_zone_report *
 xfrog_report_zones(
 	int			fd,
@@ -24,10 +27,27 @@ _("Failed to allocate memory for reporting zones."));
 		}
 	}
 
+	/*
+	 * Try cached report zones first. If this fails, fallback to the regular
+	 * (slower) report zones.
+	 */
 	rep->rep.sector = sector;
 	rep->rep.nr_zones = ZONES_PER_REPORT;
 
-	if (ioctl(fd, BLKREPORTZONE, &rep->rep)) {
+	if (atomic_read(&cached_reporting_disabled))
+		goto uncached;
+
+	rep->rep.flags = BLK_ZONE_REP_CACHED;
+	if (ioctl(fd, BLKREPORTZONEV2, &rep->rep)) {
+		atomic_inc(&cached_reporting_disabled);
+		goto uncached;
+	}
+
+	return rep;
+
+uncached:
+	rep->rep.flags = 0;
+	if (ioctl(fd, BLKREPORTZONE, rep)) {
 		fprintf(stderr, "%s %s\n",
 _("ioctl(BLKREPORTZONE) failed:\n"),
 			strerror(-errno));
-- 
2.47.3

