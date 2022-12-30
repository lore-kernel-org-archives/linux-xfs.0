Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E62C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiLaDSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDSw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:18:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB412733;
        Fri, 30 Dec 2022 19:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D48CDB81E68;
        Sat, 31 Dec 2022 03:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF88C433EF;
        Sat, 31 Dec 2022 03:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456728;
        bh=kkAncmtlgROoumNrICT7aA09iwxyFnjQmFDkrxSn0J4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CALRVmenN1OB6s6hlrVX4Gd9HOtfKQqSzHJtDfx0G2Fa7TuqHIHQVAfWfP43KVHCa
         VYdwT85XR2W907rUj/vFGGd464NoDIiSQp0Oou+xl/O0Oe1+LCKuPcWHa7snw2AORp
         r5WyHlUHmb2sR7hnTXJmEO/4H8fkHNNGtme9qcFj0zdq3nETK2QL2rxZ7m2UzDu5aN
         S89FfU9uPTJBNsq5EQC2DFF9o+24vGrSAjRgIXpdERhXJcS3XgimFPUQvlIe7Eban8
         BhTxpTdLMtHyqxUhaJX8Ue0e/4ysBOU433AAwNdZl0jMnwVD681HswqutVCaOs9bKG
         dRzhiSws2NNdg==
Subject: [PATCH 1/4] xfs: make sure that CoW will write around when rextsize >
 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:52 -0800
Message-ID: <167243885283.740527.14048806433666288002.stgit@magnolia>
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

Make sure that CoW triggers the intended copy-around behavior when we
write a tiny amount to the middle of a large rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/919     |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/919.out |   84 +++++++++++++++++++++++++++
 2 files changed, 247 insertions(+)
 create mode 100755 tests/xfs/919
 create mode 100644 tests/xfs/919.out


