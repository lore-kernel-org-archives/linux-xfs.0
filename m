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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D110C43603
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5467165220
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCHPv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhCHPvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:33 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A48C06174A;
        Mon,  8 Mar 2021 07:51:33 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso3208474pjd.3;
        Mon, 08 Mar 2021 07:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ihEZoDgsRmmlYcoS0S1pXr2KamqMw/qSaPB9FaNuZA=;
        b=oNYgw5Q3+MjNwtYT1XCbOdv1lnvBShX3z6BSdHfm6/RbZcFQ0LZH58GT6VaIQELvVz
         EyXHkpgVgYlw4zWcXjgX8nTngQYXp0oL0Jtw5/otTJsTIMRV4w3rl7gSOGcyUSGvlIMM
         kJSUabt2d2jPGQkyKNpWveJ7zrSy5MyAdwA+w8HXMH6SwkyI9gNcQyF+ktxuPrTTeLBh
         XCCkXgZSa17238+QShjqt2B9CLl/yZqNSzdNUlETT69lP6dwwG3VQE2UiBCMlJ/XEYNG
         ddxer3U6OLRipUBHyKDjGJBQcp74ufXe/RpsgZRDVSO3pC8UlSyx5p8l8ZP+PKqOgs5f
         emFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ihEZoDgsRmmlYcoS0S1pXr2KamqMw/qSaPB9FaNuZA=;
        b=he3vjZIFc2XWvyrTimeQXSG8gXZ1FTwUlXcLNH06l6ryQm0QGCae+ij94yOeefISnd
         vczJW6USule+Z+m84SLVkhoHDrgw+H3mZFMAKrhzcZL/iYDUn2iah8gIH28HQQy0L3HT
         tG4xB9g2NQ5C76bkhOndPHlolIzRtErPvoBzAavoIWevyQs3zaSiJfsx5v55yeebPZii
         hRGFaXYfdCz85fJGne36v+R7sZkCxDsu6t29MDKz6ITsGpjzGCFIJkNCsWoZEOIuO/Rs
         Wq7FhQNABTiVgyamIBYZy4Bkx4OR4dnu6otwgtvqeqUHq2sSx62fQErCEAHzaJVUVsZp
         Rx4g==
X-Gm-Message-State: AOAM531AKB5YKMmp3SW4IbD/PF+lDkmAKPo8HhSfOJ3rsQ/pSqUShRKn
        hZdfQ05dCz3YG3qX6rb0hBUBpqj27cU=
X-Google-Smtp-Source: ABdhPJximgFXBxRX/iztJ9q+J9IMNiIkHamMsQtBwo4uu8nj7Tz0k04NGSoOHF0fNon1JJxyKoSPkA==
X-Received: by 2002:a17:90a:5d09:: with SMTP id s9mr24781600pji.172.1615218693172;
        Mon, 08 Mar 2021 07:51:33 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:32 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 05/13] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
Date:   Mon,  8 Mar 2021 21:21:03 +0530
Message-Id: <20210308155111.53874-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Verify that XFS does not cause realtime bitmap/summary inode fork's
extent count to overflow when growing the realtime volume associated
with a filesystem.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 124 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  11 ++++
 tests/xfs/group   |   1 +
 3 files changed, 136 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..dd7019f5
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,124 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 529
+#
+# Verify that XFS does not cause bitmap/summary inode fork's extent count to
+# overflow when growing an the realtime volume of the filesystem.
+#
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
+	_scratch_unmount >> $seqres.full 2>&1
+	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
+	rm -f $tmp.* $TEST_DIR/$seq.rtvol
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/inject
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+# Note that we don't _require_realtime because we synthesize a rt volume
+# below.
+_require_test
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_scratch_nocheck
+
+echo "* Test extending rt inodes"
+
+_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+. $tmp.mkfs
+
+echo "Create fake rt volume"
+nr_bitmap_blks=25
+nr_bits=$((nr_bitmap_blks * dbsize * 8))
+
+# Realtime extent size has to be atleast 4k in size.
+if (( $dbsize < 4096 )); then
+	rtextsz=4096
+else
+	rtextsz=$dbsize
+fi
+
+rtdevsz=$((nr_bits * rtextsz))
+truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Format and mount rt volume"
+
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
+	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
+_try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
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
+echo "Grow realtime volume"
+$XFS_GROWFS_PROG -r $SCRATCH_MNT >> $seqres.full 2>&1
+if [[ $? == 0 ]]; then
+	echo "Growfs succeeded; should have failed."
+	exit 1
+fi
+
+_scratch_unmount >> $seqres.full
+
+echo "Verify rbmino's and rsumino's extent count"
+for rtino in rbmino rsumino; do
+	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
+	echo "$rtino = $ino" >> $seqres.full
+
+	nextents=$(_scratch_get_iext_count $ino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+done
+
+echo "Check filesystem"
+_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+
+losetup -d $rtdev
+rm -f $TEST_DIR/$seq.rtvol
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..4ee113a4
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,11 @@
+QA output created by 529
+* Test extending rt inodes
+Create fake rt volume
+Format and mount rt volume
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Grow realtime volume
+Verify rbmino's and rsumino's extent count
+Check filesystem
diff --git a/tests/xfs/group b/tests/xfs/group
index 2356c4a9..5dff7acb 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 526 auto quick mkfs
 527 auto quick quota
 528 auto quick quota
+529 auto quick realtime growfs
-- 
2.29.2

