Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138EF4963A;
	Tue, 13 Aug 2024 07:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534540; cv=none; b=MBBqCLnowqtY5FIgyTG7NNaVbYALplNmy7MmcEt9pVHlicuN34JI7pBIrJICp1hBYUREhvPMsYcelm39DqPuQ4iqB1SfOoKLmXxpg/pRQe5xzf5IK2/ci0YrGlugmUDWjw7r6R/RcYmbUgZsi8mbeJyOJpVCYqS3CZmwqYamwGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534540; c=relaxed/simple;
	bh=zvB8pz0JGgmEiUSpMl0V2lkxvLX3TtS1nRUrbE4kwsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIgEVXuEZng2iEhvdCdUTfpYp80s+8xcsiZP2j1MYKE4zyP3R3Vyh+k6eLEWyeUP1jfNiFPpT/U5xGFDBxxxqqnITIAn+jbpHfUycbvc7P/0AAr+dAn5x8mxCD00pKBWr5kjvaG4hPuRjx6nXJAT6PMPXOUpK1rCEV/lBgRN8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QdtwIgzX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QdtwIgzX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JtftmwHqZb/jp0LR1s8R7mO42IavgSwsFgMWe1HxMGE=; b=QdtwIgzXVQee+DygvzoadbSVM/
	4SZgY0bYGvjZiA0SXWfRDueaTluPhW624BbQisur3DYa2UphwJEsW2yiAaP8Ziqv+IsQSexXEEmFa
	UC9ysawEWxjzozJoNZyDMSdgzRCnl+VIkIUqe2PffgfYn8UqAJzcjDiKtvqYrVt9GC8njExYMSD7b
	Su31kf0784Axv637attAAYG9SsUC5d+MdBfgiSXhLwKIy3FvIzcl3Ckykn0d7GiBg4Slq9GI8XxHo
	Od8SFSqcGUiK/MKe0ZikU8nCpXu7TFDyDahSKBypLISecCm+S0BscrPgSCKtkeRjy1NZ2T8aMzKJq
	1Zj9uXJA==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm49-00000002kWH-3mF5;
	Tue, 13 Aug 2024 07:35:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] add a new min_dio_alignment helper
Date: Tue, 13 Aug 2024 09:35:01 +0200
Message-ID: <20240813073527.81072-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073527.81072-1-hch@lst.de>
References: <20240813073527.81072-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new C program to find the minimum direct I/O alignment.  This
uses the statx stx_dio_offset_align field if provided, then falls
back to the BLKSSZGET ioctl for block backed file systems and finally
the page size.  It is intended as a more capable replacement for the
_min_dio_alignment bash helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 src/Makefile            |  2 +-
 src/min_dio_alignment.c | 66 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 src/min_dio_alignment.c

diff --git a/src/Makefile b/src/Makefile
index 559209be9..b3da59a0e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -34,7 +34,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
-	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault
+	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/min_dio_alignment.c b/src/min_dio_alignment.c
new file mode 100644
index 000000000..c3345bfb2
--- /dev/null
+++ b/src/min_dio_alignment.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Christoph Hellwig
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mount.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include "statx.h"
+
+static int min_dio_alignmenent(const char *mntpnt, const char *devname)
+{
+	struct statx stx = { };
+	struct stat st;
+	int fd;
+
+	/*
+	 * If the file system supports STATX_DIOALIGN, use the dio_offset_align
+	 * member, as that reports exactly the information that we are asking
+	 * for.
+	 *
+	 * STATX_DIOALIGN is only reported on regular files, so use O_TMPFILE
+	 * to create one without leaving a trace.
+	 */
+	fd = open(mntpnt, O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	if (fd >= 0 &&
+	    xfstests_statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
+	    (stx.stx_mask & STATX_DIOALIGN))
+		return stx.stx_dio_offset_align;
+
+	/*
+	 * If we are on a block device and no explicit aligned is reported, use
+	 * the logical block size as a guestimate.
+	 */
+	if (stat(devname, &st) == 0 && S_ISBLK(st.st_mode)) {
+		int dev_fd = open(devname, O_RDONLY);
+		int logical_block_size;
+
+		if (dev_fd > 0 &&
+		    fstat(dev_fd, &st) == 0 &&
+		    S_ISBLK(st.st_mode) &&
+		    ioctl(dev_fd, BLKSSZGET, &logical_block_size)) {
+			return logical_block_size;
+		}
+	}
+
+	/*
+	 * No support for STATX_DIOALIGN and not a block device:
+	 * default to PAGE_SIZE.
+	 */
+	return getpagesize();
+}
+
+int main(int argc, char **argv)
+{
+	if (argc != 3) {
+		fprintf(stderr, "usage: %s mountpoint devicename\n", argv[0]);
+		exit(1);
+	}
+
+	printf("%d\n", min_dio_alignmenent(argv[1], argv[2]));
+	exit(0);
+}
-- 
2.43.0

