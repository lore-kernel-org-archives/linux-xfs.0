Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509A73B42FE
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 09:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786960225; cv=none; b=bZ0UwRh1EbKvZWXiUizz53XsizU54jnUlI9lfbRBRCnDXoiRVjGw10YYDtmzDl+iZQeMI58zSJqWPUK23DLS+C8pK0ymsGBpCvkVeCYc0KjnONlENxrYyetY1Jqqqu32oHu8lhfx5N7B0MSxF2Ph1M7x4ODx9bZ4g9OsUn6YsKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786960225; c=relaxed/simple;
	bh=uWF8orLwxEoijm1Gh06k0YjXWGn2fJsbdt7DGpXsnxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLmFJGSo1JnhmxmimEtvqv3Sc5SBHNm8TmCACS3TD/62W8xKcO7k+ZKx1tOozwtnnygTuOol17phIQ60aJll5M9qDyvO6hMRghutwHrx+CCeI+p2nvm0uAOrhHKoLcSVgH6ulnByklnqUNV+iRxJG4D2VHtMkesWRwSlUylV4rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wy6zAanT; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wy6zAanT"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ceaf8a1265so48131305ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 02:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786960222; x=1787565022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dtGOINVlwfH2yT0hV/LWcrRl/ap1zI6ZO5ir4XusDuY=;
        b=Wy6zAanTGWHjnLjPBLtv5A+FQ+thbcJTd3cqB9pPv+pp4q3Fuco0iHLKCvbKL8woDH
         CnW4E519kDPl+00GfOdrdy2QRm1gSSmVfM0rVBazWUx+IZGJS/Wd0ul1VT+HJyP4qyVs
         cUgaRjTBS6bfB+8QZ4nZRACZRqIFbfl7A3ggTFRV2hN34791raoFoLuFAc8+xjkkvsig
         eNAnmoLNMdIJHqUuqu9eJWq6EkpjJT5QhYdhtIg0XDAol65iaf14659zuLlvbQsYX+3Y
         GaoVCtOXuiwka3JVvqEjwUGNspXpCAVx88LG0n1rGpY+EGji/4qsBiqhwlRuc6W/vcjj
         OIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786960222; x=1787565022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dtGOINVlwfH2yT0hV/LWcrRl/ap1zI6ZO5ir4XusDuY=;
        b=R6YnuwnlDDsVs0ROntN0Gn+NScTwER/yoYh1FsjLAgaz+iJYkm6x3WaMyGKzXw83q5
         WLxV2QlxVUkr35y3SJR5cn4v9GeRAfmrKCbya59bF9xdIZ/rQZGZ1X3xpC4deJMHoUKV
         M4Aw2hnSIO+YLwhCaTjyK2Vhr9lEx7qlXLCoK06Lih6CRqxbmySVxR4StSnUeTwavJhh
         c23R/Xj8kCABEHr4za4G15h36ebZYyAj4QSWQiyZowJSDA08vooghz0Rh2+W/ZQYxcxg
         szXYsICYJQKolxNUnqsE5jlyTQm4ipMWIG0ziiaIoFX7kjQ3Ux7HtG2/z3RBdLspEUmR
         l8LQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNXq0d+tQNt7TBF5dRI45CCmFp9JJIh/mn5kb9ZK3JQLgpzayxtApnIl5sTlJYJ7grHcLwJIUiGLs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2/jldXr+iqJF8rbHAIZucHVXIwANT58EQfeW9aT8nSKMEatCo
	+XaCoyU4OcctZUeldJyYLzQWuwOiavjMWj6Y7qVIwKm5maIjxBPJ73um
