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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C74C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53A3227BF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbhARGWu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732203AbhARGWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:20 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008DAC061793;
        Sun, 17 Jan 2021 22:21:06 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i7so10304031pgc.8;
        Sun, 17 Jan 2021 22:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MIvnJ0VsDhNnrp8Hs5gLG61IFY55F0VThKgOo2dcDHI=;
        b=a3OxbXxQSDDnBU5kEuXvEzm6TGCO7E2XuFasNdiIibXP+iIekCCHwv7Jh1uQULOWXU
         87e15c4pDuZKdi13TWWcNWE4VOvvE3kVZwvVuYvT8CfbPPEqiv0e8q6Hr/Y6hWA8Z/74
         IXlDEfJgya2g5R24tEZdMgMICgu98emxQSWGSrCwGCa4taMYGcKAQ/46Y0tzubA4Lc2h
         SFnA7hGuJxtKAknCz/MeWUQtDPwTInKc5IowXxkz+0dJJVc+00rkGXUC3qKjG+4YXG5v
         yemrmyl3rGPqB4wIPiCnwcN31R/6/J2cDUT4pp+7Z3kovS7VYZA6t50i0oW3agq4C09k
         WwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MIvnJ0VsDhNnrp8Hs5gLG61IFY55F0VThKgOo2dcDHI=;
        b=HtzrlZ/kNrtoAoNYwQDQFEajn/cdYXPvAt8cudvEktLLBmPQj8MNcEoJuu4GbkO+tg
         nXkfbmxq6dYu8Br3g00r4L2oa18g6jyqvxoy9JqrnAb8r3TVi9f0uTRb3G82CfE0gaBr
         mkKOxqIgtOK4GfBrLciBavmB75rnqy7Vsl3rzTX7G3pfhIpZ/sP1xK9LAxqIwqHCZ/+9
         3VaCwTdwFPNreGq7u2WGmKoTOUZXmlz8bfp/aJcAutbfLeGFoi9pQSYNr/gNV5PQ1VHx
         kFv7PAhk8/goNOxRX6ulj0jxWhIFy0+WLhoqErl6J/idcVSUjffSw6MBRgZl8nC0HZ3J
         zz5g==
X-Gm-Message-State: AOAM532PLk0GGL4G8YWo3ABhhChVnyIst9dq8ww6WfxlFluV5ifD+lP7
        w7BdMGmcYB2Vq/D4SrJ1nnONVit/jQ4=
X-Google-Smtp-Source: ABdhPJzuQjUwpL//jMBAmj96Z7oGNxLReANFeOXllzPK//EiPgKBchwQ/GGMVDl9mi9b7pmSUjStRQ==
X-Received: by 2002:a63:585a:: with SMTP id i26mr24425570pgm.330.1610950866463;
        Sun, 17 Jan 2021 22:21:06 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:21:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 10/11] xfs: Check for extent overflow when swapping extents
Date:   Mon, 18 Jan 2021 11:50:21 +0530
Message-Id: <20210118062022.15069-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when swapping forks across two files.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/530.out |  13 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out

diff --git a/tests/xfs/530 b/tests/xfs/530
new file mode 100755
index 00000000..0986d8bf
--- /dev/null
+++ b/tests/xfs/530
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 530
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# swapping forks between files
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
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "swapext"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Swap extent forks"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+donorfile=${SCRATCH_MNT}/donorfile
+
+echo "Create \$donorfile having an extent of length 67 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 10); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+
+echo "Create \$srcfile having an extent of length 18 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
+for i in $(seq 1 7); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
+done
+
+echo "Collect \$donorfile's extent count"
+donor_nr_exts=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
+donor_nr_exts=${donor_nr_exts##fsxattr.nextents = }
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
+src_nr_exts=${src_nr_exts##fsxattr.nextents = }
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Swap \$srcfile's and \$donorfile's extent forks"
+$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$($XFS_IO_PROG -c 'stat' $donorfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$($XFS_IO_PROG -c 'stat' $srcfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/530.out b/tests/xfs/530.out
new file mode 100644
index 00000000..9f55608b
--- /dev/null
+++ b/tests/xfs/530.out
@@ -0,0 +1,13 @@
+QA output created by 530
+* Swap extent forks
+Format and mount fs
+Create $donorfile having an extent of length 67 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 18 blocks
+Fragment $srcfile
+Collect $donorfile's extent count
+Collect $srcfile's extent count
+Inject reduce_max_iextents error tag
+Swap $srcfile's and $donorfile's extent forks
+Check for $donorfile's extent count overflow
+Check for $srcfile's extent count overflow
diff --git a/tests/xfs/group b/tests/xfs/group
index bc3958b3..81a15582 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -527,3 +527,4 @@
 527 auto quick
 528 auto quick reflink
 529 auto quick reflink
+530 auto quick
-- 
2.29.2

