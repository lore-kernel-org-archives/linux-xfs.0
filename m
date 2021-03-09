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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC15C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A385D652A8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCIFCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhCIFCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:02:03 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D41C06174A;
        Mon,  8 Mar 2021 21:02:03 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 16so1526157pgo.13;
        Mon, 08 Mar 2021 21:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qZtleY3wzxVT6CvlavJW7x8kJqVdaHZImc3EPO0Aek=;
        b=aQXFiECYtJ/Gv+QJNFFdRaueLjWJ250FB7BkFABvP+Yv3VZVO8N1sGP2fNHKypxM/a
         ZgU7VPcaiaUWnwMxNRnY81LyAW1yEfQVt1SNkGMZ7joyHI/0cVDBhDtylt3gaZPPXVfm
         ST466nB/YPi9+1lBpp75JTa+J9cWmNV5bycCgZgqJ0iNxDYjRQNwiQxHbT780naErStk
         UvF6gDMeuKG8iZMTZ0jKnYbpNCI+xWyOqZ2uaqr5PNXd2W15JX5t6EOgkOCNsYH9+ux3
         XJZLwW21MbfZl+8S72VV5jsVbh54sybZI3CPSoZXCCYT91JP+R5eUlfhSdeVYdZEhY8b
         5rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qZtleY3wzxVT6CvlavJW7x8kJqVdaHZImc3EPO0Aek=;
        b=hE5XaX5h0UvzyFmKLwfB5TIGabwYtmUoJ8d5KmYT29LgoZbVFY6gUabJ8kHCRadzPl
         JIQc4d19SY7oJEm+UJwL29gXEdImcgq7pH1fvGjXWoMD1XsjApPyt6XEdUXjswUSKs0c
         6AKTS9qdIgk/sFNNq9ni2Uw6mMgpv3yehA2rDzcXFI7w5TLPYFnj8OhS7jB+4W0V+X84
         /lpVIPvbuIepsPu4zVzxLrOeCEegOkO11o24nrnE41+CneqX/TVJooBa4rp7VyHLNesg
         2Qt0gPOWwTMBG8bheXvxRwiIGC7Jm6gzc3uAOZhM4rhq3iRNc1PeQnMAocYyujuV/dhp
         wTHw==
X-Gm-Message-State: AOAM530HnI/+C1VqCP57PkHX/u9wQgv+xY4emJGpFtjGCwDY4Ic6GxDe
        9PVWeNJz51Sh2fPzEt0PXNRkb39DpmQ=
X-Google-Smtp-Source: ABdhPJwk48YdsHFYGYARwzQMGEvxM7N0FPOEIFywtel2tD6J71oHBW+RmWZVWwrizjVskDNUllR69A==
X-Received: by 2002:aa7:92c7:0:b029:1ee:75b2:2dab with SMTP id k7-20020aa792c70000b02901ee75b22dabmr24763697pfa.61.1615266122515;
        Mon, 08 Mar 2021 21:02:02 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:02:02 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 11/13] xfs: Check for extent overflow when remapping an extent
Date:   Tue,  9 Mar 2021 10:31:22 +0530
Message-Id: <20210309050124.23797-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/535     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/535.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/535
 create mode 100644 tests/xfs/535.out

diff --git a/tests/xfs/535 b/tests/xfs/535
new file mode 100755
index 00000000..98209e06
--- /dev/null
+++ b/tests/xfs/535
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 535
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
+	_reflink_range $srcfile $((i * bsize)) $dstfile $((i * bsize)) $bsize \
+		       >> $seqres.full 2>&1
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
diff --git a/tests/xfs/535.out b/tests/xfs/535.out
new file mode 100644
index 00000000..cfe50f45
--- /dev/null
+++ b/tests/xfs/535.out
@@ -0,0 +1,8 @@
+QA output created by 535
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 15 blocks
+Create $dstfile having an extent of length 15 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index b4f0c777..aed06494 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -532,3 +532,4 @@
 532 auto quick dir hardlink symlink
 533 auto quick
 534 auto quick reflink
+535 auto quick reflink
-- 
2.29.2

