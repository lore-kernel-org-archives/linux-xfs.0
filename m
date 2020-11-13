Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96466C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386632224C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kxgFGxq/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgKMMFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgKML1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:43 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC52C0613D1;
        Fri, 13 Nov 2020 03:27:41 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b63so3770211pfg.12;
        Fri, 13 Nov 2020 03:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pot8Kf6jgb7e4v+fUhEDLSV5g2CFkO2k7KfvRf+68oY=;
        b=kxgFGxq/1u37Jm/TVHSs0lWzdVdbnY+FMjyo/eXi02lymZktLpLXXbTD+PEsk12i4z
         vHDoynGr3iuZjCOcDCZ+eSdCdeNm5tsWvTw3pjPrcWiTIPtG1743c9jx20x8Uqc2Nqrv
         9AxKYnxkMx/GaXPh7W8wOLXXieMJZLt9HrmyueHCsApryO7ghRcLqeSFS8JRgiEIC39p
         lOjc1t9+tedVJzIiC9NZ8uOmS3WJomeHva9coDWShsuFlR76qyL1eEI0Xi9IVLBTJ3S7
         ghlPNmzvHqbr5Vrqby0sPOUFoms2tRSvuNP4Ozxu31ALSkZjGBc5XYs214wHgcOcAD0Q
         NI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pot8Kf6jgb7e4v+fUhEDLSV5g2CFkO2k7KfvRf+68oY=;
        b=Rw77QNWbiqt3ZIuORA//+Mb9RfrYivxlSFcubejKG57m0HZfk673YSl7apOixcFzPY
         j+A7B7CNNWM9dmZqEd2d4AkL/wNCAznN0kEk5ZOS8iuy1Dfuk5VIbej/0cXV+UoQUaUL
         qrAFg4zQLjia+7GCz8ZBSPp1tHwNAcCVuQc2zb6WyIEL2y6LhN7ZqADBbubad9uf0Wev
         Xt5klMmNF3+GruS8GB6D93+ALwv94yzYwzDgDaOxxAfBODRLvIMDjG8Pudgi86Y6n1Z1
         U6FEzbWPC7wWDI+ZXqLcB4/+Ij/hc7dZVyLAV0vOopwTzXaw7ddF/FjXWZmJ6oDwsnFG
         cinw==
X-Gm-Message-State: AOAM532yMMIbEyUcjo8aKaAmS///6mM/xNFLkUBdCWbtze94grLJCUdU
        QPEasa6JuqpG7SeRtIRg1/CtEKX1Jf4=
X-Google-Smtp-Source: ABdhPJxLyJmeXCIHXWdOv+m8H6wH29UFH+rZHE8snEnDn2a5RvpYTuH1+X6y7F/bRuh+Wc+TCL6rOA==
X-Received: by 2002:a17:90a:d997:: with SMTP id d23mr814367pjv.218.1605266860492;
        Fri, 13 Nov 2020 03:27:40 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:39 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 04/11] xfs: Check for extent overflow when punching a hole
Date:   Fri, 13 Nov 2020 16:56:56 +0530
Message-Id: <20201113112704.28798-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when punching out an extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/524     | 210 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/524.out |  25 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 236 insertions(+)
 create mode 100755 tests/xfs/524
 create mode 100644 tests/xfs/524.out

diff --git a/tests/xfs/524 b/tests/xfs/524
new file mode 100755
index 00000000..9e140c99
--- /dev/null
+++ b/tests/xfs/524
@@ -0,0 +1,210 @@
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
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "fzero"
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+punch_range()
+{
+	echo "* Fpunch regular file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	nr_blks=30
+
+	echo "Create \$testfile"
+	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
+	       -c sync $testfile  >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "fpunch alternating blocks"
+	$here/src/punch-alternating $testfile >> $seqres.full 2>&1
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$testfile's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino data ||
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+finsert_range()
+{
+	echo "* Finsert regular file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)	
+
+	nr_blks=30
+
+	echo "Create \$testfile"
+	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
+	       -c sync $testfile  >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Finsert at every other block offset"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		xfs_io -f -c "finsert $((i * bsize)) $bsize" $testfile \
+		       >> $seqres.full 2>&1
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
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = ${nextents}"
+		exit 1
+	fi
+}
+
+fcollapse_range()
+{
+	echo "* Fcollapse regular file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)	
+
+	nr_blks=30
+
+	echo "Create \$testfile"
+	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
+	       -c sync $testfile  >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Fcollapse at every other block offset"
+	for i in $(seq 1 $((nr_blks / 2 - 1))); do
+		xfs_io -f -c "fcollapse $((i * bsize)) $bsize" $testfile \
+		       >> $seqres.full 2>&1
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
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = ${nextents}"
+		exit 1
+	fi
+}
+
+fzero_range()
+{
+	echo "* Fzero regular file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+	bsize=$(_get_block_size $SCRATCH_MNT)	
+
+	nr_blks=30
+
+	echo "Create \$testfile"
+	xfs_io -f -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
+	       -c sync $testfile  >> $seqres.full
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Fzero at every other block offset"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		xfs_io -f -c "fzero $((i * bsize)) $bsize" $testfile \
+		       >> $seqres.full 2>&1
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
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = ${nextents}"
+		exit 1
+	fi
+}
+
+punch_range
+finsert_range
+fcollapse_range
+fzero_range
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/524.out b/tests/xfs/524.out
new file mode 100644
index 00000000..58f7d7ae
--- /dev/null
+++ b/tests/xfs/524.out
@@ -0,0 +1,25 @@
+QA output created by 524
+* Fpunch regular file
+Format and mount fs
+Create $testfile
+Inject reduce_max_iextents error tag
+fpunch alternating blocks
+Verify $testfile's extent count
+* Finsert regular file
+Format and mount fs
+Create $testfile
+Inject reduce_max_iextents error tag
+Finsert at every other block offset
+Verify $testfile's extent count
+* Fcollapse regular file
+Format and mount fs
+Create $testfile
+Inject reduce_max_iextents error tag
+Fcollapse at every other block offset
+Verify $testfile's extent count
+* Fzero regular file
+Format and mount fs
+Create $testfile
+Inject reduce_max_iextents error tag
+Fzero at every other block offset
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 018c70ef..3fa38c36 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -521,3 +521,4 @@
 521 auto quick realtime growfs
 522 auto quick quota
 523 auto quick realtime growfs
+524 auto quick punch zero insert collapse
-- 
2.28.0

