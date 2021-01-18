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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E7AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116A722581
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 06:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbhARGWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 01:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732060AbhARGWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 01:22:08 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043F7C0613D3;
        Sun, 17 Jan 2021 22:20:58 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q7so10304474pgm.5;
        Sun, 17 Jan 2021 22:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7UjqUaoiP4TTj1RVD9Zf0UWCU4yIfYnZ2LkNzeDhWlA=;
        b=Qva8idhimjfSZO/xYENUDfuBZQrJ2kmmwEgA5QhE7HNytN40HZcWTmn2bFLoXqP8KG
         kjhUHz++Tm8aXVbHgHrpw0/p9JShq45gvx5KNKpJLT9PHP7Klzd4zxXa2teFSY7o9F9q
         ZvO1MDgW7VJNxbc6X+sT7lSYmeNxy7hevEmCesOkcDBcwbwIF44RnW1d9w+PBFcI5ava
         RvLgfR5Z2FBU7Z3ZW42GkAjIqWRWtTb9H2sZZ2ChoO7gBYCWPDKLF7TQjvniwIM1FRne
         850VQaFiV+LYQP3/2NOfQ2p03WaVExnj55zSU/kfH9os972PsXCLP6jq0/BVSrOVtGRB
         aNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7UjqUaoiP4TTj1RVD9Zf0UWCU4yIfYnZ2LkNzeDhWlA=;
        b=AAe7WADsN7g4d26S5ZlYmIbL+2P5vkPwDo4Xv4jn8S4AdmlMY4H7JRmstOko/qftPE
         Q75zmog/B5qaC3nU6h1DVZPumcPMJcRJM+lxaxkiIPGAl/tyRcs3auYivkCscGNS8O/X
         zyIQgLRItgVGRE0/j17jyq9fVdl5kQ8ErhJF1LEv58RHyfLP3srUDtx+VA3QwD2Dhq0e
         /lAsAcaTx2QfhoEdMEFBlvI/j5pOyVEc4LNrZgb5KG6Kvk6DEd3LDpKtGmbWOj9eaz7t
         ygzKu7EYBh10O0CsS35sEkuOCL6FRv7CvVpbLfKQ9BVQ/HefZpgUcwUvNhmxUA0mwXOg
         usNQ==
X-Gm-Message-State: AOAM532Iz+oDdvMeALGulOo+l2rOuapwKD4Wh0iqC3WTERiGGmSL6KT3
        bL78VUItRl7vIsLTpwT4VROcbpiUpGY=
X-Google-Smtp-Source: ABdhPJzuDWa4BHhOB4hi2GNK6rPZ6JQ0kLlO96I+wmM4nnqoS814YiYbAKpOoLg3u2cyOUCYfPhdxg==
X-Received: by 2002:a63:ce58:: with SMTP id r24mr24610640pgi.192.1610950857418;
        Sun, 17 Jan 2021 22:20:57 -0800 (PST)
Received: from localhost.localdomain ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id t1sm14608423pfq.154.2021.01.17.22.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:20:57 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V4 06/11] xfs: Check for extent overflow when adding/removing dir entries
Date:   Mon, 18 Jan 2021 11:50:17 +0530
Message-Id: <20210118062022.15069-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118062022.15069-1-chandanrlinux@gmail.com>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing directory entries.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/526     | 186 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  17 +++++
 tests/xfs/group   |   1 +
 3 files changed, 204 insertions(+)
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out

diff --git a/tests/xfs/526 b/tests/xfs/526
new file mode 100755
index 00000000..5a789d61
--- /dev/null
+++ b/tests/xfs/526
@@ -0,0 +1,186 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 526
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
+if (( $dbsize != $dirbsize )); then
+	_notrun "FSB size ($dbsize) and directory block size ($dirbsize) do not match"
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
+nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
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
+nextents=$($XFS_IO_PROG -c 'stat' $dstdir | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
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
+nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
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
+nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
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
diff --git a/tests/xfs/526.out b/tests/xfs/526.out
new file mode 100644
index 00000000..d055f56d
--- /dev/null
+++ b/tests/xfs/526.out
@@ -0,0 +1,17 @@
+QA output created by 526
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
index bd38aff0..d089797b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -523,3 +523,4 @@
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
 525 auto quick attr
+526 auto quick dir hardlink symlink
-- 
2.29.2

