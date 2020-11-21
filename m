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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B26C388F9
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CAC22269
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irSwRXW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgKUIX5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:57 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEECC0613CF;
        Sat, 21 Nov 2020 00:23:57 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q34so9450630pgb.11;
        Sat, 21 Nov 2020 00:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8p24vg1QYRAdft/ri+YAlOtLiS09tRhRxSLUxtPEzS8=;
        b=irSwRXW2NN46Msd37wDLyJNWLcVRf81JZ11HON4D8orqVKHbKujnunGXjgthTsGNnp
         DZpysf1wtQhAufGDRjQ/ATwjUDboupMG6d0+TC42SEOup2aUaESxljYGbXcH0xr32UzX
         +/HZVstDMbmnt8QT3e5a5FhVFIiHTRWXeyxJGcCuU8H/U1DG+MqJVg67QeCYUDqoaMyW
         1b74h/swRRuyqG8Q/xLPXAA7dgY5qP6EVAhs5/gMKouUY4GA3kw9vyA2hXYqhbTHWqor
         bpwv82KzB6ByM1/rtXIkAXSt/R7QbgGNIMHw99vr+zPZ9hzS1RL8fsbwTUx5yK3nZWn7
         aJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8p24vg1QYRAdft/ri+YAlOtLiS09tRhRxSLUxtPEzS8=;
        b=BNsh3UhRhHLhaa3UZCAZ2BWd7avTfKVn9lciZWItKp3ezD5lafu0ecd9kK9TOQ2b/x
         3wwRz1iBk2wJH3UumtXaWeeX2MFP/WQPkdZyMj+VvjzLyjRrI4Ad2i0Z4yjO1u7w+xaY
         Djx+QSXlW8KOhSvppm8A/Hha1qmn4wO/Rhs7TLmi/4f30FhrHoa3efSO43Wx+ZlAox7i
         xQDEeLvsrfk9aZyPweQWbno2BRuFUBn/i761ebTZuGUiSt9fKxhCj1HXrGbREkIanQZf
         LJJmBnD5JyCOi3v4D5mZksIRPVfntEmCyjbHV7pQ/H7ljqxJTJ2D/BoSECo/Fzsyy0UX
         laEg==
X-Gm-Message-State: AOAM531EX0iJtjhPArFkEv5omRduDFlh/AEz694CQKCBAjSioA3jR559
        D6cwvps3IQPRzLzARlcwwmBFlBV/m/4=
X-Google-Smtp-Source: ABdhPJzyaLC9hmHtYXB5wQWHyMXI6y8sSULG2UoDCcLRG8oMqVz2PwX1NiF1dleo5BgIf2JKQMt6wg==
X-Received: by 2002:a17:90b:1115:: with SMTP id gi21mr14762423pjb.58.1605947036792;
        Sat, 21 Nov 2020 00:23:56 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:56 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 05/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Sat, 21 Nov 2020 13:53:26 +0530
Message-Id: <20201121082332.89739-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/525     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/525.out |  19 +++++
 tests/xfs/group   |   1 +
 3 files changed, 196 insertions(+)
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out

diff --git a/tests/xfs/525 b/tests/xfs/525
new file mode 100755
index 00000000..07061bbe
--- /dev/null
+++ b/tests/xfs/525
@@ -0,0 +1,176 @@
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
+# To be able to remove xattr entries in a situation where inserting new xattrs
+# is prevented due to possible extent count overflow , each xattr insert
+# operation should reserve an extent count for deletion of maximum sized xattr
+# apart from the extent count required for the xattr insert operation being
+# performed.
+#
+# The following table gives an estimation of the total extent count that needs
+# to be reserved for maximum sized "local" xattr insert operation for various
+# block sizes,
+#
+# |-------+----------------------------------------+----------------------------------|
+# | Block |         Worst case remove extent count |                     Total extent |
+# |  size | (XFS_DA_NODE_MAXDEPTH + (64k / bsize)) |                            count |
+# |       |                                        | (Xattr insert extent count (6) + |
+# |       |                                        |  Worst case remove extent count) |
+# |-------+----------------------------------------+----------------------------------|
+# |  1024 |                                     69 |                               75 |
+# |  2048 |                                     37 |                               43 |
+# |  4096 |                                     22 |                               28 |
+# | 32768 |                                      7 |                               13 |
+# | 65536 |                                      6 |                               12 |
+# |-------+----------------------------------------+----------------------------------|
+# Note: Xattr insert extent count = XFS_DA_NODE_MAXDEPTH + 1 = 6.
+#
+# 35 (which is > 28) has been chosen as the pseudo maximum extent count in the
+# XFS kernel module. Hence xattr tests are limited to block sizes >= 4k.
+
+if (( $bsize < 4096 )); then
+	_notrun "FSB size ($bsize) is less than 4k"
+fi
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
+nr_attrs=$((bsize * 45 / attr_len))
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
+if (( $naextents > 35 )); then
+	echo "Extent count overflow check failed: naextents = $naextents"
+	exit 1
+fi
+
+echo "Remove one xattr"
+attr="$(printf "trusted.%0247d" 1)"
+$SETFATTR_PROG -x "$attr" $testfile
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
+while (( $naextents < 30 )); do
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
index 00000000..c90dc873
--- /dev/null
+++ b/tests/xfs/525.out
@@ -0,0 +1,19 @@
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
+Remove one xattr
+Remove $testfile
+* Remove xattrs
+Create $testfile
+Disable reduce_max_iextents error tag
+Create initial xattr extents
+Inject reduce_max_iextents error tag
+Remove xattr to trigger -EFBIG
+Successfully removed $testfile
diff --git a/tests/xfs/group b/tests/xfs/group
index 7031cabf..bfaac6aa 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -522,6 +522,7 @@
 522 auto quick quota
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
+525 auto quick attr
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

