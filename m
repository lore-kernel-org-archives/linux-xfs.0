Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712EB3C73EA
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785801314; cv=none; b=uNMmMrD75v/zSyBfdyuCMkFjNX8nlIcgy8WHz67JgYS1x9mZjMd/RUQr7a0S/trJ0GIred4FL872BpeI6VrYo1bFdHoA614FT/FCxh9V+I2yE8P6xq+1jmLDJ40RaChi+jATYZrfF4VLHPCvqAw2g4zlL0oirZUqfSyBOCNKhcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785801314; c=relaxed/simple;
	bh=fGvviV+vYU7uX5NqfLxSXffOZxCnI+jmw4PzZSTFLaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxH51R6W+HzYbPSt1fMZnX8iXh4CxZJsi8a40CVGa7+7Uaup9ZHiEb2qWSr+6SL4gONXir7kW6uFNafSyrDcZujtHEWIwuVfXCXmudT/OcUqWl/g2rCwYq8b6BqEWnPvPRY1p+P2fFcuceDzELebhPFEsPJLBTkGOL5arv/gRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rlX27Gbl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tmv+KSXu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rlX27Gbl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tmv+KSXu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55A5E7F434;
	Mon,  3 Aug 2026 23:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785801306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=y/wPOgGtSbruc5STgM5zCVYa97ouCUDc3Xi/bSAUNWg=;
	b=rlX27Gbl3uohzIMdFJ11l9CvvfWjnPGA0BppEp+HZ7vyKIpHkFRPtTX7ZT5cZTs/XMTvdF
	uK15Vipw0SQomlABL3mbGfQ40SeytCk3GnMbN+iiIMTZj/DzTmmRE+WyXAcTRed3n1Y/7t
	5B7/NkatgXtO0Rdo37vCM1g9UDXOJh8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tmv+KSXu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785801302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=y/wPOgGtSbruc5STgM5zCVYa97ouCUDc3Xi/bSAUNWg=;
	b=tmv+KSXuyQ3j+8kp4xdozfQtEcTN57vL0U6u95tYd/HaEmUcglHq5EbtGjNz0nJ55W3u9F
	4yHU5P+6rB2nbO7VIKGhxy+V2CbT1UlkxCUNIVSjx9jIzsfx8Bzm94ByWC+c04CZoSdonG
	KaoHaDi76ARq/giS7359cnY0eHT1ye4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF471779A1;
	Mon,  3 Aug 2026 23:55:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XeSTI1QqcWrhZwAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 03 Aug 2026 23:55:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v2] fstests: add a dio-read-into-mmap and sync race test case
Date: Tue,  4 Aug 2026 09:24:39 +0930
Message-ID: <20260803235439.25785-1-wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 55A5E7F434
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

There is a report that on btrfs, if the following workload are running,
btrfs can fail:

- A dio read into a mmaped range
  Only the mmap range needs to be on btrfs.
  The dio read source makes no difference.

- Sync_range on the mapped range

The btrfs errors include:

- Hang during data writeback
- Filesystem flips RO

The mmap range is dirtied but written back by the sync_range process,
then dio read finished and found that the folios are no longer dirty,
so dio endio will mark those folios dirty again so that the fs can write
them back again.

However for non-experimental btrfs with 4K block size and 4K page size,
there is a regression in v7.2 that such case is no longer handled
properly, due to the enablement of large folios and removal of cow
fixup.
And btrfs can never handle it for bs < ps from day 1.

Add a regression test for it.

Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Rebased to the latest patches-in-queue branch
  The old number is taken by another test case, now this one got the
  number 800.

- Fix a bug when the direct read failed short, the read buffer is not
  advanced

- Add _require_odirect

- Add _require_xfs_io_command sync_range

- Add missing tmp files cleanup

- Remove unneessary trap command for the main process

- Fix the unset command
---
 .gitignore               |  1 +
 src/Makefile             |  2 +-
 src/dio-read-into-mmap.c | 81 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/800        | 79 +++++++++++++++++++++++++++++++++++++++
 tests/generic/800.out    |  2 +
 5 files changed, 164 insertions(+), 1 deletion(-)
 create mode 100644 src/dio-read-into-mmap.c
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out

diff --git a/.gitignore b/.gitignore
index 0b6b9452..d52ba4ad 100644
--- a/.gitignore
+++ b/.gitignore
@@ -216,6 +216,7 @@ tags
 /src/truncate
 /src/t_btrfs_received_uuid_ioctl
 /src/btrfs_ioctl
+/src/dio-read-into-mmap
 
 # Symlinked files
 /tests/generic/035.out
diff --git a/src/Makefile b/src/Makefile
index e8da2636..ea3d77b2 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	t_mmap_writev_overlap checkpoint_journal mmap-rw-fault allocstale \
 	t_mmap_cow_memory_failure fake-dump-rootino dio-buf-fault rewinddir-test \
 	readdir-while-renames dio-append-buf-fault dio-write-fsync-same-fd \
