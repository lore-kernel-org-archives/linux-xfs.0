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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A6EC6379F
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE962225B
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODQYo6/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgKUIXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:50 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6086DC0613CF;
        Sat, 21 Nov 2020 00:23:50 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v21so9491109pgi.2;
        Sat, 21 Nov 2020 00:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7B2hUwJfXTxu96bGaOyZtJ4w7SV/v8RN1Cm21+LWtIU=;
        b=ODQYo6/Sj89q6d+yrtRoY6afZAGZzZ2efS0Sz3lOHCMH49VvmxMdJt9rxR5rbUeMqp
         mgCQ11Kkf83ALSEXAmtGmD9c4igF5Rqhf9CZ9o7Gar5ffPwUZXu/xua9NBcV7uUj4TGp
         CFBIgozZQzFFsPhsKSYCJDDcX/y6l7JZDngczsFYL5krGl06YVyiELj1xgIHqF9PNFgL
         uBs7rzCixhSYtzZuvTvw6m791uk+QZ7wZCygeUvg38NXgskhNlWbTAQi0ZA+KG+4AOKv
         /z7QFb1n6FyACHe9wMBWY73HRgP9E6fk5BaF+CMwLAlAPsJhWIGScCTfl2OymekZZ775
         sxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7B2hUwJfXTxu96bGaOyZtJ4w7SV/v8RN1Cm21+LWtIU=;
        b=avkJss14MplTJqeFWCIyclRI9wA3rUcA3ckMPrOpoURtrjbfJ9aXcxQOhbg3kp5YUq
         X2xThGeAawXy0i933rK5L5q4tatHRYe9aCQFDcWZd+P1XpwSuD5New4V4u69dCtm0Xhl
         hqN76l30dfRYoVS9j8imtvLrIimaTnXbvw6rqqpnXQghgrNuNldGpGlP+lpUjigxPjaj
         u71YvGINHvAy83d/X3D8/YPL29LcnaxkYTTuC/8iu04Q68t4rk8zSXEN5Vc3oAqIUaJK
         iDdmvHIECMISyJuNFLq7C3xbfcBwK9kjSQ+C0WUgLw113o6LG1wewBrVKBChHjWvXOSO
         cQOA==
X-Gm-Message-State: AOAM530dS0L5Af/eRLdUihZCZVYb2En61y4Z3wjWeKMcem4suHo1OPHs
        DyYFGzWFA96QrEz2gOx4K8eWodnNP84=
X-Google-Smtp-Source: ABdhPJw69QkBizs5QZ0ny13e5gEqWJmAJ+Y7F9O/Cz9Y83Egj61jbC++OQAg18By19BztYBeaGouJg==
X-Received: by 2002:a62:768b:0:b029:197:dea6:586e with SMTP id r133-20020a62768b0000b0290197dea6586emr4412340pfc.44.1605947029120;
        Sat, 21 Nov 2020 00:23:49 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 02/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Sat, 21 Nov 2020 13:53:23 +0530
Message-Id: <20201121082332.89739-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
 tests/xfs/522     | 175 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/522.out |  20 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 196 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out

diff --git a/tests/xfs/522 b/tests/xfs/522
new file mode 100755
index 00000000..f2ac22cd
--- /dev/null
+++ b/tests/xfs/522
@@ -0,0 +1,175 @@
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
+nr_blks=$((40 * 2))
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Fallocate of unwritten extents"
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Directio write"
+
+nr_blks=$((40 * 2))
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
+if (( $nextents > 35 )); then
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
+nr_blks=40
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/522.out b/tests/xfs/522.out
new file mode 100644
index 00000000..99aa430b
--- /dev/null
+++ b/tests/xfs/522.out
@@ -0,0 +1,20 @@
+QA output created by 522
+Format and mount fs
+* Delalloc to written extent conversion
+Inject reduce_max_iextents error tag
+Create fragmented file
+Verify $testfile's extent count
+* Fallocate of unwritten extents
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
index 17f6bc6c..6aff1210 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -519,6 +519,7 @@
 519 auto quick reflink
 520 auto quick reflink
 521 auto quick realtime growfs
+522 auto quick quota
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

