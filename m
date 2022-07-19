Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBADCCA482
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiGSVhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbiGSVhU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EB35F986;
        Tue, 19 Jul 2022 14:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F01B81D7B;
        Tue, 19 Jul 2022 21:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5352C341C6;
        Tue, 19 Jul 2022 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266633;
        bh=4yvBEPcFDLZMUQSB8xy5TKBWdqY1raiUkM64FryhW/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lIcK+rnk8sowLCkAFy2OfCsNGvn/HQbxJdjcD1QEmF1SiXn902t+NxZl0d6mMCsYV
         saeKOlltTYdZflXIdgApFin/jPHLnLRJzDfLsj/liSydIpU8y4kwvJ6Ru11oIggfEG
         VPF67vDzNLtbsVV34g23mAxfHd+6oNzSm/t3A705ZWA2Bgmo+Un6qlqmwKqQbbxd0u
         g/OaDq+lpjqvOOXtm13pBybCsgK2yrVsjsTfgpUgXK/jB4i9vJR6tRYxjwWps1Z8RT
         RAs821rAyenJ5PMquPo935bgXK4ZXd2fz3QxgIyn06yL29cVyAfrzf36sUra8mnBGy
         0fN6OpX84lQOA==
Subject: [PATCH 1/1] generic/275: fix premature enospc errors when fs block
 size is large
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 19 Jul 2022 14:37:13 -0700
Message-ID: <165826663321.3249425.14767713688923502274.stgit@magnolia>
In-Reply-To: <165826662758.3249425.5439317033584646383.stgit@magnolia>
References: <165826662758.3249425.5439317033584646383.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When running this test on an XFS filesystem with a 64k block size, I
see this error:

generic/275       - output mismatch (see /var/tmp/fstests/generic/275.out.bad)
    --- tests/generic/275.out   2021-05-13 11:47:55.694860280 -0700
    +++ /var/tmp/fstests/generic/275.out.bad    2022-07-19 10:38:41.840000000 -0700
    @@ -2,4 +2,7 @@
     ------------------------------
     write until ENOSPC test
     ------------------------------
    +du: cannot access '/opt/tmp1': No such file or directory
    +stat: cannot statx '/opt/tmp1': No such file or directory
    +/tmp/fstests/tests/generic/275: line 74: [: -lt: unary operator expected
     done
    ...
    (Run 'diff -u /tmp/fstests/tests/generic/275.out /var/tmp/fstests/generic/275.out.bad'  to see the entire diff)

The 275.full file indicates that the test was unable to recreate the
$SCRATCH_MNT/tmp1 file after we freed all but the last 256K of free
space in the filesystem.  I mounted the scratch fs, and df reported
exactly 256K of free space available, which means there are 4 blocks
left in the filesystem for user programs to use.

Unfortunately for this test, xfs_create requires sufficient free blocks
in the filesystem to handle full inode btree splits and the maximal
directory expansion for a new dirent.  In other words, there must be
enough free space to handle the worst case space consumption.  That
quantity is 26 blocks, hence the last dd in the test fails with ENOSPC,
which makes the test fail.

Fix all this by creating the file that we use to test the low-space file
write *before* we drain the free space down to 256K.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/275 |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff --git a/tests/generic/275 b/tests/generic/275
index 6189edca..f3b05409 100755
--- a/tests/generic/275
+++ b/tests/generic/275
@@ -37,6 +37,15 @@ _scratch_unmount 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
+# Certain filesystems such as XFS require sufficient free blocks to handle the
+# worst-case directory expansion as a result of a creat() call.  If the fs
+# block size is very large (e.g. 64k) then the number of blocks required for
+# the creat() call can represent far more free space than the 256K left at the
+# end of this test.  Therefore, create the file that the last dd will write to
+# now when we know there's enough free blocks.
+later_file=$SCRATCH_MNT/later
+touch $later_file
+
 # this file will get removed to create 256k of free space after ENOSPC
 # conditions are created.
 dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seqres.full 2>&1
@@ -63,12 +72,12 @@ _freespace=`$DF_PROG -k $SCRATCH_MNT | tail -n 1 | awk '{print $5}'`
 
 # Try to write more than available space in chunks that will allow at least one
 # full write to succeed.
-dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=128k count=8 >>$seqres.full 2>&1
+dd if=/dev/zero of=$later_file bs=128k count=8 >>$seqres.full 2>&1
 echo "Bytes written until ENOSPC:" >>$seqres.full
-du $SCRATCH_MNT/tmp1 >>$seqres.full
+du $later_file >>$seqres.full
 
 # And at least some of it should succeed.
-_filesize=`_get_filesize $SCRATCH_MNT/tmp1`
+_filesize=`_get_filesize $later_file`
 [ $_filesize -lt $((128 * 1024)) ] && \
 	_fail "Partial write until enospc failed; wrote $_filesize bytes."
 

