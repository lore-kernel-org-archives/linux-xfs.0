Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8380BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6004B65224
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhCHPwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhCHPvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BBDC06174A;
        Mon,  8 Mar 2021 07:51:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso3208826pjd.3;
        Mon, 08 Mar 2021 07:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gyIQpvibVeWIJVsoXwr/CW1cR4wrDfUs7ZYhFUCt/QI=;
        b=XiY5UsltYZk49LIf+JloFgs7iiCDx5vORLJpUHtJSy8ad7EyYcUer94rhgfRI5i/DD
         mJ5bI48vv2OR82XwMsCVnFFf1Qkyhkc5F8q5A5VDeVZLHT8IxFnmio8UuT/aY2ZHs3D2
         F5fOjjV9VfszzWk4umxIeK3xe37HT3KmVrodVdS8JCLnJuHNe5AnOKdtODnSlcH6znh4
         knTeT6smMJsqsM2ZEcUNgF2udBvgDBfuLOF235wIWk4P6JXsps/TzZIHfT17p3M6PT5i
         T91c+BkeVGohkfP9wdAPXxYQuKCQ2PSOtvnp+LZTW75p8e5ClB63G5vJOtQMmGcDlWOh
         ++pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gyIQpvibVeWIJVsoXwr/CW1cR4wrDfUs7ZYhFUCt/QI=;
        b=BnmERu1YtW07bfxiEEvZ1NgvYgrD8oDTkyczFclSEgspST/v2sp5tKTVbBkMrP8MZb
         b2wgCdCXt9sBly9L2lf3NaLUSkr2ZUDSCYZe7U01ZnITR5ixkbuSVbuSLbAfgd/9w5Sd
         qXs+poGv82ZkT32Vc5cLOw0Vf2LVOnT7fsjy4GQSFcSt7IaOJ+vi+NBTopBuYRuI/Bll
         /vZQyOABWYCeJL1ihez8olrUckHBputVCieQDSAoLQggvEtb4M+Oj1gO4sXBY7dw9l1L
         R8YOvMMslaK0aFeBfJ7C2eTUJsJCqavDCnHanOESS7kfcTrw+ex9VOvdtPjCutzeEqsc
         B4Yw==
X-Gm-Message-State: AOAM530aMPmxB8g9GUyNvkhPg8dgIc1pmuwXqoatIMT2MNVZPXpGpQsO
        jIiy4NY+31edfL7NF/TDKONSyN2E0bM=
X-Google-Smtp-Source: ABdhPJxfLMczLk+2v1mo7VK4OT/xya2l9BD4qusGDjDY5nkaEjqmb9AFqIBQhv/IktFCkNAjkXMnCA==
X-Received: by 2002:a17:90a:1049:: with SMTP id y9mr25408057pjd.173.1615218706962;
        Mon, 08 Mar 2021 07:51:46 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:46 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 12/13] xfs: Check for extent overflow when swapping extents
Date:   Mon,  8 Mar 2021 21:21:10 +0530
Message-Id: <20210308155111.53874-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when swapping forks across two files.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/536     | 105 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/536.out |  13 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/xfs/536
 create mode 100644 tests/xfs/536.out

diff --git a/tests/xfs/536 b/tests/xfs/536
new file mode 100755
index 00000000..245c2feb
--- /dev/null
+++ b/tests/xfs/536
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 536
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# swapping forks between files
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "swapext"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Swap extent forks"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+donorfile=${SCRATCH_MNT}/donorfile
+
+echo "Create \$donorfile having an extent of length 67 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 10); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+
+echo "Create \$srcfile having an extent of length 18 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
+for i in $(seq 1 7); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
+done
+
+echo "Collect \$donorfile's extent count"
+donor_nr_exts=$(xfs_get_fsxattr nextents $donorfile)
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$(xfs_get_fsxattr nextents $srcfile)
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Swap \$srcfile's and \$donorfile's extent forks"
+$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$(xfs_get_fsxattr nextents $donorfile)
+
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$(xfs_get_fsxattr nextents $srcfile)
+
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/536.out b/tests/xfs/536.out
new file mode 100644
index 00000000..f550aa1e
--- /dev/null
+++ b/tests/xfs/536.out
@@ -0,0 +1,13 @@
+QA output created by 536
+* Swap extent forks
+Format and mount fs
+Create $donorfile having an extent of length 67 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 18 blocks
+Fragment $srcfile
+Collect $donorfile's extent count
+Collect $srcfile's extent count
+Inject reduce_max_iextents error tag
+Swap $srcfile's and $donorfile's extent forks
+Check for $donorfile's extent count overflow
+Check for $srcfile's extent count overflow
diff --git a/tests/xfs/group b/tests/xfs/group
index aed06494..ba674a58 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -533,3 +533,4 @@
 533 auto quick
 534 auto quick reflink
 535 auto quick reflink
+536 auto quick
-- 
2.29.2

