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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2127DC4361A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6D7652AB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhCIFB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhCIFBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:55 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28425C06174A;
        Mon,  8 Mar 2021 21:01:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n17so2414292plc.7;
        Mon, 08 Mar 2021 21:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gOy0uAB+kmgeFjFalqiQ+ZNbpIqcPaD/CaY0LV8aROM=;
        b=HT3O7Wu+xDYZsUbxVKzWyOASBKLQfd10/omJehs0X8+MS28HLz6nrOBwDdl+M79+mu
         gossfzsGVuP6Qk37511dmnrCdb8p8jBbbFTQ3QRcohSA5md0x0XyoXFN3HohIyFFB/6a
         /MtqtYepsHyU7YQpCQmZbceNkm/kx3JW1tGniNhI4c/2pCzvaPKXzxUgW5CT071kUtj1
         iqnkMcxDHJN5Bm6bUEzQpEqI5SWMtaT85nqL5N58OGaIRaj7TCdFqEW6ilo5dQRW/uv6
         EI00bX/ZpMn1B6Q1UAjSxSnlo+WBtknaEtpd9hTbeHiV2IoTwTFI4UUpo8PsOr4vvY3A
         NTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOy0uAB+kmgeFjFalqiQ+ZNbpIqcPaD/CaY0LV8aROM=;
        b=Ml5Lrj4QyIENP9OnVERaoLE1SiQLLaBP07rhU0z4VGSYjW5jouv5GfS5E2Vz38wCp3
         G9TfxsJezYyBMU6z60nIAlIeCOtc8I/dfhx8y65oQHJbuZ5JuCjeuMKNx70/j4pXeIfh
         UcOVx3vf9eMfdUq0w01UJZrADpGV8R6eO3xU2FwURiEOvAoQMlxpKDoo2R6HnZRNAMvj
         /orI9lO2KxZpLVF2slzWY36B/m/aKpVajY52zAjVV1EVBdQFeCEBsLsdhy1T0SWpFsLt
         eLSNR13QdiqTL44ea9w3XgOgbb6ksX8eD5BWuv4/whgIOPiGTh1e72BKcCalgt4A2amX
         F70g==
X-Gm-Message-State: AOAM531C3lgI64Qfc8vH475OSYAibkloGVCwkOYMIS2VBzP6qLwW/kib
        L26MMTILFibkqBuT+K5djx0Hm9fSors=
X-Google-Smtp-Source: ABdhPJwasWI34BiZJETHBi8EU7kJP3UYckPuopyiMD+3wI2t3kJfquznN4HD24Av3HAw3CL0Hs/6kQ==
X-Received: by 2002:a17:90a:3902:: with SMTP id y2mr2776175pjb.202.1615266114515;
        Mon, 08 Mar 2021 21:01:54 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 07/13] xfs: Check for extent overflow when adding/removing xattrs
Date:   Tue,  9 Mar 2021 10:31:18 +0530
Message-Id: <20210309050124.23797-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/531     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/531.out |  18 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 158 insertions(+)
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

diff --git a/tests/xfs/531 b/tests/xfs/531
new file mode 100755
index 00000000..432c02cb
--- /dev/null
+++ b/tests/xfs/531
@@ -0,0 +1,139 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 531
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding/removing xattrs.
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
+. ./common/attr
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
+_require_attrs
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+attr_len=255
+
+testfile=$SCRATCH_MNT/testfile
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
+echo "* Set xattrs"
+
+echo "Create \$testfile"
+touch $testfile
+
+echo "Create xattrs"
+nr_attrs=$((bsize * 20 / attr_len))
+for i in $(seq 1 $nr_attrs); do
+	attr="$(printf "trusted.%0247d" $i)"
+	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's naextent count"
+
+naextents=$(_xfs_get_fsxattr naextents $testfile)
+if (( $naextents > 10 )); then
+	echo "Extent count overflow check failed: naextents = $naextents"
+	exit 1
+fi
+
+echo "Remove \$testfile"
+rm $testfile
+
+echo "* Remove xattrs"
+
+echo "Create \$testfile"
+touch $testfile
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+echo "Create initial xattr extents"
+
+naextents=0
+last=""
+start=1
+nr_attrs=$((bsize / attr_len))
+
+while (( $naextents < 4 )); do
+	end=$((start + nr_attrs - 1))
+
+	for i in $(seq $start $end); do
+		attr="$(printf "trusted.%0247d" $i)"
+		$SETFATTR_PROG -n $attr $testfile
+	done
+
+	start=$((end + 1))
+
+	naextents=$(_xfs_get_fsxattr naextents $testfile)
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Remove xattr to trigger -EFBIG"
+attr="$(printf "trusted.%0247d" 1)"
+$SETFATTR_PROG -x "$attr" $testfile >> $seqres.full 2>&1
+if [[ $? == 0 ]]; then
+	echo "Xattr removal succeeded; Should have failed "
+	exit 1
+fi
+
+rm $testfile && echo "Successfully removed \$testfile"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
new file mode 100644
index 00000000..7b699b7a
--- /dev/null
+++ b/tests/xfs/531.out
@@ -0,0 +1,18 @@
+QA output created by 531
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+* Set xattrs
+Create $testfile
+Create xattrs
+Verify $testfile's naextent count
+Remove $testfile
+* Remove xattrs
+Create $testfile
+Disable reduce_max_iextents error tag
+Create initial xattr extents
+Inject reduce_max_iextents error tag
+Remove xattr to trigger -EFBIG
+Successfully removed $testfile
diff --git a/tests/xfs/group b/tests/xfs/group
index 463d810d..7e284841 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,3 +528,4 @@
 528 auto quick quota
 529 auto quick realtime growfs
 530 auto quick punch zero insert collapse
+531 auto quick attr
-- 
2.29.2

