Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408E8C432C3
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A7B65224
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCHPv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhCHPvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:35 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA87C06174A;
        Mon,  8 Mar 2021 07:51:35 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id jx13so3255099pjb.1;
        Mon, 08 Mar 2021 07:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OXtz0/qF1hsnvk4d2jDdPDfzlFMenp4VZO0kyImZx64=;
        b=AW0S0VgDD8fG9L++sIF0pdan65oCzDXXOIR7GZcGhlvV3jdcjnaZCNru5q6UcIk4jq
         wzRLDnwlW6PgaA6OAo8uXRHaGW8T2C4eGKrVWn4bSYzh+n+4fLYdBuJQn9O9tJQDHLMe
         tyewC60PKmgdBDpeIySd4KuTIq2+P80/cjwwzJbEq2OYx6Cc1jZfA2Q3YPiY7jzr4cW3
         3ro90LXpOq/ujHX1t5bo4le06/a9ZyhD2/rLhEw2lzKRRBD6dhpUPjk+2rJwjMgGmJAB
         6fHwWKIaVM5Oy5gq96BhEGIoutT3ePMEt74K2Su3c0v+zoTvvyKcfS6EsA2V3jMuYQk9
         ydkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OXtz0/qF1hsnvk4d2jDdPDfzlFMenp4VZO0kyImZx64=;
        b=gmP6o2bWWf/Jlsj0N1D00Iy0+pmnHa5i2hRbpShYfUYmoSDcDyuXFBee5Qo93sK6y4
         a/McQSwAC07p/3TH/LMIesw3JhR1RSLs6T8PqGt9q1o/gdYi+9vcGCYllK+5D8xmAsnh
         yZNE3oj7fCoS/pWzsixPLpXRpKJGoiUoBF84sUCPZsyzDYZQoOCM6i6dLojBd0Zl24rK
         nnnRnDiBa32d8ww4FnVkQszH6KkUt/lUwTCUkKnOcbOKiR5XAz9I7JHlC2ucjh+hL69K
         RSU+PzI9G7UyM112ph9OszoRK/CHs77rfDGBDIA1d797YcdNeg2fxH6HfATMo42D1fY6
         tQcQ==
X-Gm-Message-State: AOAM532+HP6ctqusQEFV9pCn1lK0JmH60pU3/JKgP27uuk08LbYv3BBC
        B277/FtRdYPTVw7yeujbEcoRW0C7smg=
X-Google-Smtp-Source: ABdhPJxJwmfHmnCMm4y97tgOxfQ6xl/zoQjKzB/DXss5q+9OsPC69B/6OZfwfQ+wH7NuuYcp8w5DMA==
X-Received: by 2002:a17:90a:778a:: with SMTP id v10mr25200225pjk.229.1615218695050;
        Mon, 08 Mar 2021 07:51:35 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:34 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 06/13] xfs: Check for extent overflow when punching a hole
Date:   Mon,  8 Mar 2021 21:21:04 +0530
Message-Id: <20210308155111.53874-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when punching out an extent.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/530.out | 19 +++++++++++
 tests/xfs/group   |  1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out

diff --git a/tests/xfs/530 b/tests/xfs/530
new file mode 100755
index 00000000..33a074bc
--- /dev/null
+++ b/tests/xfs/530
@@ -0,0 +1,83 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 530
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# punching out an extent.
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
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "fzero"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+nr_blks=30
+
+testfile=$SCRATCH_MNT/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+for op in fpunch finsert fcollapse fzero; do
+	echo "* $op regular file"
+
+	echo "Create \$testfile"
+	$XFS_IO_PROG -f -s \
+		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
+		     $testfile  >> $seqres.full
+
+	echo "$op alternating blocks"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		$XFS_IO_PROG -f -c "$op $((i * bsize)) $bsize" $testfile \
+		       >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(xfs_get_fsxattr nextents $testfile)
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	rm $testfile
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/530.out b/tests/xfs/530.out
new file mode 100644
index 00000000..4df2d9d0
--- /dev/null
+++ b/tests/xfs/530.out
@@ -0,0 +1,19 @@
+QA output created by 530
+Format and mount fs
+Inject reduce_max_iextents error tag
+* fpunch regular file
+Create $testfile
+fpunch alternating blocks
+Verify $testfile's extent count
+* finsert regular file
+Create $testfile
+finsert alternating blocks
+Verify $testfile's extent count
+* fcollapse regular file
+Create $testfile
+fcollapse alternating blocks
+Verify $testfile's extent count
+* fzero regular file
+Create $testfile
+fzero alternating blocks
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 5dff7acb..463d810d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -527,3 +527,4 @@
 527 auto quick quota
 528 auto quick quota
 529 auto quick realtime growfs
+530 auto quick punch zero insert collapse
-- 
2.29.2

