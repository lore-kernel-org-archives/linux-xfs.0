Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C21C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62CE62224C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2ziz39v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgKML2W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgKML1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:43 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C14FC061A04;
        Fri, 13 Nov 2020 03:27:36 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c20so7375910pfr.8;
        Fri, 13 Nov 2020 03:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ehVuNvOmS0r5As9G9ddM7RoBFx7tHtjMsmcu9AMKtU=;
        b=J2ziz39vLs1r8M7RzYmVmo0TXDbzvA8X4fGoAd5KcdVdtjIc9IkmS2qUSnW8ZMkbtF
         JzqpYy7IzNUJUOEZ8UnPEKDiO72AKWg9WosP37rFFtEAtBnX5t4RMvCezFV0PaFnJbMT
         xOpgpXE41zCtdyz5XiV6LT02j1IbAkL/0KJi8Uu3qGgBfUtX9HwiA2kgbU4ZIy5sAqw5
         dosEvnUJ2d7b6o2pSNh+usw+Dh95sojmuwtygop/cfQwJfdhXeAjW/ict1A47Kzbq8ib
         rbsDIMe2RVzdfIQDGRkB1GoJIRs1pqo5HvpGEp35hsEryVpW2DZNKVA1fLVIZAdzCFWx
         wwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ehVuNvOmS0r5As9G9ddM7RoBFx7tHtjMsmcu9AMKtU=;
        b=TILs8ojsWGBNcCZ4TK+Fo9kVEGuTa12w1e8IcLcSI2tNPKNPdXlhAMuIfWfVCajaAu
         R8XiErGrYmE8X5rjUjvVIYTy2Cr4wU50/sAE6ju1Qu6bONbkHDYGDji9JE1+cBDguBhq
         3jlJOC8H/9XNAEeIiSKndkje/Cjnib3Pvq7qso6vx7ivwOyVtHtWLceDd6FBm+/jgL8J
         bxdamQtw9fnG15YUHh/dNonJSqWabZHvrIKHwBFuxUzwNG8J/KJyrK2LDubIEl5XPhnT
         zF6etTka3ClxhFRxrnbuqQOWVm0Uu6TsjF2JbGi61vKpej7lXaa38Rz/0nmDq6yNhHfS
         4WnA==
X-Gm-Message-State: AOAM530+S/tJurdRFNHq5DxbAnJ5MJFxrRGYREci2ssS5c8tyml7spky
        qzQ+YBK/2ajRKAbbUOKvsCzU75i3FVA=
X-Google-Smtp-Source: ABdhPJxqBA+wpiehq0G7y2MyxDaKAjHJm1Da7eb79DzmJ2FyeOnJ+Hs+UB4xkr03oPYPcySWUwulEg==
X-Received: by 2002:a65:62ca:: with SMTP id m10mr1687709pgv.407.1605266855423;
        Fri, 13 Nov 2020 03:27:35 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:34 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 02/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Fri, 13 Nov 2020 16:56:54 +0530
Message-Id: <20201113112704.28798-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding a single extent while there's no possibility of
splitting an existing mapping (limited to non-realtime files).

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/522     | 214 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/522.out |  24 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 239 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out

diff --git a/tests/xfs/522 b/tests/xfs/522
new file mode 100755
index 00000000..a54fe136
--- /dev/null
+++ b/tests/xfs/522
@@ -0,0 +1,214 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 522
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding a single extent while there's no possibility of splitting an existing
+# mapping (limited to non-realtime files).
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+delalloc_to_written_extent()
+{
+	echo "* Delalloc to written extent conversion"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	nr_blks=$((15 * 2))
+
+	echo "Create fragmented file"
+	for i in $(seq 0 2 $((nr_blks - 1))); do
+		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data || \
+			   _fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+falloc_unwritten_extent()
+{
+	echo "* Fallocate of unwritten extents"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	nr_blks=$((15 * 2))
+
+	echo "Fallocate fragmented file"
+	for i in $(seq 0 2 $((nr_blks - 1))); do
+		xfs_io -f -c "falloc $((i * bsize)) $bsize" $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data || \
+			   _fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+quota_inode_extend()
+{
+	echo "* Extend quota inodes"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount -o uquota >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	nr_blks=20
+
+	# This is a rough calculation; It doesn't take block headers into
+	# consideration.
+	# gdb -batch vmlinux -ex 'print sizeof(struct xfs_disk_dquot)'
+	# $1 = 104
+	nr_quotas_per_block=$((bsize / 104))
+	nr_quotas=$((nr_quotas_per_block * nr_blks))
+
+	echo "Extend uquota file"
+	for i in $(seq 0 $nr_quotas); do
+		chown $i $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify uquota inode's extent count"
+	uquotino=$(_scratch_xfs_db -c sb -c "print uquotino")
+	uquotino=${uquotino##uquotino = }
+
+	nextents=$(_scratch_get_iext_count $uquotino data || \
+			   _fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+directio_write()
+{
+	echo "* Directio write"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	nr_blks=$((15 * 2))
+
+	echo "Create fragmented file via directio writes"
+	for i in $(seq 0 2 $((nr_blks - 1))); do
+		xfs_io -d -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data || \
+			   _fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+delalloc_to_written_extent
+falloc_unwritten_extent
+quota_inode_extend
+directio_write
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/522.out b/tests/xfs/522.out
new file mode 100644
index 00000000..98791aae
--- /dev/null
+++ b/tests/xfs/522.out
@@ -0,0 +1,24 @@
+QA output created by 522
+* Delalloc to written extent conversion
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create fragmented file
+Verify $testfile's extent count
+* Fallocate of unwritten extents
+Format and mount fs
+Inject reduce_max_iextents error tag
+Fallocate fragmented file
+Verify $testfile's extent count
+* Extend quota inodes
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Extend uquota file
+Verify uquota inode's extent count
+* Directio write
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create fragmented file via directio writes
+Verify $testfile's extent count
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
2.28.0

