Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8748174E25;
	Thu, 20 Jun 2024 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916875; cv=none; b=sR1yF2NHZ2kLblisQ861Wk7MUS+87tU2LL/xElx/qHMedUh7S8PEE6uUJ7aX8J+wyD67Z09SLzTPnp1Y98TK9M0UEdNuZAHB+Xolb0IJI74m0o9ZVlReReCuLxkc06gu6xeyYWXqKZVDSCGsqsH+4gQahkcGkUquA6Vlf6j6flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916875; c=relaxed/simple;
	bh=YCLI2eJj4dlMPbg53WbgOQZwy7vBfGEo0aDQrYdeS3A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTe438TJE6kpVOe8leOqS6wxeHm2tqqAwkdFpaTDW81tjAAyDMAt30Mn/uabz7ANVjWFn3/cyknKz6QvRvd6WTsx2f6cw8UnPBxPCGYDCspFGvY+uppuigTGCvFi6v7guHSbGgYdGpDLJuBXikp7u9L4/cc8EVt6FYkh6TC+IBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnVbbjat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnVbbjat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFE7C2BD10;
	Thu, 20 Jun 2024 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916875;
	bh=YCLI2eJj4dlMPbg53WbgOQZwy7vBfGEo0aDQrYdeS3A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DnVbbjatmJJP1lyOARrMXV+ZziPV4CHufTNYKxj6C6p7OwJgn9B7+RJYPbA2ZFMHO
	 d7bc3xY32lgY8ds4RopOL3/uTIDa9PKAJ/eerGDftH5t2HllZum69+xSVysfkkn2TE
	 a0uFI583gDHgq6s9RbLPnu1YYDNgx3h7OX+e/WoVoaIp7GYnB3LiCnSenmgHzHG2X0
	 VKO/X20/IP4maKQnPtTJYZe4AX6Rzz4qwJSvGOqwl+rN825Jjoo1qOUplmsA2aAg20
	 lCzU1ksS2LbXDlp4k55ejongUcgOpA7k/rtcv8ZgSI+XY3JX4XDq76zgcOB4KqoLjh
	 H+CBum42F0Dsw==
Date: Thu, 20 Jun 2024 13:54:34 -0700
Subject: [PATCH 02/11] misc: change xfs_io -c swapext to exchangerange
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669143.3034840.15267717495079465249.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the swapext command to use exchangerange as part of severing the
connection between the two ioctls.

Flags changed:

-h (only exchange written extents) is now -w.

-a (atomic mode) is always enabled now.

-e (to eof) is now the default; -l (length) disables this flag.

-u (unconditonal swap) is inverted to -c (commit only if fresh).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/712     |    8 ++++----
 tests/generic/713     |   38 +++++++++++++++++++-------------------
 tests/generic/713.out |   38 +++++++++++++++++++-------------------
 tests/generic/714     |   36 ++++++++++++++++++------------------
 tests/generic/714.out |   34 +++++++++++++++++-----------------
 tests/generic/715     |   22 ++++++++++++----------
 tests/generic/715.out |   14 +++++++-------
 tests/generic/716     |    2 +-
 tests/generic/717     |   34 +++++++++++++++++-----------------
 tests/generic/717.out |   32 ++++++++++++++++----------------
 tests/generic/718     |   10 +++++-----
 tests/generic/718.out |    2 +-
 tests/generic/719     |    2 +-
 tests/generic/720     |    8 ++++----
 tests/generic/721     |    2 +-
 tests/generic/722     |    6 +++---
 tests/generic/723     |   10 +++++-----
 tests/generic/724     |    8 ++++----
 tests/generic/725     |    2 +-
 tests/generic/726     |    2 +-
 tests/generic/727     |    2 +-
 tests/xfs/300         |    2 +-
 tests/xfs/443         |    4 ++--
 tests/xfs/790         |    8 ++++----
 tests/xfs/790.out     |    2 +-
 tests/xfs/791         |    8 ++++----
 tests/xfs/791.out     |    2 +-
 tests/xfs/792         |    2 +-
 tests/xfs/795         |    2 +-
 29 files changed, 172 insertions(+), 170 deletions(-)


diff --git a/tests/generic/712 b/tests/generic/712
index f2862c3f8e..a5f2ac26fd 100755
--- a/tests/generic/712
+++ b/tests/generic/712
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 712
 #
-# Make sure that swapext modifies ctime and not mtime of the file.
+# Make sure that exchangerange modifies ctime and not mtime of the file.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -39,8 +39,8 @@ old_mtime="$(echo $(stat -c '%y' $dir/a $dir/b))"
 old_ctime="$(echo $(stat -c '%z' $dir/a $dir/b))"
 stat -c '%y %Y %z %Z' $dir/a $dir/b >> $seqres.full
 
-# Now try to swapext
-$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+# Now try to exchangerange
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
 
 # Snapshot the 'a' file after we swap
 echo after >> $seqres.full
