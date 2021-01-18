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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A5AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086E3227C3
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbhARGVu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbhARGVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:21:33 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60CC0613C1;
        Sun, 17 Jan 2021 22:20:53 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id md11so8812383pjb.0;
        Sun, 17 Jan 2021 22:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JlURlfQZpNNMmIPVRCThz8X9YsyM5LYX1Ylt4W4EDyQ=;
        b=pcFugMYS3wNtzR95ji4Zbv5ID49y8ttQgdD58gB8DuACr04d0SecAk36ed4OhaSEEc
         D34mndn+ZSCFQi/rZtJi2c2e5TG3LK1PGHnSVp/gIs1IFgBxCLqnb6pYOzdHLrqPYkSa
         KCVBwKpN+pJFyJWsIDB47fuq59AEI7AduOle1ZL3tVVSyG0Hq9GE/mTh0q+gZo18ahHW
         VarL9Lui16le7izjmikSpRRCoqIxV04MfQE4s2fEUx5SAdiTWGw6Zv85GmtJ2AxyM44g
         wilT7J7bwd6MZBJo9M9tTyc6qf5fdVPdKIDrbJ1Js2GpxFt4LGeXhezm2pZtAjxdADQe
         E6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlURlfQZpNNMmIPVRCThz8X9YsyM5LYX1Ylt4W4EDyQ=;
        b=TrJxUAeVdPMrDl7iaXpJVLgsJ5FxUKQeNUKXKi3o46n89IIGktfZv7zzQRirjqlmsU
         Btex/Ng/U3GYQFwYAJWdP95vqEJAj3RMEy2U8n2krP8ISHwTnfu7vd1W72oT5JCinLvV
         wxbJHl5t3Da/b0nq0jy8RqR74CRBXwjdNvYDXXcxkaxwdydNjTIZ5hFsDdCi5kmViNbA
         7eYY3K17AALRoxar7P6PyzZ1O5IgKN40it25F4ZYNJlSg+mu63QDcApcW+ZhKwnoXHzO
         R0kBQowE+w48dOUSsSTyPG8mghj0efUhV9sqTzXBwQbtpvs51OHyjtge79p2XRnQFUSD
         nBiA==
X-Gm-Message-State: AOAM533eyYcOuLnpxgI5kcVYPIN4d88l9qwxFw5W1iZmp7tbc0rmuXBt
        O9eZuOlKwacKjL6yBHJNV7jpLkbw1+I=
X-Google-Smtp-Source: ABdhPJxWDp5OK8xYKlQR2XMtaDMmErLCZeRB/0eMc43rM7eV7TKL859Y1R67PgZeoXJsLlXjk3lkQw==
X-Received: by 2002:a17:90b:e15:: with SMTP id ge21mr23777305pjb.185.1610950852914;
        Sun, 17 Jan 2021 22:20:52 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:52 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 04/11] xfs: Check for extent overflow when punching a hole
Date:   Mon, 18 Jan 2021 11:50:15 +0530
Message-Id: <20210118062022.15069-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when punching out an extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/524     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/524.out | 19 +++++++++++
 tests/xfs/group   |  1 +
 3 files changed, 104 insertions(+)
 create mode 100755 tests/xfs/524
 create mode 100644 tests/xfs/524.out

diff --git a/tests/xfs/524 b/tests/xfs/524
new file mode 100755
index 00000000..79fa31d8
--- /dev/null
+++ b/tests/xfs/524
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 524
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
+	nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
+	nextents=${nextents##fsxattr.nextents = }
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
diff --git a/tests/xfs/524.out b/tests/xfs/524.out
new file mode 100644
index 00000000..a957f9c7
--- /dev/null
+++ b/tests/xfs/524.out
@@ -0,0 +1,19 @@
+QA output created by 524
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
index 018c70ef..3fa38c36 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -521,3 +521,4 @@
 521 auto quick realtime growfs
 522 auto quick quota
 523 auto quick realtime growfs
+524 auto quick punch zero insert collapse
-- 
2.29.2

