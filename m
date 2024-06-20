Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889EB2BAF3;
	Thu, 20 Jun 2024 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916844; cv=none; b=cdnEUUMNOPJCr9IZqfGUoy8l4uEfj5ZEBYuJPLo64Uaohm17NiCafhqwzx8uF+ybYdk2nT/+MqMTF3dVtXvOEdIiiRA7HbmBEWqKNINpJfjzYmcFrTD0j4cJkSP4+J2Pyj9hGsyhe2MBUJavQ6KJWx334EzSA7jaz2GGOu0jGsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916844; c=relaxed/simple;
	bh=tiIef5fvszd/NxnJ+pIvoBMWjvqr1UiNWyKZ9PQ0v4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L2jzQGCWBztpLRJTgrQSLv0+dzwR+8AHPbX6OHk2Xk8BFvWa+nuAolNGF41ua55kwlYvD0XBIBF56aFAJZh9qyAZFZWDqq3cN0O2b7CqYIkOQsutphFuCgluq7GLLGUP7A+Vy3xZsDxvb86bibbnCNSmwGW1G3IxXcP8pldGcnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJ73sLwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJ73sLwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE6BC2BD10;
	Thu, 20 Jun 2024 20:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916844;
	bh=tiIef5fvszd/NxnJ+pIvoBMWjvqr1UiNWyKZ9PQ0v4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mJ73sLwIdxqB5Sp2DYn1VnKcxFILHcrATP4Bj1e72OgI5MBzfuwyqLO9nsraKhWWJ
	 i7OVJbth8Y2RBCMyrcc5nSI/BLwPbzMrqcv3Ku/XsSIJ92oCt/1itQKHat2XDOE9Y8
	 Nrm3NjnuoqWEfu0GUyBewi4HVnFdARg3fnTv21rfpvdkoWuICtnHajAC2ZDW/8+Xzy
	 5+6iE55sfb2U4YlGCq36/whzlhprQkhR/KlsfGb/m5i2rLivjeEGp5QiK9wpd4Y/1A
	 8PNnhx64s5CD5nzBXPUTT4sSZpgiDu0nRzfCRm8wdZAgpi3vTOvD8vmJPfpiLKzxhj
	 riy0sV7Wm8Gzw==
Date: Thu, 20 Jun 2024 13:54:03 -0700
Subject: [PATCH 1/1] xfs: test scaling of the mkfs concurrency options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891668754.3034747.12230682178335162983.stgit@frogsfrogsfrogs>
In-Reply-To: <171891668738.3034747.8089506305966920065.stgit@frogsfrogsfrogs>
References: <171891668738.3034747.8089506305966920065.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/1842             |   55 ++++++++++++++
 tests/xfs/1842.cfg         |    4 +
 tests/xfs/1842.out.lba1024 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba2048 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba4096 |  177 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1842.out.lba512  |  177 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 767 insertions(+)
 create mode 100755 tests/xfs/1842
 create mode 100644 tests/xfs/1842.cfg
 create mode 100644 tests/xfs/1842.out.lba1024
 create mode 100644 tests/xfs/1842.out.lba2048
 create mode 100644 tests/xfs/1842.out.lba4096
 create mode 100644 tests/xfs/1842.out.lba512