diff --git a/tests/generic/713 b/tests/generic/713
index b2d3260806..b0165b1d91 100755
--- a/tests/generic/713
+++ b/tests/generic/713
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 713
 #
-# Test swapext between ranges of two different files.
+# Test exchangerange between ranges of two different files.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -34,26 +34,26 @@ filesnap() {
 	fi
 }
 
-test_swapext_once() {
-	filesnap "$1: before swapext" $dir/$3 $dir/$4
+test_exchangerange_once() {
+	filesnap "$1: before exchangerange" $dir/$3 $dir/$4
 	$XFS_IO_PROG -c "exchangerange $2 $dir/$3" $dir/$4
-	filesnap "$1: after swapext" $dir/$3 $dir/$4
+	filesnap "$1: after exchangerange" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
 	echo
 }
 
-test_swapext_two() {
-	# swapext the same range of two files
-	test_swapext_once "$*: samerange" \
+test_exchangerange_two() {
+	# exchangerange the same range of two files
+	test_exchangerange_once "$*: samerange" \
 		"-s $((blksz * 3)) -d $((blksz * 3)) -l $((blksz * 5))" b a
 
-	# swapext different ranges of two files
-	test_swapext_once "$*: diffrange" \
+	# exchangerange different ranges of two files
+	test_exchangerange_once "$*: diffrange" \
 		"-s $((blksz * 37)) -d $((blksz * 47)) -l $((blksz * 7))" b a
 
-	# swapext overlapping ranges of two files
-	test_swapext_once "$*: overlap" \
+	# exchangerange overlapping ranges of two files
+	test_exchangerange_once "$*: overlap" \
 		"-s $((blksz * 17)) -d $((blksz * 23)) -l $((blksz * 7))" b a
 }
 
@@ -67,19 +67,19 @@ _require_congruent_file_oplen $TEST_DIR $blksz
 rm -rf $dir/a $dir/b
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 _pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
-test_swapext_two "simple"
+test_exchangerange_two "simple"
 
 # Make some files that don't end an aligned offset.
 rm -rf $dir/a $dir/b
 _pwrite_byte 0x58 0 $(( (blksz * nrblks) + 37)) $dir/a >> $seqres.full
 _pwrite_byte 0x59 0 $(( (blksz * nrblks) + 37)) $dir/b >> $seqres.full
-test_swapext_once "unalignedeof" "" a b
+test_exchangerange_once "unalignedeof" "" a b
 
 # Set up some crazy rainbow files
 rm -rf $dir/a $dir/b
 _weave_file_rainbow $blksz $nrblks $dir/a >> $seqres.full
 _weave_file_rainbow $blksz $nrblks $dir/b >> $seqres.full
-test_swapext_two "rainbow"
+test_exchangerange_two "rainbow"
 
 # Now set up a simple file for testing within the same file
 rm -rf $dir/c
@@ -87,12 +87,12 @@ $XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((blksz * nrblks))" \
 	-c "pwrite -S 0x59 $((blksz * nrblks)) $((blksz * nrblks))" \
 	$dir/c >> $seqres.full
 
-# swapext the same offset into the 'X' and 'Y' regions of the file
-test_swapext_once "single: sameXandY" \
+# exchangerange the same offset into the 'X' and 'Y' regions of the file
+test_exchangerange_once "single: sameXandY" \
 	"-s $((blksz * 3)) -d $((blksz * (nrblks + 3))) -l $((blksz * 5))" c c
 
-# swapext the same offset into the 'X' and 'Y' regions of the file
-test_swapext_once "single: overlap" \
+# exchangerange the same offset into the 'X' and 'Y' regions of the file
+test_exchangerange_once "single: overlap" \
 	"-s $((blksz * 13)) -d $((blksz * 17)) -l $((blksz * 5))" c c
 
 # success, all done
diff --git a/tests/generic/713.out b/tests/generic/713.out
index cb58e93aa6..87e26c5372 100644
--- a/tests/generic/713.out
+++ b/tests/generic/713.out
@@ -1,85 +1,85 @@
 QA output created by 713
-simple: samerange: before swapext
+simple: samerange: before exchangerange
 db85d578204631f2b4eb1e73974253c2  TEST_DIR/test-713/b
 d0425612f15c6071022cf7127620f63d  TEST_DIR/test-713/a
-simple: samerange: after swapext
+simple: samerange: after exchangerange
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-713/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-713/a
 simple: samerange: after cycling mount
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-713/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-713/a
 
-simple: diffrange: before swapext
+simple: diffrange: before exchangerange
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-713/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-713/a
-simple: diffrange: after swapext
+simple: diffrange: after exchangerange
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-713/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-713/a
 simple: diffrange: after cycling mount
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-713/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-713/a
 
-simple: overlap: before swapext
+simple: overlap: before exchangerange
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-713/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-713/a
-simple: overlap: after swapext
+simple: overlap: after exchangerange
 e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-713/b
 ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-713/a
 simple: overlap: after cycling mount
 e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-713/b
 ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-713/a
 
-unalignedeof: before swapext
+unalignedeof: before exchangerange
 9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-713/a
 7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-713/b
-unalignedeof: after swapext
+unalignedeof: after exchangerange
 7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-713/a
 9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-713/b
 unalignedeof: after cycling mount
 7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-713/a
 9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-713/b
 
-rainbow: samerange: before swapext
+rainbow: samerange: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
-rainbow: samerange: after swapext
+rainbow: samerange: after exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
 rainbow: samerange: after cycling mount
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
 
-rainbow: diffrange: before swapext
+rainbow: diffrange: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
-rainbow: diffrange: after swapext
+rainbow: diffrange: after exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
 rainbow: diffrange: after cycling mount
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
 
-rainbow: overlap: before swapext
+rainbow: overlap: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-713/a
-rainbow: overlap: after swapext
+rainbow: overlap: after exchangerange
 6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-713/b
 39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-713/a
 rainbow: overlap: after cycling mount
 6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-713/b
 39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-713/a
 
-single: sameXandY: before swapext
+single: sameXandY: before exchangerange
 39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-713/c
-single: sameXandY: after swapext
+single: sameXandY: after exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-713/c
 single: sameXandY: after cycling mount
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-713/c
 
-single: overlap: before swapext
+single: overlap: before exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-713/c
-swapext: Invalid argument
-single: overlap: after swapext
+exchangerange: Invalid argument
+single: overlap: after exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-713/c
 single: overlap: after cycling mount
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-713/c
diff --git a/tests/generic/714 b/tests/generic/714
index ea963fdfa7..4d2d4a0b49 100755
--- a/tests/generic/714
+++ b/tests/generic/714
@@ -4,11 +4,11 @@
 #
 # FS QA Test No. 714
 #
-# Test swapext between ranges of two different files, when one of the files
+# Test exchangerange between ranges of two different files, when one of the files
 # is shared.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -35,26 +35,26 @@ filesnap() {
 	fi
 }
 
-test_swapext_once() {
-	filesnap "$1: before swapext" $dir/$3 $dir/$4
+test_exchangerange_once() {
+	filesnap "$1: before exchangerange" $dir/$3 $dir/$4
 	$XFS_IO_PROG -c "exchangerange $2 $dir/$3" $dir/$4
-	filesnap "$1: after swapext" $dir/$3 $dir/$4
+	filesnap "$1: after exchangerange" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
 	echo
 }
 
-test_swapext_two() {
-	# swapext the same range of two files
-	test_swapext_once "$*: samerange" \
+test_exchangerange_two() {
+	# exchangerange the same range of two files
+	test_exchangerange_once "$*: samerange" \
 		"-s $((blksz * 3)) -d $((blksz * 3)) -l $((blksz * 5))" b a
 
-	# swapext different ranges of two files
-	test_swapext_once "$*: diffrange" \
+	# exchangerange different ranges of two files
+	test_exchangerange_once "$*: diffrange" \
 		"-s $((blksz * 37)) -d $((blksz * 47)) -l $((blksz * 7))" b a
 
-	# swapext overlapping ranges of two files
-	test_swapext_once "$*: overlap" \
+	# exchangerange overlapping ranges of two files
+	test_exchangerange_once "$*: overlap" \
 		"-s $((blksz * 17)) -d $((blksz * 23)) -l $((blksz * 7))" b a
 
 	# Now let's overwrite a entirely to make sure COW works
@@ -79,14 +79,14 @@ rm -f $dir/a $dir/b $dir/sharea
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 _pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
 _cp_reflink $dir/a $dir/sharea
-test_swapext_two "simple"
+test_exchangerange_two "simple"
 
 # Set up some crazy rainbow files
 rm -f $dir/a $dir/b $dir/sharea
 _weave_file_rainbow $blksz $nrblks $dir/a >> $seqres.full
 _weave_file_rainbow $blksz $nrblks $dir/b >> $seqres.full
 _cp_reflink $dir/a $dir/sharea
-test_swapext_two "rainbow"
+test_exchangerange_two "rainbow"
 
 # Now set up a simple file for testing within the same file
 rm -f $dir/c $dir/sharec
@@ -95,12 +95,12 @@ $XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((blksz * nrblks))" \
 	$dir/c >> $seqres.full
 _cp_reflink $dir/c $dir/sharec
 
-# swapext the same offset into the 'X' and 'Y' regions of the file
-test_swapext_once "single: sameXandY" \
+# exchangerange the same offset into the 'X' and 'Y' regions of the file
+test_exchangerange_once "single: sameXandY" \
 	"-s $((blksz * 3)) -d $((blksz * (nrblks + 3))) -l $((blksz * 5))" c c
 
-# swapext the same offset into the 'X' and 'Y' regions of the file
-test_swapext_once "single: overlap" \
+# exchangerange the same offset into the 'X' and 'Y' regions of the file
+test_exchangerange_once "single: overlap" \
 	"-s $((blksz * 13)) -d $((blksz * 17)) -l $((blksz * 5))" c c
 
 # Now let's overwrite a entirely to make sure COW works
diff --git a/tests/generic/714.out b/tests/generic/714.out
index bd45efc141..0d1714bf0c 100644
--- a/tests/generic/714.out
+++ b/tests/generic/714.out
@@ -1,28 +1,28 @@
 QA output created by 714
-simple: samerange: before swapext
+simple: samerange: before exchangerange
 db85d578204631f2b4eb1e73974253c2  TEST_DIR/test-714/b
 d0425612f15c6071022cf7127620f63d  TEST_DIR/test-714/a
-simple: samerange: after swapext
+simple: samerange: after exchangerange
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-714/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-714/a
 simple: samerange: after cycling mount
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-714/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-714/a
 
-simple: diffrange: before swapext
+simple: diffrange: before exchangerange
 20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-714/b
 e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-714/a
-simple: diffrange: after swapext
+simple: diffrange: after exchangerange
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-714/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-714/a
 simple: diffrange: after cycling mount
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-714/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-714/a
 
-simple: overlap: before swapext
+simple: overlap: before exchangerange
 cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-714/b
 d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-714/a
-simple: overlap: after swapext
+simple: overlap: after exchangerange
 e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-714/b
 ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-714/a
 simple: overlap: after cycling mount
@@ -34,30 +34,30 @@ d0425612f15c6071022cf7127620f63d  TEST_DIR/test-714/sharea
 d0425612f15c6071022cf7127620f63d  TEST_DIR/test-714/sharea
 d0425612f15c6071022cf7127620f63d  TEST_DIR/test-714/sharea
 
-rainbow: samerange: before swapext
+rainbow: samerange: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
-rainbow: samerange: after swapext
+rainbow: samerange: after exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
 rainbow: samerange: after cycling mount
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
 
-rainbow: diffrange: before swapext
+rainbow: diffrange: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
-rainbow: diffrange: after swapext
+rainbow: diffrange: after exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
 rainbow: diffrange: after cycling mount
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
 
-rainbow: overlap: before swapext
+rainbow: overlap: before exchangerange
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/b
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/a
-rainbow: overlap: after swapext
+rainbow: overlap: after exchangerange
 6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-714/b
 39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-714/a
 rainbow: overlap: after cycling mount
@@ -69,17 +69,17 @@ overwrite A and B entirely
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/sharea
 48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-714/sharea
 
-single: sameXandY: before swapext
+single: sameXandY: before exchangerange
 39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-714/c
-single: sameXandY: after swapext
+single: sameXandY: after exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-714/c
 single: sameXandY: after cycling mount
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-714/c
 
-single: overlap: before swapext
+single: overlap: before exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-714/c
-swapext: Invalid argument
-single: overlap: after swapext
+exchangerange: Invalid argument
+single: overlap: after exchangerange
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-714/c
 single: overlap: after cycling mount
 8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-714/c
diff --git a/tests/generic/715 b/tests/generic/715
index eb164a848a..60a5381eaa 100755
--- a/tests/generic/715
+++ b/tests/generic/715
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 715
 #
-# Test swapext between two files of unlike size.
+# Test exchangerange between two files of unlike size.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -33,7 +33,7 @@ filesnap() {
 	fi
 }
 
-test_swapext_once() {
+test_exchangerange_once() {
 	local tag=$1
 	local a_len=$2
 	local b_len=$3
@@ -41,20 +41,22 @@ test_swapext_once() {
 	local b_off=$5
 	local len=$6
 
-	# len is either a block count or -e to swap to EOF
-	if [ "$len" != "-e" ]; then
+	# len is either a block count or "EOF"
+	if [ "$len" = "EOF" ]; then
+		len=""
+	else
 		len="-l $((blksz * len))"
 	fi
 
 	rm -f $dir/a $dir/b
 	_pwrite_byte 0x58 0 $((blksz * a_len)) $dir/a >> $seqres.full
 	_pwrite_byte 0x59 0 $((blksz * b_len)) $dir/b >> $seqres.full
-	filesnap "$tag: before swapext" $dir/a $dir/b
+	filesnap "$tag: before exchangerange" $dir/a $dir/b
 
 	cmd="exchangerange -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
 	echo "$cmd" >> $seqres.full
 	$XFS_IO_PROG -c "$cmd" $dir/b
-	filesnap "$tag: after swapext" $dir/a $dir/b
+	filesnap "$tag: after exchangerange" $dir/a $dir/b
 
 	_test_cycle_mount
 	filesnap "$tag: after cycling mount" $dir/a $dir/b
@@ -65,11 +67,11 @@ dir=$TEST_DIR/test-$seq
 mkdir -p $dir
 blksz=65536
 
-test_swapext_once "last 5 blocks" 27 37 22 32 5
+test_exchangerange_once "last 5 blocks" 27 37 22 32 5
 
-test_swapext_once "whole file to eof" 27 37 0 0 -e
+test_exchangerange_once "whole file to eof" 27 37 0 0 EOF
 
-test_swapext_once "blocks 30-40" 27 37 30 30 10
+test_exchangerange_once "blocks 30-40" 27 37 30 30 10
 
 # success, all done
 status=0
diff --git a/tests/generic/715.out b/tests/generic/715.out
index b4a6565aba..c2652e632b 100644
--- a/tests/generic/715.out
+++ b/tests/generic/715.out
@@ -1,29 +1,29 @@
 QA output created by 715
-last 5 blocks: before swapext
+last 5 blocks: before exchangerange
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/a
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/b
-last 5 blocks: after swapext
+last 5 blocks: after exchangerange
 3f34470fe9feb8513d5f3a8538f2c5f3  TEST_DIR/test-715/a
 c3daca7dd9218371cd0dc64f11e4b0bf  TEST_DIR/test-715/b
 last 5 blocks: after cycling mount
 3f34470fe9feb8513d5f3a8538f2c5f3  TEST_DIR/test-715/a
 c3daca7dd9218371cd0dc64f11e4b0bf  TEST_DIR/test-715/b
 
-whole file to eof: before swapext
+whole file to eof: before exchangerange
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/a
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/b
-whole file to eof: after swapext
+whole file to eof: after exchangerange
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/a
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/b
 whole file to eof: after cycling mount
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/a
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/b
 
-blocks 30-40: before swapext
+blocks 30-40: before exchangerange
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/a
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/b
-swapext: Invalid argument
-blocks 30-40: after swapext
+exchangerange: Invalid argument
+blocks 30-40: after exchangerange
 207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-715/a
 eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-715/b
 blocks 30-40: after cycling mount
diff --git a/tests/generic/716 b/tests/generic/716
index 5d3fa5e721..dbfa426378 100755
--- a/tests/generic/716
+++ b/tests/generic/716
@@ -10,7 +10,7 @@
 # and some of the contents are updated.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/717 b/tests/generic/717
index dd2f3dcdc4..ffabe2eaa1 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -7,7 +7,7 @@
 # Try invalid parameters to see if they fail.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -39,62 +39,62 @@ _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/b >> $seqres.full
 
 echo Immutable files
-$XFS_IO_PROG -c 'chattr +i' -c "swapext $dir/b" $dir/a
+$XFS_IO_PROG -c 'chattr +i' -c "exchangerange $dir/b" $dir/a
 $CHATTR_PROG -i $dir/a
 
 echo Readonly files
-$XFS_IO_PROG -r -c "swapext $dir/b" $dir/a
+$XFS_IO_PROG -r -c "exchangerange $dir/b" $dir/a
 
 echo Directories
-$XFS_IO_PROG -c "swapext $dir/b" $dir
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir
 
 echo Unaligned ranges
-$XFS_IO_PROG -c "swapext -s 37 -d 61 -l 17 $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -s 37 -d 61 -l 17 $dir/b" $dir/a
 
 echo file1 range entirely beyond EOF
-$XFS_IO_PROG -c "swapext -s $(( blksz * (nrblks + 500) )) -d 0 -l $blksz $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -s $(( blksz * (nrblks + 500) )) -d 0 -l $blksz $dir/b" $dir/a
 
 echo file2 range entirely beyond EOF
-$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks + 500) )) -s 0 -l $blksz $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -d $(( blksz * (nrblks + 500) )) -s 0 -l $blksz $dir/b" $dir/a
 
 echo Both ranges entirely beyond EOF
-$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks + 500) )) -s $(( blksz * (nrblks + 500) )) -l $blksz $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -d $(( blksz * (nrblks + 500) )) -s $(( blksz * (nrblks + 500) )) -l $blksz $dir/b" $dir/a
 
 echo file1 range crossing EOF
