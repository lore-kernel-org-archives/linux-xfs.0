Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B0F27FD44
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975826; cv=none; b=cn3aES61fiXSUj9KmY/S9OO3jHEduJzFyU73vBkHSeaggumBUWlzKokZ+FTteBp7SL32J6R6ysXWR6D82uxpO2u/5noPW4AErNNB/Nq3tE9k0exB8jKzOZqXDjg5qad1Vn87e9sGF3fIKcQexLzMYlpVUgbX9bqiuXiUneAhJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975826; c=relaxed/simple;
	bh=ETyWh3wMYosfC73l5xwIrimvcQAThJbxFwgmy3dDtxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox1qC2H8eJQojGahkFlS5SIfrZYTXuIgj/zTnikpP1rPSrSyNAcSB5K/7rECbmPfBKYtvzuX0t+NOQ06c6pUs3BTpKjGFm97AyfgvtfVdCrnx655jvUqCxv8NMnV7Ol/c8/t++IxEYmAfYsZoo9KGwhmXolZhKQjJfKKUT26Tjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rko0wxf1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rko0wxf1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k2h1zO8BBPSGXVmIST815/9e+udSdCQCG6ZVjxhylPU=; b=rko0wxf1dhtrMcegTpfOCM+EtZ
	Ub57fmNhYvGR47NEx34YvKwV266+wZCvE7ba5AtbdMn0YBwjSXdpQ2x9EIty9MRhy++vbvpITjRtA
	y3IC2+Y4S08L5xuSLlnOM4lTxI/SfHtMzoJ+PaEY6MqVuZ/TkE90n8pV1vfZ5+L+ZWJPvi28wj40c
	LpC0QRa+EeutEaVhS+SMHowchZTSJoAZDAYm3phPzJ/586tv76ItMQe1WKun6KppdMA0sr/5SsowJ
	moNpMnlHCaFYomvEeg6d06ahn9d68U2B9iELBhWpgxVoCsUnASXAbw0zQfcGCJv46tRZKIpz7PE+t
	lz1t8TWQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFH6-00000002cCA-0crn;
	Fri, 09 Jan 2026 16:23:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] libfrog: lift common zone reporting code from mkfs and repair
Date: Fri,  9 Jan 2026 17:22:54 +0100
Message-ID: <20260109162324.2386829-4-hch@lst.de>
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

Define the new helper function xfrog_report_zones() to report zones of
a zoned block device.  This function is implemented in the new file
libfrog/zones.c and defined in the header file libfrog/zones.h and
use it from mkfs and repair instead of the previous open coded versions.

xfrog_report_zones() allocates and returns a struct blk_zone_report
structure, which can be be reused by subsequent invocations.  It is the
responsibility of the caller to free this structure after use.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[hch: refactored to allow buffer reuse]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/Makefile |  6 ++++--
 libfrog/zones.c  | 39 +++++++++++++++++++++++++++++++++++++++
 libfrog/zones.h  | 18 ++++++++++++++++++
 mkfs/xfs_mkfs.c  | 41 ++++++++++++-----------------------------
 repair/zoned.c   | 35 +++++++++++------------------------
 5 files changed, 84 insertions(+), 55 deletions(-)
 create mode 100644 libfrog/zones.c
 create mode 100644 libfrog/zones.h

diff --git a/libfrog/Makefile b/libfrog/Makefile
index 268fa26638d7..9f405ffe3475 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -35,7 +35,8 @@ radix-tree.c \
 randbytes.c \
 scrub.c \
 util.c \
-workqueue.c
+workqueue.c \
+zones.c
 
 HFILES = \
 avl64.h \
@@ -65,7 +66,8 @@ radix-tree.h \
 randbytes.h \
 scrub.h \
 statx.h \
-workqueue.h
+workqueue.h \
+zones.h
 
 GETTEXT_PY = \
 	gettext.py
diff --git a/libfrog/zones.c b/libfrog/zones.c
new file mode 100644
index 000000000000..2276c56bec9c
--- /dev/null
+++ b/libfrog/zones.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025, Western Digital Corporation or its affiliates.
+ */
+#include "platform_defs.h"
+#include "libfrog/zones.h"
+#include <sys/ioctl.h>
+
+/* random size that allows efficient processing */
+#define ZONES_PER_REPORT		16384
+
+struct xfrog_zone_report *
+xfrog_report_zones(
+	int			fd,
+	uint64_t		sector,
+	struct xfrog_zone_report *rep)
+{
+	if (!rep) {
+		rep = calloc(1, struct_size(rep, zones, ZONES_PER_REPORT));
+		if (!rep) {
+			fprintf(stderr, "%s\n",
+_("Failed to allocate memory for reporting zones."));
+			return NULL;
+		}
+	}
+
+	rep->rep.sector = sector;
+	rep->rep.nr_zones = ZONES_PER_REPORT;
+
+	if (ioctl(fd, BLKREPORTZONE, &rep->rep)) {
+		fprintf(stderr, "%s %s\n",
+_("ioctl(BLKREPORTZONE) failed:\n"),
+			strerror(-errno));
+		free(rep);
+		return NULL;
+	}
+
+	return rep;
+}
diff --git a/libfrog/zones.h b/libfrog/zones.h
new file mode 100644
index 000000000000..33c1da7ef192
--- /dev/null
+++ b/libfrog/zones.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025, Western Digital Corporation or its affiliates.
+ */
+#ifndef __LIBFROG_ZONES_H__
+#define __LIBFROG_ZONES_H__
+
+#include <linux/blkzoned.h>
+
+struct xfrog_zone_report {
+	struct blk_zone_report	rep;
+	struct blk_zone		zones[];
+};
+
+struct xfrog_zone_report *
+xfrog_report_zones(int fd, uint64_t sector, struct xfrog_zone_report *rep);
+
+#endif /* __LIBFROG_ZONES_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 215cff8db7b1..9c165f29c298 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -15,6 +15,7 @@
 #include "libfrog/crc32cselftest.h"
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
+#include "libfrog/zones.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -2542,9 +2543,6 @@ struct zone_topology {
 	struct zone_info	log;
 };
 
