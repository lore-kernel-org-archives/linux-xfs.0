Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF461C28E;
	Wed, 19 Feb 2025 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927020; cv=none; b=d8e47ZsV1iPS09dPEIYejA0Blgg3BVyiR5xCczwya4fUZR7ENc7OaGBRMPTDFqTaHbcw+3jH33WFRiQHdevLCT/lUvVOkcnrYhBMZ0GD5NhSj+Ugh4IyjAj7V0YBFaR6O2cLpRzgdDnxRnW18Yo2D3OSY7pyC+TpOANCSW5eLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927020; c=relaxed/simple;
	bh=o7+hEsBuxsHh79cM+Secglfakibe/I02+KHtDNmR1DQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MyhVZ3vHCIz30zbM0gaSW+6Qg0bcsrT6Rvvol84YAqiNNvVp6j5sHstM7EWD8v9lnKg9qVTRVufEMKxUPac+n5HSgFNli5bKP7dzh2JgrIjOiFKxJLm228t4+ykGgMjYgDNjZ8K5mvTO+KLAZ/Jjc18kNR4YanoaY357kzT/fRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rx/H7iUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rx/H7iUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E4CC4CEE2;
	Wed, 19 Feb 2025 01:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927019;
	bh=o7+hEsBuxsHh79cM+Secglfakibe/I02+KHtDNmR1DQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rx/H7iUK2IYR/qWumBq074GdS9Ex5ApgQXTKdD3dA+L/GF6kO1ENPwcxNlPq6zYVh
	 9MRld+V1tInjZ6KxFeMo6I8qOolmqpjbl1Xmp+jcyVzlL0rBV1vq4Q2AIRHENp9JbX
	 WOP7/Rcjw6khj3KYBT6i+pl6CxXaju7+233r4R8ZuvtVHXDXdBLCSBCh9J//Ss4n2T
	 Em00/KF1bC5qq+2V9jkvT2qi5OupFTj9INanoCwFz8QdN0qRDMcgdBAYB2W5K57F9J
	 CEdoGswlLB25DIKg0mTvxY7NxQ5Tj3/PMyq6cbXvJaDGpAVJaZ/DoSLcWmnZgwyjtG
	 Bhi0O86NDPGEw==
Date: Tue, 18 Feb 2025 17:03:39 -0800
Subject: [PATCH 1/1] common: test statfs reporting with project quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992590675.4080455.17713454161928793525.stgit@frogsfrogsfrogs>
In-Reply-To: <173992590656.4080455.15086949489894120802.stgit@frogsfrogsfrogs>
References: <173992590656.4080455.15086949489894120802.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a test to check that statfs on a directory tree with a project
quota will report the quota limit and available blocks; and that the
available blocks reported doesn't exceed that of the whole filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/1955     |  114 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1955.out |   13 +++++
 2 files changed, 127 insertions(+)
 create mode 100755 tests/generic/1955
 create mode 100644 tests/generic/1955.out


