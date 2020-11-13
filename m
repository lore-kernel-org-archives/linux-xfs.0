Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253BFC63697
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D28262224C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOlShzuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgKMMFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgKML1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:47 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B096C0617A6;
        Fri, 13 Nov 2020 03:27:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id w4so6826148pgg.13;
        Fri, 13 Nov 2020 03:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSHIjMLszJX+fVahS+/Q1sywlr/Eq7uHni2gPmOwKNk=;
        b=pOlShzuXLn698yv4OYxW4BZjsrcJZEw5++VUjQzzpswf/oWoqWKbLRSSQhDEpakyIk
         w3/EfOA4i39FauTmv61xR7RKNi8e+l3XZzszG3DbipTy/3JlYWM584haASZKCYIu8iHB
         YDjaqnUV3ssFVTArDhd0kvPLqkiG0gzVDUtOYy+ohettnpVtogtMekaS7iL27C538BVT
         XgKBSZ1ydr2+yNNjND/qTCqpFQ3K3nxi2ovxbex+Quc52XCtWPvaHs02c3pqVfbxGhDn
         SIHb8T+y20lEdBpAQHFMIdCWThuQiOnZO4frNVQZVL/ZpHdhkZibz/3gEWqEf3/2DM2b
         2v7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSHIjMLszJX+fVahS+/Q1sywlr/Eq7uHni2gPmOwKNk=;
        b=s9eXhDjPLHYV/9b4bdyMUty8quiUnVaBjEpTIAF4dvwwgeE+UlILULPy48WOM59QdC
         NVmw4EaOLIICv208HEWwWrrgBeOhVxCKUWIJwqRBkp0pU13gic1fWZmpZLTK5TMQF6Ks
         kOvTKG1jgNBxdNgOYro8uOzZw/qgXrPD8ofLoLc44IYXofJqmY3k+EKzn9opUPGp9Yde
         OrY+mW0XwMoEE3gl/6sWrsT08iNZpFIQC0ClXJdZeY55M6WLd//1ytaJClFWpw4GMO7s
         ijNK1SKNFeTCeTbh81RifXH1stAqg0madLWVxmZ3G4PmbdxIWWFu1AwPr5qDC6WYZO/J
         lNYg==
X-Gm-Message-State: AOAM530RDX12dD4ph1GOMrERaxpOKR2lYC45sR8hs/qOx5Vq6Qe4ZUFO
        boIYNz2/umLYVa9MLDmEIenULurAhaI=
X-Google-Smtp-Source: ABdhPJyACVH1kNluM4vUTAlSniSmKM0R+2+DPxUsDI6Jz0yS+ZW4du35cejZBFwEI0ygdym6IIxlVw==
X-Received: by 2002:a17:90a:cf84:: with SMTP id i4mr1478255pju.88.1605266865583;
        Fri, 13 Nov 2020 03:27:45 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:45 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 06/11] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 13 Nov 2020 16:56:58 +0530
Message-Id: <20201113112704.28798-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing directory entries.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/526     | 360 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  47 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 408 insertions(+)
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out

