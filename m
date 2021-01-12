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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF39CC43219
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B21BD22E01
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392021AbhALHmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387522AbhALHmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:13 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35465C0617A7;
        Mon, 11 Jan 2021 23:41:07 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j1so963994pld.3;
        Mon, 11 Jan 2021 23:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pXq1swQ3X8lKmN4LLR69V2aKz/5fowFJPyMsr2Quw6Q=;
        b=m4zJTmbbQxLA46hY2pjRPl7hBLdOST7F3qMAnB6HPUC47NapVw7Vh6fR4H7xYfjhmJ
         3y0Vm9pwERM7mgMj2RcKWxM7OCv0KsS1FyGnRJAWgcvfQh9Ft4Umx8mmKxHyagWN5lqb
         iPd5Qaojo9g9cFPrsD4HMDPX1QEPeJEjdM1jhuOoS+RF5yoUmLkj0OpGmVIz/trAD3Zv
         WscBoIGFOPY5gNiNtyqCKUTl+4QmPYlST4RllhQGfsxKPjANfWzMrP8FUiEQQUqIyCF7
         nxDCHBif6dlxLh6srl6OUeoNltZM+/t6QMxFGL8WiCcJAxxNg/mejKT29fHVqQI26rcf
         UMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pXq1swQ3X8lKmN4LLR69V2aKz/5fowFJPyMsr2Quw6Q=;
        b=rhVr2+c4knSl5zXxenq7+3uALQtyXbqzrLBCPn8Dpn9TSpojeRtMulcEhfMHJCaJJ6
         m35n1J9OqVr+jbAXEB9MnucsWvTMufZXV/ofIvd4dRx+JL/5lfaxqalJrMNX1oeez/Yh
         b75JMy5Eb0XRnTY2VTT73jqU5bn8c/Gi/jnCaz8IqYIG+3XreYwLZsRSgS9Bzgh/g5ay
         4kipaAgaDQ2OGXGi5vUn8H3bqJTk2EJrlNhkhXiK0I/dqjBsRZRpt54fTXm34ulIcL48
         NWWLsw46+PhjmFAYhN+fc/TpRT9tL+JV9IEhPczYVc/WywJ1hBLI7fLGjw1IzFJry+Xu
         Z9Iw==
X-Gm-Message-State: AOAM532bZZwYjBjaiBzPa5wF91R9EjylWZioYefPaVDtOCyCoxdsnsIC
        e+Fc2ouIsDPPi8HDNdbCJXtJwZ4oKuo=
X-Google-Smtp-Source: ABdhPJzLjXicNNFH7JqpItiuB2vsPsDxfznmbw8kW/Yz/eBazXSq5lIGI0AzNj329i4Q8i1ACMhTww==
X-Received: by 2002:a17:902:7b98:b029:db:fab3:e74b with SMTP id w24-20020a1709027b98b02900dbfab3e74bmr3495420pll.27.1610437266610;
        Mon, 11 Jan 2021 23:41:06 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 08/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Tue, 12 Jan 2021 13:10:24 +0530
Message-Id: <20210112074027.10311-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to/funshare-ing a shared extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/528     | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  12 +++++
 tests/xfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..269d368d
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,110 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 528
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
+$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full
+
+echo "Buffered write to every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
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
+rm $dstfile
+
+echo "* Funshare shared extent"
+
+echo "Share the extent with \$dstfile"
+$XFS_IO_PROG -f -c "reflink $srcfile" $dstfile >> $seqres.full
+
+echo "Funshare every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
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
+# super_block->s_wb_err will have a newer seq value when compared to "/"'s
+# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
+ 
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..d0f2c878
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,12 @@
+QA output created by 528
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
index c17bc140..ea892308 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,6 +525,7 @@
 525 auto quick attr
 526 auto quick dir hardlink symlink
 527 auto quick
+528 auto quick reflink
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

