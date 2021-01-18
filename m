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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74E7C4332D
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D9222581
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbhARGW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730634AbhARGWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:20 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FAAC061786;
        Sun, 17 Jan 2021 22:21:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m5so9080700pjv.5;
        Sun, 17 Jan 2021 22:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glIlnlSgDUKeauealF0Vvm3N8x6rNgHNGcwKkgZ+AhI=;
        b=edv74rNOM18C9CJnyneMm3dE3FizEJfempn7ETNQPvLkTXnQwFQ2mvEHxiOZVrz6UL
         HlVg9UWwU4vIkzMP3DFdO1uMQikKegpAWP29TTj98azcLBNbhG/L8oC15DsLLb0uY+4Y
         k/hioodFgdSigE4F9PRlB5oUe7XlcASz2ytmr5Z4v0A6ApOv6J6Gk42J0TF4TfHbgy3j
         DR6WW9jH2U2zMGQDsb7Ggz+JqttBfiYw8nuGcEb2TDDY0ZLYPvkN/AGOy6GjP9hgKY4o
         mjD0JNpfPv4b2KLNKVLNatokp4hWjpwi9tF+H4zZkP7PgmxI/EpI1/1lq5ke6KrB9iIE
         3sPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glIlnlSgDUKeauealF0Vvm3N8x6rNgHNGcwKkgZ+AhI=;
        b=gG+ideEtRDNPVXbGfq57JEpDwvtniWfihxs4RtVq/kZlAUzc6bieksS38EBsoS/r1L
         KMhQ5Yf3jTOHMk7lMnesbIvm3Wu7+dTP5sKsabUyIHBno8Vb2fmxq+R9SDzXxx9qlzUH
         xhRJATuHWQ0OFUq+6OQJJjrzX242GQFsKkgQJIPBbd/94yeWH/y+L9aDRh+8s4sZ2Tsf
         ocpmCDEi7j5uNMMLYAAGM5LoGailbeiG4PHQwi78q98JTdxWwmwWr2+yQsJIDHGOASfP
         xofepDLD09RVatiD3kxGBg+30pKzHu4TlMxxs//PhoPy41c63GzqYi7FfAxvLscnbS5h
         M+ng==
X-Gm-Message-State: AOAM5322S5+mDUEm7xQDuzNGwhN2iZbzLdfnw1Kmr1otejEZXX0mnq7O
        Y+h7bq9Fm10Y+7fmpx2ARHLKzS1Sr6k=
X-Google-Smtp-Source: ABdhPJxq3YYCjVRfLbfd5FGa1Di/jVcPCEhTqWSsaXkw0Q/Pfp3XUqhmW23qHbrgeB9zu+AVuafT0g==
X-Received: by 2002:a17:90b:346:: with SMTP id fh6mr24555534pjb.225.1610950864165;
        Sun, 17 Jan 2021 22:21:04 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:21:03 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 09/11] xfs: Check for extent overflow when remapping an extent
Date:   Mon, 18 Jan 2021 11:50:20 +0530
Message-Id: <20210118062022.15069-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..f6a5922f
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 529
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# remapping extents from one file's inode fork to another.
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
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Reflink remap extents"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+nr_blks=15
+
+echo "Create \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile >> $seqres.full
+
+echo "Create \$dstfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $dstfile >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Reflink every other block from \$srcfile into \$dstfile"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
+	       $dstfile >> $seqres.full 2>&1
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..687a8bd2
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,8 @@
+QA output created by 529
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 15 blocks
+Create $dstfile having an extent of length 15 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index c85aac6b..bc3958b3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 526 auto quick dir hardlink symlink
 527 auto quick
 528 auto quick reflink
+529 auto quick reflink
-- 
2.29.2

