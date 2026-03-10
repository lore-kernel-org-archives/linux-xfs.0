Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE4636C9ED;
	Tue, 10 Mar 2026 03:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114608; cv=none; b=CGVBuWXVdjNGIopINAwnWHcDYfmthoErr90RbbrTwkEqIBgOikxa0nv0D4g/7mv9MqxksT5B//dfrhWO8YiwCxU2renuFaimcMNB7AzvvwSEsqhNO6Xh6tvATUCiQ/MoOIpMCbKscW9fzyTIIm1d7zgtzi0aeMweamD0/XsEkpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114608; c=relaxed/simple;
	bh=QEBshE9Lx4urYaju01xowfaes4oSxb/d9gR/RAoujhE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Crp0Bjlp0qjqErsrzEjL+qf7FcQLiEpVGqoE7k9rYWbSTbaC5jmsm6BwXU7JyIRY9iVlsC4nvfBeaSa/F+hh0TaqDyJqgG8Ox1BG8bYUXxdm45OBS5KLFEtHlI0RpvdrI2L2gkmJ3dV78BOlg8r/t+GnljCxM4btxHLW3k8IPH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JakoK9sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JakoK9sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97826C2BC9E;
	Tue, 10 Mar 2026 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114608;
	bh=QEBshE9Lx4urYaju01xowfaes4oSxb/d9gR/RAoujhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JakoK9syIycToobRDER2dqgpNd/vNMEEMdEA6q18ArtuapRzB3EtkuRIef1eY1/rG
	 giU4B+zEt59kSsVLh6wX9ABacADaABRwF5dJUwjvtcDieI4+pHre30Z2i6H/sJGfaj
	 L0cpV/ii616aoan7hLpPtn0RiwzbfSLvAIuwu1GIXO8ftp2ZR7gZfPXdoyXjyBrB7J
	 BitQ8l7THcAih0CBT81wfQJI/zbXiIe1cgAtCcMBsYIAOXSaOBDPTIaNWHD7a/o4z2
	 jFXaLnGy9I+eH+YMgnIo1Bw7RG+0ChFV57PNmaNc1DDeTPTwCJDxXRZvuUZFBsxNPy
	 wcnGT0+ZDT68Q==
Date: Mon, 09 Mar 2026 20:50:08 -0700
Subject: [PATCH 1/1] generic: test fsnotify filesystem error reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: jack@suse.cz, fstests@vger.kernel.org, amir73il@gmail.com,
 gabriel@krisman.be, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test the fsnotify filesystem error reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc              |   25 ++++++
 doc/group-names.txt    |    1 
 src/Makefile           |    2 
 src/fs-monitor.c       |  153 ++++++++++++++++++++++++++++++++++
 tests/generic/1838     |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1838.out |   20 ++++
 6 files changed, 414 insertions(+), 1 deletion(-)
 create mode 100644 src/fs-monitor.c
 create mode 100755 tests/generic/1838
 create mode 100644 tests/generic/1838.out


diff --git a/common/rc b/common/rc
index fd4ca9641822cf..ccb78baf5bd41a 100644
--- a/common/rc
+++ b/common/rc
@@ -3013,6 +3013,11 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"healthmon")
+		test -z "$param" && param="-p"
+		testio=`$XFS_IO_PROG -c "healthmon $param" $TEST_DIR 2>&1`
+		param_checked="$param"
+		;;
 	"label")
 		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
 		;;
@@ -6149,6 +6154,26 @@ _require_max_file_range_blocks()
 	esac
 }
 
+_require_fanotify_ioerrors()
+{
+	local x
+
+	case "$FSTYP" in
+	xfs)
+		# added as a part of xfs health monitoring
+		_require_xfs_io_command healthmon
+		return 0
+		;;
+	ext4)
+		# added at the same time as err_report_sec
+		x="$(_get_fs_sysfs_attr $TEST_DEV err_report_sec)"
+		test -n "$x" && return 0
+		;;
+	esac
+
+	_notrun "$FSTYP does not support fanotify ioerrors"
+}
+
 ################################################################################
 # make sure this script returns success
 /bin/true
diff --git a/doc/group-names.txt b/doc/group-names.txt
index 10b49e50517797..158f84d36d3154 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -117,6 +117,7 @@ samefs			overlayfs when all layers are on the same fs
 scrub			filesystem metadata scrubbers
 seed			btrfs seeded filesystems
 seek			llseek functionality
+selfhealing		self healing filesystem code
 selftest		tests with fixed results, used to validate testing setup
 send			btrfs send/receive
 shrinkfs		decreasing the size of a filesystem
