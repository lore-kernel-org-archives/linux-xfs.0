Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FAB3BD65B;
	Tue, 10 Mar 2026 03:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114656; cv=none; b=kL3KRlNHq7tALuTXRkrKsYcAv43J/qvI4lERSWvCGBg8BFWPHO9JOATMoxBwVTZwv2XAGIIB5Vnf5WtmGNzUZsOBdh6J4Ve/l405EVDhXuout6If0EOGiETg1TPsiVainsxWazFLFLGg+Qii8CDBO9718TrKBrPYhtVp31aRs08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114656; c=relaxed/simple;
	bh=H/1JEd8+CMCbZ3Y2fxzF8SYq5qrTkGnQjTq/ut/F4A0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USbIv8xAwlWL0YIeTjKrrdnY/EujvdI2NRwoD5jxKzKBxpkKzalkThSXOWRBXaxc1IViGo6Cqle0w59wO37xpW4NICDmMxxvI8i5MHMJcsbnW5G9xpVEfvUyv/YG3LySBB8YDrmQFdPWWRH0Nbg3iGC3+i+Rhb9yjEDE3jsrR1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaN+J92Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaN+J92Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA75C19423;
	Tue, 10 Mar 2026 03:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114655;
	bh=H/1JEd8+CMCbZ3Y2fxzF8SYq5qrTkGnQjTq/ut/F4A0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KaN+J92ZX3upWwCu71fd8+wf9ThX7GG1eZ0pvBtz5wlAC6ZGUtAfYg/uFqCi5BFc8
	 JBScJIRAgwcFHqDfXKWkGteSgli+rNtDHiif3dDVN4x8kaV/HYReTxR9wcZ/4k23bh
	 +9F3uPJBE7t61d43OORUzt7vlwR8z5DWEXafs60n4/64RX3otR9RMwK9f6M99r9/xX
	 N627me9ToorCeSs46XWkakOc4BsQNTMbjY8AkKx0wTI2YJtSDhI8q0Jf00/FtAprbh
	 Y7lQHoumf14+CIKuJqUopvBUehmFzeM/4hKHcKkT4FrbjfX1cAUhLc+xAQYSKNg3Ta
	 QDxZ1mr8z0hJw==
Date: Mon, 09 Mar 2026 20:50:55 -0700
Subject: [PATCH 03/14] xfs: test io error reporting via healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403831.1186408.9334207319061853105.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
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
 tests/xfs/1878     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1878.out |   10 ++++++
 2 files changed, 103 insertions(+)
 create mode 100755 tests/xfs/1878
 create mode 100644 tests/xfs/1878.out


diff --git a/tests/xfs/1878 b/tests/xfs/1878
new file mode 100755
index 00000000000000..1ff6ae040fb193
--- /dev/null
+++ b/tests/xfs/1878
@@ -0,0 +1,93 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1878
+#
+# Attempt to read and write a file in buffered and directio mode with the
+# health monitoring program running.  Check that healthmon observes all four
+# types of IO errors.
+#
+. ./common/preamble
+_begin_fstest auto quick eio selfhealing
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
+filter_healer_errors() {
+	_filter_scratch | \
+		grep -E '(buffered|directio)' | \
+		sed \
+		    -e 's/ino [0-9]*/ino NUM/g' \
+		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
+		    -e 's/pos [0-9]*/pos NUM/g' \
+		    -e 's/len [0-9]*/len NUM/g' \
+		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g' | \
+		uniq
+}
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
+sleep 1	# wait for program to start up
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
+sleep 1	# wait for program to start up
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
+filter_healer_errors < $tmp.healthmon
+
+_dmerror_cleanup
+
+status=0
+exit
diff --git a/tests/xfs/1878.out b/tests/xfs/1878.out
new file mode 100644
index 00000000000000..f64c440b1a6ed1
--- /dev/null
+++ b/tests/xfs/1878.out
@@ -0,0 +1,10 @@
+QA output created by 1878
+Format and mount
+pwrite: Input/output error
+pread: Input/output error
+pread: Input/output error
+fsync: Input/output error
+VICTIM pos NUM len NUM: directio_write: Input/output error
+VICTIM pos NUM len NUM: directio_read: Input/output error
+VICTIM pos NUM len NUM: buffered_read: Input/output error
+VICTIM pos NUM len NUM: buffered_write: Input/output error