X-Gm-Gg: AR+sD13Sc64cPNytyhUy4kb/8OgULqDtCpIFScs2IF3T687Kg3VnoGVrD0+vWEmjNEV
	PIFJlpBIDMV0ucGVlaG0v3oDUHD/Utf934OV8//haSuIC9GX2mN6CfrW6ZiJcJ1kI0XD+jHBtpL
	9Gpc5cc5iB15LHLGIuh7dm/Vhv7P9ecKdev1vyWEiPHGIbbC3IAQrarSyznUZfdGpKeo7YSZP8t
	thCXK4h0ZKXyWJzd9gEKG574gLX79TI/4vnDMTIB2FvfCQ0hV/T8PBcOzuh2MbGNWwLF+6h4JAl
	f8CE4BjJ6e6exhctPEWsHTv0fSkKqPfJ+DtIm55R9R9kyhVcIShXQdguhB4iNQ2RRj31pT3iegO
	oGu8QfKB6pldzJjeKg9af29dbkTw4eBvKdO/JS2BqB/bYDDhkttYQqwFFHuO7WcTaKAwzcYakbq
	IMds4bLwqJ3HyqDYamNHFIaEWPmf8MMlgMTftQrRY7jZ/Zhl3CyYtPYcWxEiTDwQkPa64lp6mqc
	LWL9mApyebfEuzjmHZlqmod2hPQjsS6YV9ijCEsgPrZwF8IhYFP7t7fpHTZKMypimHf+9QA+xWW
	O+9LQ6GEJs4RD5jRCZO1fyOSGDCD90UpgdCXtZcvbmh/adNQ5RNM765Giq6CwvI=
X-Received: by 2002:a17:903:144b:b0:2d3:2e86:647a with SMTP id d9443c01a7336-2d3b07effbfmr287095635ad.5.1786960221528;
        Mon, 17 Aug 2026 02:50:21 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5bb499e12sm3187135ad.8.2026.08.17.02.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 02:50:21 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	fdmanana@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [PATCH v2] generic: test FIDEDUPERANGE result reporting with REPORT_PROGRESS
Date: Mon, 17 Aug 2026 17:50:17 +0800
Message-ID: <20260817095017.948979-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260805071839.3423779-1-matthias.goergens@gmail.com>
References: <20260805071839.3423779-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a raw FIDEDUPERANGE helper that reports each destination's
bytes_deduped and status, and a test for the proposed
FILE_DEDUPE_RANGE_REPORT_PROGRESS flag: explicit zero-length success,
a request the VFS shortens for an interior destination, a sub-block
request that makes no progress (zero, no error), and differing
contents (the examined span).  One unflagged case pins the legacy
reporting so the default ABI cannot change silently.

