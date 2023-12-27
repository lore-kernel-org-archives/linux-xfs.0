Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086AB9464;
	Mon,  1 Jan 2024 00:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQIyVGMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F799C433C8;
	Mon,  1 Jan 2024 00:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069818;
	bh=4no1kR5Uv3KasvAmfQXSTNVM6RSsc/tOjJE08i9cm5Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQIyVGMHSHRQkXJY8GXAGt/yBMCZElZMO4xQeL8pYKoy8h4drUW8h46asPUkrlLH3
	 FP324UMgC5Al52WmU0odu7y8qfP7CUc4G48ILdMDZf0CZW1a8MIR4Q1StiE1/Es4Bt
	 pp8l/442kebfGUEKUfeevfDnoh+IckwfCI8L1eHNROskN7IXA+reFFIq2M6XXk/9yF
	 sCxuvKoI9VSrFidEa6Uq0OdjiQtaq4l3++30FlWd8pes+YJi/lN3hJZx1iowpGhfrv
	 TfoSM/HR+RGYtEFFWbEjYwqLUD/EvoTkTZduPLt/634jUNgji+fvIkCbAiI8Vqskhq
	 R9hbfFpBGhaug==
Date: Sun, 31 Dec 2023 16:43:37 +9900
Subject: [PATCH 1/1] xfs: test scaling of the mkfs concurrency options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405025944.1823561.5698073164938069178.stgit@frogsfrogsfrogs>
In-Reply-To: <170405025931.1823561.11251524119820744796.stgit@frogsfrogsfrogs>
References: <170405025931.1823561.11251524119820744796.stgit@frogsfrogsfrogs>
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

Make sure that the AG count and log size scale up with the new
concurrency options to mkfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1842     |   51 +++++++++++++++
 tests/xfs/1842.out |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+)
 create mode 100755 tests/xfs/1842
 create mode 100644 tests/xfs/1842.out