-$XFS_IO_PROG -c "swapext -s $(( blksz * (nrblks - 1) )) -d 0 -l $((2 * blksz)) $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -s $(( blksz * (nrblks - 1) )) -d 0 -l $((2 * blksz)) $dir/b" $dir/a
 
 echo file2 range crossing EOF
-$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks  - 1) )) -s 0 -l $((2 * blksz)) $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -d $(( blksz * (nrblks  - 1) )) -s 0 -l $((2 * blksz)) $dir/b" $dir/a
 
 echo Both ranges crossing EOF
-$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks - 1) )) -s $(( blksz * (nrblks - 1) )) -l $((blksz * 2)) $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -d $(( blksz * (nrblks - 1) )) -s $(( blksz * (nrblks - 1) )) -l $((blksz * 2)) $dir/b" $dir/a
 
 echo file1 unaligned EOF to file2 nowhere near EOF
 _pwrite_byte 0x58 $((blksz * nrblks)) 37 $dir/a >> $seqres.full
 _pwrite_byte 0x59 $((blksz * nrblks)) 37 $dir/b >> $seqres.full
-$XFS_IO_PROG -c "swapext -d 0 -s $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -d 0 -s $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
 
 echo file2 unaligned EOF to file1 nowhere near EOF
-$XFS_IO_PROG -c "swapext -s 0 -d $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange -s 0 -d $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
 
 echo Files of unequal length
 _pwrite_byte 0x58 $((blksz * nrblks)) $((blksz * 2)) $dir/a >> $seqres.full
 _pwrite_byte 0x59 $((blksz * nrblks)) $blksz $dir/b >> $seqres.full