The kernel side is under review:
https://lore.kernel.org/linux-fsdevel/20260805071414.3414870-1-matthias.goergens@gmail.com/
The commit id in _wants_kernel_commit is a placeholder until it lands.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
v2 (per Zorro's review and the kernel thread):
- drop the generic/517 golden-output change: the kernel side is now an
  opt-in flag, so default reporting is unchanged
- test the flag semantics proposed by Darrick in the kernel thread,
  including bytes_deduped as an advance hint on DIFFERS and zero on a
  per-destination error
- sentinel-fill the helper's output fields so the test proves the
  kernel wrote them
- add the helper binary to .gitignore
- use _wants_kernel_commit (placeholder id until the kernel side lands)

Every expected line was produced by a kernel with the flag patch
applied (btrfs scratch under QEMU) rather than written from the spec.
 .gitignore            |   1 +
 src/Makefile          |   2 +-
 src/fideduperange.c   | 166 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806     | 118 ++++++++++++++++++++++++++++++
 tests/generic/806.out |   7 ++
 5 files changed, 293 insertions(+), 1 deletion(-)
 create mode 100644 src/fideduperange.c
 create mode 100755 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/.gitignore b/.gitignore
index 0b6b9452..3d6ce89d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -71,6 +71,7 @@ tags
 /src/cloner
 /src/dbtest
 /src/deduperace
+/src/fideduperange
 /src/detached_mounts_propagation
 /src/devzero
 /src/dio-append-buf-fault
diff --git a/src/Makefile b/src/Makefile
index 76cf50c3..e686fe27 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -25,7 +25,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
-	locktest unwritten_mmap bulkstat_unlink_test deduperace \
+	locktest unwritten_mmap bulkstat_unlink_test deduperace fideduperange \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
diff --git a/src/fideduperange.c b/src/fideduperange.c
new file mode 100644
index 00000000..b36365f6
--- /dev/null
+++ b/src/fideduperange.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Issue a raw FIDEDUPERANGE ioctl and report each destination's result.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <inttypes.h>
+#include <linux/fs.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+/* Local copies of the UAPI types: the system linux/fs.h may predate the
+ * FILE_DEDUPE_RANGE_REPORT_PROGRESS flag.  The layout matches the kernel
+ * UAPI. */
+#ifndef FILE_DEDUPE_RANGE_REPORT_PROGRESS
+#define FILE_DEDUPE_RANGE_REPORT_PROGRESS (1U << 0)
+#endif
+#define FILE_DEDUPE_RANGE_SAME		0
+#define FILE_DEDUPE_RANGE_DIFFERS	1
+
+struct file_dedupe_range_info_local {
+	__s64 dest_fd;
+	__u64 dest_offset;
+	__u64 bytes_deduped;
+	__s32 status;
+	__u32 reserved;
+};
+
+struct file_dedupe_range_local {
+	__u64 src_offset;
+	__u64 src_length;
+	__u16 dest_count;
+	__u16 reserved1;
+	__u32 flags;
+	struct file_dedupe_range_info_local info[0];
+};
+
+#ifndef FIDEDUPERANGE
+#define FIDEDUPERANGE _IOWR(0x94, 54, struct file_dedupe_range_local)
+#endif
+
+static __u32 range_flags;
+
+static void
+usage(const char *progname)
+{
+	fprintf(stderr,
+		"Usage: %s [-f] src src_offset length dest dest_offset "
+		"[dest dest_offset ...]\n"
+		"  -f: set FILE_DEDUPE_RANGE_REPORT_PROGRESS\n",
+		progname);
+	exit(EXIT_FAILURE);
+}
+
+static uint64_t
+parse_u64(const char *arg, const char *name)
+{
+	char *end;
+	unsigned long long value;
+
+	errno = 0;
+	value = strtoull(arg, &end, 0);
+	if (errno || end == arg || *end != '\0') {
+		fprintf(stderr, "Invalid %s: %s\n", name, arg);
+		exit(EXIT_FAILURE);
+	}
+
+	return value;
+}
+
+int
+main(int argc, char **argv)
+{
+	struct file_dedupe_range_local *range;
+	size_t range_size;
+	unsigned int dest_count;
+	unsigned int i;
+	int src_fd;
+	int ret;
+	int c;
+
+	const char *progname = argv[0];
+
+	while ((c = getopt(argc, argv, "f")) != -1) {
+		switch (c) {
+		case 'f':
+			range_flags |= FILE_DEDUPE_RANGE_REPORT_PROGRESS;
+			break;
+		default:
+			usage(progname);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc < 5 || (argc - 3) % 2 != 0)
+		usage(progname);
+
+	dest_count = (argc - 3) / 2;
+	if (dest_count > UINT16_MAX) {
+		fprintf(stderr, "Too many destinations: %u\n", dest_count);
+		return EXIT_FAILURE;
+	}
+
+	range_size = sizeof(*range) +
+		dest_count * sizeof(struct file_dedupe_range_info_local);
+	range = calloc(1, range_size);
+	if (!range) {
+		perror("calloc");
+		return EXIT_FAILURE;
+	}
+
+	src_fd = open(argv[0], O_RDONLY);
+	if (src_fd < 0) {
+		perror(argv[0]);
+		free(range);
+		return EXIT_FAILURE;
+	}
+
+	range->src_offset = parse_u64(argv[1], "source offset");
+	range->src_length = parse_u64(argv[2], "length");
+	range->dest_count = dest_count;
+	range->flags = range_flags;
+
+	for (i = 0; i < dest_count; i++) {
+		const char *dest_path = argv[3 + i * 2];
+
+		range->info[i].dest_fd = open(dest_path, O_RDWR);
+		if (range->info[i].dest_fd < 0) {
+			perror(dest_path);
+			ret = EXIT_FAILURE;
+			goto close_destinations;
+		}
+		range->info[i].dest_offset =
+			parse_u64(argv[4 + i * 2], "destination offset");
+		/* Sentinels: the kernel must overwrite both output fields. */
+		range->info[i].bytes_deduped = ~0ULL;
+		range->info[i].status = INT32_MIN;
+	}
+
+	if (ioctl(src_fd, FIDEDUPERANGE, range) < 0) {
+		perror("FIDEDUPERANGE");
+		ret = EXIT_FAILURE;
+		goto close_destinations;
+	}
+
+	for (i = 0; i < dest_count; i++)
+		printf("destination %u: bytes=%" PRIu64 " status=%d\n", i,
+		       (uint64_t)range->info[i].bytes_deduped,
+		       range->info[i].status);
+	ret = EXIT_SUCCESS;
+
+close_destinations:
+	while (i > 0) {
+		i--;
+		close(range->info[i].dest_fd);
+	}
+	close(src_fd);
+	free(range);
+	return ret;
+}
diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100755
index 00000000..70a5fe36
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,118 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Matthias Goergens. All Rights Reserved.
+#
+# FS QA Test No. 806
+#
+# Check FIDEDUPERANGE result reporting with FILE_DEDUPE_RANGE_REPORT_PROGRESS:
+# bytes_deduped as an advance hint for zero-length, shortened, zero-progress
+# and differing requests, plus one unflagged case pinning the legacy
+# reporting.
+#
+. ./common/preamble
+_begin_fstest auto quick dedupe clone
+
+. ./common/reflink
+
+_require_scratch_dedupe
+_require_test_program "fideduperange"
+
+# Placeholder commit id: the kernel patch is still under review; to be
+# replaced with the real id when it lands (the helper only prints a hint).
+_wants_kernel_commit XXXXXXXXXXXX \
+	"vfs: add FILE_DEDUPE_RANGE_REPORT_PROGRESS flag to FIDEDUPERANGE"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+block_size=$(_get_block_size "$SCRATCH_MNT")
+short_length=$((2 * block_size))
+full_length=$((short_length + 100))
+
+src=$SCRATCH_MNT/src
+src_short=$SCRATCH_MNT/src-short
+src_diff=$SCRATCH_MNT/src-diff
+dest_interior=$SCRATCH_MNT/dest-interior
+dest_eof=$SCRATCH_MNT/dest-eof
+dest_short_eof=$SCRATCH_MNT/dest-short-eof
+dest_diff=$SCRATCH_MNT/dest-diff
+
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$src" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$src_short" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $((full_length + block_size))" \
+	"$dest_interior" >>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 $full_length" "$dest_eof" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x6b 0 100" "$dest_short_eof" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $full_length" "$src_diff" \
+	>>$seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $full_length" "$dest_diff" \
+	>>$seqres.full 2>&1
+
+check_results()
+{
+	local description="$1"
+	local expected="$2"
+	shift 2
+	local result
+	local ret
+
+	result=$($here/src/fideduperange "$@" 2>&1)
+	ret=$?
+	{
+		echo "$description"
+		echo "$result"
+	} >>$seqres.full
+
+	if [ $ret -ne 0 ]; then
+		_fail "$description: ioctl helper failed"
+	fi
+	if [ "$result" != "$expected" ]; then
+		_fail "$description: unexpected ioctl result"
+	fi
+
+	echo "$description"
+}
+
+# With the flag, bytes_deduped is an advance hint: actual bytes on SAME,
+# the examined span on DIFFERS, zero when no further work is possible.
+
+expected="destination 0: bytes=0 status=0"
+check_results "zero length: 0 bytes, SAME" "$expected" \
+	-f "$src" 0 0 "$dest_interior" 0
+
+expected="destination 0: bytes=$short_length status=0
+destination 1: bytes=$full_length status=0"
+check_results "mixed partial request: shortened, full" "$expected" \
+	-f "$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
+
+expected="destination 0: bytes=0 status=0
+destination 1: bytes=100 status=0"
+check_results "sub-block request: zero progress, full" "$expected" \
+	-f "$src_short" 0 100 "$dest_interior" 0 "$dest_short_eof" 0
+
+expected="destination 0: bytes=$block_size status=1"
+check_results "differing contents: DIFFERS with advance hint" "$expected" \
+	-f "$src_diff" 0 "$full_length" "$dest_diff" 0
+
+# On a per-destination error, status carries the errno and bytes_deduped
+# is zero (the huge offset fails VFS validation with EINVAL).
+
+expected="destination 0: bytes=0 status=-22"
+check_results "error: bytes zero on EINVAL" "$expected" \
+	-f "$src" 0 "$full_length" "$dest_interior" 9223372036854775807
+
+# Without the flag, the legacy reporting is unchanged: the requested
+# length is reported even when the VFS shortens the range.
+
+expected="destination 0: bytes=$full_length status=0
+destination 1: bytes=$full_length status=0"
+check_results "unflagged legacy reporting: full length" "$expected" \
+	"$src" 0 "$full_length" "$dest_interior" 0 "$dest_eof" 0
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 00000000..5c436cb3
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,7 @@
+QA output created by 806
+zero length: 0 bytes, SAME
+mixed partial request: shortened, full
+sub-block request: zero progress, full
+differing contents: DIFFERS with advance hint
+error: bytes zero on EINVAL
+unflagged legacy reporting: full length
-- 
2.55.0

