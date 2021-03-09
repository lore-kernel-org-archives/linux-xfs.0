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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9558C43603
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E6F652BE
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCIFB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCIFBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35002C06174A;
        Mon,  8 Mar 2021 21:01:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d23so2758108plq.2;
        Mon, 08 Mar 2021 21:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e9VuivX6aKQ1kZhSKHOLtnG6lSuEZSopiR2LX+0lhSY=;
        b=MkZVGpAWFhowyR3EBcRCgZ4WbJzYaagKgszeWoKp5k2EcwLjckOF7JNgLCd+6TqPZr
         aCW7vdWXObJcP/GNF/KbnbWWq3snkR+N7Z4cZZjJZE8wD/xkNZF0kfGkF4XF5hSbKslm
         FmM5tWobznkqLc8rUmaYWF59gYSyYaIqQgyPlo76SA8Qr73mjbf5Vk23eUzZZnhQs92u
         vX2Ad0ZRQVOsKaowsQQ0yGXc+9uCG2OCXgA/H5XlyH/IpGAQx3iyfwN3JA3DOyScANlA
         pvuIg+7RZdveQcWB6dcZNC3dWVIK+bABa/xpxkecocrezTMxgCaQ99JHU7/S5zNtsanJ
         +ygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e9VuivX6aKQ1kZhSKHOLtnG6lSuEZSopiR2LX+0lhSY=;
        b=dsJoJm61NuLPl0H7QlTG7nAq61UruKs2C+g8Mn2zfUp2Nlx+T6EFiQ0EjQe9W3hFi+
         qIx/EoFFCYwaFAA7c9q4KzMo6cKIlgeBl+oyEZ+9WLmCpvLGoVnQKf/8jOS3JFsTsNO9
         R7CraS1o2oO0Q9hU5rymUeLM7UeZ15tBdmZjY6hYHcFaQoLvXNjo9NZGXws860n7Oamr
         haNRj7w9XeQ6s9dixK4oGUcBd52f3llcJg63A/VsLT4a0AH4bVqyxfLcWGPrK4/1UbEW
         6ct1+pam+ys0WSR0WTwkNf4bC4oq/G0kTdlT9Tm3MEoJ5kIwFtOV0oT0/8I5bnq7Yb9Y
         fSMg==
X-Gm-Message-State: AOAM533bAYU/vXRYqGNLjDfPSUVfEGMB+Y3yUd5XPphPXJth39JM6PGx
        tQfO23UrQIj97vrqZ4Kw1VT7ZrXzKn4=
X-Google-Smtp-Source: ABdhPJw+xHoAuvw7FxEXainv9aS/Pns24GMlNEALXwzytLzh145jqXuJGmvlsLMufQRVakb4krSJ3g==
X-Received: by 2002:a17:902:e5c7:b029:e5:df58:8155 with SMTP id u7-20020a170902e5c7b02900e5df588155mr21792343plf.55.1615266108492;
        Mon, 08 Mar 2021 21:01:48 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 04/13] xfs: Check for extent overflow when trivally adding a new extent
Date:   Tue,  9 Mar 2021 10:31:15 +0530
Message-Id: <20210309050124.23797-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding a single extent while there's no possibility of splitting
an existing mapping.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/528     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  20 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..557e6818
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 528
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
+nextents=$(_xfs_get_fsxattr nextents $testfile)
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
+nextents=$(_xfs_get_fsxattr nextents $testfile)
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
+nextents=$(_xfs_get_fsxattr nextents $testfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+# Check if XFS gracefully returns with an error code when we try to increase
+# extent count of user quota inode beyond the pseudo max extent count limit.
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
+uquotino=$(_scratch_xfs_get_metadata_field 'uquotino' 'sb 0')
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
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..3973cc15
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,20 @@
+QA output created by 528
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
index e861cec9..2356c4a9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick mkfs
 526 auto quick mkfs
 527 auto quick quota
+528 auto quick quota
-- 
2.29.2