-$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
 
 echo Files on different filesystems
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $SCRATCH_MNT/c >> $seqres.full
-$XFS_IO_PROG -c "swapext $SCRATCH_MNT/c" $dir/a
+$XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/c" $dir/a
 
 echo Files on different mounts
 mkdir -p $SCRATCH_MNT/xyz
 mount --bind $dir $SCRATCH_MNT/xyz --bind
 _pwrite_byte 0x60 0 $((blksz * (nrblks + 2))) $dir/c >> $seqres.full
-$XFS_IO_PROG -c "swapext $SCRATCH_MNT/xyz/c" $dir/a
+$XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/xyz/c" $dir/a
 umount $SCRATCH_MNT/xyz
 
 echo Swapping a file with itself
-$XFS_IO_PROG -c "swapext $dir/a" $dir/a
+$XFS_IO_PROG -c "exchangerange $dir/a" $dir/a
 
 # success, all done
 status=0
diff --git a/tests/generic/717.out b/tests/generic/717.out
index 7a7ab30b59..85137bf412 100644
--- a/tests/generic/717.out
+++ b/tests/generic/717.out
@@ -1,33 +1,33 @@
 QA output created by 717
 Immutable files
-swapext: Operation not permitted
+exchangerange: Operation not permitted
 Readonly files
