Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3039AC10F1B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 22:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiLUWjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiLUWjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 17:39:01 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03711A3A7;
        Wed, 21 Dec 2022 14:38:32 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id j16so136121qtv.4;
        Wed, 21 Dec 2022 14:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWDvi6NA1oNJ6B4yhOwLG7WTkWiS1ZUVjFh9SQnNc1c=;
        b=IMPK1P0MVIPOn5G2AfiM8yC5AOGhf1pnViwkQSucp28+YCutDJI4ZHxICASabxy88p
         KFLbK0ThhiGMaudxKOE8n6ogyhhV1r6+Zo9eyCdt7X8VQ3uzdDf5Guj2U7WT02UYjQK4
         N/DLLiLEWJ8oLkOiQxj4bwasqc3jh3NUQslXTXbERSsF3e+KcEIrEF1W16kVPgnEcV8v
         F3CZkT2DjNI7pIXCKgesJNZTxjZC/XvQH1VX8r7GUOOomzXOsTkHZGtfId7e50kVmzzT
         X6ffvWut6AVUj9ixVH6tlCOj763qlQjTWC0sDQtwu0Yby8BKVmhClBYNbDFFsttlM9Tm
         l+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWDvi6NA1oNJ6B4yhOwLG7WTkWiS1ZUVjFh9SQnNc1c=;
        b=VWmp1pOuEZZTeAKwRBLl8IZPeAp3bpvQSLp/2mOwYzkgDFNEPx7QszDHASIun/CCsx
         gVrek26mueH7RWvhtdh9F+GjiBxyRCxnFNmMVUJVQvAdN8cyxsxFpcg6Z35iIoF1RvRu
         5HkL2zqEBIU+pvbN/AfbHszdKUtw9jA49VJYS5CLQCdOHWEdXeMwjBwX8vTMjdH80Wkg
         CxEd9pj3ys1KGeCAVcVuwWf0KVhRTV4l3aYn8NVzLUD3n4+nTckpqezapOB5dxi02UB+
         4lcwtcypXVhghU3hd1VupZYjqMf/SpSTPPBS3jJHF7xQZHRx8L36+F3j7VG8b3RmiMqm
         Ngkw==
X-Gm-Message-State: AFqh2kqxi64qEaMPePD4AUn23SUIfOEMFJHD6pcFBFrlT8LuNRALaQn+
        Alz8sv1S1L4AWxg3BgIs+oN+rLYZ/VEgBA==
X-Google-Smtp-Source: AMrXdXvhGf3a3aGe4JNO4HdirPSaqxHoZ/OH91HJ6O+7ZZzG/UKzMMs6ZAW3phj0N0w4eMp1VTxOvg==
X-Received: by 2002:ac8:6685:0:b0:3a8:123a:b549 with SMTP id d5-20020ac86685000000b003a8123ab549mr9204329qtp.46.1671662312063;
        Wed, 21 Dec 2022 14:38:32 -0800 (PST)
Received: from shiina-laptop.hsd1.ma.comcast.net ([2601:18f:47f:7270:54c1:7162:1772:f1d])
        by smtp.gmail.com with ESMTPSA id z16-20020ac87cb0000000b003a7ec97c882sm9786591qtv.6.2022.12.21.14.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 14:38:31 -0800 (PST)
From:   Hironori Shiina <shiina.hironori@gmail.com>
X-Google-Original-From: Hironori Shiina <shiina.hironori@fujitsu.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [PATCH v2] xfs: Test bulkstat special query for root inode
Date:   Wed, 21 Dec 2022 17:38:05 -0500
Message-Id: <20221221223805.148788-1-shiina.hironori@fujitsu.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221161843.124707-1-shiina.hironori@fujitsu.com>
References: <20221221161843.124707-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a test for the fix:
  bf3cb3944792 xfs: allow single bulkstat of special inodes
This fix added a feature to query the root inode number of a filesystem.
This test creates a file with a lower inode number than the root and run
a query for the root inode.

Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
---
 tests/xfs/557     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/557.out |  2 ++
 2 files changed, 65 insertions(+)
 create mode 100644 tests/xfs/557
 create mode 100644 tests/xfs/557.out

diff --git a/tests/xfs/557 b/tests/xfs/557
new file mode 100644
index 00000000..608ce13c
--- /dev/null
+++ b/tests/xfs/557
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
+#
+# FS QA Test No. 557
+#
+# This is a test for:
+#   bf3cb3944792 (xfs: allow single bulkstat of special inodes)
+# Create a filesystem which contains an inode with a lower number
+# than the root inode. Then verify that XFS_BULK_IREQ_SPECIAL_ROOT gets
+# the correct root inode number.
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+_supported_fs xfs
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "bulkstat_single"
+_require_scratch
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"xfs: get root inode correctly at bulkstat"
+
+# A large stripe unit will put the root inode out quite far
+# due to alignment, leaving free blocks ahead of it.
+_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full 2>&1 || _fail "mkfs failed"
+
+# Mounting /without/ a stripe should allow inodes to be allocated
+# in lower free blocks, without the stripe alignment.
+_scratch_mount -o sunit=0,swidth=0
+
+root_inum=$(stat -c %i $SCRATCH_MNT)
+
+# Consume space after the root inode so that the blocks before
+# root look "close" for the next inode chunk allocation
+$XFS_IO_PROG -f -c "falloc 0 16m" $SCRATCH_MNT/fillfile
+
+# And make a bunch of inodes until we (hopefully) get one lower
+# than root, in a new inode chunk.
+echo "root_inum: $root_inum" >> $seqres.full
+for i in $(seq 0 4096) ; do
+	fname=$SCRATCH_MNT/$(printf "FILE_%03d" $i)
+	touch $fname
+	inum=$(stat -c "%i" $fname)
+	[[ $inum -lt $root_inum ]] && break
+done
+
+echo "created: $inum" >> $seqres.full
+
+[[ $inum -lt $root_inum ]] || _notrun "Could not set up test"
+
+# Get root ino with XFS_BULK_IREQ_SPECIAL_ROOT
+bulkstat_root_inum=$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT | grep bs_ino | awk '{print $3;}')
+echo "bulkstat_root_inum: $bulkstat_root_inum" >> $seqres.full
+if [ $root_inum -ne $bulkstat_root_inum ]; then
+	echo "root ino mismatch: expected:${root_inum}, actual:${bulkstat_root_inum}"
+fi
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/557.out b/tests/xfs/557.out
new file mode 100644
index 00000000..1f1ae1d4
--- /dev/null
+++ b/tests/xfs/557.out
@@ -0,0 +1,2 @@
+QA output created by 557
+Silence is golden
-- 
2.38.1

