Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498575;
	b=GzXpXA3E0Wyoh+4SRk4Mgjc2B9FcoGv9KGTNiwhU+XwUwpg2BpnUeDO6k+5z1F0W8wbe
	 6Vzx6AskbjibcVNqedZdX9dJjZ2ZRMOL7BtsXZSQhhNWisS1w26o8jKdth01OyNuV2unT
	 NKYxO3TWRjVt5TmQ9xUY6qb+Cqqt9tv6aLQH6qg7DHGynNbxc2vwg08ErNYMFcJG/DcCU
	 rG3gChp6H5tTYDybdarBr7HOwZ4tyYT9hTQUvGoCz3d17gULW/s3RUWpnN0llpS7StYaL
	 ZAAVjsumcqYcHOVuC5ZR9BhsCSY5k6n3s5R1wNRcHRkaZnNTCUyIN1UFGbHk7jxdMFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JB9RC+A5BbaSKEWWha0jLo9ULFAdBPRzEEnoru6E9DQ=;
	b=Y+2H2rIlr+X0aIMO1y+Nn69mmwCe603k9bigQ8GhN6ncMN3/ARnfvu5NmJph6IABj3nw
	 0j1FJGldNiwA8ncistc6OogYfkzta1PbN+pC+h8vhu5yD/x83cCd08sJwHJbNDOvRqxkh
	 U3Ag25SFGe+JVL2uuUAJnRUQm1A/v7dMqWwo9wsdzi5slB28JgUjNWUb7x3VosWq1D6Fn
	 9DHXD4g07MhAY4vG6iknIXD+VrR16TBdEZmcht+oyfXtgH86VMxyp5ekLvrBHNtvhcObg
	 L53+oev2hTT9zZewGE9U7a3TRjKV09c18RA2z5Rc9ynq9mVyr6IEZGaX88enZ9zi6sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=RpcvTqLC;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82648606A32D
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 15:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82648606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=RpcvTqLC
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b33de9d2b1so36734517b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 07:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794498573; x=1795103373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JB9RC+A5BbaSKEWWha0jLo9ULFAdBPRzEEnoru6E9DQ=;
        b=RpcvTqLCZfaaZBfCfch6W8UhCFu7GYDnR43kqQUnZL9ZxjV/Tc65Id5KCj8AWwYeJN
         j0ebk0vHxJt7lx1+Cvuj7Ju+QFOchRYzErPNT6qwr5YswiIBZCbL6kEUIF31cM9riu/i
         YhEY18D9Zylj/5WE2W9aNC6g1Qrdga1cJNRr9JlriGANAgt4xBjIlVgq1bgZwHM5J3bx
         4CCzWMIpCrrJnVwnulvc9xhsn8GDvls4JkevWYORFd/+4AlUJLSvIU08MkSBQg+TAgmM
         Qs0j85g5b6tajMaVia0/dSjoQHidID+BR6DtKyxTe8PTpmf8ZoQDmuWXrFs9Q1ARwBRj
         Cd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498573; x=1795103373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JB9RC+A5BbaSKEWWha0jLo9ULFAdBPRzEEnoru6E9DQ=;
        b=W3m3/wW7smvjkDN4llf18QD9aXm+WqEB+1h0EmSGNXtFLPCGbXdTCBDoARhnj/1vgp
         q9rTzVnqkjWAtUUNX9X4vY1mtYYEncQ2BP7+ZVsSPgij69W3lEB3Z/WL1tUU1siYNSYr
         aQ2IqrXpPfs85/LRnWxLt8+pmeo6klpYVHQfBjctmnmc/Qotgga2ZyHhXkahZDwoYV+l
         fCuEO116rCn2G97cZSMzbCpgCwrrlyOYLi00uLYIVotC1awA/tisiHj1IqYgaQv3N2F3
         WPPoTLvMvX6qoICA29AnpKw5tXPAHBDQu2RdlgztA+/uCEjS0OxaFq58GmkEPKBxRQi6
         1pow==
X-Forwarded-Encrypted: i=1; AL+hErH2r+L5G15Wj1nmbHfrqCR85me9IqRkryYFDyZ7Fzuh1eJbYWlSpIgLQx5cyHXNbmHblIT6OiiugyU=@vger.kernel.org
X-Gm-Message-State: APuU4Z953xJjPcGUTPqY0VkawzkeHwBbZHoGqYh4E6R0V9w0Yd1RPXZQ
	EN+Wow9uzVi4DayUhw71AF9fZO4pkhF/snPaIivXkHAEc5jWAtk6I9DA1GGcnj7Aew==