-	dio-writeback-race unlink-fsync truncate
+	dio-writeback-race unlink-fsync truncate dio-read-into-mmap
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/dio-read-into-mmap.c b/src/dio-read-into-mmap.c
new file mode 100644
index 00000000..2a5ad085
--- /dev/null
+++ b/src/dio-read-into-mmap.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) SUSE S.A.
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <err.h>
+
+static int read_source_fd = -1;
+static int mmap_dest_fd = -1;
+static void *buf = NULL;
+static int iosize = 4 * 1024 * 1024;
+
+static void usage()
+{
+	fprintf(stderr,
+	"Usage: dio-read-into-mmap <read_source> <mmap_dest>\n");
+}
+
+int main(int argc, char **argv)
+{
+	int ret = -EINVAL;
+	const int pagesize = sysconf(_SC_PAGESIZE);
+	unsigned int cur = 0;
+
+	if (argc != 3) {
+		usage();
+		goto error;
+	}
+	if (iosize < pagesize) {
+		ret = -EINVAL;
+		fprintf(stderr, "blocksize smaller than pagesize\n");
+		goto error;
+	}
+
+	read_source_fd = open(argv[1], O_RDONLY | O_DIRECT, 0600);
+	if (read_source_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "failed to open '%s': %m", argv[1]);
+		goto error;
+	}
+	mmap_dest_fd = open(argv[2], O_RDWR, 0600);
+	if (mmap_dest_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "failed to open '%s': %m", argv[2]);
+		goto error;
+	}
+	buf = mmap(NULL, iosize, PROT_WRITE, MAP_SHARED, mmap_dest_fd, 0);
+	if (buf == MAP_FAILED) {
+		buf = NULL;
+		fprintf(stderr, "failed to mmap: %m");
+		return -errno;
+	}
+	while (cur < iosize) {
+		ret = pread(read_source_fd, buf + cur, iosize - cur, cur);
+		if (ret == 0) {
+			ret = -EINVAL;
+			fprintf(stderr, "reached EOF");
+			goto error;
+		}
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr, "failed to read: %m");
+			goto error;
+		}
+		cur += ret;
+	}
+error:
+	close(read_source_fd);
+	close(mmap_dest_fd);
+	if (buf)
+		munmap(buf, iosize);
+	if (ret < 0)
+		return EXIT_FAILURE;
+	return EXIT_SUCCESS;
+}
diff --git a/tests/generic/800 b/tests/generic/800
new file mode 100755
index 00000000..980d1734
--- /dev/null
+++ b/tests/generic/800
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
+#
+# FS QA Test 800
+#
+# Test direct read into a mmaped range meanwhile doing data sync for the mmaped
+# range.
+# Such racy workload should cause direct endio function to mark the folio
+# dirty without going through buffered write nor page_mkwrite().
+#
+# Make sure the fs can handle such ->dirty_folio() callback correctly.
+#
+. ./common/preamble
+_begin_fstest auto rw mmap
+
+_require_test_program dio-read-into-mmap
+_require_scratch
+_require_test
+_require_odirect
+_require_xfs_io_command sync_range
+
+_cleanup()
+{
+	cd /
+	[ -n "$mount_pid" ] && kill $mount_pid &> /dev/null
+	[ -n "$remount_pid" ] && kill $remount_pid &> /dev/null
+	wait
+	rm -r -f $tmp.*
+}
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Create the 4MiB target file on TEST_MNT as the read source.
+$XFS_IO_PROG -f -c "pwrite -i /dev/urandom 0 4M" "$TEST_MNT/dio-read-source" >> $seqres.full
+
+# Another 4MiB target file on SCRATCH_MNT as the mmap dest
+$XFS_IO_PROG -f -c "pwrite 0 4M" "$SCRATCH_MNT/mmap-dest" >> $seqres.full
+
+read_workload()
+{
+	_register_cleanup "wait"
+	while true; do
+		$here/src/dio-read-into-mmap "$TEST_MNT/dio-read-source" \
+			"$SCRATCH_MNT/mmap-dest" &> /dev/null
+		if [ $? -ne 0 ]; then
+			echo "dio read failed"
+			break;
+		fi
+	done
+}
+
+sync_workload()
+{
+	_register_cleanup "wait"
+	while true; do
+		$XFS_IO_PROG -c "sync_range 0 4m" "$SCRATCH_MNT/mmap-dest"
+		if [ $? -ne 0 ]; then
+			echo "sync_range failed"
+			break;
+		fi
+	done
+}
+
+read_workload &
+read_pid=$!
+
+sync_workload &
+sync_pid=$!
+
+sleep $((15 * $TIME_FACTOR))
+
+kill "$read_pid" "$sync_pid" &> /dev/null
+unset read_pid sync_pid
+wait
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/generic/800.out b/tests/generic/800.out
new file mode 100644
index 00000000..bdfaa2ce
--- /dev/null
+++ b/tests/generic/800.out
@@ -0,0 +1,2 @@
+QA output created by 800
+Silence is golden
-- 
2.51.2

