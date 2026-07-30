Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B323B5DEE
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419127; cv=none; b=iEvpI33hgx+GXeS9ZPJjw1F3PN6JGnWtiRW5r4XYYK9f1RIHtjljiryTSdQwe/Z9Ld17gEhBGs4ZfciWuCCfVjpLarEXdAqQAKDENqejRUou7MMgnDi8SysuzQVAma5Fpd5sj3snU3s407RV5CNKcCTQJLsYg9ibVQD24Tdwkac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419127; c=relaxed/simple;
	bh=6M7AabTlQmOgaL5QKtt8cFUarHyIr6m4JwJGidfp79o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fYsosZt0sTekanmy2ANRx0zdozLJ9CIO+WsEX/5cFirU8lA4vHtMOJe+2Z18+A1561T7sSW0vDSyYt3MIYm7QYHw2cBnq2XgRlAW3ckYtTbp1UQpj6diI7s53RQ4j3J2fng3UGZozlicLmp6CThgeQvowLFSMZvcoIyODP9ByRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com; spf=none smtp.mailfrom=readmodwrite.com; dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b=Q1m0uJIs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b="Q1m0uJIs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954aff6088so19636705e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1785419123; x=1786023923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZT24kAIVuTjDlFHcKpuzH42zP/PuFzG1Btnvr+nrYtk=;
        b=Q1m0uJIsetBPTU9VzZskRHxSkmVZd2Vo9SwXQ49CfYbxkf/+NzAMf3tsmgA2KfnyTW
         JdvMN+RTB+4WeJEzra7I0FS/SLrDzo6IyRFikZ8QdfktAMStyNBH//9xsCh/8EaVLG1H
         25F9aa0QFDu87Fd/TMZEaMGL9EHHBob95pvhk7XeeK5pvTtvDn7HBjDzG1FHFv3v9Z7R
         4XvyWnSxkewJjcIqtbTkpR9NKnCPDuWlNaviilo90wsR4WA/0/eJkLi1ERebRRmRX6+L
         2WCC0KXd+lTmxmJtS2YDxmyb0H/sBlghnTz8iKfmfuz/iMJfT0kE/UFIVdbZdF5ytIwz
         Teog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419123; x=1786023923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZT24kAIVuTjDlFHcKpuzH42zP/PuFzG1Btnvr+nrYtk=;
        b=ekYwY5vWxirWXS0bGbvuEohgRBSdaUzSylkVcx0uwVhyxAZ9xmy3471t1U7sqjVcyw
         ZUJRUzYCek57mYKgSxRoO45GdB0/Ytp0jW1QR+MwLFwmIK792lT2nh0GZ6KB1aLIPBGK
         aDy4X+4HRGCVUdgL2o7soaYk57v2HBK+mTh1bMe+H150rA1JviwolrfM5EYlXsBcns27
         ajf572WJJrc58aCAX2OhTDM7hwgI39fSqNnYAJ9iWuqnGQVci4a3T/8Hh9mwZJJsLXow
         367QBC7Uo4qIpljmECmq9mnZO4U6DbXpKbCvTAUtDLskz2t9Spc9h7BukXMp+HZXotHn
         2wBg==
X-Forwarded-Encrypted: i=1; AHgh+RooV/m4wxd+4mmTIZetXg5XnIcdWUX3XUh5ZuOGWKFJExebziopNsZuQoJmSzRjM13JuUBZKvi5IOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3wntZsS8ylgFSCUJDV+8YlRy6kVhNjgNICD/pTN6vmhS+Hknj
	Nmo0IHvNRvHoZQR8feClCPzAN95QEAmwnDBOlt+6mx+G1AYwTiuHVeUs2uzuP1xH/6I=
