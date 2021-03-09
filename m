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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA249C43332
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF67652AB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCIFB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCIFBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:51 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA05C06174A;
        Mon,  8 Mar 2021 21:01:51 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id j12so8545996pfj.12;
        Mon, 08 Mar 2021 21:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ncwkbzvt+WbLSN/VqIehCEC60/hvj6MmhPTGOtBFyY=;
        b=K/8l9+fVsxQrUfJd5J+VfsMeUG32+z6IAoKh56mW+AoTQOmrxIgcsSDKpC1m1LARlw
         v+WKu3nhaxcJzFZmbAjyJACMM+FRLZmJEAgBu/H/g7nENU2xV4WysVCmXxao8WUtsI51
         PxEh3+gFWA4R7NGrOxs7n8NQ5BMN0JMT8+2vz9Y0PpjjbNeS/cmRtXNPkPTc4lCR/UrQ
         +ahTL8Nhel40YXfvLD9kdMjG4wQkPxfiK7Ec4Uu1omIP3fHkxplJo6xjG6TVQruGExH+
         W9rhyuO8J7FUWNBKa1McvCd49lXS2wjIAuPDOBrVnkQ21oEQb1+Z5AcIaMunknVcPqXt
         Z4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ncwkbzvt+WbLSN/VqIehCEC60/hvj6MmhPTGOtBFyY=;
        b=soCQkc6CgOdSkweqZ1AtNJTYJPAsLj4coIALXmYSnq+leTMEizXOeVPye++Dyr7hgE
         wLBqWj34Z1yTEwwdnMD8PullSyUrtM7JTjKmhwZw90qCr/bdiN9D2U1cNoKobcOErbQ7
         wtNnDNYtFx2Fh1wHhavMChN7xFNWePo1onLjgrxTMG2BuWZUW8eoieyBCAh/XPUBuOKP
         idTb9DmK8MYKcqerUR2ZZg1JI2+sQnd3QPb9h17wGEaE3Js7Oc3uDlrDsgRlsEJEoCOZ
         lLOPYE8qUXGdyUunRsLZHPffJ6LbiwmJr3aLWMdkbb+U/vbB62PQdADpHbGVS8r6KyEq
         5VoA==
X-Gm-Message-State: AOAM5323OWv20vQeP6YR8f1cTXeG+hxiFkcOxSZ25jgreUY232j7RN6W
        r106RGs49iliP1aO+4vZUH6fEOfv2CQ=
X-Google-Smtp-Source: ABdhPJzumYaHeQQ1BmdIq/Wo59ImxwzH3lsY6JxKz+QzQe7/iTfnvzfLYQ9CKVjqDI7XNCoZVQEVAQ==
X-Received: by 2002:a63:4a44:: with SMTP id j4mr23219891pgl.199.1615266110677;
        Mon, 08 Mar 2021 21:01:50 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:50 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 05/13] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
Date:   Tue,  9 Mar 2021 10:31:16 +0530
Message-Id: <20210309050124.23797-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Verify that XFS does not cause realtime bitmap/summary inode fork's
extent count to overflow when growing the realtime volume associated
with a filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 124 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  11 ++++
 tests/xfs/group   |   1 +
 3 files changed, 136 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..dd7019f5
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,124 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 529
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
+# Note that we don't _require_realtime because we synthesize a rt volume
+# below.
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
+
+# Realtime extent size has to be atleast 4k in size.
+if (( $dbsize < 4096 )); then
+	rtextsz=4096
+else
+	rtextsz=$dbsize
+fi
+
+rtdevsz=$((nr_bits * rtextsz))
+truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Format and mount rt volume"
+
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
+	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
+_try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
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
+	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
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
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..4ee113a4
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,11 @@
+QA output created by 529
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
index 2356c4a9..5dff7acb 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 526 auto quick mkfs
 527 auto quick quota
 528 auto quick quota
+529 auto quick realtime growfs
-- 
2.29.2

