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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFE0C64E7A
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1AD22254
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2ygw1Xj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgKUIXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:53 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EAC0613CF;
        Sat, 21 Nov 2020 00:23:52 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v5so6136767pff.10;
        Sat, 21 Nov 2020 00:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OBNwgYuDDvMsdB1m6qgDy2y5sV0eqFEetefPmt/B85Y=;
        b=f2ygw1Xjs569KL0o+maHwFI/EHppAjSGV3YPwKME3KFWopNIuHuXljp8wNW09oiQwP
         ANJgQF4S7V0p7LwMS6mee+OXUe1LIV5pBBPTI0aj1M63JzT6KLHmwkjoz0+B3Do1LDc7
         edkljMJPiGE7Pyf4CS9TF98mh8YCMZO7XtuUmzS5mR6kjMGIfZhEjIxv+x/TT0xCznL7
         qiNNGItT5hyIshUvQ4BgRLEv9a7YIDACKwfWi/CMIZm8DgewBwU61Q/I0aNvdpD7TN1t
         VcjNcZz3RtuwOH6I0hYXYHaD5THHf4KTmBVw5vyqNPf1MW6gkniV3oVbia1jdm5qeZlC
         F+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OBNwgYuDDvMsdB1m6qgDy2y5sV0eqFEetefPmt/B85Y=;
        b=T3tl1BjGXFjkYgBBKJro4IJFCHtTCVtjjnFXuUl72JP32YM/D881klzavzQ9gG4ilk
         6tfNZxgPx+y1mYeO5e/m1PA8b19MF2lfeXZQmCVPy4jvMvOb5OcJRrE5tjOQiDTS7cIx
         w2rIHk15vBsG3tKHGrQWS7xMIDnnK7dTek2JpUNLgsUCtwGJ1l7kuMQdMeendS6bNrLb
         mx6VFPI/hppLM+UxxctU91AVbYkjEh1vfoi3OUk+Ht44HmXy0HVbb0pliRMQlIm+pLfR
         RuxZPBPVaS4xkRtg0GunGYqrlt9TAxBY5qHCdHAIczJxObaNAyHL46us0pg6qiHnUPVn
         hp4g==
X-Gm-Message-State: AOAM533K2LAjxGJa615VE5aWorPREoHnx3KP2QOkUmheRvT5UJdPA3EP
        mzaZKKHtuLhh4AHapo95qRcTsCYpAIc=
X-Google-Smtp-Source: ABdhPJxumlU8ypj03XsFhO+r6M2AhM65Rciyh6FzMvl2Mi+nLQJuwXubfkEsaUymAa0XU8Q7dYsBxQ==
X-Received: by 2002:a17:90a:16c1:: with SMTP id y1mr14202029pje.168.1605947031624;
        Sat, 21 Nov 2020 00:23:51 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:51 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 03/11] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
Date:   Sat, 21 Nov 2020 13:53:24 +0530
Message-Id: <20201121082332.89739-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
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
index 00000000..fae7ab1f
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
+nr_bitmap_blks=40
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
+	if (( $nextents > 35 )); then
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
index 6aff1210..b375a94c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,6 +520,7 @@
 520 auto quick reflink
 521 auto quick realtime growfs
 522 auto quick quota
+523 auto quick realtime growfs
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

