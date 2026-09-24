Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD8345FFBE
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244337; cv=none; b=U+iadKCl4Ei4FDO7odi5xFXMBaARVBf6Mug45BoSh1Rt+YuUkfxFhyFCzQOd3xU9plr37csSZafkLtugVr535mhsRJCJUWZH91nXk6JB2qSyp4JM6ToJan8EHvRmQ9o0ZtM83Dz8kLh9bnWrOOCvixUaozXUA3NognViUWaYkh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244337; c=relaxed/simple;
	bh=geGxSAt0UKZBKA7M0cklyhmYmLgUfaui+Eh4mDYz8Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwKNB6i+a4tprPT8pHAQdgasWSKNzptDU1EaOxJyR9e3vb6GqUaALnaIYrzOsPoZWfjL8CXEoVIpXYaYw4XGhGTgG+URl777+FTy+F00cNx7/HM3UxhNz1RvNz6OOBo+fyJlmZvXGS6ZfiQkZ9e2XuiSlwcvwfzT4UzvlaioBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ipLpb5qT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ipLpb5qT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=csyMPnjHgIN6rEimWKe8BXGaEAeah9itJdnkJ1VAM0o=; b=ipLpb5qTIHc34qzNqybTotZ77/
	xr0s9elrU8U1qMmz38KDFomJGVKT+N1lrPUhGoi4jK0NQ1R+wJJd3sCOBiSx7JaXL9J7coQsEnK4V
	4Y2zEgiHMdsrSpqYsrP5Q12EaWTujFT6l6111aR5G7/vKB1aoBYzb5eo/l/xE74l8OI0DTq3IpAg4
	13mhq0eS+3j9N16mkDImQfgv7rFS5m2dCp7aO77PBYKqwz3aAT9y+y8xQMjDyRHH2AEWuD59fuY4t
	nIZuL4OntdhbWM9YZB833YrrOTLbHmjPJrNVsTc4XuVzXjGsz7Xm2UQH/wgpqqOLzt65DfChO2KT4
	ug3LZfgg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKS-0000000AfAm-2eoc;
	Thu, 24 Sep 2026 10:05:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/32] libfrog: add a crc64_nvme implementation
Date: Thu, 24 Sep 2026 12:03:53 +0200
Message-ID: <20260924100512.2733748-4-hch@lst.de>
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