diff --git a/src/Makefile b/src/Makefile
index 577d816ae859b6..1c761da0ccff20 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint
+	rw_hint fs-monitor
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/fs-monitor.c b/src/fs-monitor.c
new file mode 100644
index 00000000000000..0cf09677a3efda
--- /dev/null
+++ b/src/fs-monitor.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2021, Collabora Ltd.
+ * Copied from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/fanotify/fs-monitor.c
+ */
+
+#include <errno.h>
+#include <err.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/fanotify.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#ifndef FAN_FS_ERROR
+#define FAN_FS_ERROR		0x00008000
+#define FAN_EVENT_INFO_TYPE_ERROR	5
+
+struct fanotify_event_info_error {
+	struct fanotify_event_info_header hdr;
+	__s32 error;
+	__u32 error_count;
+};
+#endif
+
+#ifndef FILEID_INO32_GEN
+#define FILEID_INO32_GEN	1
+#endif
+
+#ifndef FILEID_INVALID
+#define	FILEID_INVALID		0xff
+#endif
+
+static void print_fh(struct file_handle *fh)
+{
+	int i;
+	uint32_t *h = (uint32_t *) fh->f_handle;
+
+	printf("\tfh: ");
+	for (i = 0; i < fh->handle_bytes; i++)
+		printf("%hhx", fh->f_handle[i]);
+	printf("\n");
+
+	printf("\tdecoded fh: ");
+	if (fh->handle_type == FILEID_INO32_GEN)
+		printf("inode=%u gen=%u\n", h[0], h[1]);
+	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
+		printf("Type %d (Superblock error)\n", fh->handle_type);
+	else
+		printf("Type %d (Unknown)\n", fh->handle_type);
+
+}
+
+static void handle_notifications(char *buffer, int len)
+{
+	struct fanotify_event_metadata *event =
+		(struct fanotify_event_metadata *) buffer;
+	struct fanotify_event_info_header *info;
+	struct fanotify_event_info_error *err;
+	struct fanotify_event_info_fid *fid;
+	int off;
+
+	for (; FAN_EVENT_OK(event, len); event = FAN_EVENT_NEXT(event, len)) {
+
+		if (event->mask != FAN_FS_ERROR) {
+			printf("unexpected FAN MARK: %llx\n",
+							(unsigned long long)event->mask);
+			goto next_event;
+		}
+
+		if (event->fd != FAN_NOFD) {
+			printf("Unexpected fd (!= FAN_NOFD)\n");
+			goto next_event;
+		}
+
+		printf("FAN_FS_ERROR (len=%d)\n", event->event_len);
+
+		for (off = sizeof(*event) ; off < event->event_len;
+		     off += info->len) {
+			info = (struct fanotify_event_info_header *)
+				((char *) event + off);
+
+			switch (info->info_type) {
+			case FAN_EVENT_INFO_TYPE_ERROR:
+				err = (struct fanotify_event_info_error *) info;
+
+				printf("\tGeneric Error Record: len=%d\n",
+				       err->hdr.len);
+				printf("\terror: %d\n", err->error);
+				printf("\terror_count: %d\n", err->error_count);
+				break;
+
+			case FAN_EVENT_INFO_TYPE_FID:
+				fid = (struct fanotify_event_info_fid *) info;
+
+				printf("\tfsid: %x%x\n",
+#if defined(__GLIBC__)
+				       fid->fsid.val[0], fid->fsid.val[1]);
+#else
+				       fid->fsid.__val[0], fid->fsid.__val[1]);
+#endif
+				print_fh((struct file_handle *) &fid->handle);
+				break;
+
+			default:
+				printf("\tUnknown info type=%d len=%d:\n",
+				       info->info_type, info->len);
+			}
+		}
+next_event:
+		printf("---\n\n");
+		fflush(stdout);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+
+	char buffer[BUFSIZ];
+
+	if (argc < 2) {
+		printf("Missing path argument\n");
+		return 1;
+	}
+
+	fd = fanotify_init(FAN_CLASS_NOTIF|FAN_REPORT_FID, O_RDONLY);
+	if (fd < 0) {
+		perror("fanotify_init");
+		errx(1, "fanotify_init");
+	}
+
+	if (fanotify_mark(fd, FAN_MARK_ADD|FAN_MARK_FILESYSTEM,
+			  FAN_FS_ERROR, AT_FDCWD, argv[1])) {
+		perror("fanotify_mark");
+		errx(1, "fanotify_mark");
+	}
+
+	printf("fanotify active\n");
+	fflush(stdout);
+
+	while (1) {
+		int n = read(fd, buffer, BUFSIZ);
+
+		if (n < 0)
+			errx(1, "read");
+
+		handle_notifications(buffer, n);
+	}
+
+	return 0;
+}
diff --git a/tests/generic/1838 b/tests/generic/1838
new file mode 100755
index 00000000000000..940811baae3a6e
--- /dev/null
+++ b/tests/generic/1838
@@ -0,0 +1,214 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1838
+#
+# Check that fsnotify can report file IO errors.
+
+. ./common/preamble
+_begin_fstest auto quick eio selfhealing
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	test -n "$fsmonitor_pid" && kill -TERM $fsmonitor_pid
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+. ./common/systemd
+
+_require_scratch
+_require_dm_target error
+_require_test_program fs-monitor
+_require_xfs_io_command "fiemap"
+_require_odirect
+_require_fanotify_ioerrors
+
+# no out of place writes
+test "$FSTYP" = "xfs" && _require_no_xfs_always_cow
+
+# fsnotify only gives us a file handle, the error number, and the number of
+# times it was seen in between event deliveries.   The handle is mostly useless
+# since we have no generic way to map that to a file path.  Therefore we can
+# only coalesce all the I/O errors into one report.
+filter_fsnotify_errors() {
+	_filter_scratch | \
+		grep -E '(FAN_FS_ERROR|Generic Error Record|error: 5)' | \
+		sed -e "s/len=[0-9]*/len=XXX/g" | \
+		sort | \
+		uniq
+}
+
+_scratch_mkfs >> $seqres.full
+
+#
+# The dm-error map added by this test doesn't work on zoned devices because
+# table sizes need to be aligned to the zone size, and even for zoned on
+# conventional this test will get confused because of the internal RT device.
+#
+# That check requires a mounted file system, so do a dummy mount before setting
+# up DM.
+#
+_scratch_mount
+test $FSTYP = xfs && _require_xfs_scratch_non_zoned
+_scratch_unmount
+
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+test $FSTYP = xfs && _xfs_force_bdev data $SCRATCH_MNT
+
+# Write a file with 4 file blocks worth of data, figure out the LBA to target
+victim=$SCRATCH_MNT/a
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
+
+awk_len_prog='{print $4}'
+bmap_str="$($XFS_IO_PROG -c "fiemap -v" $victim | grep "^[[:space:]]*0:")"
+echo "$bmap_str" >> $seqres.full
+
+phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
+kernel_sectors_per_fs_block=$((fs_blksz / 512))
+
+# Did we get at least 4 fs blocks worth of extent?
+min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
+test "$len" -lt $min_len_sectors && \
+	_fail "could not format a long enough extent on an empty fs??"
+
+phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
+
+echo "$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full
+
+# Set the dmerror table so that all IO will pass through.
+_dmerror_reset_table
+
+cat >> $seqres.full << ENDL
+dmerror before:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+# All sector numbers that we feed to the kernel must be in units of 512b, but
+# they also must be aligned to the device's logical block size.
+logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+kernel_sectors_per_device_lba=$((logical_block_size / 512))
+
+# Mark as bad one of the device LBAs in the middle of the extent.  Target the
+# second LBA of the third block of the four-block file extent that we allocated
+# earlier, but without overflowing into the fourth file block.
+bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
+bad_len=$kernel_sectors_per_device_lba
+if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
+	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
+fi
+if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
+	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
+fi
+
+# Remount to flush the page cache, start fsnotify, and make the LBA bad
+_dmerror_unmount
+_dmerror_mount
+
+$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
+fsmonitor_pid=$!
+sleep 1
+
+_dmerror_mark_range_bad $bad_sector $bad_len
+
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+# See if buffered reads pick it up
+echo "Try buffered read"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Now mark the bad range good so that unmount won't fail due to IO errors.
+echo "Fix device"
+_dmerror_mark_range_good $bad_sector $bad_len
+_dmerror_load_error_table
+
+cat >> $seqres.full << ENDL
+dmerror after marking good:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+# Unmount filesystem to start fresh
+echo "Kill fsnotify"
+_dmerror_unmount
+sleep 1
+kill -TERM $fsmonitor_pid
+unset fsmonitor_pid
+echo fsnotify log >> $seqres.full
+cat $tmp.fsmonitor >> $seqres.full
+cat $tmp.fsmonitor | filter_fsnotify_errors
+
+# Start fsnotify again so that can verify that the errors don't persist after
+# we flip back to the good dm table.
+echo "Remount and restart fsnotify"
+_dmerror_mount
+$here/src/fs-monitor $SCRATCH_MNT > $tmp.fsmonitor &
+fsmonitor_pid=$!
+sleep 1
+
+# See if buffered reads pick it up
+echo "Try buffered read again"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read again"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write again"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write again"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Unmount fs and kill fsnotify, then wait for it to finish
+echo "Kill fsnotify again"
+_dmerror_unmount
+sleep 1
+kill -TERM $fsmonitor_pid
+unset fsmonitor_pid
+cat $tmp.fsmonitor >> $seqres.full
+cat $tmp.fsmonitor | filter_fsnotify_errors
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1838.out b/tests/generic/1838.out
new file mode 100644
index 00000000000000..adae590fe0b2ea
--- /dev/null
+++ b/tests/generic/1838.out
@@ -0,0 +1,20 @@
+QA output created by 1838
+Try buffered read
+pread: Input/output error
+Try directio read
+pread: Input/output error
+Try directio write
+pwrite: Input/output error
+Try buffered write
+fsync: Input/output error
+Fix device
+Kill fsnotify
+	Generic Error Record: len=XXX
+	error: 5
+FAN_FS_ERROR (len=XXX)
+Remount and restart fsnotify
+Try buffered read again
+Try directio read again
+Try directio write again
+Try buffered write again
+Kill fsnotify again

