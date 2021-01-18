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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87320C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6205B22597
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbhARGWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732091AbhARGWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:15 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5C9C0613D6;
        Sun, 17 Jan 2021 22:21:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q4so8067100plr.7;
        Sun, 17 Jan 2021 22:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gj45JGvYkk5W0jnWrfD2y/z7Uml5Qb0gG1OtUd9hCwI=;
        b=nHDIMit//PWT82oWBKX//4Pd9lfIYSYvGeqrCpF9S8WEGvLW75uo3P16j4FW+t7SRe
         Lp6UCQ8fBUT6vdFrTEEzudPLjJ6QnRS3RHywmbd/fPRZaCA+0uZlRcg47/f1jRWYLUrh
         hMGQ5W849ugH56aEt9EndilDX3sgQ0Oe1G0LEyRLdevp14uwXAVWRgl2LkNF/5ypFCAb
         kBtpcgEbQ2Pvhn8mnih/yv7VxGeqB/Zv+fmr5RO/LSzoQvG1BULDV/oSxhfatVxjZv6M
         5BqE3aAsI4RRKjK91/eVPOsfiQeQ13ZSd29W/lFo451unP7nKBPHIK0Ijips/Le0f2f7
         8CQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gj45JGvYkk5W0jnWrfD2y/z7Uml5Qb0gG1OtUd9hCwI=;
        b=lmvkgwrsrNTxxJCBzbAQ+EugL/P+DrbdnxzvHJ2hr33yUHd9fbptu/ArOxImnNFNG5
         EkD6S4/dlZmVwz2ltYQNjA8tSEW9QolYEeU00Iob9Wkvt42NpSI/s+6M0B/zMCWr6Qo9
         4E5QxHP3roDh/Cpv033Ziyy4smYsEqE4fZWsI2JbQKcTmY9OTZolP5MAcMCk3/Kdx9YS
         JfsNVSI1ktOT/+RuaGzZmRv0x5GG1g14sG339Yv6lLfEN/D4bBsvrNS8lOzzly/z9w8t
         vIWgRVouMSR+ngL4TShuJydPlfaW2hfKrSiko8bmAaUZAvWmn6HHxcWX/YrgB1FBSuZ9
         n0+Q==
X-Gm-Message-State: AOAM530mSJNn4V0wbi+o07sTE7fOBNeShFyqZ4/YEHa/GbpgaeX5ziUn
        iardLO7/wgMP/OGSqOZ7iEogAITHQuI=
X-Google-Smtp-Source: ABdhPJwPWxJ+xZ25KsHt/HqIyDOtiAQSSW8WQXMyBrTDglsOyHXpZUj1vx6CSQyG2P1wPzxeRZA+vw==
X-Received: by 2002:a17:90a:517:: with SMTP id h23mr3693425pjh.108.1610950859645;
        Sun, 17 Jan 2021 22:20:59 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:59 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 07/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon, 18 Jan 2021 11:50:18 +0530
Message-Id: <20210118062022.15069-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to an unwritten extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/527     | 89 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/527.out | 11 ++++++
 tests/xfs/group   |  1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out

diff --git a/tests/xfs/527 b/tests/xfs/527
new file mode 100755
index 00000000..cd67bce4
--- /dev/null
+++ b/tests/xfs/527
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 527
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to an unwritten extent.
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+testfile=${SCRATCH_MNT}/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+nr_blks=15
+
+for io in Buffered Direct; do
+	echo "* $io write to unwritten extent"
+
+	echo "Fallocate $nr_blks blocks"
+	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
+
+	if [[ $io == "Buffered" ]]; then
+		xfs_io_flag=""
+	else
+		xfs_io_flag="-d"
+	fi
+
+	echo "$io write to every other block of fallocated space"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
+		       $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	echo "Verify \$testfile's extent count"
+	nextents=$($XFS_IO_PROG -c 'stat' $testfile | grep nextents)
+	nextents=${nextents##fsxattr.nextents = }
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	rm $testfile
+done
+
+# super_block->s_wb_err will have a newer seq value when compared to "/"'s
+# file->f_sb_err. Consume it here so that xfs_scrub can does not error out.
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/527.out b/tests/xfs/527.out
new file mode 100644
index 00000000..3597ad92
--- /dev/null
+++ b/tests/xfs/527.out
@@ -0,0 +1,11 @@
+QA output created by 527
+Format and mount fs
+Inject reduce_max_iextents error tag
+* Buffered write to unwritten extent
+Fallocate 15 blocks
+Buffered write to every other block of fallocated space
+Verify $testfile's extent count
+* Direct write to unwritten extent
+Fallocate 15 blocks
+Direct write to every other block of fallocated space
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index d089797b..627813fe 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,3 +524,4 @@
 524 auto quick punch zero insert collapse
 525 auto quick attr
 526 auto quick dir hardlink symlink
+527 auto quick
-- 
2.29.2