Imported from the Linux kernel, using and older version as of commit
commit 067bc8717aee ("lib/crc64: add support for arch-optimized
implementations") which doesn't have the relatively complicated
common optimized crc implementation in the current kernel.

Compared to the kernel, libfrog drops the ECMA CRC64 and only keeps the
NVMe one that is used by XFS RT deata checksums.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/Makefile         | 14 +++++++--
 libfrog/crc64.c          | 23 ++++++++++++++
 libfrog/crc64.h          | 25 +++++++++++++++
 libfrog/gen_crc64table.c | 67 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 127 insertions(+), 2 deletions(-)
 create mode 100644 libfrog/crc64.c
 create mode 100644 libfrog/crc64.h
 create mode 100644 libfrog/gen_crc64table.c

diff --git a/libfrog/Makefile b/libfrog/Makefile
index c7bcd6a778d7..8cf07622f01f 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -18,6 +18,7 @@ bitmap.c \
 bulkstat.c \
 convert.c \
 crc32.c \
+crc64.c \
 file_exchange.c \
 flagmap.c \
 fsgeom.c \
@@ -51,6 +52,8 @@ crc32c.h \
 crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
+crc64.h \
+crc64table.h \
 dahashselftest.h \
 div64.h \
 fakelibattr.h \
@@ -80,9 +83,10 @@ zones.h
 GETTEXT_PY = \
 	gettext.py
 
-LSRCFILES += gen_crc32table.c
+LSRCFILES += gen_crc32table.c gen_crc64table.c
 
-LDIRT = gen_crc32table crc32table.h
+LDIRT = gen_crc32table crc32table.h \
+	gen_crc64table crc64table.h
 
 ifeq ($(ENABLE_GETTEXT),yes)
 HAVE_GETTEXT = True
@@ -120,6 +124,12 @@ crc32table.h: gen_crc32table.c crc32defs.h
 	@echo "    [GENERATE] $@"
 	$(Q) ./gen_crc32table > crc32table.h
 
+crc64table.h: gen_crc64table.c
+	@echo "    [CC]     gen_crc64table"
+	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc64table $<
+	@echo "    [GENERATE] $@"
+	$(Q) ./gen_crc64table > crc64table.h
+
 $(GETTEXT_PY): $(GETTEXT_PY).in $(TOPDIR)/include/builddefs
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@HAVE_GETTEXT@|$(HAVE_GETTEXT)|g" \
diff --git a/libfrog/crc64.c b/libfrog/crc64.c
new file mode 100644
index 000000000000..280ac77b16cc
--- /dev/null
+++ b/libfrog/crc64.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * 64-bit CRC calculation based on the NVMe NVM Command Set specication:
+ * using least-significant-bit first bit order:
+ *
+ * x^64 + x^63 + x^61 + x^59 + x^58 + x^56 + x^55 + x^52 + x^49 + x^48 + x^47 +
+ * x^46 + x^44 + x^41 + x^37 + x^36 + x^34 + x^32 + x^31 + x^28 + x^26 + x^23 +
+ * x^22 + x^19 + x^16 + x^13 + x^12 + x^10 + x^9 + x^6 + x^4 + x^3 + 1
+ *
+ * Copyright 2018 SUSE Linux.
+ *   Author: Coly Li <colyli@suse.de>
+ */
+
+#include <stdint.h>
+#include "libfrog/crc64.h"
+#include "crc64table.h"
+
+uint64_t crc64_nvme_generic(uint64_t crc, const uint8_t *p, size_t len)
+{
+	while (len--)
+		crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *p++];
+	return crc;
+}
diff --git a/libfrog/crc64.h b/libfrog/crc64.h
new file mode 100644
index 000000000000..283bd3949577
--- /dev/null
+++ b/libfrog/crc64.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LIBFROG_CRC64_H
+#define _LIBFROG_CRC64_H
+
+#include <stdint.h>
+#include <stddef.h>
+
+uint64_t crc64_nvme_generic(uint64_t crc, const uint8_t *p, size_t len);
+
+/**
+ * crc64_nvme - Calculate CRC64-NVME
+ * @crc: seed value for computation. 0 for a new CRC calculation, or the
+ *	 previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ *
+ * This computes the CRC64 defined in the NVME NVM Command Set Specification,
+ * *including the bitwise inversion at the beginning and end*.
+ */
+static inline uint64_t crc64_nvme(uint64_t crc, const void *p, size_t len)
+{
+	return ~crc64_nvme_generic(~crc, p, len);
+}
+
+#endif /* _LIBFROG_CRC64_H */
diff --git a/libfrog/gen_crc64table.c b/libfrog/gen_crc64table.c
new file mode 100644
index 000000000000..bf88f8c6ffc8
--- /dev/null
+++ b/libfrog/gen_crc64table.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generate lookup table for the table-driven CRC64 calculation.
+ *
+ * gen_crc64table is executed at build time and generates crc64table.h.
+ * This header is included by crc64.c for the table-driven CRC64 calculation.
+ *
+ * See crc64.c for more information about which specification and polynomial
+ * arithmetic that gen_crc64table.c follows to generate the lookup table.
+ *
+ * Copyright 2018 SUSE Linux.
+ *   Author: Coly Li <colyli@suse.de>
+ */
+#include <inttypes.h>
+#include <stdio.h>
+
+#define CRC64_NVME_POLY 0x9A6C9329AC4BC9B5ULL
+
+static uint64_t crc64_nvme_table[256] = {0};
+
+static void generate_reflected_crc64_table(uint64_t table[256], uint64_t poly)
+{
+	uint64_t i, j, c, crc;
+
+	for (i = 0; i < 256; i++) {
+		crc = 0ULL;
+		c = i;
+
+		for (j = 0; j < 8; j++) {
+			if ((crc ^ (c >> j)) & 1)
+				crc = (crc >> 1) ^ poly;
+			else
+				crc >>= 1;
+		}
+		table[i] = crc;
+	}
+}
+
+static void output_table(uint64_t table[256])
+{
+	int i;
+
+	for (i = 0; i < 256; i++) {
+		printf("\t0x%016" PRIx64 "ULL", table[i]);
+		if (i & 0x1)
+			printf(",\n");
+		else
+			printf(", ");
+	}
+	printf("};\n");
+}
+
+static void print_crc64_tables(void)
+{
+	printf("/* this file is generated - do not edit */\n\n");
+	printf("#include <stdint.h>\n");
+
+	printf("\nstatic const uint64_t crc64nvmetable[256] = {\n");
+	output_table(crc64_nvme_table);
+}
+
+int main(int argc, char *argv[])
+{
+	generate_reflected_crc64_table(crc64_nvme_table, CRC64_NVME_POLY);
+	print_crc64_tables();
+	return 0;
+}
-- 
2.53.0

