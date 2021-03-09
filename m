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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3046C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B463F652B1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhCIFC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhCIFCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:02:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE1C06174A;
        Mon,  8 Mar 2021 21:02:01 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o38so7946371pgm.9;
        Mon, 08 Mar 2021 21:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0JiuyjLxAO766Dbi/Flr0AGUrNxdP+HauXEXRBua5E=;
        b=OU5vu1eK7cp7vcI7PgqHMwWkuozCniccvj5XN9bv59myNjxMGzd0rh2hs4j4XBc6gE
         2u2tgAAkTvkqBUeRZ8DZr22LgRz1COS88/A9aVqcziQU5Y738kG68ik8/dfrsfEG9Iw2
         XNmXuTCp74Zp8c9bnNdpI0ws/IOgAhBxy+H9OLZXLOG1iJOW0Fxbh8s2g0XBY1Ht8V8Z
         vznrcsLIZca/SeNES+YrVQkGpmn6GNOCvXpzvr7xFlipYLv8Dsyy9PIBV8Co+yds68In
         yS6K25NeJIWFy0KUI1t8gjhJ95DRl5vcDtLE8fkxwkTgwW8NRbuvCKOvlskCNo/DzeyH
         MD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0JiuyjLxAO766Dbi/Flr0AGUrNxdP+HauXEXRBua5E=;
        b=JAJzxggIb8o6bxaDE2rgSeym/hO4JPQrMZr06JIhbU3UbBipawAfdbohrCkyvSoXR2
         iJ3gFRNqazL77UMw5IT17OI5Lis5+GqodjG7Zpk//t46RedVC36VLu62y5n3dq/Axaka
         eFm/QtmcSeUX9UoWgwNsgfCzS99qk/tdZf+OXkmnA2r5c7b5tGcUac2NC5lebKnD3cHl
         pD8e/kkK15NdIDqxct+glYPUjRdRbXLCWdJIod4VsKq9qWH9KRdM27Eikz/zbSF2YITD
         52zDHMDX3QLxiiCSkDRwrr91BdkcqqB51otGNT62pNfSg1Yk7FN32Il6St0AHBqnTMgx
         exDA==
X-Gm-Message-State: AOAM53122oLVEGZGALeM/3vDjtdyimYsbgm13psh7flcRI8f1uIfnXzT
        gwqeWMmGtqo9EO739UHbrOw/9aFkpdk=
X-Google-Smtp-Source: ABdhPJwaDBBGci+GxtxtMJni9odsRo2r9Uz9ea8iTUcIeqV997edTGJIPiIeyz9dUoEliACEIrVhiA==
X-Received: by 2002:a63:4f57:: with SMTP id p23mr23417416pgl.281.1615266120530;
        Mon, 08 Mar 2021 21:02:00 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:02:00 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 10/13] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue,  9 Mar 2021 10:31:21 +0530
Message-Id: <20210309050124.23797-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to/funshare-ing a shared extent.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/534     | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/534.out |  12 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 117 insertions(+)
 create mode 100755 tests/xfs/534
 create mode 100644 tests/xfs/534.out

diff --git a/tests/xfs/534 b/tests/xfs/534
new file mode 100755
index 00000000..06b21f40
--- /dev/null
+++ b/tests/xfs/534
@@ -0,0 +1,104 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 534
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to a shared extent.
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
+. ./common/reflink
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_require_xfs_debug
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "funshare"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+nr_blks=15
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Create a \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile  >> $seqres.full
+
+echo "* Write to shared extent"
+
+echo "Share the extent with \$dstfile"
+_reflink $srcfile $dstfile >> $seqres.full
+
+echo "Buffered write to every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$(_xfs_get_fsxattr nextents $dstfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $dstfile
+
+echo "* Funshare shared extent"
+
+echo "Share the extent with \$dstfile"
+_reflink $srcfile $dstfile >> $seqres.full
+
+echo "Funshare every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$(_xfs_get_fsxattr nextents $dstfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
+ 
diff --git a/tests/xfs/534.out b/tests/xfs/534.out
new file mode 100644
index 00000000..53288d12
--- /dev/null
+++ b/tests/xfs/534.out
@@ -0,0 +1,12 @@
+QA output created by 534
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create a $srcfile having an extent of length 15 blocks
+* Write to shared extent
+Share the extent with $dstfile
+Buffered write to every other block of $dstfile's shared extent
+Verify $dstfile's extent count
+* Funshare shared extent
+Share the extent with $dstfile
+Funshare every other block of $dstfile's shared extent
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 3ad47d07..b4f0c777 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -531,3 +531,4 @@
 531 auto quick attr
 532 auto quick dir hardlink symlink
 533 auto quick
+534 auto quick reflink
-- 
2.29.2