diff --git a/tests/generic/1955 b/tests/generic/1955
new file mode 100755
index 00000000000000..e431b3c4e3fd5d
--- /dev/null
+++ b/tests/generic/1955
@@ -0,0 +1,114 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1955
+#
+# Make sure that statfs reporting works when project quotas are set on a
+# directory tree.
+#
+. ./common/preamble
+_begin_fstest auto quota
+
+_fixed_by_git_commit kernel XXXXXXXXXXXXXX \
+	"xfs: don't over-report free space or inodes in statvfs"
+
+. ./common/filter
+. ./common/quota
+
+_require_quota
+_require_scratch
+_require_xfs_io_command 'chproj'
+_require_xfs_io_command "falloc"
+
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "prjquota"
+_qmount
+_force_vfs_quota_testing $SCRATCH_MNT
+_require_prjquota $SCRATCH_DEV
+
+mkdir $SCRATCH_MNT/dir
+
+bsize() {
+	$XFS_IO_PROG -c 'statfs' $1 | grep f_bsize | awk '{print $3}'
+}
+
+blocks() {
+	$XFS_IO_PROG -c 'statfs' $1 | grep f_blocks | awk '{print $3}'
+}
+
+bavail() {
+	$XFS_IO_PROG -c 'statfs' $1 | grep f_bavail | awk '{print $3}'
+}
+
+bsize=$(bsize $SCRATCH_MNT)
+orig_bavail=$(bavail $SCRATCH_MNT)
+orig_blocks=$(blocks $SCRATCH_MNT)
+
+# Set a project quota limit of half the free space, make sure both report the
+# same number of blocks
+pquot_limit=$(( orig_bavail / 2 ))
+setquota -P 55 0 $((pquot_limit * bsize / 1024))K 0 0 $SCRATCH_DEV
+$XFS_IO_PROG -c 'chproj 55' -c 'chattr +P' $SCRATCH_MNT/dir
+
+# check statfs reporting
+fs_blocks=$(blocks $SCRATCH_MNT)
+dir_blocks=$(blocks $SCRATCH_MNT/dir)
+
+_within_tolerance "root blocks1" $fs_blocks $orig_blocks 1% -v
+_within_tolerance "dir blocks1" $dir_blocks $pquot_limit 1% -v
+
+fs_bavail=$(bavail $SCRATCH_MNT)
+expected_dir_bavail=$pquot_limit
+dir_bavail=$(bavail $SCRATCH_MNT/dir)
+
+_within_tolerance "root bavail1" $fs_bavail $orig_bavail 1% -v
+_within_tolerance "dir bavail1" $dir_bavail $expected_dir_bavail 1% -v
+
+# use up most of the free space in the filesystem
+rem_free=$(( orig_bavail / 10 ))	# bsize blocks
+fallocate -l $(( (orig_bavail - rem_free) * bsize )) $SCRATCH_MNT/a
+
+if [ $rem_free -gt $pquot_limit ]; then
+	echo "rem_free $rem_free greater than pquot_limit $pquot_limit??"
+fi
+
+# check statfs reporting
+fs_blocks=$(blocks $SCRATCH_MNT)
+dir_blocks=$(blocks $SCRATCH_MNT/dir)
+
+_within_tolerance "root blocks2" $fs_blocks $orig_blocks 1% -v
+_within_tolerance "dir blocks2" $dir_blocks $pquot_limit 1% -v
+
+fs_bavail=$(bavail $SCRATCH_MNT)
+dir_bavail=$(bavail $SCRATCH_MNT/dir)
+
+_within_tolerance "root bavail2" $fs_bavail $rem_free 1% -v
+_within_tolerance "dir bavail2" $dir_bavail $rem_free 1% -v
+
+# use up 10 blocks of project quota
+$XFS_IO_PROG -f -c "pwrite -S 0x99 0 $((bsize * 10))" -c fsync $SCRATCH_MNT/dir/a >> $seqres.full
+
+# check statfs reporting
+fs_blocks=$(blocks $SCRATCH_MNT)
+dir_blocks=$(blocks $SCRATCH_MNT/dir)
+
+_within_tolerance "root blocks3" $fs_blocks $orig_blocks 1% -v
+_within_tolerance "dir blocks3" $dir_blocks $pquot_limit 1% -v
+
+fs_bavail=$(bavail $SCRATCH_MNT)
+dir_bavail=$(bavail $SCRATCH_MNT/dir)
+
+_within_tolerance "root bavail3" $fs_bavail $rem_free 1% -v
+_within_tolerance "dir bavail3" $dir_bavail $((rem_free - 10)) 1% -v
+
+# final state diagnostics
+$XFS_IO_PROG -c 'statfs' $SCRATCH_MNT $SCRATCH_MNT/dir | grep statfs >> $seqres.full
+repquota -P $SCRATCH_DEV >> $seqres.full
+df $SCRATCH_MNT >> $seqres.full
+ls -laR $SCRATCH_MNT/ >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1955.out b/tests/generic/1955.out
new file mode 100644
index 00000000000000..3601010962193e
--- /dev/null
+++ b/tests/generic/1955.out
@@ -0,0 +1,13 @@
+QA output created by 1955
+root blocks1 is in range
+dir blocks1 is in range
+root bavail1 is in range
+dir bavail1 is in range
+root blocks2 is in range
+dir blocks2 is in range
+root bavail2 is in range
+dir bavail2 is in range
+root blocks3 is in range
+dir blocks3 is in range
+root bavail3 is in range
+dir bavail3 is in range

