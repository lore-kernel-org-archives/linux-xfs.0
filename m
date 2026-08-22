Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0601C3148D8;
	Sat, 22 Aug 2026 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787418927; cv=none; b=mGSa7ywPwWpkxOwp0CBvD/pigckISN2rnXDhCUSDuq1v+rZHsRf1dm/R2T6odODKzvEH8uJkWgD247tlxrtt217sIuTGFoEmk7iMKCwJIhf5ips5Sc0oVuLwoeaS/RHvaXAniLlt0ujxcYZAajdyfeZEdKrNzb4TQKh5nlP7cyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787418927; c=relaxed/simple;
	bh=4mJfCK+g8cw0xCHX3rTi+pXRcwG/R9juBeCj8su7aBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AuK7WRd1zTzWxFrxCTSKQp7xYGbb6IqWI2r4IBOlSnHBq0eKGRrq7fF8+zdu5lakmKsdzREkSq6fKyvYXEt6R4oRL5HeFAZp3PCFFpt/R6cOkkKVM99G7mKD3boscy3F945wcQ+O6s0qVXyrKmQKaOGEkS2xAQ+yp9roKD2m5w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0GbVRnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0GbVRnQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9B7171F000E9;
	Sat, 22 Aug 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787418925;
	bh=GlE9Xeh3v7LBfk1CPSSqYvy3sWzaclCRgkNE8j2idd8=;
	h=Date:From:To:Cc:Subject;
	b=L0GbVRnQzQDJzZQSVdCAn7EJLKj0zMpsmRWj4iUeE4kv8t4VUlRKzRPD4TujGc7z2
	 Q7gX3kJIA+VFDQIWb8zJXUJ189w8udYPy+FtYe4yQQmy0Xiq0vk2C8ReBEqzb5rytI
	 cd+j3O6P7nUjwvLwfZ1M/yVMkF01T1Mpt7CLVTS55gr8cyX5XYVF5ZwXVbOI/oXKib
	 iWO6hHNsHIJifGpEEYrnFnIjcjadle8O0NMpSV31v75iaYzKQFBjPYRWQ9CeC+rjIQ
	 54DwwpFT1mzwn8EBoj04qFUyO5sY43XQXCZQNUr7TA8lll9tLGkSdXN8jiZ+W/n+AJ
	 1I7YXSZlscTrg==
Date: Sat, 22 Aug 2026 10:15:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	ljp1205831794@gmail.com
Subject: [PATCH v3] xfs: test reflux with exchange-range
Message-ID: <20260822171525.GM839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Regression test for the XFS_IOC_EXCHRANGE flag INO1_WRITTEN clearing
reflink flags when that shouldn't happen.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zorro Lang <zlang@kernel.org
---
v3: remove dummydir, add more rvb, fix fixes tag
v2: add rvb tags, fix test description
---
 tests/generic/1957     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1957.out |   16 ++++++++++++
 2 files changed, 81 insertions(+)
 create mode 100755 tests/generic/1957
 create mode 100644 tests/generic/1957.out

diff --git a/tests/generic/1957 b/tests/generic/1957
new file mode 100755
index 00000000000000..693072a0866c2f
--- /dev/null
+++ b/tests/generic/1957
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1957
+#
+# Regression test for an exchange-range bug which unintentionally results in
+# files that share data blocks but don't have the reflink flag set.  This
+# enables attackers to rewrite shared blocks to gain root privileges, similar
+# to refluxfs.
+. ./common/preamble
+_begin_fstest auto quick fiexchange
+
+. ./common/filter
+. ./common/reflink
+
+_require_scratch_reflink
+_require_xfs_io_command exchangerange
+_require_cp_reflink
+
+_fixed_by_fs_commit xfs b2d5a81dae3853 \
+	"xfs: fix exchange-range reflink flag clearing issue with  INO1_WRITTEN"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Create file1 as a fully written file, and file2 as a sparse file with one
+# written area.
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 1m" $SCRATCH_MNT/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate 1m" -c "pwrite -S 0x59 64k 64k" $SCRATCH_MNT/file2 >> $seqres.full
+
+_scratch_unmount
+_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
+_scratch_mount
+
+# Reflink file1 so that the reflink flag gets set
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/fileC
+
+md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
+
+# Exchange the written parts of file2 with file1, but only file1 has the
+# reflink flag set.
+$XFS_IO_PROG -c "exchangerange -w $SCRATCH_MNT/file2" $SCRATCH_MNT/file1 >> $seqres.full
+
+# Check reflink flags
+_scratch_unmount
+_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
+_scratch_mount
+
+# Record content and layout
+md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
+$XFS_IO_PROG -c 'bmap -vvvvvvvv' $SCRATCH_MNT/file[12C] >> $seqres.full
+
+# Write a single byte to file1, does that get echoed in fileC?
+$XFS_IO_PROG -c 'pwrite -S 0x59 0 1' $SCRATCH_MNT/file1 >> $seqres.full
+#
+# Check reflink flags
+_scratch_unmount
+_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
+_scratch_mount
+
+md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
+$XFS_IO_PROG -c 'bmap -vvvvvvvv' $SCRATCH_MNT/file[12C] >> $seqres.full
+
+_exit 0
diff --git a/tests/generic/1957.out b/tests/generic/1957.out
new file mode 100644
index 00000000000000..7d64ea0e2c372d
--- /dev/null
+++ b/tests/generic/1957.out
@@ -0,0 +1,16 @@
+QA output created by 1957
+v3.reflink = 0
+v3.reflink = 0
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/file1
+e6ee47dca6e786a44ae5b912be870d96  SCRATCH_MNT/file2
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
+v3.reflink = 1
+v3.reflink = 1
+b630c7de58afd0ba5b8dfa24d701b5b8  SCRATCH_MNT/file1
+18cc9868973139a0bb558e09802a51b6  SCRATCH_MNT/file2
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
+v3.reflink = 1
+v3.reflink = 1
+82b27c6f1b1de8fba44a911af80d9a7a  SCRATCH_MNT/file1
+18cc9868973139a0bb558e09802a51b6  SCRATCH_MNT/file2
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
