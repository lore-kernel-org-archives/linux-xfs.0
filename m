Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50B31754B;
	Wed, 21 May 2025 22:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867296; cv=none; b=XND8NCcD02yHubypskIgH9gynr5MJP2utxqoz01kimuL5Cv7F2Oafcee6cEPYlpcVpFRBjDll/pp8hwT56eW8s7G/WyRwbXc8znM2v0EW6g1fNy+zX//JDOilruaywkqjRfc7gnbX6WaewLuH9dwMfzuxd+wAXOSh9QUPk+eqoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867296; c=relaxed/simple;
	bh=BjnPx7nsIYwT3MDktnRGwYVIHFz3Vdp9C40D3beQACQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1o1aAo8/tig7RKIyUY5228LHisCYKh9CD4tXYb7uvkB2bmUFHfTpnZ0Efq+Fb+fI8kpOCXRDJJ413FqOxrMbEPKm4VCjtj4GL4pbFf+cXp2WMpxUu2g2Awr1dPCrykDbal35XZD9/G8l6UQ3e/vZxdp/ird84SrJrxQ36hQvjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z24tX2PO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z24tX2PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB288C4CEE4;
	Wed, 21 May 2025 22:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867296;
	bh=BjnPx7nsIYwT3MDktnRGwYVIHFz3Vdp9C40D3beQACQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z24tX2PONSJsL49g0HiNzMhnjgzS8w+zRqJ+k2x5l5PwY7pONPz8Vh41clD9rd+Tb
	 FUP6a5j+uRMJC2Q/+7ebjW07juTvwanpMitAHLZpS+4gRJEL9a6swkepvEKwogWsMB
	 BM9ued9HzBy+x5xIYRK/5X0+74K5536JnMfRb9vmauhzNfsoMleBk/Y8mEZl5abPaX
	 N21KCiyHIqsqhNb2jDbTPimnm1Zht/sqjLHHRY6kYegUHORlbFoVFU490NH5WZJ8c+
	 ZLtjIH8u4KkUDBwSC7gO6P/PQlGs1k76PReIntTh5MdRyI+dVkveaQUT+Ax1QeuPub
	 UEYm9xp1SpT8A==
Date: Wed, 21 May 2025 15:41:36 -0700
Subject: [PATCH 3/4] xfs/259: try to force loop device block size
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
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

Starting with 6.15-rc1, loop devices created with directio mode enabled
will set their logical block size to whatever STATX_DIO_ALIGN on the
host filesystem reports.  If you happen to be running a kernel that
always sets up loop devices in directio mode and TEST_DEV is a block
device with 4k sectors, this will cause conflicts with this test's usage
of mkfs with different block sizes.  Add a helper to force the loop
device block size to 512 bytes, which is implied by scenarios such as
"device size is 4T - 2048 bytes".

Also fix xfs/078 which simply needs the blocksize to be set.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |   22 ++++++++++++++++++++++
 tests/generic/563 |    1 +
 tests/xfs/078     |    2 ++
 tests/xfs/259     |    1 +
 tests/xfs/613     |    1 +
 5 files changed, 27 insertions(+)


diff --git a/common/rc b/common/rc
index 657772e73db86b..4e3917a298e072 100644
--- a/common/rc
+++ b/common/rc
@@ -4526,6 +4526,28 @@ _create_loop_device()
 	echo $dev
 }
 
+# Configure the loop device however needed to support the given block size.
+_force_loop_device_blocksize()
+{
+	local loopdev="$1"
+	local blksize="$2"
+	local is_dio
+	local logsec
+
+	if [ ! -b "$loopdev" ] || [ -z "$blksize" ]; then
+		echo "_force_loop_device_blocksize requires loopdev and blksize" >&2
+		return 1
+	fi
+
+	curr_blksize="$(losetup --list --output LOG-SEC --noheadings --raw "$loopdev")"
+	if [ "$curr_blksize" -gt "$blksize" ]; then
+		losetup --direct-io=off "$loopdev"
+		losetup --sector-size "$blksize" "$loopdev"
+	fi
+
+	#losetup --raw --list "$loopdev" >> $seqres.full
+}
+
 _destroy_loop_device()
 {
 	local dev=$1
diff --git a/tests/generic/563 b/tests/generic/563
index 89a71aa44938ea..6fd153d8b04ca8 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -92,6 +92,7 @@ reset()
 # cgroup I/O accounting doesn't work on partitions. Use a loop device to rule
 # that out.
 loop_dev=$(_create_loop_device $SCRATCH_DEV)
+_force_loop_device_blocksize $loop_dev $SCRATCH_DEV
 smajor=$((0x`stat -L -c %t $loop_dev`))
 sminor=$((0x`stat -L -c %T $loop_dev`))
 
diff --git a/tests/xfs/078 b/tests/xfs/078
index 0d3c2eb23e51ce..43a384dbdf7797 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -56,6 +56,7 @@ _grow_loop()
 
 	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
 	loop_dev=`_create_loop_device $LOOP_IMG`
+	_force_loop_device_blocksize $loop_dev $bsize
 
 	dparam=""
 	if [ -n "$agsize" ]; then
@@ -74,6 +75,7 @@ _grow_loop()
 	_destroy_loop_device $loop_dev
 	$XFS_IO_PROG -c "pwrite $new_size $bsize" $LOOP_IMG | _filter_io
 	loop_dev=`_create_loop_device $LOOP_IMG`
+	_force_loop_device_blocksize $loop_dev $bsize
 	echo "*** mount loop filesystem"
 	_mount $loop_dev $LOOP_MNT
 
diff --git a/tests/xfs/259 b/tests/xfs/259
index e367d35acc3956..8e93b464b90360 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -42,6 +42,7 @@ for del in $sizes_to_check; do
 		rm -f "$testfile"
 		truncate -s $ddseek "$testfile"
 		loop_dev=$(_create_loop_device $testfile)
+		_force_loop_device_blocksize $loop_dev 512
 		$MKFS_XFS_PROG -l size=32m -b size=$bs $loop_dev >> $seqres.full || \
 			echo "mkfs failed!"
 		sync
diff --git a/tests/xfs/613 b/tests/xfs/613
index c034ef60d28bad..f4d16c62570274 100755
--- a/tests/xfs/613
+++ b/tests/xfs/613
@@ -169,6 +169,7 @@ do_test "-o attr2" pass "attr2" "true"
 do_test "-o noattr2" pass "attr2" "false"
 
 # Test logbsize=value.
+_force_loop_device_blocksize $loop_dev 512	 # needed for v1 log
 do_mkfs -m crc=0 -l version=1
 # New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
 # prints "logbsize=N" in /proc/mounts, but old kernel not. So the default

