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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4ABC43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5880E652A4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhCIFB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhCIFBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:53 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4DC06174A;
        Mon,  8 Mar 2021 21:01:53 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e6so7953004pgk.5;
        Mon, 08 Mar 2021 21:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIBCosXehk5P/5OS1wZp50+lniDs8rcSeJgfrB/gdFc=;
        b=DYBmEVjW/b21tgQ58mmkcQVW99LqHEwxCfkDEycHJPfuHthfGFMwNMghIw/raTGBEV
         DtUBrO4ir4B4XG6vlUFNwt+68LWaARlrF63zCsY9T8dTX9KmAWxUjCKqrp0Uq0U7adMi
         3P1ZEhj1UMs682k/ftHJjxsrorVa7uq9fvD+BVgPdTnXzbmtoiA1e+G1mFLuCQtV/TDc
         InUQhH/Wd0vtNZ/lthMqBNERbHfZ1F7GZzJ3D5zYuGnf71szFpEwfBPsBiCchHknD2dW
         r6AEOfmeI+HTIkQxBVsc4gskP3YbwCRrTjZq9t1NG/RFyqnemtJXAXPa2RRifnz0ku8A
         dwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIBCosXehk5P/5OS1wZp50+lniDs8rcSeJgfrB/gdFc=;
        b=sKdVL8LdDeLHYXuaj2BWmDKuAfXSpStDn1ETP3jwJXfWeDSppk1r4InudYeBPtxpxp
         GveO13nlHoFs3VwqWYRuH9GFlKf/nXCk2Z+fMa+SvvEsFQ9l1egcdr/qDLxrTrw4IFM4
         4Ao9v1NKMLnVR7x/se2WUotbgoLfI3Xz2jyAcuUFcPR1jpLe/20juJxqd1Af45BTHHf7
         BianZa8pvJWkp1UzHwOQDqM5gOU1vXc11FGFeiCz94yIjDz7otq1Pimc8Vi2+5S/f7yq
         Lcpic8SWyA1sk8xJhTgbswJjTBVNiWyv/hVXRHvVO9gByeEK43sj3cICkRbj6LeWAPRW
         O4Sg==
X-Gm-Message-State: AOAM531+BuJDDA6BSR0w8RrDZd81H0wn/hrjWA6jKkPsJWorGifajG9z
        HmrKZEqhcTy68fgr2IuGLuYz6eVSiWY=
X-Google-Smtp-Source: ABdhPJzXUqbSyyFjCmxstvHXN/wXRS/uot90CwlUF8DGxJlDIOuzvRz9+tbONYMGSgTCaKvEoiAVjg==
X-Received: by 2002:a63:545e:: with SMTP id e30mr23904857pgm.13.1615266112575;
        Mon, 08 Mar 2021 21:01:52 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:52 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 06/13] xfs: Check for extent overflow when punching a hole
Date:   Tue,  9 Mar 2021 10:31:17 +0530
Message-Id: <20210309050124.23797-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
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
index 00000000..f73f199c
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
+	nextents=$(_xfs_get_fsxattr nextents $testfile)
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

