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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A28C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2621D22838
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbhARGVv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731648AbhARGVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:21:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3882CC061757;
        Sun, 17 Jan 2021 22:20:51 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o20so1194408pfu.0;
        Sun, 17 Jan 2021 22:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dXh8gdoNbv/TtTkdd1We3ZVSTXnfbEKXi6TBqGYv5vk=;
        b=WSRSwP4wMT4B8DyoOm2I3d4yRsPDYPeuPTAnVdLJK/cPKz/GaORSSQxuL9fgXR5Pcj
         PuloPYApHXnmF/9PxvHC3/i3JoRK9QY/9VKD/niRg6wFov8k/C0YdBMqNR1b7skxvNRq
         GgQqtPPFdI97AYjqzkk/NFviwjotk1RuG0AxpEzNw2xEVup5RTd6/o6AdcrUon9wpboD
         ZMQi+NhHzaVXJYIQ6cDlaYarxEo92m1OfbYFlea4lb8LBHwxEnNm0DNnY8Z/qoZLo53G
         yDx8XsusHaQLsSogGHVHEe2tUIFpxkrRm7SI/MzvvBb0+nYAp0WR/VKaJp0GY+a3twm0
         2FqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXh8gdoNbv/TtTkdd1We3ZVSTXnfbEKXi6TBqGYv5vk=;
        b=RxTGxqFBOxxLdmvM0bvR1mX7NEaohV2Uwoomp5Bf02JS1WHtBFeCNHYhCxBMdiIT5l
         sOZXAbLvJs0wnVDuA/IgevlJ+95pQV8pLy5B7LR7ao83HJiMl5p+kQoW0+AqD7ZuXIyl
         kbG9XtbX+pFDMc7Q60vhkK0QPIGZR8uovGuBN1qo3Gc5iGyddCef5IiSARS7LFc456IJ
         pVgD+DglGyRLWFEu6+8leVBi1JpTXBf7JRguaXNPnwQK5gcPwTgTkHNGlMIo49n3WuMv
         6Xjv/2v0HeYlP8/yBVs61dTocnSP28HYFsxUTKtlhIXlIUCZaP7e5i4Pp9gYIfUGoKNG
         MDZQ==
X-Gm-Message-State: AOAM530fQfQRDOPu7kmrSUPMJLVsCWQ/0btLVvtfOPSjfGNUKewa/nLS
        0/waCmmdspqqbBmNYsv2a13Q/4V64GU=
X-Google-Smtp-Source: ABdhPJyySGJm195v14QJk2p1j2zjuQb+BDsXugK7xGSkcweqv0Z6nGP04peAkAMU/K1rBM8qr/dogw==
X-Received: by 2002:a63:4b5c:: with SMTP id k28mr24207244pgl.294.1610950850641;
        Sun, 17 Jan 2021 22:20:50 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 03/11] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
Date:   Mon, 18 Jan 2021 11:50:14 +0530
Message-Id: <20210118062022.15069-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
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
 tests/xfs/523     | 119 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/523.out |  11 +++++
 tests/xfs/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/523
 create mode 100644 tests/xfs/523.out

diff --git a/tests/xfs/523 b/tests/xfs/523
new file mode 100755
index 00000000..145f0ff6
--- /dev/null
+++ b/tests/xfs/523
@@ -0,0 +1,119 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 523
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
+rtextsz=$dbsize
+rtdevsz=$((nr_bits * rtextsz))
+truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Format and mount rt volume"
+
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
+	      -r size=2M,extsize=${rtextsz} >> $seqres.full
+_scratch_mount >> $seqres.full
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
+	ino=$(_scratch_xfs_db -c sb -c "print $rtino")
+	ino=${ino##${rtino} = }
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
+export USE_EXTERNAL=""
+export SCRATCH_RTDEV=""
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/523.out b/tests/xfs/523.out
new file mode 100644
index 00000000..7df02970
--- /dev/null
+++ b/tests/xfs/523.out
@@ -0,0 +1,11 @@
+QA output created by 523
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
index 1831f0b5..018c70ef 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,3 +520,4 @@
 520 auto quick reflink
 521 auto quick realtime growfs
 522 auto quick quota
+523 auto quick realtime growfs
-- 
2.29.2