diff --git a/tests/xfs/526 b/tests/xfs/526
new file mode 100755
index 00000000..39cfbcf8
--- /dev/null
+++ b/tests/xfs/526
@@ -0,0 +1,360 @@
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
+dir_entry_create()
+{
+	echo "* Create directory entries"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	echo "Create directory entries"
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dbsize * 20 / dent_len))
+	for i in $(seq 1 $nr_dents); do
+		touch $SCRATCH_MNT/$(uuidgen) >> $seqres.full 2>&1 || break
+	done
+
+	dirino=$(stat -c "%i" $SCRATCH_MNT)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify directory's extent count"
+
+	nextents=$(_scratch_get_iext_count $dirino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+dir_entry_rename_dst()
+{
+	echo "* Rename: Populate destination directory"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	dstdir=$SCRATCH_MNT/dstdir
+	mkdir $dstdir
+
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dirbsize * 20 / dent_len))
+
+	echo "Populate \$dstdir by mv-ing new directory entries"
+	for i in $(seq 1 $nr_dents); do
+		file=${SCRATCH_MNT}/$(uuidgen)
+		touch $file || break
+		mv $file $dstdir >> $seqres.full 2>&1 || break
+	done
+
+	dirino=$(stat -c "%i" $dstdir)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify \$dstdir's extent count"
+
+	nextents=$(_scratch_get_iext_count $dirino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+dir_entry_rename_src()
+{
+	echo "* Rename: Populate source directory and mv one entry to destination directory"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	srcdir=${SCRATCH_MNT}/srcdir
+	dstdir=${SCRATCH_MNT}/dstdir
+
+	mkdir $srcdir $dstdir
+
+	dirino=$(stat -c "%i" $srcdir)
+
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dirbsize / dent_len))
+	nextents=0
+	last=""
+
+	echo "Populate \$srcdir with atleast 4 extents"
+	while (( $nextents < 4 )); do
+		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+		for i in $(seq 1 $nr_dents); do
+			last=${srcdir}/$(uuidgen)
+			touch $last || break
+		done
+
+		_scratch_unmount >> $seqres.full
+
+		nextents=$(_scratch_get_iext_count $dirino data || \
+				_fail "Unable to obtain inode fork's extent count")
+
+		_scratch_mount >> $seqres.full
+	done
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Move an entry from \$srcdir to trigger -EFBIG"
+	mv $last $dstdir >> $seqres.full 2>&1
+	if [[ $? == 0 ]]; then
+		echo "Moving from \$srcdir to \$dstdir succeeded; Should have failed"
+	fi
+
+	_scratch_unmount >> $seqres.full
+}
+
+dir_entry_create_hard_links()
+{
+	echo "* Create multiple hard links to a single file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dirbsize * 20 / dent_len))
+
+	echo "Create multiple hardlinks"
+	for i in $(seq 1 $nr_dents); do
+		ln $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break
+	done
+
+	dirino=$(stat -c "%i" $SCRATCH_MNT)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify directory's extent count"
+
+	nextents=$(_scratch_get_iext_count $dirino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+dir_entry_create_symlinks()
+{
+	echo "* Create multiple symbolic links to a single file"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dirbsize * 20 / dent_len))
+
+	echo "Create multiple symbolic links"
+	for i in $(seq 1 $nr_dents); do
+		ln -s $testfile ${SCRATCH_MNT}/$(uuidgen) >> $seqres.full 2>&1 || break;
+	done
+
+	dirino=$(stat -c "%i" $SCRATCH_MNT)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify directory's extent count"
+
+	nextents=$(_scratch_get_iext_count $dirino data || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+	fi
+}
+
+dir_entry_remove()
+{
+	echo "* Populate a directory and remove one entry"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	dirino=$(stat -c "%i" $SCRATCH_MNT)
+
+	dent_len=$(uuidgen | wc -c)
+	nr_dents=$((dirbsize / dent_len))
+	nextents=0
+	last=""
+
+	echo "Populate directory with atleast 4 extents"
+	while (( $nextents < 4 )); do
+		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+		for i in $(seq 1 $nr_dents); do
+			last=${SCRATCH_MNT}/$(uuidgen)
+			touch $last || break
+		done
+
+		_scratch_unmount >> $seqres.full
+
+		nextents=$(_scratch_get_iext_count $dirino data || \
+				_fail "Unable to obtain inode fork's extent count")
+
+		_scratch_mount >> $seqres.full
+	done
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Remove an entry from directory to trigger -EFBIG"
+	rm $last >> $seqres.full 2>&1
+	if [[ $? == 0 ]]; then
+		echo "Removing file succeeded; Should have failed"
+	fi
+
+	_scratch_unmount >> $seqres.full
+}
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
+dir_entry_create
+dir_entry_rename_dst
+dir_entry_rename_src
+dir_entry_create_hard_links
+dir_entry_create_symlinks
+dir_entry_remove
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/526.out b/tests/xfs/526.out
new file mode 100644
index 00000000..21f77cd8
--- /dev/null
+++ b/tests/xfs/526.out
@@ -0,0 +1,47 @@
+QA output created by 526
+* Create directory entries
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Create directory entries
+Verify directory's extent count
+* Rename: Populate destination directory
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Populate $dstdir by mv-ing new directory entries
+Verify $dstdir's extent count
+* Rename: Populate source directory and mv one entry to destination directory
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Populate $srcdir with atleast 4 extents
+Inject reduce_max_iextents error tag
+Move an entry from $srcdir to trigger -EFBIG
+* Create multiple hard links to a single file
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Create multiple hardlinks
+Verify directory's extent count
+* Create multiple symbolic links to a single file
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Create multiple symbolic links
+Verify directory's extent count
+* Populate a directory and remove one entry
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Populate directory with atleast 4 extents
+Inject reduce_max_iextents error tag
+Remove an entry from directory to trigger -EFBIG
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
2.28.0