diff --git a/tests/xfs/919 b/tests/xfs/919
new file mode 100755
index 0000000000..45bb42f91f
--- /dev/null
+++ b/tests/xfs/919
@@ -0,0 +1,163 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 919
+#
+# Make sure that copy on write actually does the intended write-around when we
+# stage a tiny modification to a large shared realtime extent.  We should never
+# end up with multiple rt extents mapped to the same region.
+#
+. ./common/preamble
+_begin_fstest auto quick clone realtime
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "funshare"
+_require_realtime
+_require_scratch_reflink
+
+rtextsz=262144
+filesz=$((rtextsz * 3))
+
+echo "Format filesystem and populate"
+_scratch_mkfs -m reflink=1 -r extsize=$rtextsz > $seqres.full
+_scratch_mount >> $seqres.full
+
+# Force all our files to be on the realtime device
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+check_file() {
+	$XFS_IO_PROG -c fsync -c 'bmap -elpv' $1 >> $seqres.full
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	md5sum $1 | _filter_scratch
+}
+
+rtextsz_got=$(_xfs_get_rtextsize "$SCRATCH_MNT")
+test $rtextsz_got -eq $rtextsz || \
+	_notrun "got rtextsize $rtextsz_got, wanted $rtextsz"
+
+_pwrite_byte 0x59 0 $filesz $SCRATCH_MNT/a >> $seqres.full
+sync
+md5sum $SCRATCH_MNT/a | _filter_scratch
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/a >> $seqres.full
+
+echo "pwrite 1 byte in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/b
+_pwrite_byte 0x00 345678 1 $SCRATCH_MNT/b >> $seqres.full
+check_file $SCRATCH_MNT/b
+
+echo "mwrite 1 byte in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/c
+$XFS_IO_PROG -c "mmap -rw 0 $filesz" -c "mwrite -S 0x00 345678 1" -c msync $SCRATCH_MNT/c
+check_file $SCRATCH_MNT/c
+
+echo "fzero 1 byte in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/d
+$XFS_IO_PROG -c "fzero 345678 1" $SCRATCH_MNT/d
+check_file $SCRATCH_MNT/d
+
+echo "fpunch 1 byte in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/e
+$XFS_IO_PROG -c "fpunch 345678 1" $SCRATCH_MNT/e
+check_file $SCRATCH_MNT/e
+
+echo "funshare 1 byte in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/f
+$XFS_IO_PROG -c "funshare 345678 1" $SCRATCH_MNT/f
+check_file $SCRATCH_MNT/f
+
+echo "pwrite 1 block in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/g
+_pwrite_byte 0x00 327680 65536 $SCRATCH_MNT/g >> $seqres.full
+check_file $SCRATCH_MNT/g
+
+echo "mwrite 1 block in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/h
+$XFS_IO_PROG -c "mmap -rw 0 $filesz" -c "mwrite -S 0x00 327680 65536" -c msync $SCRATCH_MNT/h
+check_file $SCRATCH_MNT/h
+
+echo "fzero 1 block in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/i
+$XFS_IO_PROG -c "fzero 327680 65536" $SCRATCH_MNT/i
+check_file $SCRATCH_MNT/i
+
+echo "fpunch 1 block in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/j
+$XFS_IO_PROG -c "fpunch 327680 65536" $SCRATCH_MNT/j
+check_file $SCRATCH_MNT/j
+
+echo "funshare 1 block in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/k
+$XFS_IO_PROG -c "funshare 327680 65536" $SCRATCH_MNT/k
+check_file $SCRATCH_MNT/k
+
+echo "pwrite 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/l
+_pwrite_byte 0x00 262144 262144 $SCRATCH_MNT/l >> $seqres.full
+check_file $SCRATCH_MNT/l
+
+echo "mwrite 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/m
+$XFS_IO_PROG -c "mmap -rw 0 $filesz" -c "mwrite -S 0x00 262144 262144" -c msync $SCRATCH_MNT/m
+check_file $SCRATCH_MNT/m
+
+echo "fzero 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/n
+$XFS_IO_PROG -c "fzero 262144 262144" $SCRATCH_MNT/n
+check_file $SCRATCH_MNT/n
+
+echo "fpunch 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/o
+$XFS_IO_PROG -c "fpunch 262144 262144" $SCRATCH_MNT/o
+check_file $SCRATCH_MNT/o
+
+echo "funshare 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/p
+$XFS_IO_PROG -c "funshare 262144 262144" $SCRATCH_MNT/p
+check_file $SCRATCH_MNT/p
+
+echo "fcollapse 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/q
+$XFS_IO_PROG -c "fcollapse 262144 262144" $SCRATCH_MNT/q
+check_file $SCRATCH_MNT/q
+
+echo "finsert 1 extent in the middle" | tee -a $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/r
+$XFS_IO_PROG -c "finsert 262144 262144" $SCRATCH_MNT/r
+check_file $SCRATCH_MNT/r
+
+echo "copy unwritten blocks in large rtext" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $filesz" -c 'pwrite -S 0x59 345678 1' $SCRATCH_MNT/s >> $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/s >> $seqres.full
+_cp_reflink $SCRATCH_MNT/s $SCRATCH_MNT/t
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/s >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 1048576 1' $SCRATCH_MNT/s >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 1048576 1' $SCRATCH_MNT/t >> $seqres.full
+check_file $SCRATCH_MNT/s
+check_file $SCRATCH_MNT/t
+
+echo "test writing to shared unwritten extent" | tee -a $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/s >> $seqres.full
+_cp_reflink $SCRATCH_MNT/s $SCRATCH_MNT/u
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/s >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 345678 1' $SCRATCH_MNT/u >> $seqres.full
+check_file $SCRATCH_MNT/u
+
+echo "Remount and recheck" | tee -a $seqres.full
+md5sum $SCRATCH_MNT/a | _filter_scratch
+for i in b c d e f g h i j k l m n o p q r s t u; do
+	check_file $SCRATCH_MNT/$i | grep -v SCRATCH_MNT.a
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/919.out b/tests/xfs/919.out
new file mode 100644
index 0000000000..6ab3f70d17
--- /dev/null
+++ b/tests/xfs/919.out
@@ -0,0 +1,84 @@
+QA output created by 919
+Format filesystem and populate
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+pwrite 1 byte in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/b
+mwrite 1 byte in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/c
+fzero 1 byte in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/d
+fpunch 1 byte in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/e
+funshare 1 byte in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/f
+pwrite 1 block in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/g
+mwrite 1 block in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/h
+fzero 1 block in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/i
+fpunch 1 block in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/j
+funshare 1 block in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/k
+pwrite 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/l
+mwrite 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/m
+fzero 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/n
+fpunch 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/o
+funshare 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/p
+fcollapse 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+b0581637c15320958874ef3f082111da  SCRATCH_MNT/q
+finsert 1 extent in the middle
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+a7359d0c100367c2cd430be334dffbd3  SCRATCH_MNT/r
+copy unwritten blocks in large rtext
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/s
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/t
+test writing to shared unwritten extent
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/u
+Remount and recheck
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/a
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/b
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/c
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/d
+ea0b05f13c8cce703accaffe56d59bd3  SCRATCH_MNT/e
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/f
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/g
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/h
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/i
+2a508e23efc80e468efa7004fd8a1839  SCRATCH_MNT/j
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/k
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/l
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/m
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/n
+352abe71b0d40f194b9d701750b0d7f3  SCRATCH_MNT/o
+924a97fdaa2ab30e2768081469e728a7  SCRATCH_MNT/p
+b0581637c15320958874ef3f082111da  SCRATCH_MNT/q
+a7359d0c100367c2cd430be334dffbd3  SCRATCH_MNT/r
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/s
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/t
+bff4e0a70430429c92d6139065e6949b  SCRATCH_MNT/u

