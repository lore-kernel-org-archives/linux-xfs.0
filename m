Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF9C23D7CE
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199481; cv=none; b=pjJ3dG6PMvQzCdsKeWhEDV13fg6zQn7Tbxxqs8CMhQA5d+Dd2iNpwu+rEzM3H2zuA6ze24DVKBDaq1iyDRC5lRM4EIiV9rxnRZAqt+05P1JuroOQpwKKuHY/eLYoDYfmDs5WZNO41BBQKcl/tlV05GCohnRmVtZK8JOJNdY+Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199481; c=relaxed/simple;
	bh=XxilWoJWVVEry/mEgGqShdNGHYJxpG2cBIQkGZVCCZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5SBtiaXlnY+xC/x1j+FNHwpaES2JiWlhakPd/qksCykAdPzXHEPdoK+rFS/mjbsgEeAF61ZmIXhs2hfsg1Qigel4LqXX5WatzOOjoQdbQr+yfIghU/taUhky+cLPWsO6NHTVu+ckPjnB3q4Pm8P+wadotVns7UXEvkB6rsG1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZSzZ0Yv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZSzZ0Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E47C16AAE;
	Sat, 20 Dec 2025 02:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199480;
	bh=XxilWoJWVVEry/mEgGqShdNGHYJxpG2cBIQkGZVCCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZSzZ0YvTzs1o18XjullFGwmsMB0HZbOirlVLw4GNIUp3jeCkBwjc6fuY4Ajw+WjR
	 82a/jKXzqpnG0gkEOQnpXgpxzJt4Dqf7pv88lEWz7LKIhaMvbNGX8d/VL4sEXDtCZH
	 1snBhKD6c4AkB34E6eBSAQUaHFktEpn2jjsQ/w4yaplh8CT5tHgFC60gzGhhzWUjW2
	 wUPYqDGR4XVKsn10g+O/vLCsQs/kBIIhBvjO2LGeXVTSC3wy89BVcvKPLeCoOixnAv
	 22drgZ1XWlZ+YC9bG4bm/lgqOmleVqh9y/KsEeEDXnRwsv3sd6Hy6D1D0OSZtJM9HI
	 O8kNlLMlI2q5A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 3/6] libfrog: introduce xfrog_report_zones
Date: Sat, 20 Dec 2025 11:53:23 +0900
Message-ID: <20251220025326.209196-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251220025326.209196-1-dlemoal@kernel.org>
References: <20251220025326.209196-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the new helper function xfrog_report_zones() to report zones of
a zoned block device. This function is implemented in the new file
libfrog/zones.c and defined in the header file libfrog/zones.h.

xfrog_report_zones() allocates and returns a struct blk_zone_report
structure. It is the responsibility of the caller to free this
structure after use.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 libfrog/Makefile |  6 ++++--
 libfrog/zones.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 libfrog/zones.h  | 13 +++++++++++++
 3 files changed, 59 insertions(+), 2 deletions(-)
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
index 000000000000..0187edce5fa4
--- /dev/null
+++ b/libfrog/zones.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025, Western Digital Corporation or its affiliates.
+ */
+#include "platform_defs.h"
+#include "zones.h"
+#include <sys/ioctl.h>
+
+/* random size that allows efficient processing */
+#define ZONES_PER_REPORT		16384
+
+struct blk_zone_report	*
+xfrog_report_zones(
+	int			fd,
+	uint64_t		sector)
+{
+	struct blk_zone_report	*rep;
+	size_t			rep_size;
+	int			ret;
+
+	rep_size = sizeof(struct blk_zone_report) +
+		   sizeof(struct blk_zone) * ZONES_PER_REPORT;
+	rep = calloc(1, rep_size);
+	if (!rep) {
+		fprintf(stderr,
+_("Failed to allocate memory for reporting zones.\n"));
+		return NULL;
+	}
+
+	rep->sector = sector;
+	rep->nr_zones = ZONES_PER_REPORT;
+
+	ret = ioctl(fd, BLKREPORTZONE, rep);
+	if (ret) {
+		fprintf(stderr,
+_("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
+		free(rep);
+		return NULL;
+	}
+
+	return rep;
+}
diff --git a/libfrog/zones.h b/libfrog/zones.h
new file mode 100644
index 000000000000..66df7a426a27
--- /dev/null
+++ b/libfrog/zones.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025, Western Digital Corporation or its affiliates.
+ */
+#ifndef __LIBFROG_ZONE_H__
+#define __LIBFROG_ZONE_H__
+
+#include <stdint.h>
+#include <linux/blkzoned.h>
+
+struct blk_zone_report	*xfrog_report_zones(int	fd, uint64_t sector);
+
+#endif /* __LIBFROG_ZONE_H__ */
-- 
2.52.0

