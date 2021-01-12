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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C1BC4332D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD05822E03
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390064AbhALHmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbhALHmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:42:11 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5E7C0617A5;
        Mon, 11 Jan 2021 23:41:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d4so142718plh.5;
        Mon, 11 Jan 2021 23:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wv0wC0Y2nMa7sKfq74YthnNcLgGAK5vR9W3+DouTvpU=;
        b=Xc9Ty1zcYLQJccRvGa1fYnCirbveO4xtYZqe7KJL5fVsXWMck/KF8tU80yHWg/vJCk
         vCjWa6IeKY8tQFUS//c7yrme/IGScea+ZVrXmcEAJZ/hhbqO9NcB7IphH+L97gDyi5ep
         1TT+oflohBstIvEa9PFx/ilMMN19zK9ktISdFajC2bslvXI9VE55LGXnMw1p4WscoW/D
         bAn84eEXcvuBnSC8acHw9Y5ean1f1Wj3THw6IDq18R/WhLPYNhI/aRSDhaZuNJDwtql+
         ZBQQGYJPSPTtAznVmpmiemXDoZM+xVd3E0YRz1pRf9GOERs8xhFBzJfFyouf3t3NiMBm
         GtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wv0wC0Y2nMa7sKfq74YthnNcLgGAK5vR9W3+DouTvpU=;
        b=q+l0ZX/c74lpZ43gTIhpbVSmktPwU7ojZf5qRQLWWqP5ekBcvgeHWSvshWS8s8kSDg
         fboadoyB4ie/FJECblX4cPYYlz5oGap8YeyR618BofUStmyimaTFMCjYoo9k/5qa2J2K
         Z7sUY2bh83WFOjh4rdoknZ77UDwGXKTsMhLgvEANplygRCMAYM4kHgXSxJfWzZPmNtOt
         IW1xRT3Y1qtQxsBThehxOGNfPOaC1Z+AZBE7TyHwo8WPp+92Bk3UZQOdEzczVoUBFIY6
         xlg2M0iQVdyn2ASaM/USIExxtXtEs8wGt/JS5x86py/v4WPDvVfOSYXZz3Ers08wFV9W
         /wTw==
X-Gm-Message-State: AOAM530lNM10LZLcjikgEfJcj6zfpxa/DwqPq498p+YQpnK6QpaVzcAY
        Az2dnY/xsoAugx1Ihfhc9M5g8OSzGNg=
X-Google-Smtp-Source: ABdhPJxOPwJFptV34YxlBVpHwX1sGAdDBwVPZhe4Pz9PvC7uCU4q8YqYKW9GrCGVzK+aIf/1DYsoUw==
X-Received: by 2002:a17:90a:6842:: with SMTP id e2mr3190781pjm.190.1610437261884;
        Mon, 11 Jan 2021 23:41:01 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:41:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 06/11] xfs: Check for extent overflow when adding/removing dir entries
Date:   Tue, 12 Jan 2021 13:10:22 +0530
Message-Id: <20210112074027.10311-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
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