diff --git a/tests/xfs/1842 b/tests/xfs/1842
new file mode 100755
index 0000000000..8180ca7a6e
--- /dev/null
+++ b/tests/xfs/1842
@@ -0,0 +1,55 @@
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
+test_dev_lbasize=$(blockdev --getss $TEST_DEV)
+seqfull=$0
+_link_out_file "lba${test_dev_lbasize}"
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
diff --git a/tests/xfs/1842.cfg b/tests/xfs/1842.cfg
new file mode 100644
index 0000000000..0678032432
--- /dev/null
+++ b/tests/xfs/1842.cfg
@@ -0,0 +1,4 @@
+lba512: lba512
+lba1024: lba1024
+lba2048: lba2048
+lba4096: lba4096
diff --git a/tests/xfs/1842.out.lba1024 b/tests/xfs/1842.out.lba1024
new file mode 100644
index 0000000000..758cdf51a8
--- /dev/null
+++ b/tests/xfs/1842.out.lba1024
@@ -0,0 +1,177 @@
+QA output created by 1842
+sz 16M cpus 2 agcount 1 logblocks 2766
+sz 16M cpus 4 agcount 1 logblocks 2766
+sz 16M cpus 8 agcount 1 logblocks 2766
+sz 16M cpus 16 agcount 1 logblocks 2766
+sz 16M cpus 32 agcount 1 logblocks 2766
+sz 16M cpus 40 agcount 1 logblocks 2766
+sz 16M cpus 64 agcount 1 logblocks 2766
+sz 16M cpus 96 agcount 1 logblocks 2766
+sz 16M cpus 160 agcount 1 logblocks 2766
+sz 16M cpus 512 agcount 1 logblocks 2766
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
+sz 1G cpus 16 agcount 4 logblocks 22698
+sz 1G cpus 32 agcount 4 logblocks 45396
+sz 1G cpus 40 agcount 4 logblocks 56745
+sz 1G cpus 64 agcount 4 logblocks 65524
+sz 1G cpus 96 agcount 4 logblocks 65524
+sz 1G cpus 160 agcount 4 logblocks 65524
+sz 1G cpus 512 agcount 4 logblocks 65524
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 25866
+sz 2G cpus 32 agcount 4 logblocks 51732
+sz 2G cpus 40 agcount 4 logblocks 64665
+sz 2G cpus 64 agcount 4 logblocks 103464
+sz 2G cpus 96 agcount 4 logblocks 131060
+sz 2G cpus 160 agcount 4 logblocks 131060
+sz 2G cpus 512 agcount 4 logblocks 131060
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 25866
+sz 16G cpus 32 agcount 4 logblocks 51732
+sz 16G cpus 40 agcount 4 logblocks 64665
+sz 16G cpus 64 agcount 4 logblocks 103464
+sz 16G cpus 96 agcount 4 logblocks 155196
+sz 16G cpus 160 agcount 4 logblocks 258660
+sz 16G cpus 512 agcount 4 logblocks 521728
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 25866
+sz 64G cpus 32 agcount 16 logblocks 51732
+sz 64G cpus 40 agcount 16 logblocks 64665
+sz 64G cpus 64 agcount 16 logblocks 103464
+sz 64G cpus 96 agcount 16 logblocks 155196
+sz 64G cpus 160 agcount 16 logblocks 258660
+sz 64G cpus 512 agcount 16 logblocks 521728
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 51732
+sz 256G cpus 40 agcount 40 logblocks 64665
+sz 256G cpus 64 agcount 64 logblocks 103464
+sz 256G cpus 96 agcount 64 logblocks 155196
+sz 256G cpus 160 agcount 64 logblocks 258660
+sz 256G cpus 512 agcount 64 logblocks 521728
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65535
+sz 512G cpus 64 agcount 64 logblocks 103464
+sz 512G cpus 96 agcount 96 logblocks 155196
+sz 512G cpus 160 agcount 128 logblocks 258660
+sz 512G cpus 512 agcount 128 logblocks 521728
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 155196
+sz 1T cpus 160 agcount 160 logblocks 258660
+sz 1T cpus 512 agcount 256 logblocks 521728
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
+sz 2T cpus 512 agcount 512 logblocks 521728
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
diff --git a/tests/xfs/1842.out.lba2048 b/tests/xfs/1842.out.lba2048
new file mode 100644
index 0000000000..5ec8e640c8
--- /dev/null
+++ b/tests/xfs/1842.out.lba2048
@@ -0,0 +1,177 @@
+QA output created by 1842
+sz 16M cpus 2 agcount 1 logblocks 2820
+sz 16M cpus 4 agcount 1 logblocks 2820
+sz 16M cpus 8 agcount 1 logblocks 2820
+sz 16M cpus 16 agcount 1 logblocks 2820
+sz 16M cpus 32 agcount 1 logblocks 2820
+sz 16M cpus 40 agcount 1 logblocks 2820
+sz 16M cpus 64 agcount 1 logblocks 2820
+sz 16M cpus 96 agcount 1 logblocks 2820
+sz 16M cpus 160 agcount 1 logblocks 2820
+sz 16M cpus 512 agcount 1 logblocks 2820
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
+sz 1G cpus 16 agcount 4 logblocks 23130
+sz 1G cpus 32 agcount 4 logblocks 46260
+sz 1G cpus 40 agcount 4 logblocks 57825
+sz 1G cpus 64 agcount 4 logblocks 65523
+sz 1G cpus 96 agcount 4 logblocks 65523
+sz 1G cpus 160 agcount 4 logblocks 65523
+sz 1G cpus 512 agcount 4 logblocks 65523
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 26298
+sz 2G cpus 32 agcount 4 logblocks 52596
+sz 2G cpus 40 agcount 4 logblocks 65745
+sz 2G cpus 64 agcount 4 logblocks 105192
+sz 2G cpus 96 agcount 4 logblocks 131059
+sz 2G cpus 160 agcount 4 logblocks 131059
+sz 2G cpus 512 agcount 4 logblocks 131059
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 26298
+sz 16G cpus 32 agcount 4 logblocks 52596
+sz 16G cpus 40 agcount 4 logblocks 65745
+sz 16G cpus 64 agcount 4 logblocks 105192
+sz 16G cpus 96 agcount 4 logblocks 157788
+sz 16G cpus 160 agcount 4 logblocks 262980
+sz 16G cpus 512 agcount 4 logblocks 521728
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 26298
+sz 64G cpus 32 agcount 16 logblocks 52596
+sz 64G cpus 40 agcount 16 logblocks 65745
+sz 64G cpus 64 agcount 16 logblocks 105192
+sz 64G cpus 96 agcount 16 logblocks 157788
+sz 64G cpus 160 agcount 16 logblocks 262980
+sz 64G cpus 512 agcount 16 logblocks 521728
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 52596
+sz 256G cpus 40 agcount 40 logblocks 65745
+sz 256G cpus 64 agcount 64 logblocks 105192
+sz 256G cpus 96 agcount 64 logblocks 157788
+sz 256G cpus 160 agcount 64 logblocks 262980
+sz 256G cpus 512 agcount 64 logblocks 521728
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 65745
+sz 512G cpus 64 agcount 64 logblocks 105192
+sz 512G cpus 96 agcount 96 logblocks 157788
+sz 512G cpus 160 agcount 128 logblocks 262980
+sz 512G cpus 512 agcount 128 logblocks 521728
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 157788
+sz 1T cpus 160 agcount 160 logblocks 262980
+sz 1T cpus 512 agcount 256 logblocks 521728
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 262980
+sz 2T cpus 512 agcount 512 logblocks 521728
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
diff --git a/tests/xfs/1842.out.lba4096 b/tests/xfs/1842.out.lba4096
new file mode 100644
index 0000000000..6f5376f508
--- /dev/null
+++ b/tests/xfs/1842.out.lba4096
@@ -0,0 +1,177 @@
+QA output created by 1842
+sz 16M cpus 2 agcount 1 logblocks 2928
+sz 16M cpus 4 agcount 1 logblocks 2928
+sz 16M cpus 8 agcount 1 logblocks 2928
+sz 16M cpus 16 agcount 1 logblocks 2928
+sz 16M cpus 32 agcount 1 logblocks 2928
+sz 16M cpus 40 agcount 1 logblocks 2928
+sz 16M cpus 64 agcount 1 logblocks 2928
+sz 16M cpus 96 agcount 1 logblocks 2928
+sz 16M cpus 160 agcount 1 logblocks 2928
+sz 16M cpus 512 agcount 1 logblocks 2928
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
+sz 1G cpus 16 agcount 4 logblocks 23994
+sz 1G cpus 32 agcount 4 logblocks 47988
+sz 1G cpus 40 agcount 4 logblocks 59985
+sz 1G cpus 64 agcount 4 logblocks 65521
+sz 1G cpus 96 agcount 4 logblocks 65521
+sz 1G cpus 160 agcount 4 logblocks 65521
+sz 1G cpus 512 agcount 4 logblocks 65521
+-----------------
+sz 2G cpus 2 agcount 4 logblocks 16384
+sz 2G cpus 4 agcount 4 logblocks 16384
+sz 2G cpus 8 agcount 4 logblocks 16384
+sz 2G cpus 16 agcount 4 logblocks 27162
+sz 2G cpus 32 agcount 4 logblocks 54324
+sz 2G cpus 40 agcount 4 logblocks 67905
+sz 2G cpus 64 agcount 4 logblocks 108648
+sz 2G cpus 96 agcount 4 logblocks 131057
+sz 2G cpus 160 agcount 4 logblocks 131057
+sz 2G cpus 512 agcount 4 logblocks 131057
+-----------------
+sz 16G cpus 2 agcount 4 logblocks 16384
+sz 16G cpus 4 agcount 4 logblocks 16384
+sz 16G cpus 8 agcount 4 logblocks 16384
+sz 16G cpus 16 agcount 4 logblocks 27162
+sz 16G cpus 32 agcount 4 logblocks 54324
+sz 16G cpus 40 agcount 4 logblocks 67905
+sz 16G cpus 64 agcount 4 logblocks 108648
+sz 16G cpus 96 agcount 4 logblocks 162972
+sz 16G cpus 160 agcount 4 logblocks 271620
+sz 16G cpus 512 agcount 4 logblocks 521728
+-----------------
+sz 64G cpus 2 agcount 4 logblocks 16384
+sz 64G cpus 4 agcount 4 logblocks 16384
+sz 64G cpus 8 agcount 8 logblocks 16384
+sz 64G cpus 16 agcount 16 logblocks 27162
+sz 64G cpus 32 agcount 16 logblocks 54324
+sz 64G cpus 40 agcount 16 logblocks 67905
+sz 64G cpus 64 agcount 16 logblocks 108648
+sz 64G cpus 96 agcount 16 logblocks 162972
+sz 64G cpus 160 agcount 16 logblocks 271620
+sz 64G cpus 512 agcount 16 logblocks 521728
+-----------------
+sz 256G cpus 2 agcount 4 logblocks 32768
+sz 256G cpus 4 agcount 4 logblocks 32768
+sz 256G cpus 8 agcount 8 logblocks 32768
+sz 256G cpus 16 agcount 16 logblocks 32768
+sz 256G cpus 32 agcount 32 logblocks 54324
+sz 256G cpus 40 agcount 40 logblocks 67905
+sz 256G cpus 64 agcount 64 logblocks 108648
+sz 256G cpus 96 agcount 64 logblocks 162972
+sz 256G cpus 160 agcount 64 logblocks 271620
+sz 256G cpus 512 agcount 64 logblocks 521728
+-----------------
+sz 512G cpus 2 agcount 4 logblocks 65536
+sz 512G cpus 4 agcount 4 logblocks 65536
+sz 512G cpus 8 agcount 8 logblocks 65536
+sz 512G cpus 16 agcount 16 logblocks 65536
+sz 512G cpus 32 agcount 32 logblocks 65536
+sz 512G cpus 40 agcount 40 logblocks 67905
+sz 512G cpus 64 agcount 64 logblocks 108648
+sz 512G cpus 96 agcount 96 logblocks 162972
+sz 512G cpus 160 agcount 128 logblocks 271620
+sz 512G cpus 512 agcount 128 logblocks 521728
+-----------------
+sz 1T cpus 2 agcount 4 logblocks 131072
+sz 1T cpus 4 agcount 4 logblocks 131072
+sz 1T cpus 8 agcount 8 logblocks 131072
+sz 1T cpus 16 agcount 16 logblocks 131072
+sz 1T cpus 32 agcount 32 logblocks 131072
+sz 1T cpus 40 agcount 40 logblocks 131071
+sz 1T cpus 64 agcount 64 logblocks 131072
+sz 1T cpus 96 agcount 96 logblocks 162972
+sz 1T cpus 160 agcount 160 logblocks 271620
+sz 1T cpus 512 agcount 256 logblocks 521728
+-----------------
+sz 2T cpus 2 agcount 4 logblocks 262144
+sz 2T cpus 4 agcount 4 logblocks 262144
+sz 2T cpus 8 agcount 8 logblocks 262144
+sz 2T cpus 16 agcount 16 logblocks 262144
+sz 2T cpus 32 agcount 32 logblocks 262144
+sz 2T cpus 40 agcount 40 logblocks 262143
+sz 2T cpus 64 agcount 64 logblocks 262144
+sz 2T cpus 96 agcount 96 logblocks 262143
+sz 2T cpus 160 agcount 160 logblocks 271620
+sz 2T cpus 512 agcount 512 logblocks 521728
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
diff --git a/tests/xfs/1842.out.lba512 b/tests/xfs/1842.out.lba512
new file mode 100644
index 0000000000..e28742e8ae
--- /dev/null
+++ b/tests/xfs/1842.out.lba512
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
+sz 16G cpus 512 agcount 4 logblocks 521728
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
+sz 64G cpus 512 agcount 16 logblocks 521728
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
+sz 256G cpus 512 agcount 64 logblocks 521728
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
+sz 512G cpus 512 agcount 128 logblocks 521728
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
+sz 1T cpus 512 agcount 256 logblocks 521728
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
+sz 2T cpus 512 agcount 512 logblocks 521728
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

