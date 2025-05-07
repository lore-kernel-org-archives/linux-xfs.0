Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1C61DF25C;
	Wed,  7 May 2025 05:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594779; cv=none; b=DjJhAcFRo8WFAwvODec/clik9FQG0tYAHZNZ1uJJQ12I4Y9swUAtclJ0yl32P3YNEqmIgnVrup5RB/YYDnnQTIaRtgqDMdiUemYGZbhj9mf5VlaMXV4g1K/ejQHFru6rdw+mOv2IuHoI/HX0YWH7tUB7FkfOeWHQQ9vrH5dJak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594779; c=relaxed/simple;
	bh=fo3nU/jP/KpNaZxsPTvs3eB8sLv1pSldGzfhcSw+UX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPYe90FqccQ/hLgZL29G9gbDH3VjOLb/cD8Ivyoy3X2oTylRKPHoWxYx39OcXeTzX4Q3vICN0BHkNVHuWVMbxxZGqfqeKQphbbjxkEl/bD2C1nMATNIMyxz39mC+p5xPVZwUZDrMk/bL3S3nT2Dj/4t0dCAgVlHsMue7TpnXaH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eZgQN4Ux; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eZgQN4Ux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mk700NqpWuMpf5M5Lr58M7i9jBqPSyJMYQek33Xu7S0=; b=eZgQN4UxeXFPd7P8Ksq4W6uxkd
	+WGiwFpHhn5ycg9dgOs10r2B5pjF/4sA+ksD2CX/lAzZydOtSYgNjY1+l7y27juXfsOAG1JVi1BKa
	a0FM0gS581wyk7Sa3OgEtyQYueSfavHSUytjSEnl6Z441uNMuazXw64iM0GKVUY8E3acd8YnCp4q7
	RcbzqcjmJxLTZcgMBKTr4WQlQTqvksDrqnUPnAGgm6u3gLJjq1A6UXc4n5G2OY4HIKeRMSrYJshMn
	b6tRPqthHTOIOU87qvQzJmXYw1hBnrCOCzQl1ynVi6PSOA7rPFz967mklvMml/YeyGyomVaG+ghRx
	w9gt2koA==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5U-0000000EEp6-3DYM;
	Wed, 07 May 2025 05:12:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] add a new rw_hint helper
Date: Wed,  7 May 2025 07:12:22 +0200
Message-ID: <20250507051249.3898395-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a tool to set the life time hint via fcntl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 .gitignore    |  1 +
 src/Makefile  |  3 ++-
 src/rw_hint.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 src/rw_hint.c

diff --git a/.gitignore b/.gitignore
index 4fd817243dca..f22cff8fb6c4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -203,6 +203,7 @@ tags
 /src/aio-dio-regress/aio-last-ref-held-by-io
 /src/aio-dio-regress/aiocp
 /src/aio-dio-regress/aiodio_sparse2
+/src/rw_hint
 /src/vfs/vfstest
 /src/vfs/mount-idmapped
 /src/log-writes/replay-log
diff --git a/src/Makefile b/src/Makefile
index 6ac72b366257..2cc1fb40d9f1 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -35,7 +35,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
-	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment
+	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
+	rw_hint
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/rw_hint.c b/src/rw_hint.c
new file mode 100644
index 000000000000..d4290e4ae369
--- /dev/null
+++ b/src/rw_hint.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Christoph Hellwig
+ */
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+
+int main(int argc, char **argv)
+{
+	uint64_t hint = -1;
+	int fd;
+
+	if (argc < 3) {
+		fprintf(stderr,
+"usage: %s file not_set|none|short|medium|long|extreme\n",
+			argv[0]);
+		return 1;
+	}
+
+	if (!strcmp(argv[2], "not_set"))
+		hint = RWH_WRITE_LIFE_NOT_SET;
+	else if (!strcmp(argv[2], "none"))
+		hint = RWH_WRITE_LIFE_NONE;
+	else if (!strcmp(argv[2], "short"))
+		hint = RWH_WRITE_LIFE_SHORT;
+	else if (!strcmp(argv[2], "medium"))
+		hint = RWH_WRITE_LIFE_MEDIUM;
+	else if (!strcmp(argv[2], "long"))
+		hint = RWH_WRITE_LIFE_LONG;
+	else if (!strcmp(argv[2], "extreme"))
+		hint = RWH_WRITE_LIFE_EXTREME;
+
+	if (hint == -1) {
+		fprintf(stderr, "invalid hint %s\n", argv[2]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_WRONLY);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+	if (fcntl(fd, F_SET_RW_HINT, &hint))
+		perror("fcntl");
+	return 0;
+}
-- 
2.47.2

