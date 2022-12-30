Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF40AC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiLaDSV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDSV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:18:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E442733;
        Fri, 30 Dec 2022 19:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8A7B81E66;
        Sat, 31 Dec 2022 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B5DC433EF;
        Sat, 31 Dec 2022 03:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456697;
        bh=v5t/VCu9Eh7EbvI3dy4porQrhQuQOlHnWICHHOqNeCo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V2WI5si+P9BB6u8NzVZ4re6TlN1Xmh8jpddXyjzn3/EynT5En/pfTe9O8zssZHQES
         SMEqrKhW2D4gk8ctm2e7iOKFkrgwvhNzWjHtkKjJxiipvl7dup57NM+KwjrvBIxTSf
         ITOJFPcPJcQ+zesWc/fcLVK8JFqNisYRvcECID1VC/+OeF/DaW+3ipVDgrEl6wieje
         cnZGsQAZfgy2C8ojvI0y47HR/2PaqupcXwP3we5CwXQ1cMVPCoVPGBWfkn8koCesWK
         OKRp79EdSGDSp7W17zq536Er8yLCO61Pd0zr1DXChpk044alS4qTcaEYdO/jUA6Ohn
         G3zCg9LefMiQA==
Subject: [PATCH 09/10] generic/331,xfs/240: support files that skip delayed
 allocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884972.740253.4451750587710158316.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The goal of this test is to ensure that log recovery finishes a copy on
write operation in the event of temporary media errors.  It's important
that the test observe some sort of IO error once we switch the scratch
device to fail all IOs, but regrettably the test encoded the specific
behavior of XFS and btrfs when the test was written -- the aio write
to the page cache doesn't have to touch the disk and succeeds, and the
fdatasync flushes things to disk and hits the IO error.

However, this is not how things work on the XFS realtime device.  There
is no delalloc on realtime, so the aio write allocates an unwritten
extent to stage the write.  The allocation fails due to EIO, so it's the
write call that fails.  Therefore, all we need to do is to detect an IO
error at any point between the write and the fdatasync call to be
satisfied that the test does what we want to do.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/331     |   12 ++++++++++--
 tests/generic/331.out |    2 +-
 tests/xfs/240         |   13 +++++++++++--
 tests/xfs/240.out     |    2 +-
 4 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/tests/generic/331 b/tests/generic/331
index 492abedf76..8c665ce4fc 100755
--- a/tests/generic/331
+++ b/tests/generic/331
@@ -59,9 +59,17 @@ echo "CoW and unmount"
 $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 sync
+
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -c "fdatasync" $testdir/file2
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 &>> $seqres.full || \
+	write_failed=1
+$XFS_IO_PROG -c "fdatasync" $testdir/file2 2>&1 | grep -q 'Input.output error' && \
+	write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/generic/331.out b/tests/generic/331.out
index adbf841d00..d8ccea704b 100644
--- a/tests/generic/331.out
+++ b/tests/generic/331.out
@@ -5,7 +5,7 @@ Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file2
 CoW and unmount
-fdatasync: Input/output error
+write failed
 Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
 d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-331/file2
diff --git a/tests/xfs/240 b/tests/xfs/240
index a65c270d23..cabe309201 100755
--- a/tests/xfs/240
+++ b/tests/xfs/240
@@ -66,8 +66,17 @@ $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
 $XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
 sync
 _dmerror_load_error_table
-$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
-$XFS_IO_PROG -c "fdatasync" $testdir/file2
+
+# If the filesystem supports delalloc, then the fdatasync will report an IO
+# error.  If the write goes directly to disk, then aiocp will return nonzero.
+unset write_failed
+_dmerror_load_error_table
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 &>> $seqres.full || \
+	write_failed=1
+$XFS_IO_PROG -c "fdatasync" $testdir/file2 2>&1 | grep -q 'Input.output error' && \
+	write_failed=1
+test -n $write_failed && echo "write failed"
+
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/xfs/240.out b/tests/xfs/240.out
index 1a22e8a389..00bb116e5c 100644
--- a/tests/xfs/240.out
+++ b/tests/xfs/240.out
@@ -5,7 +5,7 @@ Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file2
 CoW and unmount
-fdatasync: Input/output error
+write failed
 Compare files
 1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
 d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-240/file2

