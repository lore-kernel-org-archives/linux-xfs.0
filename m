Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA743D988;
	Thu,  7 Mar 2024 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709853777; cv=none; b=rUXceoNsZYiC6uhrWLXHnaKAthylJaL5IPFUDqGVtpFJSCyUl/VRbahsGQJWjlyQOvOcaroHBz92/QEYe+QOLdxlnCGPgyubaeOF1t9IEZ7CbIgu6dSC5tYWYio5GXHr6b5I2Meqbsq85JR1aB3Yn9T3XlEtQ/rayKs0ZJRy2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709853777; c=relaxed/simple;
	bh=uAAG7DyqL+hIA8eSSsdzlHAUhk3kRwf8uvIFLfuYM9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYFMHO59MX6bFu6l67blI3EAjwSo9pBL+IaFZgL/YB7HM+BHxxCpyBrrSamNSL4uSX9I30cEy32SCzYOpfpIDZcnivE2wGtrsYhG1yPgoY55tZICNF/PYaxIRImt/wfeen5y6caLEbexW2XGDgZvIY1JquQ3H3kAVZkrmJsQ0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLz6qWvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLz6qWvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC1CC43390;
	Thu,  7 Mar 2024 23:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709853776;
	bh=uAAG7DyqL+hIA8eSSsdzlHAUhk3kRwf8uvIFLfuYM9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLz6qWvRPwdNRWbIPsTWPb8dO+bbesp0Lv5rJBHT05vMv+XiE8ABSfBXD36vBb404
	 YY5EFWCWc21WP4z+P4s0+bxFzdbg/yQnKJw/w+dW7MKLs0ahE6CyFQgoAXnbuAHFBG
	 KNyRzKiR0cLL4H66bvAXW14m+mAqYWDYCAZ5dCB62mS7SRd02UuLSANb2fwMoOasYJ
	 oG6RnUP+msHYGq4Xj6M5XYC+HQcS2nBVCJJze2YuMdezU7/zIYCgsHPrSMJtG7sBf2
	 FID6ahCc77zhMtFYBp+QnQAvZPZvbUxMq0SW0gKwZT/AafgLjXq/plDr1oJycYzmvJ
	 Kc64E7EIO+2aQ==
Date: Thu, 7 Mar 2024 15:22:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: [PATCH v1.2 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240307232255.GG1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
even though the filesystem has sufficient number of free blocks.

This occurs if the file offset range on which the write operation is being
performed has a delalloc extent in the cow fork and this delalloc extent
begins much before the Direct IO range.

In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
allocate the blocks mapped by the delalloc extent. The extent thus allocated
may not cover the beginning of file offset range on which the Direct IO write
was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.

This test addresses this issue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: address some missing bits and remove extraneous code
v1.2: fix cow fork dumping screwing up golden output
---
 common/rc          |   14 ++++++++
 tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1923.out |    8 +++++
 3 files changed, 108 insertions(+)
 create mode 100755 tests/xfs/1923
 create mode 100644 tests/xfs/1923.out

diff --git a/common/rc b/common/rc
index 50dde313b8..9f54ab1e77 100644
--- a/common/rc
+++ b/common/rc
@@ -1883,6 +1883,20 @@ _require_scratch_delalloc()
 	_scratch_unmount
 }
 
+# Require test fs supports delay allocation.
+_require_test_delalloc()
+{
+	_require_command "$FILEFRAG_PROG" filefrag
+
+	rm -f $TEST_DIR/testy
+	$XFS_IO_PROG -f -c 'pwrite 0 64k' $TEST_DIR/testy &> /dev/null
+	$FILEFRAG_PROG -v $TEST_DIR/testy 2>&1 | grep -q delalloc
+	res=$?
+	rm -f $TEST_DIR/testy
+	test $res -eq 0 || \
+		_notrun "test requires delayed allocation buffered writes"
+}
+
 # this test needs a test partition - check we're ok & mount it
 #
 _require_test()
diff --git a/tests/xfs/1923 b/tests/xfs/1923
new file mode 100755
index 0000000000..4ad3dfa764
--- /dev/null
+++ b/tests/xfs/1923
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1923
+#
+# This is a regression test for "xfs: Fix false ENOSPC when performing direct
+# write on a delalloc extent in cow fork".  If there is a lot of free space but
+# it is very fragmented, it's possible that a very large delalloc reservation
+# could be created in the CoW fork by a buffered write.  If a directio write
+# tries to convert the delalloc reservation to a real extent, it's possible
+# that the allocation will succeed but fail to convert even the first block of
+# the directio write range.  In this case, XFS will return ENOSPC even though
+# all it needed to do was to keep converting until the allocator returns ENOSPC
+# or the first block of the direct write got some space.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+_cleanup()
+{
+	cd /
+	rm -f $file1 $file2 $fragmentedfile
+}
+
+# Import common functions.
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_fixed_by_kernel_commit d62113303d69 \
+	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_test_program "punch-alternating"
+_require_test_reflink
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_test_delalloc
+
+file1=$TEST_DIR/file1.$seq
+file2=$TEST_DIR/file2.$seq
+fragmentedfile=$TEST_DIR/fragmentedfile.$seq
+
+rm -f $file1 $file2 $fragmentedfile
+
+# COW operates on pages, so we must not perform operations in units smaller
+# than a page.
+blksz=$(_get_file_block_size $TEST_DIR)
+pagesz=$(_get_page_size)
+if (( $blksz < $pagesz )); then
+	blksz=$pagesz
+fi
+
+echo "Create source file"
+$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
+
+sync
+
+echo "Create Reflinked file"
+_cp_reflink $file1 $file2 >> $seqres.full
+
+echo "Set cowextsize"
+$XFS_IO_PROG -c "cowextsize $((blksz * 128))" -c stat $file1 >> $seqres.full
+
+echo "Fragment FS"
+$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 512))" $fragmentedfile >> $seqres.full
+sync
+$here/src/punch-alternating $fragmentedfile
+
+echo "Allocate block sized extent from now onwards"
+_test_inject_error bmap_alloc_minlen_extent 1
+
+echo "Create big delalloc extent in CoW fork"
+$XFS_IO_PROG -c "pwrite 0 $blksz" $file1 >> $seqres.full
+
+sync
+
+$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 &>> $seqres.full
+
+echo "Direct I/O write at offset 3FSB"
+$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $file1 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1923.out b/tests/xfs/1923.out
new file mode 100644
index 0000000000..a0553cf3ee
--- /dev/null
+++ b/tests/xfs/1923.out
@@ -0,0 +1,8 @@
+QA output created by 1923
+Create source file
+Create Reflinked file
+Set cowextsize
+Fragment FS
+Allocate block sized extent from now onwards
+Create big delalloc extent in CoW fork
+Direct I/O write at offset 3FSB
