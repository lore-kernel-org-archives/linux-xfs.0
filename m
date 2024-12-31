Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E9529415;
	Tue, 31 Dec 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689489; cv=none; b=ogYDFqtbrpa9JSbiK3QAE3dTAv15F8g7RAOsVhMt/i5hbhnddD9xEmx8v7mDIZ30nJPkuc7N2E9xS228nd/BBeib34DEoPLZRDd7IpjaGPg2soDKpW9lCPYBszSRQRo/HKBSYkqgzf2HGso1esa88FJPP+cIhr12mbn7K+VyNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689489; c=relaxed/simple;
	bh=7h4f7ZQQbFs0PaadpR0aYoCszZf/aLPEhK2i9AxXyyI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEAKjJ8DTEnUh0tQSMH5YYoT4cotwHm0Z+yH564JgT9rm3ACE09mH1Zq1TFwbNH7lZSm44W5yXMbUs8LPiESj/H+hwKClHy8c89mRxR1LBt2DaDji0xT3Qa7UG5CyER19PMV1myaMrfvS8fSdoPp8DI9ml9fxPhQ8uZ3dvGoG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zu5L7zpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zu5L7zpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C051AC4CED2;
	Tue, 31 Dec 2024 23:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689488;
	bh=7h4f7ZQQbFs0PaadpR0aYoCszZf/aLPEhK2i9AxXyyI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zu5L7zpLuh2UdiXJdouU7SM37kKZ9dIibsq1bciodCJroC+9/WAVuWxi8v2OHUU4B
	 0GWfaOyi7rNlkTjF9moEnARNcWsUuiJ0VoMK0IHnjI2u54GuxCz9RPep0mhzaiw+Ba
	 4Hil3OHLs3NCZNrX/3rjSXby4BU0w0CqvhSVxJfye5puOtz55EgTXj6V0x34J5Tacm
	 oBmRE1VA2aWR2KCVkrX8DuXyJwqqe30R8DomOcQ0uz3KMZfBw7HvuKITBmzcFvYDU7
	 7kZec6tvr1OL50v/36DQxpKktjuUbIROnZ+e5NeeGn9tD9s898NLwyFQelew+6SMsl
	 twCjvx5BbjuzA==
Date: Tue, 31 Dec 2024 15:58:08 -0800
Subject: [PATCH 5/6] xfs: test io error reporting via healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783209.2712254.9438605455559107615.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
References: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new test to make sure the kernel can report IO errors via
health monitoring.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1878     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1878.out |   10 +++++++
 2 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/1878
 create mode 100644 tests/xfs/1878.out


diff --git a/tests/xfs/1878 b/tests/xfs/1878
new file mode 100755
index 00000000000000..882d0dcca03cb1
--- /dev/null
+++ b/tests/xfs/1878
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1878
+#
+# Attempt to read and write a file in buffered and directio mode with the
+# health monitoring program running.  Check that healthmon observes all four
+# types of IO errors.
+#
+. ./common/preamble
+_begin_fstest auto quick eio
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $testdir
+	_dmerror_cleanup
+}
+
+. ./common/filter
+. ./common/dmerror
+
+_require_scratch_nocheck
+_require_xfs_io_command healthmon
+_require_dm_target error
+
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_dmerror_init no_log
+_dmerror_mount
+
+_require_fs_space $SCRATCH_MNT 65536
+
+# Create a file with written regions far enough apart that the pagecache can't
+# possibly be caching the regions with a single folio.
+testfile=$SCRATCH_MNT/fsync-err-test
+$XFS_IO_PROG -f \
+	-c 'pwrite -b 1m 0 1m' \
+	-c 'pwrite -b 1m 10g 1m' \
+	-c 'pwrite -b 1m 20g 1m' \
+	-c fsync $testfile >> $seqres.full
+
+# First we check if directio errors get reported
+$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &
+sleep 1	# wait for python program to start up
+_dmerror_load_error_table
+$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
+$XFS_IO_PROG -d -c 'pread -b 256k 10g 16k' $testfile >> $seqres.full
+_dmerror_load_working_table
+
+_dmerror_unmount
+wait	# for healthmon to finish
+_dmerror_mount
+
+# Next we check if buffered io errors get reported.  We have to write something
+# before loading the error table to ensure the dquots get loaded.
+$XFS_IO_PROG -c 'pwrite -b 256k 20g 1k' -c fsync $testfile >> $seqres.full
+$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &
+sleep 1	# wait for python program to start up
+_dmerror_load_error_table
+$XFS_IO_PROG -c 'pread -b 256k 12k 16k' $testfile >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -b 256k 20g 16k' -c fsync $testfile >> $seqres.full
+_dmerror_load_working_table
+
+_dmerror_unmount
+wait	# for healthmon to finish
+
+# Did we get errors?
+cat $tmp.healthmon >> $seqres.full
+grep -E '(diowrite|dioread|readahead|writeback)' $tmp.healthmon | sort | uniq
+
+_dmerror_cleanup
+
+status=0
+exit
diff --git a/tests/xfs/1878.out b/tests/xfs/1878.out
new file mode 100644
index 00000000000000..a8070c3c1afd23
--- /dev/null
+++ b/tests/xfs/1878.out
@@ -0,0 +1,10 @@
+QA output created by 1878
+Format and mount
+pwrite: Input/output error
+pread: Input/output error
+pread: Input/output error
+fsync: Input/output error
+  "type":       "dioread",
+  "type":       "diowrite",
+  "type":       "readahead",
+  "type":       "writeback",