diff --git a/tests/xfs/1842 b/tests/xfs/1842
new file mode 100755
index 0000000000..41254a1581
--- /dev/null
+++ b/tests/xfs/1842
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1842
+#
+# mkfs concurrency test - ensure the log and agsize scaling works for various
+# concurrency= parameters
+#
+. ./common/preamble
+_begin_fstest log metadata auto quick
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $loop_file
+}
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_test
+_require_loop
+$MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
+	_notrun "mkfs does not support concurrency options"
+
+loop_file=$TEST_DIR/$seq.loop
+
+rm -f "$loop_file"
+for sz in 16M 512M 1G 2G 16G 64G 256G 512G 1T 2T 4T 16T 64T 256T 512T 1P; do
+	for cpus in 2 4 8 16 32 40 64 96 160 512; do
+		truncate -s "$sz" "$loop_file"
+		echo "sz $sz cpus $cpus" >> $seqres.full
+		echo "-----------------" >> $seqres.full
+
+		$MKFS_XFS_PROG -f -N "$loop_file" -d concurrency=$cpus -l concurrency=$cpus &> $tmp.mkfsout
+		cat $tmp.mkfsout >> $seqres.full
+
+		_filter_mkfs > /dev/null 2> $tmp.mkfs < $tmp.mkfsout
+		. $tmp.mkfs
+		echo "sz $sz cpus $cpus agcount $agcount logblocks $lblocks"
+	done
+	echo "-----------------"
+done
+
+status=0
+exit
diff --git a/tests/xfs/1842.out b/tests/xfs/1842.out
new file mode 100644
index 0000000000..9d1e22120b
--- /dev/null
+++ b/tests/xfs/1842.out
@@ -0,0 +1,177 @@
+QA output created by 1842
+sz 16M cpus 2 agcount 1 logblocks 3075
+sz 16M cpus 4 agcount 1 logblocks 3075
+sz 16M cpus 8 agcount 1 logblocks 3075
+sz 16M cpus 16 agcount 1 logblocks 3075
+sz 16M cpus 32 agcount 1 logblocks 3075
+sz 16M cpus 40 agcount 1 logblocks 3075
+sz 16M cpus 64 agcount 1 logblocks 3075
+sz 16M cpus 96 agcount 1 logblocks 3075
+sz 16M cpus 160 agcount 1 logblocks 3075
+sz 16M cpus 512 agcount 1 logblocks 3075
+-----------------
+sz 512M cpus 2 agcount 4 logblocks 16384
+sz 512M cpus 4 agcount 4 logblocks 16384
+sz 512M cpus 8 agcount 4 logblocks 16384
+sz 512M cpus 16 agcount 4 logblocks 16384
+sz 512M cpus 32 agcount 4 logblocks 16384
+sz 512M cpus 40 agcount 4 logblocks 16384
+sz 512M cpus 64 agcount 4 logblocks 16384
+sz 512M cpus 96 agcount 4 logblocks 16384
+sz 512M cpus 160 agcount 4 logblocks 16384
+sz 512M cpus 512 agcount 4 logblocks 16384
+-----------------
+sz 1G cpus 2 agcount 4 logblocks 16384
+sz 1G cpus 4 agcount 4 logblocks 16384
+sz 1G cpus 8 agcount 4 logblocks 16384
+sz 1G cpus 16 agcount 4 logblocks 22482
+sz 1G cpus 32 agcount 4 logblocks 44964
+sz 1G cpus 40 agcount 4 logblocks 56205
+sz 1G cpus 64 agcount 4 logblocks 65524
+sz 1G cpus 96 agcount 4 logblocks 65524
+sz 1G cpus 160 agcount 4 logblocks 65524
+sz 1G cpus 512 agcount 4 logblocks 65524
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 25650
+sz 2G cpus 32 agcount 4 logblocks 51300
+sz 2G cpus 40 agcount 4 logblocks 64125
+sz 2G cpus 64 agcount 4 logblocks 102600
+sz 2G cpus 96 agcount 4 logblocks 131060
+sz 2G cpus 160 agcount 4 logblocks 131060
+sz 2G cpus 512 agcount 4 logblocks 131060
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 25650
+sz 16G cpus 32 agcount 4 logblocks 51300
+sz 16G cpus 40 agcount 4 logblocks 64125
+sz 16G cpus 64 agcount 4 logblocks 102600
+sz 16G cpus 96 agcount 4 logblocks 153900
+sz 16G cpus 160 agcount 4 logblocks 256500
+sz 16G cpus 512 agcount 4 logblocks 296512
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 25650
+sz 64G cpus 32 agcount 16 logblocks 51300
+sz 64G cpus 40 agcount 16 logblocks 64125
+sz 64G cpus 64 agcount 16 logblocks 102600
+sz 64G cpus 96 agcount 16 logblocks 153900
+sz 64G cpus 160 agcount 16 logblocks 256500
+sz 64G cpus 512 agcount 16 logblocks 296512
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 51300
+sz 256G cpus 40 agcount 40 logblocks 64125
+sz 256G cpus 64 agcount 64 logblocks 102600
+sz 256G cpus 96 agcount 64 logblocks 153900
+sz 256G cpus 160 agcount 64 logblocks 256500
+sz 256G cpus 512 agcount 64 logblocks 296512
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 102600
+sz 512G cpus 96 agcount 96 logblocks 153900
+sz 512G cpus 160 agcount 128 logblocks 256500
+sz 512G cpus 512 agcount 128 logblocks 296512
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 153900
+sz 1T cpus 160 agcount 160 logblocks 256500
+sz 1T cpus 512 agcount 256 logblocks 296512
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262143
+sz 2T cpus 512 agcount 512 logblocks 296512
+-----------------
+sz 4T cpus 2 agcount 4 logblocks 521728
+sz 4T cpus 4 agcount 4 logblocks 521728
+sz 4T cpus 8 agcount 8 logblocks 521728
+sz 4T cpus 16 agcount 16 logblocks 521728
+sz 4T cpus 32 agcount 32 logblocks 521728
+sz 4T cpus 40 agcount 40 logblocks 521728
+sz 4T cpus 64 agcount 64 logblocks 521728
+sz 4T cpus 96 agcount 96 logblocks 521728
+sz 4T cpus 160 agcount 160 logblocks 521728
+sz 4T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 16T cpus 2 agcount 16 logblocks 521728
+sz 16T cpus 4 agcount 16 logblocks 521728
+sz 16T cpus 8 agcount 16 logblocks 521728
+sz 16T cpus 16 agcount 16 logblocks 521728
+sz 16T cpus 32 agcount 32 logblocks 521728
+sz 16T cpus 40 agcount 40 logblocks 521728
+sz 16T cpus 64 agcount 64 logblocks 521728
+sz 16T cpus 96 agcount 96 logblocks 521728
+sz 16T cpus 160 agcount 160 logblocks 521728
+sz 16T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 64T cpus 2 agcount 64 logblocks 521728
+sz 64T cpus 4 agcount 64 logblocks 521728
+sz 64T cpus 8 agcount 64 logblocks 521728
+sz 64T cpus 16 agcount 64 logblocks 521728
+sz 64T cpus 32 agcount 64 logblocks 521728
+sz 64T cpus 40 agcount 64 logblocks 521728
+sz 64T cpus 64 agcount 64 logblocks 521728
+sz 64T cpus 96 agcount 96 logblocks 521728
+sz 64T cpus 160 agcount 160 logblocks 521728
+sz 64T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 256T cpus 2 agcount 256 logblocks 521728
+sz 256T cpus 4 agcount 256 logblocks 521728
+sz 256T cpus 8 agcount 256 logblocks 521728
+sz 256T cpus 16 agcount 256 logblocks 521728
+sz 256T cpus 32 agcount 256 logblocks 521728
+sz 256T cpus 40 agcount 256 logblocks 521728
+sz 256T cpus 64 agcount 256 logblocks 521728
+sz 256T cpus 96 agcount 256 logblocks 521728
+sz 256T cpus 160 agcount 256 logblocks 521728
+sz 256T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 512T cpus 2 agcount 512 logblocks 521728
+sz 512T cpus 4 agcount 512 logblocks 521728
+sz 512T cpus 8 agcount 512 logblocks 521728
+sz 512T cpus 16 agcount 512 logblocks 521728
+sz 512T cpus 32 agcount 512 logblocks 521728
+sz 512T cpus 40 agcount 512 logblocks 521728
+sz 512T cpus 64 agcount 512 logblocks 521728
+sz 512T cpus 96 agcount 512 logblocks 521728
+sz 512T cpus 160 agcount 512 logblocks 521728
+sz 512T cpus 512 agcount 512 logblocks 521728
+-----------------
+sz 1P cpus 2 agcount 1024 logblocks 521728
+sz 1P cpus 4 agcount 1024 logblocks 521728
+sz 1P cpus 8 agcount 1024 logblocks 521728
+sz 1P cpus 16 agcount 1024 logblocks 521728
+sz 1P cpus 32 agcount 1024 logblocks 521728
+sz 1P cpus 40 agcount 1024 logblocks 521728
+sz 1P cpus 64 agcount 1024 logblocks 521728
+sz 1P cpus 96 agcount 1024 logblocks 521728
+sz 1P cpus 160 agcount 1024 logblocks 521728
+sz 1P cpus 512 agcount 1024 logblocks 521728
+-----------------

