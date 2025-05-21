Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3456D186294;
	Wed, 21 May 2025 22:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867281; cv=none; b=EkejX29CVamUJveuZa9AerjgdoRj/qeuDuRWcbhTQmckJ60oFZaw1zKWQaauZNynGK5l5VKknY58alZ+WdIZLplI2I/g7jKadlLAP8iDnIfBRfBVvO90AhtFPSH9CIvOmEqA7rpZMDxrLsVsk9jugHJkLc0YRCGCrghmzaw06e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867281; c=relaxed/simple;
	bh=MqnB1fe1Bzy+s7+m8W4navbuB9tP5btaJuUJAQ9RySU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QY0ePK6XzH7YDUB0ACQgg18VfdTsSW5pOfQJAhnTqtypXbrapLr5IwHovXKxTfsRGxdBzy73Tp6d+Mp/d7jTT+dcbLPNDAzdO1q74W9ckutOtLuWBa5R2kGqrA44rew5NcPehCEzyoe89wLtkKn7C6gcw8IdbBq1aXvQ27+dPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0VI3r4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0VI3r4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAB7C4CEE4;
	Wed, 21 May 2025 22:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867281;
	bh=MqnB1fe1Bzy+s7+m8W4navbuB9tP5btaJuUJAQ9RySU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T0VI3r4XtQEmVflrKV9w9Hz9MRvQP+i4Pz8UE+xxyY6Ui+teJtRcxQuaBM+XBSdXK
	 PaNhUBEt9dBfG99g4g7eMNwIvlJI3lelYBV6VEGCPq0Uu+MLztGzT6k5+JBBdbG1WQ
	 uJ9LlkovYtbxFBTHku4RLA4Io5btZfvV3FDCkmIsK/t2KgJP/yZaS0mIQwWYpGn08o
	 aFgtEqYWTiFTDP3wv2QspEqGi5MBEsy4OAfA3XpGFwLqcm/XiEkLi36/ZRCOVHAki7
	 rOU78fNvjIMWEP8tFFgHP7bFLTxbQ4wFh8A+7cr24vAUT3ATNawxrXkUKbo1fs0krY
	 9tsNvwNW6CNzw==
Date: Wed, 21 May 2025 15:41:20 -0700
Subject: [PATCH 2/4] xfs/259: drop the 512-byte fsblock logic from this test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <174786719427.1398726.17422210804621368417.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

V5 filesystems do not support 512-byte fsblocks, and mkfs.xfs has long
defaulted to V5 filesystems.  Drop the 512 from the test loops, which
means we can get rid of all the _fs_has_crcs logic.  As a further
cleanup, use the truncate -s command to create the sparse file instead
of dd since even RHEL7 supports the -s switch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/259     |   24 ++++++++----------------
 tests/xfs/259.out |    7 -------
 2 files changed, 8 insertions(+), 23 deletions(-)


diff --git a/tests/xfs/259 b/tests/xfs/259
index c2d26381a91c02..e367d35acc3956 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -30,28 +30,20 @@ testfile=$TEST_DIR/259.image
 # Test various sizes slightly less than 4 TB. Need to handle different
 # minimum block sizes for CRC enabled filesystems, but use a small log so we
 # don't write lots of zeros unnecessarily.
-sizes_to_check="4096 2048 1024 512"
-blocksizes="4096 2048 1024 512"
+sizes_to_check="4096 2048 1024"
+blocksizes="4096 2048 1024"
 four_TB=$(_math "2^42")
-# The initial value of _fs_has_crcs is not important, because we start testing
-# with 4096 block size, it only matters for 512 block size test
-_fs_has_crcs=0
+
 for del in $sizes_to_check; do
 	for bs in $blocksizes; do
-		echo "Trying to make (4TB - ${del}B) long xfs, block size $bs"
-		# skip tests with 512 block size if the fs created has crc
-		# enabled by default
-		if [ $_fs_has_crcs -eq 1 -a $bs -eq 512 ]; then
-			break;
-		fi
+		echo "Trying to make (4TB - ${del}B) long xfs, block size $bs" | \
+			tee -a $seqres.full
 		ddseek=$(_math "$four_TB - $del")
 		rm -f "$testfile"
-		dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek \
-			>/dev/null 2>&1 || echo "dd failed"
+		truncate -s $ddseek "$testfile"
 		loop_dev=$(_create_loop_device $testfile)
-		$MKFS_XFS_PROG -l size=32m -b size=$bs $loop_dev |  _filter_mkfs \
-			>/dev/null 2> $tmp.mkfs || echo "mkfs failed!"
-		. $tmp.mkfs
+		$MKFS_XFS_PROG -l size=32m -b size=$bs $loop_dev >> $seqres.full || \
+			echo "mkfs failed!"
 		sync
 		_destroy_loop_device $loop_dev
 		unset loop_dev
diff --git a/tests/xfs/259.out b/tests/xfs/259.out
index 9fc4920c2b33b3..50af1a9b326147 100644
--- a/tests/xfs/259.out
+++ b/tests/xfs/259.out
@@ -2,16 +2,9 @@ QA output created by 259
 Trying to make (4TB - 4096B) long xfs, block size 4096
 Trying to make (4TB - 4096B) long xfs, block size 2048
 Trying to make (4TB - 4096B) long xfs, block size 1024
-Trying to make (4TB - 4096B) long xfs, block size 512
 Trying to make (4TB - 2048B) long xfs, block size 4096
 Trying to make (4TB - 2048B) long xfs, block size 2048
 Trying to make (4TB - 2048B) long xfs, block size 1024
-Trying to make (4TB - 2048B) long xfs, block size 512
 Trying to make (4TB - 1024B) long xfs, block size 4096
 Trying to make (4TB - 1024B) long xfs, block size 2048
 Trying to make (4TB - 1024B) long xfs, block size 1024
-Trying to make (4TB - 1024B) long xfs, block size 512
-Trying to make (4TB - 512B) long xfs, block size 4096
-Trying to make (4TB - 512B) long xfs, block size 2048
-Trying to make (4TB - 512B) long xfs, block size 1024
-Trying to make (4TB - 512B) long xfs, block size 512