-swapext: Bad file descriptor
+exchangerange: Bad file descriptor
 Directories
-swapext: Is a directory
+exchangerange: Is a directory
 Unaligned ranges
-swapext: Invalid argument
+exchangerange: Invalid argument
 file1 range entirely beyond EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 file2 range entirely beyond EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 Both ranges entirely beyond EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 file1 range crossing EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 file2 range crossing EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 Both ranges crossing EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 file1 unaligned EOF to file2 nowhere near EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 file2 unaligned EOF to file1 nowhere near EOF
-swapext: Invalid argument
+exchangerange: Invalid argument
 Files of unequal length
-swapext: Bad address
+exchangerange: Bad address
 Files on different filesystems
-swapext: Invalid cross-device link
+exchangerange: Invalid cross-device link
 Files on different mounts
-swapext: Invalid cross-device link
+exchangerange: Invalid cross-device link
 Swapping a file with itself
-swapext: Invalid argument
+exchangerange: Invalid argument
diff --git a/tests/generic/718 b/tests/generic/718
index 23e092df4d..ab81dbec95 100755
--- a/tests/generic/718
+++ b/tests/generic/718
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 718
 #
-# Make sure swapext honors RLIMIT_FSIZE.
+# Make sure exchangerange honors RLIMIT_FSIZE.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -29,7 +29,7 @@ mkdir -p $dir
 blksz=65536
 nrblks=64
 
