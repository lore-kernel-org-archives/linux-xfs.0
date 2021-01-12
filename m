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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECEAC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD8F22E02
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbhALHmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbhALHmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:09 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5C8C0617A3;
        Mon, 11 Jan 2021 23:40:57 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g3so965258plp.2;
        Mon, 11 Jan 2021 23:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KSmrcvw5ZUJlTQHKIeh4tHzJvLM/jJb0v/5lnrJ6Kp0=;
        b=dzwuUAr2EXcDXKrI0YnIlUOmFTRInZLrANUqXkHh8rpn/J6Ymo0jq9lmkEz95s9jpH
         iWCmKS7pQN3foqI/6WPOrqcY3MVE8e0GWehjhoWDGgNkbdS6YoysuKlQyv9nrW+xgLMn
         jUPV5qC409myTNZ2VEL3nd1LrJbeyFFSeRI5VPqYk+9jk0WD4sOgHqs7ZLPMlPnQXL6V
         GX7QTLEj0oH2Ni3aZWiMxf7XLwPsgxR4HfoQUW6fEGJDtLU73LWWX/QCgcRck8PyLbQ5
         r2PKT+UGpn1vSz8wzVEz78MDvgJd0AWpe0sbWelxZZUqwkm/JHsfc/gJYDR4pJMEhXwN
         nXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KSmrcvw5ZUJlTQHKIeh4tHzJvLM/jJb0v/5lnrJ6Kp0=;
        b=PpervOutKmEuQhbNkXlcoL5CA0RvGyFcYEO9Hz2thOmN1XtesmJpBTknzZa4QhKZ9H
         V2jSFybzUHdGSUBwwHpcRQ7ZvMvNGgrFs+tlY5jRWpY3+rsvaRYGuB0ZElMZpiDIoG3P
         cxYPyWtuKVwnbq7BgP/3aHQrs6+erS5SKE7kkgADQd9fpXOqGPvjmniNUjAMsDYhjvOG
         fUKjhMHi1YYTtiXdQ4n+J3tkSJKROvU4KDhltMj90pkrgiKE2js54PR3DuNhGDsIWOuD
         dbhLx5WTCXcF+04azM+dnJSIztidoyEKZP4AVyD1U5Pxo1lDjZ0SxLpAk+875lBGSr2v
         5bFQ==
X-Gm-Message-State: AOAM531ivLCCJqY59GRWJY6CuAa3eM6+djI5wv3eHHkpDiMbtBR7OWhS
        BR9B8U55PI0D8vXksUvczPqYy2u9hQI=
X-Google-Smtp-Source: ABdhPJxYJrIR3cJ+gQDJ9PS5JiFh0p9sJzWcO3TlLU6Jx233PozCuYkTFlmG5RZUS+GLx8rH1KdMmg==
X-Received: by 2002:a17:90a:3d4e:: with SMTP id o14mr3188582pjf.44.1610437257236;
        Mon, 11 Jan 2021 23:40:57 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:40:56 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 04/11] xfs: Check for extent overflow when punching a hole
Date:   Tue, 12 Jan 2021 13:10:20 +0530
Message-Id: <20210112074027.10311-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
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
index b375a94c..7031cabf 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -521,6 +521,7 @@
 521 auto quick realtime growfs
 522 auto quick quota
 523 auto quick realtime growfs
+524 auto quick punch zero insert collapse
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