-/* random size that allows efficient processing */
-#define ZONES_PER_IOCTL			16384
-
 static void
 zone_validate_capacity(
 	struct zone_info	*zi,
@@ -2572,12 +2570,11 @@ report_zones(
 	const char		*name,
 	struct zone_info	*zi)
 {
-	struct blk_zone_report	*rep;
+	struct xfrog_zone_report *rep = NULL;
 	bool			found_seq = false;
-	int			fd, ret = 0;
+	int			fd;
 	uint64_t		device_size;
 	uint64_t		sector = 0;
-	size_t			rep_size;
 	unsigned int		i, n = 0;
 	struct stat		st;
 
@@ -2604,32 +2601,18 @@ report_zones(
 	zi->nr_zones = device_size / zi->zone_size;
 	zi->nr_conv_zones = 0;
 
-	rep_size = sizeof(struct blk_zone_report) +
-		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
-	rep = malloc(rep_size);
-	if (!rep) {
-		fprintf(stderr,
-_("Failed to allocate memory for zone reporting.\n"));
-		exit(1);
-	}
-
 	while (n < zi->nr_zones) {
-		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
+		struct blk_zone *zones;
 
-		memset(rep, 0, rep_size);
-		rep->sector = sector;
-		rep->nr_zones = ZONES_PER_IOCTL;
-
-		ret = ioctl(fd, BLKREPORTZONE, rep);
-		if (ret) {
-			fprintf(stderr,
-_("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
+		rep = xfrog_report_zones(fd, sector, rep);
+		if (!rep)
 			exit(1);
-		}
-		if (!rep->nr_zones)
+
+		if (!rep->rep.nr_zones)
 			break;
 
-		for (i = 0; i < rep->nr_zones; i++) {
+		zones = rep->zones;
+		for (i = 0; i < rep->rep.nr_zones; i++) {
 			if (n >= zi->nr_zones)
 				break;
 
@@ -2676,8 +2659,8 @@ _("Unknown zone type (0x%x) found.\n"), zones[i].type);
 
 			n++;
 		}
-		sector = zones[rep->nr_zones - 1].start +
-			 zones[rep->nr_zones - 1].len;
+		sector = zones[rep->rep.nr_zones - 1].start +
+			 zones[rep->rep.nr_zones - 1].len;
 	}
 
 	free(rep);
diff --git a/repair/zoned.c b/repair/zoned.c
index 206b0158f95f..5102d43e218d 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -7,6 +7,7 @@
 #include "libxfs_priv.h"
 #include "libxfs.h"
 #include "xfs_zones.h"
+#include "libfrog/zones.h"
 #include "err_protos.h"
 #include "zoned.h"
 
@@ -51,8 +52,7 @@ check_zones(
 	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
 	unsigned int		zone_size, zone_capacity;
 	uint64_t		device_size;
-	size_t			rep_size;
-	struct blk_zone_report	*rep;
+	struct xfrog_zone_report *rep = NULL;
 	unsigned int		i, n = 0;
 
 	if (ioctl(fd, BLKGETSIZE64, &device_size))
@@ -67,31 +67,18 @@ check_zones(
 		return;
 	}
 
-	rep_size = sizeof(struct blk_zone_report) +
-		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
-	rep = malloc(rep_size);
-	if (!rep) {
-		do_warn(_("malloc failed for zone report\n"));
-		return;
-	}
-
 	while (n < mp->m_sb.sb_rgcount) {
-		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
-		int ret;
+		struct blk_zone *zones;
 
-		memset(rep, 0, rep_size);
-		rep->sector = sector;
-		rep->nr_zones = ZONES_PER_IOCTL;
+		rep = xfrog_report_zones(fd, sector, rep);
+		if (!rep)
+			return;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
-		if (ret) {
-			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
-			goto out_free;
-		}
-		if (!rep->nr_zones)
+		if (!rep->rep.nr_zones)
 			break;
 
-		for (i = 0; i < rep->nr_zones; i++) {
+		zones = rep->zones;
+		for (i = 0; i < rep->rep.nr_zones; i++) {
 			if (n >= mp->m_sb.sb_rgcount)
 				break;
 
@@ -130,8 +117,8 @@ _("Inconsistent zone capacity!\n"));
 			report_zones_cb(mp, &zones[i]);
 			n++;
 		}
-		sector = zones[rep->nr_zones - 1].start +
-			 zones[rep->nr_zones - 1].len;
+		sector = zones[rep->rep.nr_zones - 1].start +
+			 zones[rep->rep.nr_zones - 1].len;
 	}
 
 out_free:
-- 
2.47.3