-# Create some 4M files to test swapext
+# Create some 4M files to test exchangerange
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 _pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
 sync
@@ -39,8 +39,8 @@ md5sum $dir/a $dir/b | _filter_test_dir
 ulimit -f $(( (blksz * 2) / 512))
 ulimit -a >> $seqres.full
 
-# Now try to swapext
-$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+# Now try to exchangerange
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
 md5sum $dir/a $dir/b | _filter_test_dir
 
 # success, all done
diff --git a/tests/generic/718.out b/tests/generic/718.out
index f3f26f7c13..c96c466b7d 100644
--- a/tests/generic/718.out
+++ b/tests/generic/718.out
@@ -1,6 +1,6 @@
 QA output created by 718
 d712f003e9d467e063cda1baf319b928  TEST_DIR/test-718/a
 901e136269b8d283d311697b7c6dc1f2  TEST_DIR/test-718/b
-swapext: Invalid argument
+exchangerange: Invalid argument
 d712f003e9d467e063cda1baf319b928  TEST_DIR/test-718/a
 901e136269b8d283d311697b7c6dc1f2  TEST_DIR/test-718/b
diff --git a/tests/generic/719 b/tests/generic/719
index 70d1ae5d0c..1f8da3a9fd 100755
--- a/tests/generic/719
+++ b/tests/generic/719
@@ -10,7 +10,7 @@
 # caller wants a full file replacement.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/720 b/tests/generic/720
index 25253968a2..b444988841 100755
--- a/tests/generic/720
+++ b/tests/generic/720
@@ -7,7 +7,7 @@
 # Stress testing with a lot of extents.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -31,18 +31,18 @@ nrblks=$((LOAD_FACTOR * 100000))
 
 _require_fs_space $TEST_DIR $(( (2 * blksz * nrblks) / 1024 ))
 
-# Create some big swiss cheese files to test swapext with a lot of extents
+# Create some big swiss cheese files to test exchangerange with a lot of extents
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 $here/src/punch-alternating $dir/a
 _pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
 $here/src/punch-alternating -o 1 $dir/b
 filefrag -v $dir/a $dir/b >> $seqres.full
 
