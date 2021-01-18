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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EC3C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34B92256F
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbhARGVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731533AbhARGV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:21:29 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EF4C061575;
        Sun, 17 Jan 2021 22:20:48 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t6so8083761plq.1;
        Sun, 17 Jan 2021 22:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PiR5XrPCo/8xBvKQBroN3k2T97ViDnryhS0HS238Hls=;
        b=ipM311vg29EgSI2l/OoABjfl4peqVJUfi/nB6hE5azNYH4UZ5H9Ijo28RF6p4RwkQW
         QO2Y06tBSkwBJBCNI9oxNK2lRzG0oMhkHxWMbLPDS6NiZWwtgGaVzCvRnQecMIXHw22m
         Kru8li2oN6SJdQ6e1uL2BlkyuOSOmaRw+cQFVyrFmLS5yyM4TI4qmhIEEFFLnjnFrT1j
         fGZ68a8fEp7gKGFI7jxY6YOxPwkzWSuVCj7WoK4K7bPT8V7a6ccz2WlFpBks6TW0dmHm
         m5KENSXd/gGpSFfImerbzKpf61eWatDrS6AtQT7yfTJi1c1WBYJqx1jrjsaMrOhmtu3R
         dfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PiR5XrPCo/8xBvKQBroN3k2T97ViDnryhS0HS238Hls=;
        b=CKhsAebLfnGrjKbHj6PIp+94iwZ7iWWEWQhQBM26+g0ZUHb67a6rPpRCkK4YXChw7Y
         CIUiPV6zNgRlf7YYskP4sPwMJw+h1imHXhlYyH4vHqpqd9IAbFkUxStuAx81IQGSjHlp
         oJCdLrf+U6kF6c0/QNEvmhZWlZz9ExBGX2ParXpYZx1UsvUYt/P0q6bMg6vXq1iEhU09
         ngdg7IA0feCI4xJzhoadf82de6hMtI9vPVS/XC27O2E/ASQeAasZmW6bTmsWdXSvn2h5
         evWZBaiFo6wDArv51tReFt5PA7VGBIep5QZcNMkr9XGs0+TOnFDf8hVFLUe2Vil91cK2
         c3Vg==
X-Gm-Message-State: AOAM533A9GDf/hSKAsvpavNsqd9TeSSa4LmPOpTrOY+Cyct4eXseS4BL
        LIb55EDPaq1HcjPUnp/cg2jI9c8tFfI=
X-Google-Smtp-Source: ABdhPJyIck67e6xUi/cLcmkT6qxvBrB0v1egA4gzaSAOlmQQbYoVTc3F/LjcdwiFlLzpiE/TvMbQ1g==
X-Received: by 2002:a17:90a:4cc5:: with SMTP id k63mr24412960pjh.202.1610950848316;
        Sun, 17 Jan 2021 22:20:48 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:47 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 02/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Mon, 18 Jan 2021 11:50:13 +0530
Message-Id: <20210118062022.15069-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding a single extent while there's no possibility of
splitting an existing mapping.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/522     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/522.out |  20 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 194 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out

diff --git a/tests/xfs/522 b/tests/xfs/522
new file mode 100755
index 00000000..33f0591e
--- /dev/null
+++ b/tests/xfs/522
@@ -0,0 +1,173 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 522
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding a single extent while there's no possibility of splitting an existing
+# mapping.
+
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
+. ./common/quota
+. ./common/inject
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_quota
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount -o uquota >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+echo "* Delalloc to written extent conversion"
+
+testfile=$SCRATCH_MNT/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+nr_blks=$((15 * 2))
+
+echo "Create fragmented file"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Fallocate unwritten extents"
+
+echo "Fallocate fragmented file"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Directio write"
+
+echo "Create fragmented file via directio writes"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep -i nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Extend quota inodes"
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+nr_blks=20
+
+# This is a rough calculation; It doesn't take block headers into
+# consideration.
+# gdb -batch vmlinux -ex 'print sizeof(struct xfs_dqblk)'
+# $1 = 136
+nr_quotas_per_block=$((bsize / 136))
+nr_quotas=$((nr_quotas_per_block * nr_blks))
+
+echo "Extend uquota file"
+for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
+	chown $i $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+_scratch_unmount >> $seqres.full
+
+echo "Verify uquota inode's extent count"
+uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
+uquotino=${uquotino##uquotino = }
+
+nextents=$(_scratch_get_iext_count $uquotino data || \
+		   _fail "Unable to obtain inode fork's extent count")
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/522.out b/tests/xfs/522.out
new file mode 100644
index 00000000..debeb004
--- /dev/null
+++ b/tests/xfs/522.out
@@ -0,0 +1,20 @@
+QA output created by 522
+Format and mount fs
+* Delalloc to written extent conversion
+Inject reduce_max_iextents error tag
+Create fragmented file
+Verify $testfile's extent count
+* Fallocate unwritten extents
+Fallocate fragmented file
+Verify $testfile's extent count
+* Directio write
+Create fragmented file via directio writes
+Verify $testfile's extent count
+* Extend quota inodes
+Disable reduce_max_iextents error tag
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Extend uquota file
+Verify uquota inode's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index b89c0a4e..1831f0b5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -519,3 +519,4 @@
 519 auto quick reflink
 520 auto quick reflink
 521 auto quick realtime growfs
+522 auto quick quota
-- 
2.29.2

