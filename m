Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278983D6480
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267884; cv=none; b=pb3ficfzno6kxlH5bigzhVRIuMXO6wQQPD5mCZWCHKreG2C08B1IXkqdQ2hLzVxLqsIYaTzjoV7o4F4Lc3poe4IVr+H1dJepHvizADqJiwbhxOifi5Z+xrplpiiuRnS9OXUTfB+d5E2DF9kIY/g2cPSUCoRz0sBw+9U3Kc6zBtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267884; c=relaxed/simple;
	bh=oH4/D5ThCNFzAT4wJ/Ifeic5014F07hOvt2LMQVj3IM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GCby7xwQTqFpFXNCypVpQ8S7ffJ9XYAuQxm2ZmmVlE/xeGvWtOOmGwICnnI7wSDAhSoD7z45KMN+Ys9ARhDk28toMCpBwatD3QzYTf2W2mtnBeMlH7s783G6yJHlC9bNBFvYRq8c5MPPUEJHfyaRWO0iGTdRCkSD/gYoosQVM1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lktodLws; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lktodLws"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c132ac5ec2so9330885ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781267881; x=1781872681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oGf3h1raXw1s94lqcpdTCTQW9x2zvcNmbWbcmw3ePu0=;
        b=lktodLwsFS6ZMgXN4rnuBFFDyNk1a1Vsie0Mxutekb8kB3K5mbA4gEdcCws6xC1zb+
         zx3+d0t1GM3Ncx/W/q7/ePKNzCu7CnPBMD1uf6OEodzxR4dvC6SyGRZixUlMQQIZzht2
         ZMPMH39+XrSf8lGKyh4xlFxTo81FoNhKh2ptp345RzyfLDUF3SB5V2mjnkV2dAUIvO0f
         Qbos1Zthz6K4AO8lyXykxX+zvvv0Z2ccEu07YSXsR7AeUdlCLKla4q65Mz4pcWfwBxAM
         NmMk8q0CF0SX3t4uold6zYO0rX8Sg+7LB4O9HGMWA33Rtg8PaglIzAu9xOOAtPKndcLr
         jVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267881; x=1781872681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGf3h1raXw1s94lqcpdTCTQW9x2zvcNmbWbcmw3ePu0=;
        b=jr17dmtnL5+sEcIaMkJrlQlIvHwHoMpdAeGOG8CmGER5saUVLhAIKNNeV89fUZhw3d
         AJjorhtcgRA7yAyW1+Hfjh2IKvgB771k4ZNtiPe0vOZN85Di2zXKmCACpaQzdhn1iw0I
         CFaGOf+/jPKBogywHFgs9ChBYKL+qT4l6JsZIiOJeV0M/qaxhxqicWOYxW0AiHfoMSai
         LImT0i5rUCeaKrSufoKm/cf6sPF08bJ2EdqfHuvGu0u3I+ApNtgntFn+O6MydkXlNH1X
         YZOFw9jYppm6dh9N+hKvkS22Se/0B46pMHQIVbJMDWxegkfIldNleWAlKpDyh9HN5+Qh
         25+g==
X-Forwarded-Encrypted: i=1; AFNElJ+cjZtsrTF67yxlKOmoRCfmXtII7meX/DHvVq3eR/AjGXsE3+ZhgBvM4VioXUHKqQ18yGu3ROTGMVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoKLOahTigAJVdaUXlquZJY0bdzJ0Obvk9g000xpxsda/LckV7
	LuJj5HFU6dm2C2uF41Cqso74uCiGWGknisrnyoJHzH4sXXJhJ0EQjxEz
X-Gm-Gg: Acq92OFekIa3nZXei/+qxmzm5Q+oeU4E1DlgOrSypwzvrrzhkUO548ry8YmRJPa5DlA
	ozuqvS/OnDlyhJV/zZz171ZTCAhzC6RTHAxJMiyut25iNJ2nBMrV3M9Txwr/jlX1aXPrnjRkPOn
	Z6ZB/eCrH5aplzF53ToWUP/dYOMIiko9PlHxVV1WoLljP3/Qe+Dpfet3MMUAY8mIIi1M025o3YM
	d+yU7cinoG8WVNbEUV1kykPznv9KBuj4vc4F/RNnXI8xJqQ9Re8FtVDS0y0AnROQZ28Fr9bcgxY
	JH6mnINnoC3IT5D1vm/hMfTf42ot2oH5qLQZ4IjlVIsxlWAzme2yv91EqKtoJAaraWpGmBBtkDA
	cYYAaqAdq74PIjyDavEYsCgv+FWzxCCZKzo9qX9bnZTT0PqBl48elNg3IvznNrOWJcAruSB2K3W
	1Dj1O1Z7tG2YP8ajMqUR4UuHHo6c7j6G+KJHwpSIEPHie8dbZLn4bm+85GnUm+uchDRi9NwPHOC
	4gvsRAQgcFHIa381vm37UcKxhpS5o1Oz90HjihAuZhUt4A2Ptrd4/XrHJsi+5RJdZVF/q93LzdQ
	rzYfq3tUPN2eBh8YNhOISUOMK7pXpb+2jXKc
X-Received: by 2002:a17:903:3c05:b0:2bf:160f:7043 with SMTP id d9443c01a7336-2c41255e0d4mr33890565ad.34.1781267881440;
        Fri, 12 Jun 2026 05:38:01 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e59e1sm21192725ad.17.2026.06.12.05.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:38:01 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH] xfs/842: test close() deadlocks on frozen filesystems
Date: Fri, 12 Jun 2026 12:37:42 +0000
Message-ID: <20260612123742.2389-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

