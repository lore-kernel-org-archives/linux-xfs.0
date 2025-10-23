Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FCE72627;
	Thu, 23 Oct 2025 00:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178685; cv=none; b=GsDm9Gn0TeqEPMkbCCHnvQoYyjubHX7YhYh3cqV9uJh3z0bBcyPW0Hjgy4ajPgXcakKgg2c/07q4qj/+rOKLO2oQLs4HDw21Jywpy8iv+l9AZ1KynCIy8XtJ7/xAdufp4YYABsTf1mjTOft2OBLIcAt0xGOzeLe+yq84LbJz+2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178685; c=relaxed/simple;
	bh=ziq7F/55N07gd2zMnaBbeqL+O4zx9NcPJUKBQsh/PUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQ4MrK1pJbS9gqm6vb0uF4hLfIOLuRSWtOr+cEeFT95YCrZot3krwACrjBjGqvKVS8iaucoZs5W5TD/4qZDANb0VNoOoec+p6MbZR5527DBHQUFsdKRp2I2A15EJ8Lw14+TshULxXM9IQN/nthXdv/zztE6KguwnmLOncg24rZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCV9TYv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCV9TYv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE5BC4CEE7;
	Thu, 23 Oct 2025 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178685;
	bh=ziq7F/55N07gd2zMnaBbeqL+O4zx9NcPJUKBQsh/PUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sCV9TYv5MHqTcq8ti8L0li+2AYNYoLEETOkJTTBGFPLtpIAvFM0hTHYC9BKBdc0Wp
	 PS+9DMg9ayFEmokiPgWLKe0NccGiQoApwTs3vL4FtZOpA63Nwbk9TMgIuH4vsdzVSO
	 LCR5YCf3uaGy6fCCFHTtJbz76DS8+P2BZhswLRNFLa7fmKji/GhXAttuJr19926gOA
	 I5Ud1hn2XwItQrI9m+DOceD1CgIeTT/cgotJvi3dtGzQEr5ZJ0Mo4SoGqcXTLTZKK5
	 G+mskWAA9xcrcCD+YysgORbJv1BfauWCMjwxJnyUDHqOo8qa0JegqojcAFk+Cp3P/6
	 gfvuscd4qmbbQ==
Date: Wed, 22 Oct 2025 17:18:04 -0700
Subject: [PATCH 3/4] xfs: test io error reporting via healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176117749488.1030150.1756588751675966428.stgit@frogsfrogsfrogs>
In-Reply-To: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
References: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
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
index 00000000000000..235fa9d385ea2b
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
+grep -E '(directio|readahead|writeback)' $tmp.healthmon | sort | uniq
+
+_dmerror_cleanup
+
+status=0
+exit
diff --git a/tests/xfs/1878.out b/tests/xfs/1878.out
new file mode 100644
index 00000000000000..abfa872cd6234d
--- /dev/null
+++ b/tests/xfs/1878.out
@@ -0,0 +1,10 @@
+QA output created by 1878
+Format and mount
+pwrite: Input/output error
+pread: Input/output error
+pread: Input/output error
+fsync: Input/output error
+  "type":       "directio_read",
+  "type":       "directio_write",
+  "type":       "readahead",
+  "type":       "writeback",