-# Now try to swapext
+# Now try to exchangerange
 md5_a="$(md5sum < $dir/a)"
 md5_b="$(md5sum < $dir/b)"
 date >> $seqres.full
-$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
 date >> $seqres.full
 
 echo "md5_a=$md5_a" >> $seqres.full
diff --git a/tests/generic/721 b/tests/generic/721
index 0beb08927b..406e2b688f 100755
--- a/tests/generic/721
+++ b/tests/generic/721
@@ -8,7 +8,7 @@
 # the staging file; and (b) when the staging file is created empty.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/722 b/tests/generic/722
index 3ec831e708..85afa2e0c1 100755
--- a/tests/generic/722
+++ b/tests/generic/722
@@ -4,11 +4,11 @@
 #
 # FS QA Test No. 722
 #
-# Test swapext with the fsync flag flushes everything to disk before the call
+# Test exchangerange with the fsync flag flushes everything to disk before the call
 # returns.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -43,7 +43,7 @@ od -tx1 -Ad -c $SCRATCH_MNT/a > /tmp/a0
 od -tx1 -Ad -c $SCRATCH_MNT/b > /tmp/b0
 
 echo swap >> $seqres.full
-$XFS_IO_PROG -c "exchangerange -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -f $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_shutdown
 _scratch_cycle_mount
 
diff --git a/tests/generic/723 b/tests/generic/723
index 0e1de3ec1f..f1df1e53e1 100755
--- a/tests/generic/723
+++ b/tests/generic/723
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 723
 #
-# Test swapext with the dry run flag doesn't change anything.
+# Test exchangerange with the dry run flag doesn't change anything.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -38,10 +38,10 @@ old_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
 old_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
 echo "md5 a: $old_a md5 b: $old_b" >> $seqres.full
 
-# Test swapext with the -n option, which will do all the input parameter
+# Test exchangerange with the -n option, which will do all the input parameter
 # checking and return 0 without changing anything.
 echo dry run swap >> $seqres.full
-$XFS_IO_PROG -c "exchangerange -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -n -f $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
@@ -54,7 +54,7 @@ test $old_b = $new_b || echo "scratch file B should not have swapped"
 # Do it again, but without the -n option, to prove that we can actually
 # swap the file contents.
 echo actual swap >> $seqres.full
-$XFS_IO_PROG -c "exchangerange -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -f $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
diff --git a/tests/generic/724 b/tests/generic/724
index 9536705503..4cc02946dd 100755
--- a/tests/generic/724
+++ b/tests/generic/724
@@ -5,11 +5,11 @@
 # FS QA Test No. 724
 #
 # Test scatter-gather atomic file writes.  We create a temporary file, write
-# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
+# sparsely to it, then use XFS_EXCHRANGE_FILE1_WRITTEN flag to swap
 # atomicallly only the ranges that we wrote.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -40,9 +40,9 @@ _pwrite_byte 0x57 768k 64k $SCRATCH_MNT/b >> $seqres.full
 md5sum $SCRATCH_MNT/a | _filter_scratch
 md5sum $SCRATCH_MNT/b | _filter_scratch
 
-# Test swapext.  -h means skip holes in /b, and -e means operate to EOF
+# Test exchangerange.  -w means skip holes in /b
 echo swap | tee -a $seqres.full
-$XFS_IO_PROG -c "exchangerange -f -u -h -e $SCRATCH_MNT/b" $SCRATCH_MNT/a
+$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/generic/725 b/tests/generic/725
index 3c6180fcbb..e5e2139c6e 100755
--- a/tests/generic/725
+++ b/tests/generic/725
@@ -9,7 +9,7 @@
 # perform the scattered update.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/726 b/tests/generic/726
index 05d8a2372a..3b186ab6ac 100755
--- a/tests/generic/726
+++ b/tests/generic/726
@@ -8,7 +8,7 @@
 # commit.
 #
 . ./common/preamble
-_begin_fstest auto fiexchange swapext quick
+_begin_fstest auto fiexchange quick
 
 # Override the default cleanup function.
 # _cleanup()
diff --git a/tests/generic/727 b/tests/generic/727
index 4b0d5bd372..f737d4dd39 100755
--- a/tests/generic/727
+++ b/tests/generic/727
@@ -8,7 +8,7 @@
 # commit.
 #
 . ./common/preamble
-_begin_fstest auto fiexchange swapext quick
+_begin_fstest auto fiexchange quick
 
 # Override the default cleanup function.
 # _cleanup()
diff --git a/tests/xfs/300 b/tests/xfs/300
index bc1f0efc6a..e21ea2e320 100755
--- a/tests/xfs/300
+++ b/tests/xfs/300
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 300
 #
-# Test xfs_fsr / swapext management of di_forkoff w/ selinux
+# Test xfs_fsr / exchangerange management of di_forkoff w/ selinux
 #
 . ./common/preamble
 _begin_fstest auto fsr