When a file with active speculative post-EOF preallocations is closed,
XFS synchronously attempts to free them via xfs_free_eofblocks().
This requires allocating a write transaction, which blocks indefinitely
if the filesystem is frozen, causing close() to hang.

Add a regression test using a helper C program to verify that close()
returns cleanly (with -EAGAIN if using XFS_TRANS_WRITECOUNT_TRYLOCK)
without blocking the close system call.

This is a regression test for the corresponding kernel patch:
"xfs: prevent close() from hanging on frozen filesystems"

On a successfully patched kernel, the close system call returns cleanly
and the test helper outputs 'close() completed immediately!', matching
the golden output. On an unpatched kernel, the close system call blocks,
the helper times out and outputs 'close() hung under freeze!', cleanly
flagging the deadlock to fstests.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 src/Makefile                 |   1 +
 src/xfs_freeze_close_repro.c | 127 +++++++++++++++++++++++++++++++++++
 tests/xfs/842                |  32 +++++++++
 tests/xfs/842.out            |   2 +
 4 files changed, 162 insertions(+)
 create mode 100644 src/xfs_freeze_close_repro.c
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..9553e7c9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -68,6 +68,7 @@ LCFLAGS += -DHAVE_FILE_GETATTR
 endif
 
 ifeq ($(PKG_PLATFORM),linux)
+LINUX_TARGETS += xfs_freeze_close_repro
 TARGETS += $(LINUX_TARGETS)
 endif
 
diff --git a/src/xfs_freeze_close_repro.c b/src/xfs_freeze_close_repro.c
new file mode 100644
index 00000000..075f2d18
--- /dev/null
+++ b/src/xfs_freeze_close_repro.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Aditya Prakash Srivastava. All Rights Reserved.
+ *
+ * xfstests helper to reproduce close() hang on frozen XFS filesystems.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sys/ioctl.h>
+#include <sys/vfs.h>
+#include <linux/fs.h>
+#include <libgen.h>
+
+int close_started;
+int close_completed;
+
+void *
+close_thread(void *arg)
+{
+	int fd = *(int *)arg;
+
+	close_started = 1;
+	close(fd);
+	close_completed = 1;
+	return NULL;
+}
+
+int
+main(int argc, char *argv[])
+{
+	struct statfs sfs;
+	char *dir_buf;
+	char *parent_dir;
+	int freeze_fd;
+	int write_fd;
+	char buf[65536];
+	pthread_t thread;
+	int hung = 1;
+	int i;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s <file_on_xfs>\n", argv[0]);
+		return 1;
+	}
+
+	if (statfs(argv[1], &sfs) < 0) {
+		dir_buf = strdup(argv[1]);
+		parent_dir = dirname(dir_buf);
+		if (statfs(parent_dir, &sfs) < 0) {
+			perror("statfs");
+			free(dir_buf);
+			return 1;
+		}
+		free(dir_buf);
+	}
+	if (sfs.f_type != 0x58465342) {
+		fprintf(stderr, "Not on XFS\n");
+		return 1;
+	}
+
+	dir_buf = strdup(argv[1]);
+	freeze_fd = open(dirname(dir_buf), O_RDONLY);
+	if (freeze_fd < 0) {
+		perror("open dir");
+		free(dir_buf);
+		return 1;
+	}
+	free(dir_buf);
+
+	write_fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (write_fd < 0) {
+		perror("open file");
+		close(freeze_fd);
+		return 1;
+	}
+
+	memset(buf, 'A', sizeof(buf));
+	for (i = 0; i < 320; i++) {
+		if (write(write_fd, buf, sizeof(buf)) < 0) {
+			perror("write");
+			close(write_fd);
+			close(freeze_fd);
+			return 1;
+		}
+	}
+
+	if (ioctl(freeze_fd, FIFREEZE, 0) < 0) {
+		perror("ioctl FIFREEZE");
+		close(write_fd);
+		close(freeze_fd);
+		return 1;
+	}
+
+	if (pthread_create(&thread, NULL, close_thread, &write_fd) != 0) {
+		perror("pthread_create");
+		ioctl(freeze_fd, FITHAW, 0);
+		close(write_fd);
+		close(freeze_fd);
+		return 1;
+	}
+
+	while (!close_started)
+		usleep(1000);
+
+	for (i = 0; i < 30; i++) {
+		usleep(100000);
+		if (close_completed) {
+			hung = 0;
+			break;
+		}
+	}
+
+	if (hung)
+		printf("close() hung under freeze!\n");
+	else
+		printf("close() completed immediately!\n");
+
+	ioctl(freeze_fd, FITHAW, 0);
+	pthread_join(thread, NULL);
+	close(freeze_fd);
+	return hung ? 0 : 1;
+}
diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 00000000..8b225ea2
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Aditya Prakash Srivastava.  All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Verify that closing a file with active speculative post-EOF preallocations
+# on a frozen XFS filesystem does not deadlock inside close().
+#
+. ./common/preamble
+_begin_fstest auto quick freeze
+
+# Import helper functions
+. ./common/rc
+. ./common/filter
+
+# Real-world configs
+_supported_fs xfs
+_require_scratch
+_require_test_program "xfs_freeze_close_repro"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+TEST_FILE=$SCRATCH_MNT/test_eofblocks_freeze
+
+# Execute the reproducer helper on scratch mount
+$here/src/xfs_freeze_close_repro $TEST_FILE
+
+status=$?
+_scratch_unmount
+_exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 00000000..386fb9cc
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+close() completed immediately!
-- 
2.47.3