X-Gm-Gg: AYBFou2KTxkWw4eFvf+vVHM6edBQbgwo6Q1kqfc6mFcHXblJwrg8tziyrfsvnJNim4l
	YJqC6tfmiQkuKdQHBeuO6xF/iUwVUKYQwpt5TW2k+wZTA96OTWv8dKa3xS0D0iqnQjGFAoAsJki
	YnALN9Idy10/Jhc3iYeYXsTRFZqs5qZn6Y34g2SeBjmb4P31IS+6EQMwlIXiU/b3ATyjqRrUtyg
	8UAkxYZbBqQBPsHKvC0H1qa+DS6vhX+FzqygQe42vhwIMRP8R4uehRmeMeqrLrnn8LMzG99Tw52
	zlDyrtHj8SAZmqgeal4OsPEIgxWfXtIhYdXjmbnD5SAsZy0awt0X68d3Rzae1aycgifDrp9Pigg
	AqgA8ZJtC+0UuQHi5Olvz8NQDGckl2S2ohi803b1GqPJMXbCj0m67bWW4zjZ96B0h8kEY9YkEAL
	nIByCWeyFfMJEONVsEeHQLwDJvR4loVMArOR/UdB+qSHSX9HFtEG8+CZUrznk5VY/BPli3duoE7
	D/j5YW8q/fIVg38RKge52efl+GS6vvEK82BnBdGtK2kbbsNzt3mOthm1t3Z3CHdmynLWkmNwKEH
	kCwCpB8NusNQDYAZM1Ye34FFL9NCLCLPg/KYHgm0AebyIqCwgXjM8L7vIOlu4/R+m5A1GngR+Q=
	=
X-Received: by 2002:a05:690c:c6c5:b0:8b0:9eb3:dbd1 with SMTP id 00721157ae682-8b3a805c093mr23509097b3.37.1794498573459;
        Thu, 12 Nov 2026 07:49:33 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b393409120sm72617317b3.27.2026.11.12.07.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:49:33 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test that statfs does not report negative free blocks
Date: Thu, 12 Nov 2026 10:49:17 -0500
Message-ID: <20261112154917.751315-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a regression test for the f_bfree underflow in statfs().

Since kernel commit dd324cb79e54 ("xfs: refactor xfs_fs_statfs"), when
the free block counter is below the number of blocks that are not
available for allocation, statfs() reports f_bfree and f_bavail close
to 2^64, and df prints negative sizes.

The test moves all free blocks into the reserve pool with the resblks
command, then deletes every other file of many single-block files. The
freed blocks refill the reserve pool first, while the free space btrees
grow.

Without the fix, f_bfree is reported as 2^64 - 6 on a filesystem with
4k blocks.

Link: https://lore.kernel.org/linux-xfs/20261112102018.3922571-1-hengyul@cs.unc.edu/
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Tested in a VM on xfs for-next 48326a2382d8 (v7.4-rc2) with mkfs.xfs
6.18 defaults, "-m rmapbt=0,reflink=0" and "-b size=1024": the test
fails without the kernel fix and passes with it.

 tests/xfs/842     | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  2 ++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 00000000..c99dd4f3
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Hengyu Liang.  All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Make sure that statfs() does not report a negative or huge number of free
+# blocks when the free block counter drops below the blocks that are not
+# available for allocation.
+#
+# Move all free blocks into the reserve pool, then free many small extents.
+# The freed blocks refill the reserve pool first, so the free block counter
+# stays the same, while the free space btrees grow.
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"xfs: fix f_bfree underflow in statfs()"
+
+_require_scratch
+_require_xfs_io_command "falloc"
+
+# Only the data device counters are checked.
+_disable_scratch_realtime
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+_require_xfs_scratch_non_zoned
+
+# A free space btree leaf holds about blksz / 8 records.  Deleting every
+# other file of blksz / 2 single-block files adds blksz / 4 records, which
+# takes a few more leaf blocks.
+blksz=$(_get_block_size $SCRATCH_MNT)
+nr_files=$((blksz / 2))
+_require_fs_space $SCRATCH_MNT $((nr_files * blksz * 2 / 1024))
+
+for ((i = 0; i < nr_files; i++)); do
+	$XFS_IO_PROG -f -c "falloc 0 $blksz" $SCRATCH_MNT/s$i
+done
+
+# Ask for more blocks than the filesystem has, so that the reserve pool takes
+# all free blocks and stays short of its target.
+nr_blocks=$(stat -f -c '%b' $SCRATCH_MNT)
+$XFS_IO_PROG -x -c "resblks $((nr_blocks * 2))" $SCRATCH_MNT >> $seqres.full
+
+find $SCRATCH_MNT -name 's*[13579]' -delete
+_scratch_sync
+
+# Before the fix, f_bfree and f_bavail were 2^64 minus a few blocks.  Some
+# versions of stat print that as a negative number.
+stat -f -c '%b %f %a' $SCRATCH_MNT | tee -a $seqres.full | $AWK_PROG '
+	$2 < 0 || $2 > $1 { print "f_bfree " $2 " out of range, f_blocks " $1 }
+	$3 < 0 || $3 > $1 { print "f_bavail " $3 " out of range, f_blocks " $1 }'
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 00000000..643d0528
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+Silence is golden

base-commit: 71641219a506ac62bfa231592394265ca812670e
-- 
2.53.0

