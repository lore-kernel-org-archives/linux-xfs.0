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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CADC4160E
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC93265220
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCHPwA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhCHPvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:39 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7804C06174A;
        Mon,  8 Mar 2021 07:51:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id j12so7304750pfj.12;
        Mon, 08 Mar 2021 07:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SURDfOI58zJg6c8uN1nhSRiIbw4USkqI3jR97Wr0A2c=;
        b=M15mPhWbDeeXZvwJ0oXGHm5+IwG/Mw9GINBMS60N6M8g9GU1lFAMpHGImSu2TLNy3W
         Y9neeQO7OKmwNzxR4/w420Qs/GRIKg1RryJOPo/5DSD6a/lHlNZi80r0T1Yrbbc9c8Ma
         ctOzZB6MIQP/DIazAF1rEPxk5f+2jfyu3P8+6YvN41tecvWlhzngqWijgqlX6Bzlk8gG
         RminppRmw91hMdaPTX/IXTdd15MEw3EJHwfGp1c8s13abC5ZKQq8rOhsGWGe0kv4aQr1
         KumS2nrlS2t9kOadi2Lxc4gVx/bI8mt/9GntDAUK9BFBK3e0bRTeuWjGR78PE0BzBSUe
         fnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SURDfOI58zJg6c8uN1nhSRiIbw4USkqI3jR97Wr0A2c=;
        b=p8wKSQmf+4q8X0iKu4BCZ9ZFq0aOtXGYwYul+KENuqV707ETtUiqWahxePQ07hHsEE
         gIehLK9dApPjMF//iSmG5Z2hfs26FCrgeQYiUb9vUVWi3VOxG+WgTBzVtAdbTAyWXPQQ
         0s8shlvLnLuhFSZSV3VaJL+HueGfEi7f5HRQyM20EwyX2hIXuXNTazTarriTh0/ys2/e
         ky4z4PDrq4KybhMekywgL+aNVs/g8mRws7cx0hBvklbN3j/crHfJVMbXhZ+9HLDoWFuD
         /tlAH2T8H2j5TdgPCZiREetEPbMfHmlUmPh6lH6uT1AAeqPuKwKLE0ZycLtDDr9JS+HY
         rSbQ==
X-Gm-Message-State: AOAM532cT3lnKZDBLfHhYXSuamhmOp87SCCgo78JjgC2/CjueE8bCDBf
        qI/yG6mIOcr8ayLQvftKrDJJfeIGE18=
X-Google-Smtp-Source: ABdhPJw1GoPQei19pugthODEUo9GMis4q+c1BOrI1OQNO1e2y2q3L2S7tBAymhFVAtqV+XdT2ME+5Q==
X-Received: by 2002:a62:7bc4:0:b029:1f1:58ea:4010 with SMTP id w187-20020a627bc40000b02901f158ea4010mr15932658pfc.70.1615218699136;
        Mon, 08 Mar 2021 07:51:39 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:38 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 08/13] xfs: Check for extent overflow when adding/removing dir entries
Date:   Mon,  8 Mar 2021 21:21:06 +0530
Message-Id: <20210308155111.53874-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing directory entries.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/532     | 182 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/532.out |  17 +++++
 tests/xfs/group   |   1 +
 3 files changed, 200 insertions(+)
 create mode 100755 tests/xfs/532
 create mode 100644 tests/xfs/532.out

diff --git a/tests/xfs/532 b/tests/xfs/532
new file mode 100755
index 00000000..235b60b5
--- /dev/null
+++ b/tests/xfs/532
@@ -0,0 +1,182 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 532
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding/removing directory entries.
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
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+. $tmp.mkfs
+
+# Filesystems with directory block size greater than one FSB will not be tested,
+# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
+# count) = 14" is greater than the pseudo max extent count limit of 10.
+# Extending the pseudo max limit won't help either.  Consider the case where 1
+# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
+# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
+if (( $dirbsize > $dbsize )); then
+	_notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
+fi
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
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
+dent_len=255
+
+echo "* Create directory entries"
+
+testdir=$SCRATCH_MNT/testdir
+mkdir $testdir
+
+nr_dents=$((dbsize * 20 / dent_len))
+for i in $(seq 1 $nr_dents); do
+	dentry="$(printf "%0255d" $i)"
+	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
+done
+
+echo "Verify directory's extent count"
+nextents=$(xfs_get_fsxattr nextents $testdir)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm -rf $testdir
+
+echo "* Rename: Populate destination directory"
+
+dstdir=$SCRATCH_MNT/dstdir
+mkdir $dstdir
+
+nr_dents=$((dirbsize * 20 / dent_len))
+
+echo "Populate \$dstdir by moving new directory entries"
+for i in $(seq 1 $nr_dents); do
+	dentry="$(printf "%0255d" $i)"
+	dentry=${SCRATCH_MNT}/${dentry}
+	touch $dentry || break
+	mv $dentry $dstdir >> $seqres.full 2>&1 || break
+done
+
+rm $dentry
+
+echo "Verify \$dstdir's extent count"
+
+nextents=$(xfs_get_fsxattr nextents $dstdir)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm -rf $dstdir
+
+echo "* Create multiple hard links to a single file"
+
+testdir=$SCRATCH_MNT/testdir
+mkdir $testdir
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+nr_dents=$((dirbsize * 20 / dent_len))
+
+echo "Create multiple hardlinks"
+for i in $(seq 1 $nr_dents); do
+	dentry="$(printf "%0255d" $i)"
+	ln $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break
+done
+
+rm $testfile
+
+echo "Verify directory's extent count"
+nextents=$(xfs_get_fsxattr nextents $testdir)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm -rf $testdir
+
+echo "* Create multiple symbolic links to a single file"
+
+testdir=$SCRATCH_MNT/testdir
+mkdir $testdir
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+nr_dents=$((dirbsize * 20 / dent_len))
+
+echo "Create multiple symbolic links"
+for i in $(seq 1 $nr_dents); do
+	dentry="$(printf "%0255d" $i)"
+	ln -s $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break;
+done
+
+rm $testfile
+
+echo "Verify directory's extent count"
+nextents=$(xfs_get_fsxattr nextents $testdir)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm -rf $testdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/532.out b/tests/xfs/532.out
new file mode 100644
index 00000000..2766c211
--- /dev/null
+++ b/tests/xfs/532.out
@@ -0,0 +1,17 @@
+QA output created by 532
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+* Create directory entries
+Verify directory's extent count
+* Rename: Populate destination directory
+Populate $dstdir by moving new directory entries
+Verify $dstdir's extent count
+* Create multiple hard links to a single file
+Create multiple hardlinks
+Verify directory's extent count
+* Create multiple symbolic links to a single file
+Create multiple symbolic links
+Verify directory's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 7e284841..77abeefa 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -529,3 +529,4 @@
 529 auto quick realtime growfs
 530 auto quick punch zero insert collapse
 531 auto quick attr
+532 auto quick dir hardlink symlink
-- 
2.29.2

