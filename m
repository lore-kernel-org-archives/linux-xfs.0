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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EB6C64E8A
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066FB22254
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHTlWXpK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKUIYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:00 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37237C0613CF;
        Sat, 21 Nov 2020 00:24:00 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v21so4911877plo.12;
        Sat, 21 Nov 2020 00:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rAdRS1EDmyYTKWOPc2TF69inX1ML8LobnyJwdxiy0dk=;
        b=gHTlWXpKYyc/JC4mNwBl1UtXZYVZXG1dOc/q95OP/wPTLEBUng39tYCn6+uKAfOExy
         pRDX2/5FUB9rP+DuZeuuBgMBw+42u589JHi3XPKpg7tUQnOChrCkkjoOZ5Gi2pWQfs37
         aQ/7nc51bIrx2c2Dka1v0ar4d0gzNa9Tn30zsL0w7a6bV0IbrpzLk+GD8ySZtsoqqyNM
         LjUFRjLPMw/jYKWZ+BhQ1S/jzYfpUQTlCjdUjQqxo39HPjFtH7wBZOz+75+jy2+pvIa4
         hbbvpgk+6voT/bjOEzkwUP2Y9/h1+24IGZsJHXZwaZb0P22qOOShZdTf2RNqUsiaw1gk
         7Anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rAdRS1EDmyYTKWOPc2TF69inX1ML8LobnyJwdxiy0dk=;
        b=ANWUWk4FaDFr33qX1d/5VYhdLmjFZJEwVUDahRc9FwMOxVqR9I5bFyI5xEmjPXYVaK
         /+PZuuDcxUba9GPuH99tXOxv19MHrKA7pC966TlFX10/iL3CmFw8i+tQAKPMKG1FiQ6O
         TB7xCJxkvY+fsrf4YBS4iPLR/kwq9z0rXyTaWH1gwnmsMdGDZWoZPZIkjmcvb6SX2cUp
         gTN2WbaOzBnCf5t/EVQ4Ve/MmjDFfqbxPn6wwoho475wPczf/AX+9ddUSOxV6hqNOVQv
         Es+LtZBYQOGDVYCw+IY6f8ffG/z+rlAFN+smMZSt6PeYSLw+GVmYjeSFaR87NkISagp+
         va2w==
X-Gm-Message-State: AOAM5319lTGSApJlcj004IyEMqPY49zOPqMiiMeiQ/Roz/i3CJyiLX6U
        EQFO7INLMvpHqmIliVfJYqs2l+XKon0=
X-Google-Smtp-Source: ABdhPJwdahg+CNjlONwnuksg2TW30bEVYIw61J+fM3EOHpatVJsbaU0llMzjDqTXlwFeMKjsJkLxww==
X-Received: by 2002:a17:902:9f86:b029:d6:d25f:7ad8 with SMTP id g6-20020a1709029f86b02900d6d25f7ad8mr16811073plq.4.1605947039338;
        Sat, 21 Nov 2020 00:23:59 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:58 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 06/11] xfs: Check for extent overflow when adding/removing dir entries
Date:   Sat, 21 Nov 2020 13:53:27 +0530
Message-Id: <20201121082332.89739-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing directory entries.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/526     | 283 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  32 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 316 insertions(+)
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out

