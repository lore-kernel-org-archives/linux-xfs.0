Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028594C9B;
	Tue, 27 Feb 2024 02:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999358; cv=none; b=QywyojvkdiuiVExdA6/qPrZLEn9h5WCXsCVy4+MMjnEnCvbZcfUpzt0n9l5hDNaWrA809nt+qldyjDJbc0DX6ZfgPpDB8PXADDVSZJR1ch+EBvPKhZDIIVvF8Xt8iTcAe/p10pD+noQnqKkfbrHLRB6XbZ0USoOQtYMByoBZJuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999358; c=relaxed/simple;
	bh=FKGvam17ZCy+PtLvxrdG7HGDzS8vHZEQkD2Rklyav4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMPXfcGQLCcUPEwqYeKdofqBDMtAHKzlbNLVxa6CEot0YlnOZJJWPoI0dDCY4Oku6fTM7xQBy7YKXs2REbeDQLZgjAxMpDFg+ctwoFv82MyOeOZiz4dgd5oLz0q7JJsFJpnm14050FHVZbuf+X5vEjscWqmwXZAKJF0KmSago1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vb+ka4Mi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vb+ka4Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F22BC433C7;
	Tue, 27 Feb 2024 02:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999357;
	bh=FKGvam17ZCy+PtLvxrdG7HGDzS8vHZEQkD2Rklyav4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vb+ka4MiInLuradAYO6f0xV0YO2FSolyIumE+Iwt/T37pyvBkvZjQQXsbMDyn6z/r
	 R2iMyscroaCod0kVbJVmdnV4rZCqfXgBZi1wlD0RHpiMew1USFr0GZpw13fTCAuLY+
	 U2Y4bi2pIrnenk/eS95Sie6Oj3NrdNJXf2mCCqonINLFUGKbZ2Mem4udYfP65Wz3D1
	 yz/MsAJD71zfuKlmNPBfMeZjwThmOiipiT3X0G9ugsPn2cXADa0Q/ES4rpVhQWTu+Y
	 pbcjh2yUAE+fJT0h9PalvH6HF6x+QzH7fuvMGDS8YXwOQ82YnliA9ea+JRM196V6sR
	 4PKdMG85vGb6g==
Date: Mon, 26 Feb 2024 18:02:37 -0800
Subject: [PATCH 8/8] xfs: test for premature ENOSPC with large cow delalloc
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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
 common/rc          |   14 +++++++++
 tests/xfs/1923     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1923.out |    8 +++++
 3 files changed, 107 insertions(+)
 create mode 100755 tests/xfs/1923
 create mode 100644 tests/xfs/1923.out


diff --git a/common/rc b/common/rc
index 30c44dddd9..d3a2a0718b 100644
--- a/common/rc
+++ b/common/rc
@@ -1873,6 +1873,20 @@ _require_scratch_delalloc()
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
index 0000000000..4e494ad8c2
--- /dev/null
+++ b/tests/xfs/1923
@@ -0,0 +1,85 @@
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
+_fixed_by_kernel_commit XXXXX \
+	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test_program "punch-alternating"
+_require_test_reflink
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_test_delalloc
+
+file1=$TEST_DIR/file1.$seq
+file2=$TEST_DIR/file2.$seq
+fragmentedfile=$TEST_DIR/fragmentedfile.$seq
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
+#$XFS_IO_PROG -f -c "reflink $file1" $file2 >> $seqres.full
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
+$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 >> $seqres.full
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