diff --git a/tests/xfs/443 b/tests/xfs/443
index 56828decae..069d976cb8 100755
--- a/tests/xfs/443
+++ b/tests/xfs/443
@@ -29,7 +29,7 @@ _require_scratch
 _require_test_program "punch-alternating"
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
-_require_xfs_io_command "swapext"
+_require_xfs_io_command "exchangerange"
 _require_xfs_io_command "fiemap"
 
 _scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
@@ -56,7 +56,7 @@ $here/src/punch-alternating $file2
 for i in $(seq 1 2 399); do
 	# punch one extent from the tmpfile and swap
 	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
-	$XFS_IO_PROG -c "swapext $file2" $file1
+	$XFS_IO_PROG -c "exchangerange $file2" $file1
 
 	# punch the same extent from the old fork (now in file2) to resync the
 	# extent counts and repeat
diff --git a/tests/xfs/790 b/tests/xfs/790
index 62bbd1fea6..88b79611ef 100755
--- a/tests/xfs/790
+++ b/tests/xfs/790
@@ -4,11 +4,11 @@
 #
 # FS QA Test No. 790
 #
-# Make sure an atomic swapext actually runs to completion even if we shut
+# Make sure an atomic exchangerange actually runs to completion even if we shut
 # down the filesystem midway through.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -49,9 +49,9 @@ _pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/c >> $seqres.full
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
 sync
 
-# Inject a bmap error and trigger it via swapext.
+# Inject a bmap error and trigger it via exchangerange.
 filesnap "before commit"
-$XFS_IO_PROG -x -c 'inject bmap_finish_one' -c "swapext $dir/b" $dir/a
+$XFS_IO_PROG -x -c 'inject bmap_finish_one' -c "exchangerange $dir/b" $dir/a
 
 # Check the file afterwards.
 _test_cycle_mount
diff --git a/tests/xfs/790.out b/tests/xfs/790.out
index 70ebb2f18f..d1321e8342 100644
--- a/tests/xfs/790.out
+++ b/tests/xfs/790.out
@@ -3,7 +3,7 @@ before commit
 c7221b1494117327570a0958b0abca51  TEST_DIR/test-790/a
 30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-790/b
 30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-790/c
-swapext: Input/output error
+exchangerange: Input/output error
 after commit
 30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-790/a
 c7221b1494117327570a0958b0abca51  TEST_DIR/test-790/b
diff --git a/tests/xfs/791 b/tests/xfs/791
index b4ded88d68..37f58972c4 100755
--- a/tests/xfs/791
+++ b/tests/xfs/791
@@ -5,12 +5,12 @@
 # FS QA Test No. 791
 #
 # Test scatter-gather atomic file writes.  We create a temporary file, write
-# sparsely to it, then use XFS_EXCH_RANGE_FILE1_WRITTEN flag to swap
+# sparsely to it, then use XFS_EXCHRANGE_FILE1_WRITTEN flag to swap
 # atomicallly only the ranges that we wrote.  Inject an error so that we can
 # test that log recovery finishes the swap.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
@@ -45,10 +45,10 @@ sync
 md5sum $SCRATCH_MNT/a | _filter_scratch
 md5sum $SCRATCH_MNT/b | _filter_scratch
 
-# Test swapext.  -h means skip holes in /b, and -e means operate to EOF
+# Test exchangerange.  -w means skip holes in /b
 echo swap | tee -a $seqres.full
 $XFS_IO_PROG -x -c 'inject bmap_finish_one' \
-	-c "exchangerange -f -u -h -e $SCRATCH_MNT/b" $SCRATCH_MNT/a
+	-c "exchangerange -f -w $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/xfs/791.out b/tests/xfs/791.out
index 015b6d3c46..2153548e91 100644
--- a/tests/xfs/791.out
+++ b/tests/xfs/791.out
@@ -2,6 +2,6 @@ QA output created by 791
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
 c9fb827e2e3e579dc2a733ddad486d1d  SCRATCH_MNT/b
 swap
-swapext: Input/output error
+exchangerange: Input/output error
 e9cbfe8489a68efaa5fcf40cf3106118  SCRATCH_MNT/a
 faf8ed02a5b0638096a817abcc6c2127  SCRATCH_MNT/b
diff --git a/tests/xfs/792 b/tests/xfs/792
index fded7a5a52..1da36fb97c 100755
--- a/tests/xfs/792
+++ b/tests/xfs/792
@@ -10,7 +10,7 @@
 # recovery finishes the swap.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick fiexchange
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/795 b/tests/xfs/795
index a381db320f..a4e65921a5 100755
--- a/tests/xfs/795
+++ b/tests/xfs/795
@@ -6,7 +6,7 @@
 #
 # Ensure that the sysadmin won't hit EDQUOT while repairing file data contents
 # even if the file's quota limits have been exceeded.  This tests the quota
-# reservation handling inside the swapext code used by repair.
+# reservation handling inside the exchangerange code used by repair.
 #
 . ./common/preamble
 _begin_fstest online_repair

