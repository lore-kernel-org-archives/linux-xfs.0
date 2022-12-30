Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C0FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiLaDTH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:19:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272442733;
        Fri, 30 Dec 2022 19:19:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EC961D4E;
        Sat, 31 Dec 2022 03:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200B0C433D2;
        Sat, 31 Dec 2022 03:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456744;
        bh=Ggtn66S+tUqeJz6df9dnlBfZADFygW2KM2hrr+vUT64=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nk51PdjGupk3+SUTJzIUaTIbIqH5TaJgiiztEygujLjlUlYmYPPomCC4c/5U2s1yj
         TIFZ2DtvITcCdvaO5yL3/OxTnn9NZw+pjK8z78kSJc/Sd/12O8E8HbGHbYzavALuhn
         bU+hX6YM3jeefw4v7svF9QoCGFAx1od5US2MLjtsbudjPPss5DTdMqS7gaQzxemhOU
         zQsPlC+dhidIT+Cg6Ggm8wrQF9rfxu8sRe9c0qH+5cdsfv4BchjRik/acKMXZRG62d
         wv5RQ0/qYYX7+ScEsudWoKOZxtkrhyVCiaczjH0796usTQtSfyOoEGYigIAFq/81KI
         qJtn5toCyxIQg==
Subject: [PATCH 2/4] xfs: skip cowextsize hint fragmentation tests on realtime
 volumes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:52 -0800
Message-ID: <167243885297.740527.12727528755692010631.stgit@magnolia>
In-Reply-To: <167243885270.740527.7129374192035439232.stgit@magnolia>
References: <167243885270.740527.7129374192035439232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The XFS CoW extent size hint is ignored on realtime filesystems when the
rt extent size set to a unit larger than a single filesystem block
because it is assumed that the larger allocation unit is the
administrator's sole and mandatory anti-fragmentation strategy.  As
such, we can skip these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/reflink |   27 +++++++++++++++++++++++++++
 tests/xfs/180  |    1 +
 tests/xfs/182  |    1 +
 tests/xfs/184  |    1 +
 tests/xfs/192  |    1 +
 tests/xfs/200  |    1 +
 tests/xfs/204  |    1 +
 tests/xfs/208  |    1 +
 tests/xfs/315  |    1 +
 tests/xfs/326  |    6 ++++++
 10 files changed, 41 insertions(+)


diff --git a/common/reflink b/common/reflink
index 22adc4449b..1082642e4e 100644
--- a/common/reflink
+++ b/common/reflink
@@ -521,3 +521,30 @@ _sweave_reflink_rainbow_delalloc() {
 		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
 	done
 }
+
+# Require that the COW extent size hint can actually be used to combat
+# fragmentation on the scratch filesystem.  This is (so far) true for any
+# filesystem except for the ones where the realtime extent size is larger
+# than one fs block, for it is assumed that setting a rt extent size is the
+# preferred fragmentation avoidance strategy.
+_require_scratch_cowextsize_useful() {
+	local testfile=$SCRATCH_MNT/hascowextsize
+	local param="${1:-1m}"
+
+	rm -f $testfile
+	touch $testfile
+	local before="$($XFS_IO_PROG -c 'cowextsize' $testfile)"
+
+	$XFS_IO_PROG -c "cowextsize $param" $testfile
+	local after="$($XFS_IO_PROG -c 'cowextsize' $testfile)"
+	rm -f $testfile
+
+	test "$before" != "$after" || \
+		_notrun "setting cowextsize to $param had no effect"
+
+	local fileblocksize=$(_get_file_block_size $SCRATCH_MNT)
+	local fsblocksize=$(_get_block_size $SCRATCH_MNT)
+
+	test $fsblocksize -eq $fileblocksize || \
+		_notrun "XFS does not support cowextsize when rt extsize ($fileblocksize) > 1FSB ($fsblocksize)"
+}
diff --git a/tests/xfs/180 b/tests/xfs/180
index cfea2020ce..06b4b69d52 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -37,6 +37,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/182 b/tests/xfs/182
index 511aca6f2d..7c0713b248 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -39,6 +39,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/184 b/tests/xfs/184
index 3bdd86addf..a0dc2741f5 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -39,6 +39,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/192 b/tests/xfs/192
index eb577f15fc..daa4fcb1e0 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -41,6 +41,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/200 b/tests/xfs/200
index b51b9a54f5..8eb54b5755 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -41,6 +41,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/204 b/tests/xfs/204
index 7d6b79a86d..85b7ed7cd9 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -43,6 +43,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/208 b/tests/xfs/208
index 9a71b74f6f..3a4a3e4df1 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -40,6 +40,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_file_block_size $testdir)
diff --git a/tests/xfs/315 b/tests/xfs/315
index 9f6b39c8cc..3a618a3680 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -38,6 +38,7 @@ echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
+_require_scratch_cowextsize_useful $sz
 
 $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 
diff --git a/tests/xfs/326 b/tests/xfs/326
index ac620fc433..a3fed8b6ac 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -55,6 +55,12 @@ $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 # staging extent for an unshared extent and trips over the injected error.
 _require_no_xfs_always_cow
 
+# This test uses a very large cowextszhint to manipulate the COW fork to
+# contain a large unwritten extent before injecting the error.  XFS ignores
+# cowextsize when the realtime extent size is greater than 1FSB, so this test
+# cannot set up the preconditions for the test.
+_require_scratch_cowextsize_useful $sz
+
 echo "Create files"
 _pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
 _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2

