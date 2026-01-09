Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75535CBD4
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975830; cv=none; b=EHjmOMGQw/N3VOormvixyvUibemd/G9Z6/87PT4dHQx+qFdIbuWsftej/7L5CRC++RIJ+Sa3Ox8riE0dWlUsk/aTF+BCE0JvuvPbommzg8iKTh+hLSEpNqiG9RNkzi/csAGKOxn9Ewvs2k5uUd693GOl+joBVEC5rUIrYESmr4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975830; c=relaxed/simple;
	bh=iVHSPUXymAWr4Xvpgn8mXrKoMGueTnmCBFpQaCetb8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX9IY8GUJanWigqqfJaNHhSHsbJyoWq4U6egQCQjF4pJxyU+DTlQgNLmGKLm6gCoPulFBu70CXt5g3uOTOHDYkVOFg1324Be74xRV0zBdhIbIjqw3TUIEvj/fLDnl0hMuUXVA+PbAQHS/VRJiosUo//N9KblNzgjRiLDHzWtnHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q1RHg8UN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q1RHg8UN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Euzv2Ss7BwBaA6N/VTidrndmuDSzcYVFqrCBzTFfFMk=; b=q1RHg8UNqNTmFwNPI63EI5mFlj
	LFmOuF3IAw5rB2TxyX/8PK2eR16eh1BHeGGjZhe03bsIpSKhSa/q383WoGjY6OQV2V4fhEDF3VXYf
	vtuH3M/9ShiTQQQC4J7/1XuyZXceNj+m3AUvbutI7B5zRmSgB1rkrpwx5C8oyNt+IRbMScrGOmE7h
	DiIPbo+YWeS3vLFAomutQT9O+EmKrLYWKeZgF831D/7tAX+8kWv49CC/zJRXWv6hlDvnltVpK2NdL
	Gn7DAV0bvUzg2ZErIEaSJcJmrHPEISpwGGeejqaBPU/zdy5azQPwoCI9sq/VPs8FeTdz7Q/hPSXud
	xPMaEueQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFHA-00000002cCP-1XGW;
	Fri, 09 Jan 2026 16:23:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] libfrog: enable cached report zones
Date: Fri,  9 Jan 2026 17:22:55 +0100
Message-ID: <20260109162324.2386829-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109162324.2386829-1-hch@lst.de>
References: <20260109162324.2386829-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

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
 libfrog/zones.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/libfrog/zones.c b/libfrog/zones.c
index 2276c56bec9c..f1ef0b24c564 100644
--- a/libfrog/zones.c
+++ b/libfrog/zones.c
@@ -3,12 +3,24 @@
  * Copyright (c) 2025, Western Digital Corporation or its affiliates.
  */
 #include "platform_defs.h"
+#include "atomic.h"
 #include "libfrog/zones.h"
 #include <sys/ioctl.h>
 
+/*
+ * Cached report ioctl (/usr/include/linux/blkzoned.h).
+ * Add in Linux 6.19.
+ */
+#ifndef BLKREPORTZONEV2
+#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
+#define BLK_ZONE_REP_CACHED	(1U << 31)
+#endif /* BLKREPORTZONEV2 */
+
 /* random size that allows efficient processing */
 #define ZONES_PER_REPORT		16384
 
+static atomic_t cached_reporting_disabled;
+
 struct xfrog_zone_report *
 xfrog_report_zones(
 	int			fd,
@@ -24,10 +36,27 @@ _("Failed to allocate memory for reporting zones."));
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

