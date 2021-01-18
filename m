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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50688C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299A9229C4
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732132AbhARGWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732041AbhARGWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:08 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B26C0613CF;
        Sun, 17 Jan 2021 22:20:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j12so176746pjy.5;
        Sun, 17 Jan 2021 22:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AFgkXl70cbhwwIhksj5vcFlmJ2rymNpMwaLmT5JS7VI=;
        b=jVFW9vzeu51KMshOQY2HjHJY1V0TMNZUCtqCJlgcyTxSLSkehWQk+jncf9q72Gaw9/
         /Jjf7dzBsBBul/IS+itiO631Dwq1cVG+jjWaSVN4chA9rmX9GyLxAsAU7QPyFa9kxPJm
         44T9x8g3ZPXdTAtIpXuLGAfWj2Fj1fZOdYqBXl/lRsrGYPWeHiCj6Lii7iktJwBVTaga
         OmfVPC3pxg0OczdpndLTS/q13QqG53XENQiDyfr/0X1vGJEylwVRwmJrso24Lbwer20w
         pqPoSmiNC8OmqHFIkqvrGhw4jvpFhLxx3tkncmYVRagmiJfWw51cVutWTnuN9QD6RdiG
         040g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFgkXl70cbhwwIhksj5vcFlmJ2rymNpMwaLmT5JS7VI=;
        b=A2vr3cPHeX7jzI5HH5b434Azg9hoGuL7TGiyrxhVwHUTHNIqFju/1DzIoxhb63Wy4y
         d5Syt0PFA2d2O9nWnjdUm8UH+/O7taTPp3dYY+scNLwf4YAcUAjf/90OHW4ckgGUuYDB
         F1aV9xcGY/vPXprkxnsYBgSTcK+edEgqQnaVMpG5RtAiwnFl9RCcRLIaLl4QYlrzoy2V
         +lT+PVeuXVNhlgoy2NI/Lu4AN83QgpS9wFh6JJzyNkaT/RV/u/frp18rAIQ05wfa25Ut
         f97s1cNa8rtEZJwKoVx2OT5Ycmre1eTw7AcH5Ufsrb3M58Igwijod6trYoaBhZ+MXZGQ
         jXqg==
X-Gm-Message-State: AOAM530BEKHkj3Fv9lLO0vxGZkl6eydqhpkJQPBpUu96HOPqHAiktPQL
        o0c9L1snErYzXG72irt6I05jyxJ9U10=
X-Google-Smtp-Source: ABdhPJxKiCmOrICSpOsjVWLm+Aaa13ByUD1GcTawPIYxF0iaOzNoTWuoGkBgOkgjoHQMcJfjiwQTfA==
X-Received: by 2002:a17:90a:d70e:: with SMTP id y14mr24507766pju.9.1610950855157;
        Sun, 17 Jan 2021 22:20:55 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 05/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon, 18 Jan 2021 11:50:16 +0530
Message-Id: <20210118062022.15069-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/525     | 141 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/525.out |  18 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 160 insertions(+)
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out

diff --git a/tests/xfs/525 b/tests/xfs/525
new file mode 100755
index 00000000..bdca846d
--- /dev/null
+++ b/tests/xfs/525
@@ -0,0 +1,141 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 525
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# Adding/removing xattrs.
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
+naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
+naextents=${naextents##fsxattr.naextents = }
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
+	naextents=$($XFS_IO_PROG -f -c 'stat' $testfile | grep naextents)
+	naextents=${naextents##fsxattr.naextents = }
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
diff --git a/tests/xfs/525.out b/tests/xfs/525.out
new file mode 100644
index 00000000..74b152d9
--- /dev/null
+++ b/tests/xfs/525.out
@@ -0,0 +1,18 @@
+QA output created by 525
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
index 3fa38c36..bd38aff0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -522,3 +522,4 @@
 522 auto quick quota
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
+525 auto quick attr
-- 
2.29.2

