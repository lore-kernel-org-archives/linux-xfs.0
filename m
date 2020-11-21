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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D20EC64E7B
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4841122252
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mg2pFbhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgKUIXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:55 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011D3C0613CF;
        Sat, 21 Nov 2020 00:23:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id w14so10175233pfd.7;
        Sat, 21 Nov 2020 00:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4cleYl7oMiziSTvwSI4KMR97F6OHUqxMcK8J8SvhMs=;
        b=mg2pFbhYR2ShW+FKQtVHWFZPo/LzU66d9ZFP0k8bq6oEeIGcoRj4SRL380MqckU3Z0
         YJtpBQpSR0QNsJBQjl8J4MjV/PeGSeUrQHaAvCFcrqEyTM8tqSIFZTo1CRnpgKQtNa9K
         CBQHcWtu7wcDlDHcyv1CZaEKNed1PwYb+7NQb8MDjRrPsjG1URbACLAi0BaWIy0A4SP/
         7IM0l5sd63Yh2/shQqdFLPhv10/To5tKUIKvquhxgmuZ38DVvN3i7h1DMjNSo4FGX1gh
         OACZg/RqjaxVdjCGlCFcaJS1H5NoqmbTJvYW1gwGfAnlkb1TEe6jsyAn24OeQhx8Ar9P
         RA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4cleYl7oMiziSTvwSI4KMR97F6OHUqxMcK8J8SvhMs=;
        b=uT/9Emy2Yp8AKerI/GHJRGXcGYioQK4QHJ1oWAR5gRPOjI21jq/zjKeBC+E8QkKM5m
         K7LiXnoDsbh6X+55UsJvNvMwmCJi91qaKsoiPqdF7i6r+LeJBaqwQ+lLQvcpXB5ceTfJ
         INDlXUH24LMgCB/uma/NpMrOjKZUJ2oPL++FrgqWZvpK0ahP2MR7z4+8pxsYCSB6FRfh
         G0rsh1853sZjts9I2XrPnT2/efHGwbH8ivlpB8MLkVZgK7Mm3XdQkl4RNSs/8BRz8DfB
         j7pOcj9kYKBF+cbiLjgdXklj+wcAP+ynLhVoSqs8E6n9K1553Ercf5RP1IAcM4weW1tR
         l5Qw==
X-Gm-Message-State: AOAM53119kFUEM3fvnbAD9mLhqszUOGvBmTHxgZoUH3IECmg2I//Nq1j
        fhO4oO9JoEkV0P0H8XKxR3qG6cmZiVU=
X-Google-Smtp-Source: ABdhPJys19/Uh3Y8xvieKM7jx2Zy2YOtkgJlfrUScsPe65g0GJ5vxyHUKpPN5EAJhxZ1/+cORbL0uw==
X-Received: by 2002:a63:cb51:: with SMTP id m17mr20006804pgi.337.1605947034120;
        Sat, 21 Nov 2020 00:23:54 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:53 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 04/11] xfs: Check for extent overflow when punching a hole
Date:   Sat, 21 Nov 2020 13:53:25 +0530
Message-Id: <20201121082332.89739-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
index 00000000..ba0b1a3b
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
+nr_blks=80
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
+	if (( $nextents > 35 )); then
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