X-Gm-Gg: AR+sD10C2vzp4J8+jIT2I3QxC1FwsG8cLlpPQAGDCOz5EOrbvjasfuUB8yIlUmdTLw6
	h62TJ9GTK79WKJSc37b5azDNIaxMJonpa1aDwqN6aGl6QCICi5QjSx0uMtfuinb6Qgypk68l6Oc
	xTZ7izrwB4D+gW2sFPwyfJySYgtt9BYlyuZ9gIGvD8sRvH6UxAc7PDU7LbLJSRDezPmlOnFexfK
	q2OmKj0ikn8Pa0sACeWTytvIQfJlhkHUGeWQO6vqENF8M/v3twUkYKJOvbgcA58EzrJSA4X9yG9
	ejAOK6rmIFnNycTo14ptYnu6n3zIqMe9wFgcvAKa2vckytOj8qB6+oSMYRn10Rjaqu0AP2knKEF
	f9D+22VtABHCMGkQUU2BGsWm8jyqKo1G0q4t51AQj7I62QyNopk8VutP8IdKi35Nne6eZn8ex53
	Sn64fMdH19kTiXhIarV8P9qbGPE4noao0/ywoSCRP8y+CtRQ9ApUnBx1TjKvdYgr4katSd99LRR
	g==
X-Received: by 2002:a05:600c:c8d:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-49800ea20e7mr35521675e9.25.1785419122989;
        Thu, 30 Jul 2026 06:45:22 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ebe::178:11c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49800f19bb3sm59295705e9.4.2026.07.30.06.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:45:22 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	kernel-team@cloudflare.com
Subject: [PATCH] xfs: Test sparse inode allocation near AGFL limits
Date: Thu, 30 Jul 2026 14:45:20 +0100
Message-ID: <20260730134520.3556786-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Matt Fleming <mfleming@cloudflare.com>

Add a regression test for a shutdown in the sparse inode allocation
path. The test builds an AG with no free inodes, a full inobt leaf, full
bnobt/cntbt leaves, and little allocatable space outside the AG
reservations.

The final create reaches the sparse inode fallback. Removing that extent
from free space can grow the free-space btrees and drain the AGFL. The
subsequent inobt insert currently trips a corruption check and shuts
down the filesystem:

  Internal error i != 1 at line 3768 of file fs/xfs/libxfs/xfs_btree.c.

Link: https://lore.kernel.org/linux-xfs/20260717130429.1838767-1-matt@readmodwrite.com/
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 .gitignore            |   1 +
 src/Makefile          |   2 +-
 src/xfs_inode_alloc.c | 285 +++++++++++++++++++++++++++++++++++
 tests/xfs/842         | 341 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out     |   2 +
 5 files changed, 630 insertions(+), 1 deletion(-)
 create mode 100644 src/xfs_inode_alloc.c
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/.gitignore b/.gitignore
index dd77ee30..7c92e5eb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -185,6 +185,7 @@ tags
 /src/uuid_ioctl
 /src/writemod
 /src/writev_on_pagefault
+/src/xfs_inode_alloc
 /src/xfsctl
 /src/xfsfind
 /src/aio-dio-regress/aio-dio-append-write-fallocate-race
diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..9e26ebd1 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint fs-monitor
+	rw_hint fs-monitor xfs_inode_alloc
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/xfs_inode_alloc.c b/src/xfs_inode_alloc.c
new file mode 100644
index 00000000..9995a047
--- /dev/null
+++ b/src/xfs_inode_alloc.c
@@ -0,0 +1,285 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <linux/falloc.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define BLOCK_SIZE 4096ULL
+#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s --selftest\n"
+		"       %s create DIR COUNT\n"
+		"       %s fill FILE\n"
+		"       %s consume FILE BLOCKS\n"
+		"       %s fragment DIR COUNT\n"
+		"       %s punch FILE OFFSET_BLOCKS LENGTH_BLOCKS\n"
+		"       %s trigger DIR\n",
+		prog, prog, prog, prog, prog, prog, prog);
+}
+
+static unsigned long long parse_ull(const char *value, const char *what)
+{
+	char *end;
+	unsigned long long result;
+
+	errno = 0;
+	result = strtoull(value, &end, 0);
+	if (errno || *value == '\0' || *end != '\0') {
+		fprintf(stderr, "invalid %s: %s\n", what, value);
+		exit(EXIT_FAILURE);
+	}
+	return result;
+}
+
+static int create_files(const char *dir, unsigned long long count)
+{
+	char path[4096];
+	unsigned long long i;
+
+	for (i = 0; i < count; i++) {
+		int fd;
+		int len = snprintf(path, sizeof(path), "%s/inode-%08llu", dir, i);
+
+		if (len < 0 || (size_t)len >= sizeof(path)) {
+			fprintf(stderr, "path too long\n");
+			return 1;
+		}
+		fd = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
+		if (fd < 0) {
+			fprintf(stderr, "create %s failed after %llu files: %s\n",
+				path, i, strerror(errno));
+			return 1;
+		}
+		close(fd);
+		if ((i + 1) % 1024 == 0)
+			printf("repro: created %llu/%llu files\n", i + 1, count);
+	}
+	printf("repro: created %llu files\n", count);
+	return 0;
+}
+
+static int fill_file(const char *path)
+{
+	static const unsigned long long chunks[] = {
+		256ULL << 20, 64ULL << 20, 16ULL << 20, 4ULL << 20,
+		1ULL << 20, 256ULL << 10, 64ULL << 10, 16ULL << 10,
+		BLOCK_SIZE,
+	};
+	struct stat st;
+	off_t offset;
+	int fd;
+	size_t i;
+
+	fd = open(path, O_RDWR | O_CREAT | O_CLOEXEC, 0600);
+	if (fd < 0) {
+		perror("open filler");
+		return 1;
+	}
+	if (fstat(fd, &st) < 0) {
+		perror("fstat filler");
+		close(fd);
+		return 1;
+	}
+	offset = st.st_size;
+
+	for (i = 0; i < ARRAY_SIZE(chunks); i++) {
+		unsigned long long allocated = 0;
+		unsigned long long chunk = chunks[i];
+
+		for (;;) {
+			if (fallocate(fd, 0, offset, (off_t)chunk) == 0) {
+				offset += (off_t)chunk;
+				allocated += chunk;
+				if (allocated >= (256ULL << 20)) {
+					printf("repro: filler size=%" PRIu64 " MiB\n",
+						(uint64_t)offset >> 20);
+					allocated = 0;
+				}
+				continue;
+			}
+			if (errno != ENOSPC) {
+				fprintf(stderr, "fallocate %llu bytes at %jd: %s\n",
+					chunk, (intmax_t)offset, strerror(errno));
+				close(fd);
+				return 1;
+			}
+			break;
+		}
+		printf("repro: allocation stopped at chunk=%llu bytes, size=%" PRIu64
+		       " MiB\n", chunk, (uint64_t)offset >> 20);
+	}
+	if (fsync(fd) < 0)
+		perror("fsync filler");
+	close(fd);
+	return 0;
+}
+
+static int fragment_free_space(const char *dir, unsigned long long count)
+{
+	char path[4096];
+	unsigned long long i;
+	int dirfd;
+
+	for (i = 0; i < count; i++) {
+		int fd;
+
+		snprintf(path, sizeof(path), "%s/inode-%08llu", dir, i);
+		fd = open(path, O_RDWR | O_CLOEXEC);
+		if (fd < 0 || fallocate(fd, 0, 0, BLOCK_SIZE) < 0) {
+			fprintf(stderr, "fragment allocation %s failed: %s\n",
+				path, strerror(errno));
+			if (fd >= 0)
+				close(fd);
+			return 1;
+		}
+		close(fd);
+		if ((i + 1) % 2048 == 0)
+			printf("repro: allocated fragment blocks %llu/%llu\n",
+			       i + 1, count);
+	}
+
+	for (i = 0; i < count; i += 2) {
+		int fd;
+
+		snprintf(path, sizeof(path), "%s/inode-%08llu", dir, i);
+		fd = open(path, O_RDWR | O_CLOEXEC);
+		if (fd < 0 || fallocate(fd, FALLOC_FL_PUNCH_HOLE |
+					      FALLOC_FL_KEEP_SIZE,
+					      0, BLOCK_SIZE) < 0) {
+			fprintf(stderr, "fragment punch %s failed: %s\n",
+				path, strerror(errno));
+			if (fd >= 0)
+				close(fd);
+			return 1;
+		}
+		close(fd);
+	}
+
+	dirfd = open(dir, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	if (dirfd >= 0) {
+		syncfs(dirfd);
+		close(dirfd);
+	}
+	printf("repro: created %llu one-block free-space fragments\n",
+	       (count + 1) / 2);
+	return 0;
+}
+
+static int consume_blocks(const char *path, unsigned long long blocks)
+{
+	struct stat st;
+	unsigned long long i;
+	off_t offset;
+	int fd = open(path, O_RDWR | O_CLOEXEC);
+
+	if (fd < 0 || fstat(fd, &st) < 0) {
+		perror("open consumer file");
+		if (fd >= 0)
+			close(fd);
+		return 1;
+	}
+	offset = st.st_size;
+	for (i = 0; i < blocks; i++) {
+		if (fallocate(fd, 0, offset, BLOCK_SIZE) < 0) {
+			fprintf(stderr, "one-block allocation failed at %llu/%llu: %s\n",
+				i, blocks, strerror(errno));
+			close(fd);
+			return 1;
+		}
+		offset += BLOCK_SIZE;
+		if ((i + 1) % 512 == 0)
+			printf("repro: consumed %llu/%llu blocks\n", i + 1, blocks);
+	}
+	fsync(fd);
+	close(fd);
+	printf("repro: consumed %llu blocks\n", blocks);
+	return 0;
+}
+
+static int punch_file(const char *path, unsigned long long offset_blocks,
+		      unsigned long long length_blocks)
+{
+	off_t offset = (off_t)(offset_blocks * BLOCK_SIZE);
+	off_t length = (off_t)(length_blocks * BLOCK_SIZE);
+	int fd = open(path, O_RDWR | O_CLOEXEC);
+
+	if (fd < 0) {
+		perror("open filler for punch");
+		return 1;
+	}
+	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		      offset, length) < 0) {
+		perror("punch hole");
+		close(fd);
+		return 1;
+	}
+	if (fsync(fd) < 0)
+		perror("fsync punched filler");
+	close(fd);
+	printf("repro: punched %llu blocks at file block %llu\n",
+	       length_blocks, offset_blocks);
+	return 0;
+}
+
+static int trigger_create(const char *dir)
+{
+	char path[4096];
+	int fd;
+
+	if (prctl(PR_SET_NAME, "xfs-ialloc-test", 0, 0, 0) < 0) {
+		perror("prctl PR_SET_NAME");
+		return 1;
+	}
+	if (snprintf(path, sizeof(path), "%s/trigger", dir) >= (int)sizeof(path)) {
+		fprintf(stderr, "trigger path too long\n");
+		return 1;
+	}
+	fd = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
+	if (fd < 0) {
+		printf("trigger create failed: errno=%d (%s)\n",
+		       errno, strerror(errno));
+		/* Clean ENOSPC is an acceptable result after the bug is fixed. */
+		return errno == ENOSPC ? 0 : 1;
+	}
+	close(fd);
+	printf("trigger create succeeded\n");
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	setvbuf(stdout, NULL, _IOLBF, 0);
+
+	if (argc == 2 && strcmp(argv[1], "--selftest") == 0) {
+		puts("selftest: ok");
+		return 0;
+	}
+	if (argc == 4 && strcmp(argv[1], "create") == 0)
+		return create_files(argv[2], parse_ull(argv[3], "file count"));
+	if (argc == 3 && strcmp(argv[1], "fill") == 0)
+		return fill_file(argv[2]);
+	if (argc == 4 && strcmp(argv[1], "consume") == 0)
+		return consume_blocks(argv[2], parse_ull(argv[3], "block count"));
+	if (argc == 4 && strcmp(argv[1], "fragment") == 0)
+		return fragment_free_space(argv[2],
+					   parse_ull(argv[3], "file count"));
+	if (argc == 5 && strcmp(argv[1], "punch") == 0)
+		return punch_file(argv[2], parse_ull(argv[3], "hole offset"),
+				  parse_ull(argv[4], "hole length"));
+	if (argc == 3 && strcmp(argv[1], "trigger") == 0)
+		return trigger_create(argv[2]);
+
+	usage(argv[0]);
+	return 2;
+}
diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 00000000..fdab240a
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,341 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Cloudflare, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Regression test for an inode allocation failure after a sparse inode extent
+# grows full free-space btrees and raises the AGFL minimum.  The subsequent
+# inobt leaf split must not trip the i != 1 corruption check.
+#
+. ./common/preamble
+_begin_fstest auto enospc punch prealloc
+
+_cleanup()
+{
+	cd /
+	_scratch_unmount 2>/dev/null
+	rm -f "$tmp".*
+}
+
+. ./common/filter
+
+_require_scratch
+_require_scratch_size $((1024 * 1024))
+_require_check_dmesg
+_require_xfs_db_command agresv
+_require_xfs_io_command bmap
+_require_xfs_io_command fsync
+
+# The state builder depends on an internal log and no realtime section.
+unset SCRATCH_LOGDEV
+unset SCRATCH_RTDEV
+
+_require_xfs_sparse_inodes
+_require_xfs_mkfs_finobt
+
+REPRO=$here/src/xfs_inode_alloc
+TARGET_ALLOCATED=16128 # 252 inode records * 64 inodes
+INOBT_MAXLEVELS=2
+FRAGMENT_FILES=1002
+
+[[ -x $REPRO ]] || _notrun "xfs_inode_alloc helper is not built"
+
+mkfs_opts="-q -K -s size=4096 \
+	-m crc=1,finobt=1,rmapbt=1,reflink=1,inobtcount=1,bigtime=1 \
+	-i size=512,sparse=1,maxpct=25,nrext64=1 \
+	-d size=1g,agcount=2,su=512k,sw=2"
+_scratch_mkfs_xfs_supported $mkfs_opts >/dev/null 2>&1 || \
+	_notrun "mkfs.xfs does not support the required feature set"
+
+min_value()
+{
+	if [ "$1" -lt "$2" ]; then
+		printf '%s\n' "$1"
+	else
+		printf '%s\n' "$2"
+	fi
+}
+
+min_freelist()
+{
+	local bno_level=$1 cnt_level=$2 rmap_level=$3
+	local alloc_maxlevels=$4 rmap_maxlevels=$5 has_rmap=$6
+	local bno_next cnt_next rmap_next total
+
+	bno_next=$(min_value $((bno_level + 1)) "$alloc_maxlevels")
+	cnt_next=$(min_value $((cnt_level + 1)) "$alloc_maxlevels")
+	total=$((bno_next * 2 - 2 + cnt_next * 2 - 2))
+	if [ "$has_rmap" -ne 0 ]; then
+		rmap_next=$(min_value $((rmap_level + 1)) "$rmap_maxlevels")
+		total=$((total + rmap_next * 2 - 2))
+	fi
+	printf '%s\n' "$total"
+}
+
+space_available()
+{
+	local freeblks=$1 flcount=$2 reservation=$3 min_free=$4 minleft=$5
+	local agflcount
+
+	agflcount=$(min_value "$flcount" "$min_free")
+	printf '%s\n' $((freeblks + agflcount - reservation - min_free - minleft))
+}
+
+agi_field()
+{
+	local field=$1
+	$XFS_DB_PROG -r -c 'agi 0' -c "p $field" "$SCRATCH_DEV" 2>/dev/null |
+		awk -v key="$field" '$1 == key { print $3; exit }'
+}
+
+inobt_root_field()
+{
+	local field=$1
+	$XFS_DB_PROG -r -c 'agi 0' -c 'addr root' -c "p $field" \
+		"$SCRATCH_DEV" 2>/dev/null |
+		awk -v key="$field" '$1 == key { print $3; exit }'
+}
+
+agf_field()
+{
+	local field=$1
+	$XFS_DB_PROG -r -c 'agf 0' -c "p $field" "$SCRATCH_DEV" 2>/dev/null |
+		awk -v key="$field" '$1 == key { print $3; exit }'
+}
+
+alloc_root_field()
+{
+	local root=$1 field=$2
+	$XFS_DB_PROG -r -c 'agf 0' -c "addr $root" -c "p $field" \
+		"$SCRATCH_DEV" 2>/dev/null |
+		awk -v key="$field" '$1 == key { print $3; exit }'
+}
+
+ag0_reservation_state()
+{
+	$XFS_DB_PROG -r -c agresv "$SCRATCH_DEV" 2>/dev/null |
+		awk '$1 == "AG" && $2 == "0:" { print $6, $8, $10; exit }'
+}
+
+free_record_covering()
+{
+	local agbno=$1
+	$XFS_DB_PROG -r -c 'agf 0' -c 'addr bnoroot' -c 'type bnobt' \
+		-c 'btdump -i' "$SCRATCH_DEV" 2>/dev/null |
+		awk -v target="$agbno" '/^[0-9]+:\[/ {
+			record = $0
+			sub(/^[^[]*\[/, "", record)
+			sub(/\].*$/, "", record)
+			split(record, value, /,/)
+			start = value[1] + 0
+			blocks = value[2] + 0
+			if (start <= target && target < start + blocks) {
+				print 0, start, blocks
+				exit
+			}
+		}'
+}
+
+largest_ag0_free_extent()
+{
+	$XFS_DB_PROG -r -c 'agf 0' -c 'addr bnoroot' -c 'type bnobt' \
+		-c 'btdump -i' "$SCRATCH_DEV" 2>/dev/null |
+		awk '/^[0-9]+:\[/ {
+			record = $0
+			sub(/^[^[]*\[/, "", record)
+			sub(/\].*$/, "", record)
+			split(record, value, /,/)
+			if (value[2] + 0 > max) {
+				start = value[1] + 0
+				max = value[2] + 0
+			}
+		} END { if (max) print start, max }'
+}
+
+inspect_unmounted()
+{
+	sync -f "$SCRATCH_MNT"
+	_scratch_unmount
+}
+
+mount_fs()
+{
+	_scratch_mount -o noatime,inode64,logbufs=8,logbsize=32k,noquota
+}
+
+release_ag1()
+{
+	local cutoff bytes
+
+	cutoff=$($XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" |
+		awk '$4 == 1 {
+			range = $2
+			gsub(/[\[\]:]/, "", range)
+			split(range, sector, /\.\./)
+			printf "%.0f\n", sector[1] / 8
+			exit
+		}')
+	[[ -n $cutoff ]] || return 1
+	bytes=$((cutoff * 4096))
+	truncate -s "$bytes" "$SCRATCH_MNT/filler"
+	$XFS_IO_PROG -c fsync "$SCRATCH_MNT/filler"
+}
+
+align_filler_eof()
+{
+	local target=$1 cutoff current bytes
+
+	cutoff=$($XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" 2>/dev/null |
+		awk -v target="$target" '$4 == 0 {
+			file_range = $2
+			ag_range = $5
+			gsub(/[\[\]:]/, "", file_range)
+			gsub(/[()]/, "", ag_range)
+			split(file_range, file_sector, /\.\./)
+			split(ag_range, ag_sector, /\.\./)
+			if (int(ag_sector[2] / 8) + 1 == target) {
+				printf "%.0f\n", (file_sector[2] + 1) / 8
+				exit
+			}
+		}')
+	[[ -n $cutoff ]] || return 1
+	current=$(( $(_get_filesize "$SCRATCH_MNT/filler") / 4096 ))
+	if (( cutoff < current )); then
+		bytes=$((cutoff * 4096))
+		truncate -s "$bytes" "$SCRATCH_MNT/filler"
+		$XFS_IO_PROG -c fsync "$SCRATCH_MNT/filler"
+	fi
+}
+
+find_trigger_hole_offset()
+{
+	$XFS_IO_PROG -r -c 'bmap -v' "$SCRATCH_MNT/filler" |
+		awk '$4 == 0 {
+			file_range = $2
+			ag_range = $5
+			gsub(/[\[\]:]/, "", file_range)
+			gsub(/[()]/, "", ag_range)
+			split(file_range, f, /\.\./)
+			split(ag_range, a, /\.\./)
+			file_start = f[1] / 8
+			ag_start = a[1] / 8
+			map_blocks = (f[2] - f[1] + 1) / 8
+			delta = (2 - (ag_start % 8) + 8) % 8
+			if (map_blocks >= delta + 16) {
+				printf "%.0f %.0f\n", file_start + delta, ag_start + delta
+				exit
+			}
+		}'
+}
+
+consume_ag0_headroom()
+{
+	local values free reserved used outside
+
+	values=$(ag0_reservation_state)
+	read -r free reserved used <<<"$values"
+	outside=$((free - (reserved - used)))
+	(( outside <= 0 )) && return 0
+
+	mount_fs
+	"$REPRO" consume "$SCRATCH_MNT/filler" "$outside" >>"$seqres.full" 2>&1 || true
+	inspect_unmounted
+}
+
+_scratch_mkfs_xfs $mkfs_opts >>"$seqres.full" 2>&1
+mount_fs
+: > "$SCRATCH_MNT/filler"
+inspect_unmounted
+
+count=$(agi_field count)
+freecount=$(agi_field freecount)
+allocated=$((count - freecount))
+need=$((TARGET_ALLOCATED - allocated))
+(( need > 0 )) || _fail "invalid initial inode state"
+
+mount_fs
+"$REPRO" create "$SCRATCH_MNT" "$need" >>"$seqres.full" 2>&1 || \
+	_fail "inode population failed"
+inspect_unmounted
+
+count=$(agi_field count)
+freecount=$(agi_field freecount)
+inobt_level=$(inobt_root_field level)
+inobt_recs=$(inobt_root_field numrecs)
+if (( count != TARGET_ALLOCATED || freecount != 0 ||
+      inobt_level != 0 || inobt_recs != 252 )); then
+	_fail "failed to build one full inobt leaf"
+fi
+
+mount_fs
+"$REPRO" fragment "$SCRATCH_MNT" "$FRAGMENT_FILES" >>"$seqres.full" 2>&1 || \
+	_fail "free-space fragmentation failed"
+"$REPRO" fill "$SCRATCH_MNT/filler" >>"$seqres.full" 2>&1 || \
+	_fail "free-space fill failed"
+release_ag1 || _fail "failed to release AG1 filler mappings"
+inspect_unmounted
+
+consume_ag0_headroom
+read -r largest_start _ <<<"$(largest_ag0_free_extent)"
+mount_fs
+align_filler_eof "$largest_start" || _fail "cannot align filler EOF"
+inspect_unmounted
+consume_ag0_headroom
+
+mount_fs
+read -r file_offset agblock <<<"$(find_trigger_hole_offset)"
+[[ -n $file_offset && -n $agblock ]] || _fail "no suitable sparse inode extent"
+"$REPRO" punch "$SCRATCH_MNT/filler" "$file_offset" 8 >>"$seqres.full" 2>&1 || \
+	_fail "failed to create sparse inode extent"
+inspect_unmounted
+
+read -r free reserved used <<<"$(ag0_reservation_state)"
+reservation=$((reserved - used))
+outside=$((free - reservation))
+bno_level=$(agf_field bnolevel)
+cnt_level=$(agf_field cntlevel)
+rmap_level=$(agf_field rmaplevel)
+flcount=$(agf_field flcount)
+bno_recs=$(alloc_root_field bnoroot numrecs)
+cnt_recs=$(alloc_root_field cntroot numrecs)
+inobt_level=$(inobt_root_field level)
+inobt_recs=$(inobt_root_field numrecs)
+minfree=$(min_freelist "$bno_level" "$cnt_level" "$rmap_level" 5 5 1)
+pagf_free=$((free - flcount))
+available=$(space_available "$pagf_free" "$flcount" "$reservation" \
+	"$minfree" "$INOBT_MAXLEVELS")
+cover=$(free_record_covering "$agblock")
+
+printf 'gate free=%d reservation=%d outside=%d fl=%d minfree=%d available=%d levels=%d/%d/%d alloc_recs=%d/%d inobt=%d/%d hole=%d record="%s"\n' \
+	"$free" "$reservation" "$outside" "$flcount" "$minfree" \
+	"$available" "$bno_level" "$cnt_level" "$rmap_level" \
+	"$bno_recs" "$cnt_recs" "$inobt_level" "$inobt_recs" \
+	"$agblock" "$cover" >>"$seqres.full"
+
+if (( available < 7 || available >= 15 || bno_level != 1 ||
+      cnt_level != 1 || bno_recs != 505 || cnt_recs != 505 ||
+      inobt_level != 0 || inobt_recs != 252 || flcount != minfree )) ||
+   [[ $cover != "0 $agblock 8" ]]; then
+	_fail "combined inode allocation precondition not met"
+fi
+
+mount_fs
+set +e
+"$REPRO" trigger "$SCRATCH_MNT" >>"$seqres.full" 2>&1
+trigger_status=$?
+set -e
+sleep 1
+
+if _check_dmesg_for 'Internal error i != 1|invalid sparse inode record|Shutting down filesystem'; then
+	_fail "sparse inode allocation shut down the filesystem"
+fi
+(( trigger_status == 0 )) || _fail "inode allocation failed with an unexpected error"
+
+# Verify that the filesystem remains usable after the allocation attempt.
+$XFS_IO_PROG -c stat "$SCRATCH_MNT" >>"$seqres.full" 2>&1 || \
+	_fail "filesystem is not usable after inode allocation"
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 00000000..643d0528
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+Silence is golden
-- 
2.43.0

