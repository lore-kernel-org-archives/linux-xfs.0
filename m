Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4F0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbiCPDbj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbiCPDbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0C5EDD6;
        Tue, 15 Mar 2022 20:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19C8CB81A07;
        Wed, 16 Mar 2022 03:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9DFC340E8;
        Wed, 16 Mar 2022 03:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401420;
        bh=JKKe2NS4fpIiMOxt3ym4v5T1bubiUMQB/Tx8c8lg0i8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W7TlEp7QvJGzd0QhAJrjfMAXLKq9OezxJ1mnTZr9z1eqyWy34n95KkRqeJi6QUC4x
         erLHOROYcwjVN6H6ehNfs6YCP2Sl7rjP1ChvQQ3uaWuMDMCg4IOIjfkhveivVak40H
         +8ee4F6Nbllz2wavLDPrvtr2/XANZmMczm7onszmp/oqiYXiyFZBlZkBg5/EhhmtxQ
         XfvteCUTMkSCz8HzwZ29MMZ88AFYp6Ig6N7ULiyufZna4sQ31SOsSMKtOfje1FJIOy
         cSjC1uYtPjVpp3d9VCt6lJ7sk2h604JNVGAQkuwnKcSXuDvY26keKobKgtFICRiZY9
         MlUhQ9tYDePeQ==
Subject: [PATCH 3/4] xfs/420: fix occasional test failures due to pagecache
 readahead
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:20 -0700
Message-ID: <164740142033.3371628.11850774504699213977.stgit@magnolia>
In-Reply-To: <164740140348.3371628.12967562090320741592.stgit@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then, this test fails with this golden output:

--- xfs/420.out
+++ xfs/420.out.bad
@@ -29,7 +29,7 @@
 Whence Result
 DATA   0
 HOLE   131072
-DATA   196608
+DATA   192512
 HOLE   262144
 Compare files
 c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1

Curiously, the file checksums always match, and it's not *forbidden* for
the page cache to have a page backing an unwritten extent that hasn't
been written.

The condition that this test cares about is that block 3 (192k-256k) are
reported by SEEK_DATA as data even if the data fork has a hole and the
COW fork has an unwritten extent.  Matthew Wilcox thinks this is a side
effect of readahead.

To fix this occasional false failure, call SEEK_DATA and SEEK_HOLE only
on the offsets that we care about.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/420 |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)


diff --git a/tests/xfs/420 b/tests/xfs/420
index 12b17588..d38772c9 100755
--- a/tests/xfs/420
+++ b/tests/xfs/420
@@ -50,6 +50,24 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
+# pagecache readahead can sometimes cause extra pages to be inserted into the
+# file mapping where we have an unwritten extent in the COW fork.  Call lseek
+# on each $blksz offset that interests us (as opposed to the whole file) so
+# that these extra pages are not disclosed.
+#
+# The important thing we're testing is that SEEK_DATA reports block 3 as data
+# when the COW fork has an unwritten mapping and the data fork has a hole.
+exercise_lseek() {
+	echo "Seek holes and data in file1"
+	$XFS_IO_PROG -c "seek -d 0" $testdir/file1
+	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file1 | sed -e '/Whence/d'
+	echo "Seek holes and data in file2"
+	$XFS_IO_PROG -c "seek -d 0" $testdir/file2
+	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file2 | sed -e '/Whence/d'
+	$XFS_IO_PROG -c "seek -d $((3 * blksz))" $testdir/file2 | sed -e '/Whence/d'
+	$XFS_IO_PROG -c "seek -h $((4 * blksz))" $testdir/file2 | sed -e '/Whence/d'
+}
+
 blksz=65536
 nr=8
 filesize=$((blksz * nr))
@@ -83,10 +101,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
 
-echo "Seek holes and data in file1"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
-echo "Seek holes and data in file2"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+exercise_lseek
 
 echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
@@ -102,10 +117,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
 
-echo "Seek holes and data in file1"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
-echo "Seek holes and data in file2"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+exercise_lseek
 
 echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch
@@ -121,10 +133,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
 $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
 
-echo "Seek holes and data in file1"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
-echo "Seek holes and data in file2"
-$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+exercise_lseek
 
 echo "Compare files"
 md5sum $testdir/file1 | _filter_scratch

