Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7207B365;
	Wed, 14 Aug 2024 04:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611162; cv=none; b=W+R1RhD9CYZ9XSVzOfCqWxnvsd2v2KwKA1BZqHFlLd4Yaub85FiIHyYLs3QZjuuudwUlp7R+Q7/U3IOiZHk15yuWD1dzF61bl0Apq5cP6rQ1Re7bUGI28ajOS+TLDI9BbdR1U8dVkXFl0Ts0XDBFlXQfJ1PFkI1UKO37sbux6TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611162; c=relaxed/simple;
	bh=FwkxUtA85ZvpMvh2lhqmJu3bVm/8V7EiKneeXMlzM4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVz+D2+Eay0HQ+efNnm/jj6tPIrjhn662Hwb+sZ1Fq4CdvRaFDMUTXkZbNJkL/D+S1m5pzJtDZJKVeR42CdeDm4mwObQn11h1AWZ3r4dMX8NpyFX2zb6i/5QBuN+k3yVvKOXzY4mPpXHnXs2Ke2FTaMdmS9YTcMxlnD8dzfxvfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P9i074bz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9i074bz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DujxcGjdRTBQfRrN5G4VMYkrTO1OM4IYiQKSOFoAUVU=; b=P9i074bzvGHgazegXUeTNWbMrp
	g52ghoYubviqTChk1j6X/OVf9gk7S0GFCsOpvrtWoPV38RzDr4mBwBwRw2vf7oDX0zqFcDQP6W7PZ
	wETNQO+WvVJmXqxKyeJV/gmMbYco+5ZDL5djE/qK+fYvJjJt4zgU1I3scHHdyoVVGIS6cZ3e3ona6
	lJ/bDjdP5ZRdJzWzr1ZPl+9HHCmRDhstxAwpKBwVU6RKyI+7tdAjuuiTQ2/5mX9u3cWea+zVEhqGH
	jlGBL8uk/3S2E+S6tyZ9EjLTSL6zKYWL8+svKxWFMk27FZwS5z1sMCq0NerSXycOmx3idHdKMCdIQ
	FckwGe3A==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se5zz-00000005jLF-2GsN;
	Wed, 14 Aug 2024 04:52:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] add a new min_dio_alignment helper
Date: Wed, 14 Aug 2024 06:52:11 +0200
Message-ID: <20240814045232.21189-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814045232.21189-1-hch@lst.de>
References: <20240814045232.21189-1-hch@lst.de>
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
 .gitignore              |  1 +
 src/Makefile            |  2 +-
 src/min_dio_alignment.c | 66 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 src/min_dio_alignment.c

diff --git a/.gitignore b/.gitignore
index 97c7e0014..36083e9d3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -207,6 +207,7 @@ tags
 /src/log-writes/replay-log
 /src/perf/*.pyc
 /src/fiemap-fault
+/src/min_dio_alignment
 
 # Symlinked files
 /tests/generic/035.out
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
index 000000000..131f60236
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
+static int min_dio_alignment(const char *mntpnt, const char *devname)
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
+	printf("%d\n", min_dio_alignment(argv[1], argv[2]));
+	exit(0);
+}
-- 
2.43.0