diff --git a/tests/xfs/526 b/tests/xfs/526
new file mode 100755
index 00000000..89e4bf4d
--- /dev/null
+++ b/tests/xfs/526
@@ -0,0 +1,283 @@
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
+nr_dents=$((dbsize * 40 / dent_len))
+for i in $(seq 1 $nr_dents); do
+	dentry="$(printf "%0255d" $i)"
+	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
+done
+
+echo "Verify directory's extent count"
+nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+dentry="$(printf "%0255d" 1)"
+rm $testdir/$dentry && echo "Successfully removed \$dentry"
+
+rm -rf $testdir
+
+echo "* Rename: Populate destination directory"
+
+dstdir=$SCRATCH_MNT/dstdir
+mkdir $dstdir
+
+nr_dents=$((dirbsize * 40 / dent_len))
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+dentry="$(printf "%0255d" 1)"
+rm $dstdir/$dentry && echo "Successfully removed \$dentry"
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
+nr_dents=$((dirbsize * 40 / dent_len))
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+dentry="$(printf "%0255d" 1)"
+rm $testdir/$dentry && echo "Successfully removed \$dentry"
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
+nr_dents=$((dirbsize * 40 / dent_len))
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
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+dentry="$(printf "%0255d" 1)"
+rm $testdir/$dentry && echo "Successfully removed \$dentry"
+
+rm -rf $testdir
+
+echo "* Rename: Populate source directory and mv one entry to destination directory"
+
+srcdir=${SCRATCH_MNT}/srcdir
+dstdir=${SCRATCH_MNT}/dstdir
+
+mkdir $srcdir
+mkdir $dstdir
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+nextents=0
+start=1
+nr_dents=$((dirbsize / dent_len))
+
+echo "Populate \$srcdir with atleast 30 extents"
+while (( $nextents < 30 )); do
+	end=$((start + nr_dents - 1))
+
+	for i in $(seq $start $end); do
+		dentry="$(printf "%0255d" $i)"
+		touch ${srcdir}/${dentry} || break
+	done
+
+	start=$((end + 1))
+
+	nextents=$($XFS_IO_PROG -c 'stat' $srcdir | grep nextents)
+	nextents=${nextents##fsxattr.nextents = }
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Move an entry from \$srcdir to trigger -EFBIG"
+dentry="$(printf "%0255d" 1)"
+mv ${srcdir}/${dentry} $dstdir >> $seqres.full 2>&1
+if [[ $? == 0 ]]; then
+	echo "Moving from \$srcdir to \$dstdir succeeded; Should have failed"
+fi
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+rm -rf $srcdir
+rm -rf $dstdir
+
+echo "* Populate a directory and remove one entry"
+
+testdir=$SCRATCH_MNT/testdir
+mkdir $testdir
+
+nextents=0
+start=1
+nr_dents=$((dirbsize / dent_len))
+
+echo "Populate directory with atleast 30 extents"
+while (( $nextents < 30 )); do
+	end=$((start + nr_dents - 1))
+
+	for i in $(seq $start $end); do
+		dentry="$(printf "%0255d" $i)"
+		touch ${testdir}/${dentry} || break
+	done
+
+	start=$((end + 1))
+
+	nextents=$($XFS_IO_PROG -c 'stat' $testdir | grep nextents)
+	nextents=${nextents##fsxattr.nextents = }
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Remove an entry from directory to trigger -EFBIG"
+dentry="$(printf "%0255d" 1)"
+rm ${testdir}/${dentry} >> $seqres.full 2>&1
+if [[ $? == 0 ]]; then
+	echo "Removing file succeeded; Should have failed"
+fi
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+rm -rf $testdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/526.out b/tests/xfs/526.out
new file mode 100644
index 00000000..5b1d3fac
--- /dev/null
+++ b/tests/xfs/526.out
@@ -0,0 +1,32 @@
+QA output created by 526
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+* Create directory entries
+Verify directory's extent count
+Successfully removed $dentry
+* Rename: Populate destination directory
+Populate $dstdir by moving new directory entries
+Verify $dstdir's extent count
+Successfully removed $dentry
+* Create multiple hard links to a single file
+Create multiple hardlinks
+Verify directory's extent count
+Successfully removed $dentry
+* Create multiple symbolic links to a single file
+Create multiple symbolic links
+Verify directory's extent count
+Successfully removed $dentry
+* Rename: Populate source directory and mv one entry to destination directory
+Disable reduce_max_iextents error tag
+Populate $srcdir with atleast 30 extents
+Inject reduce_max_iextents error tag
+Move an entry from $srcdir to trigger -EFBIG
+Disable reduce_max_iextents error tag
+* Populate a directory and remove one entry
+Populate directory with atleast 30 extents
+Inject reduce_max_iextents error tag
+Remove an entry from directory to trigger -EFBIG
+Disable reduce_max_iextents error tag
diff --git a/tests/xfs/group b/tests/xfs/group
index bfaac6aa..0e98d623 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -523,6 +523,7 @@
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
 525 auto quick attr
+526 auto quick dir hardlink symlink
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

