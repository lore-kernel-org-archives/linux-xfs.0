Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AF6C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjEBUIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjEBUIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A6D1BDF;
        Tue,  2 May 2023 13:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D6D6213D;
        Tue,  2 May 2023 20:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4808FC433D2;
        Tue,  2 May 2023 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058109;
        bh=9dtzW82U9sgJXUIYWTxVoYjFxL7VG+haXr7WmnPrLOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pTRLwf+9MUl2btLX0TaIcgTj8RlqziYG1LdxO3PeEIZg242vMhzF0suQ0iy2+zhnM
         aH+hAyukgcsfWR0j3o9wHJgBhjMY9+tDcnFAhHVY5WsPPvpiV/rpo/P1Q1JaO5J/W7
         a/ILNybcUTQ5XWHb1UI6igXWKIxRYdI/C/fPjyUbBhkcHrYviqo/3nK1sBAaDFtoKw
         ixb8W0WM29mJpqSFEdJseQ1LHwOYehxI4dGkw+OkB+9s+WynBshOVNjGF7XWn4Hvft
         u3cmc65Xh72CS8wMmjH/9q7qa+dZhGrx3cOHW3TM5w4tHkZUYBk6UOYeffhn8/zCkK
         t1TsZo0OiReMg==
Subject: [PATCH 4/7] xfs/{243,245,272,274}: ignore raid alignment flags in
 bmap output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:28 -0700
Message-ID: <168305810873.331137.15436349640460378478.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test doesn't care about the RAID alignment status of the mappings
that it finds; it only cares about shared and unwritten.  Ignore the
mapping stripe alignment flags in the bmapx output.  This fixes this
test when the fs has su=128k,sw=4.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/243 |   12 ++++++------
 tests/xfs/245 |    6 +++---
 tests/xfs/272 |    4 ++--
 tests/xfs/274 |    8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/tests/xfs/243 b/tests/xfs/243
index 514fa35667..2e537f3f55 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -92,16 +92,16 @@ echo "Delayed allocation CoW extents:"
 test $(_xfs_bmapx_find cow $testdir/file3 delalloc) -gt 0 || \
 	echo "Expected to find a delalloc CoW extent"
 echo "Shared data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '100000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '10[01]{4}$') -gt 0 || \
 	echo "Expected to find a shared data extent"
 echo "Unwritten data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '10000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '1[01]{4}$') -gt 0 || \
 	echo "Expected to find an unwritten data extent"
 echo "Hole data extents:"
 test $(_xfs_bmapx_find data $testdir/file3 hole) -gt 0 || \
 	echo "Expected to find a hole data extent"
 echo "Regular data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '000000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '00[01]{4}$') -gt 0 || \
 	echo "Expected to find a regular data extent"
 
 sync
@@ -115,16 +115,16 @@ echo "Real CoW extents:"
 test $(_xfs_bmapx_find cow $testdir/file3 delalloc ) -eq 0 || \
 	echo "Expected to find zero delalloc CoW extent"
 echo "Shared data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '100000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '10[01]{4}$') -gt 0 || \
 	echo "Expected to find a shared data extent"
 echo "Unwritten data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '10000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '1[01]{4}$') -gt 0 || \
 	echo "Expected to find an unwritten data extent"
 echo "Hole data extents:"
 test $(_xfs_bmapx_find data $testdir/file3 hole) -gt 0 || \
 	echo "Expected to find a hole data extent"
 echo "Regular data extents:"
-test $(_xfs_bmapx_find data $testdir/file3 '000000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file3 -E '00[01]{4}$') -gt 0 || \
 	echo "Expected to find a regular data extent"
 
 _scratch_cycle_mount
diff --git a/tests/xfs/245 b/tests/xfs/245
index 0cd0935cfa..595a5938b4 100755
--- a/tests/xfs/245
+++ b/tests/xfs/245
@@ -42,17 +42,17 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Unwritten data extents"
-test $(_xfs_bmapx_find data $testdir/file1 '10000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file1 -E '1[01]{4}$') -gt 0 || \
 	echo "Expected to find an unwritten file1 extent"
 echo "Shared data extents"
-test $(_xfs_bmapx_find data $testdir/file1 '100000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file1 -E '10[01]{4}$') -gt 0 || \
 	echo "Expected to find a shared data extent"
 
 echo "Hole data extents"
 test $(_xfs_bmapx_find data $testdir/file2 'hole') -gt 0 || \
 	echo "Expected to find a hole data extent"
 echo "Shared data extents"
-test $(_xfs_bmapx_find data $testdir/file2 '100000$') -gt 0 || \
+test $(_xfs_bmapx_find data $testdir/file2 -E '10[01]{4}$') -gt 0 || \
 	echo "Expected to find a shared data extent"
 
 echo "Hole cow extents"
diff --git a/tests/xfs/272 b/tests/xfs/272
index 7ed8b95122..c68fa9d614 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -49,10 +49,10 @@ $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk | grep '^[[:space:]]*[0-9]*:' | grep
 
 echo "Check bmap and fsmap" | tee -a $seqres.full
 cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}$"
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}(| [01]*)$"
 	echo "${qstr}" >> $seqres.full
 	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
 	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
 done
 
diff --git a/tests/xfs/274 b/tests/xfs/274
index dcaea68804..cd483d77bc 100755
--- a/tests/xfs/274
+++ b/tests/xfs/274
@@ -49,10 +49,10 @@ $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 | grep '^[[:space:]]*[0-9]*:' | grep -
 
 echo "Check f1 bmap and fsmap" | tee -a $seqres.full
 cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
 	echo "${qstr}" >> $seqres.full
 	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
 	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
 done
 
@@ -62,10 +62,10 @@ $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 | grep '^[[:space:]]*[0-9]*:' | grep -
 
 echo "Check f2 bmap and fsmap" | tee -a $seqres.full
 cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 010[01]{4}$"
 	echo "${qstr}" >> $seqres.full
 	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
-	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	found=$(grep -E -c "${qstr}" $TEST_DIR/fsmap)
 	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
 done
 

