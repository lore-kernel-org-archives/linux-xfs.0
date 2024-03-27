Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825031CD2B;
	Wed, 27 Mar 2024 02:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507422; cv=none; b=qpJUljNW1362zg1IncVpoJlGmyAA5KQo9x+AeFNh0vsyESE93tBZr23iHmr6aVIQSbrpzgfHnx/cQ3fEeDiM6wf0IrZTzxgQVJk3j0h4iPpTsITDMHbq1Y5K7PvMVWS97YDTWhd+zNXPMtnC4rhymt/7abGREM4zyFXoezFKVBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507422; c=relaxed/simple;
	bh=IG88Lepce6s0skeT7uh1mvnMKFQVVFwX7vG7KogjAro=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4PT3C+84rr1V40DdLo0bwwAcvjQx/N2Lcv4sqyVRB4z7ovG60Rrx4At9ss8o32/zPqBjiOYqRTxr87FXMTZX8aMqz+VZTQE6aopRtmqBU6mbBE9Dc4+giwGk9ya2xoaG0VTaXB3WTJgiw0mDyXRjBz71zcQFhoPkle0+u+CtZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGtjoVXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGtjoVXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148FEC433F1;
	Wed, 27 Mar 2024 02:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507422;
	bh=IG88Lepce6s0skeT7uh1mvnMKFQVVFwX7vG7KogjAro=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=FGtjoVXo6OurfqfvOt1Cy8W+K+EqZc8T2GJv9OnwSN7vKyJ56W5YBnE/FuR8HaetX
	 +oz8RthgzqzAhOFj4YY4ZHXyr16LPj4T0SlyTIEUUNeDDeUQuN2e+UYYz6PWShsgpI
	 qryoX4B9biqEJhfj3kK95saoU7H656mfo/MvWC+sj6m6paQq+xb6FqCH/c0xzdVa3w
	 0pyiXvB02x2Z9aIpkJByFlkgkwNgi83LYzSJKsLdUQSsg6s3jtGkv5n1svJlfC97PV
	 jrwU+mL2Wkt7pEaoLNmc/35Swy4GOGbMeVnDUd776s8Suo0GhHL2yiayj11G1BiXZ2
	 kAXi8cdKQ4VgA==
Subject: [PATCH 4/4] generic: test MADV_POPULATE_READ with IO errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Date: Tue, 26 Mar 2024 19:43:41 -0700
Message-ID: <171150742156.3286541.2986329968568619601.stgit@frogsfrogsfrogs>
In-Reply-To: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
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

This is a regression test for "mm/madvise: make
MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly".

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/1835     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1835.out |    4 +++
 2 files changed, 69 insertions(+)
 create mode 100755 tests/generic/1835
 create mode 100644 tests/generic/1835.out


diff --git a/tests/generic/1835 b/tests/generic/1835
new file mode 100755
index 0000000000..07479ab712
--- /dev/null
+++ b/tests/generic/1835
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1835
+#
+# This is a regression test for a kernel hang that I saw when creating a memory
+# mapping, injecting EIO errors on the block device, and invoking
+# MADV_POPULATE_READ on the mapping to fault in the pages.
+#
+. ./common/preamble
+_begin_fstest auto rw
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/dmerror
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly"
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command madvise -R
+_require_scratch
+_require_dm_target error
+_require_command "$TIMEOUT_PROG" "timeout"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_dmerror_init
+
+filesz=2m
+
+# Create a file that we'll read, then cycle mount to zap pagecache
+_dmerror_mount
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $filesz" "$SCRATCH_MNT/a" >> $seqres.full
+_dmerror_unmount
+_dmerror_mount
+
+# Try to read the file data in a regular fashion just to prove that it works.
+echo read with no errors
+timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"
+_dmerror_unmount
+_dmerror_mount
+
+# Load file metadata and induce EIO errors on read.  Try to provoke the kernel;
+# kill the process after 10s so we can clean up.
+stat "$SCRATCH_MNT/a" >> $seqres.full
+echo read with IO errors
+_dmerror_load_error_table
+timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"
+_dmerror_load_working_table
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1835.out b/tests/generic/1835.out
new file mode 100644
index 0000000000..1b03586e8c
--- /dev/null
+++ b/tests/generic/1835.out
@@ -0,0 +1,4 @@
+QA output created by 1835
+read with no errors
+read with IO errors
+madvise: Bad address

