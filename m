Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A22BD593;
	Tue, 29 Jul 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819820; cv=none; b=G6/WGMR3HGGSU2FF807iXA0uPABn4otZUNN3PRo9cMi6lOUKhbZoLP/bh3E70nBP9c6EbVECC8EYCKsxOgCKkkgYbTGASpCxPcKmiGO0smPCWZ9pnc8Bu7IZJdFKRFgsjolXQWn6j9NrE0TMwDAfmSc8lvsI+hr4L8MA2dnGJlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819820; c=relaxed/simple;
	bh=2/9ulrkcVnYT5U+TLS26QCRKW5UG+/oU4xFpqVAfIJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JlsbUI0vCUKMQtjGxO4fDdiZweKeUa+FPJJpAY4f6Z3TIF5k/BUaOvK1wqpVPRfuAFEt8kd4BEdQs5B3MifgDg/vJVFuF5HtbSaeVQXjGkyrZnKAVggbQWyCPIvpH+cTnsZHBxLNf9hI4ZtVez+wuyLS7JMrkwhq5QTvKJCjOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSnNsPRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSnNsPRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ECBC4CEEF;
	Tue, 29 Jul 2025 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819820;
	bh=2/9ulrkcVnYT5U+TLS26QCRKW5UG+/oU4xFpqVAfIJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kSnNsPRQb/rFTb2yFD4m5bxEfEm8tLRZS1Ibca0VogAVFezZREhQphS8WFl5tpOvB
	 i3TAPbLfxM+Ua3FDRAtWjpUqX3ggop4nTHfi19b615wBDku7JUSIS6M79zYBJB4Wtv
	 tdh6V6v1FJy/1zQ2RrA6+JKUYVAWEkx5BACtzmozkHKezF17nag9i/b7Ka+wS1EbPW
	 YZAJuiLr9d94VFmQKRFHvasMovco7btc4r1pIxhuVSgQOlxJIYNm0NkxeuPyiZool5
	 noj/XQ/E3jIdl1NFoR+2n6kOWwisEBXccV73aALlmJ/Qk8KybS3MS8XHZcQn/OuDtT
	 9GeqSdfXRaeCA==
Date: Tue, 29 Jul 2025 13:10:19 -0700
Subject: [PATCH 1/2] xfs/259: try to force loop device block size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958216.3021057.6861906785798079394.stgit@frogsfrogsfrogs>
In-Reply-To: <175381958191.3021057.13973475638062852804.stgit@frogsfrogsfrogs>
References: <175381958191.3021057.13973475638062852804.stgit@frogsfrogsfrogs>
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
host filesystem reports.  If you want fstests to set up loop devices in
directio mode and TEST_DEV is a block device with 4k sectors, this will
cause conflicts with this test's usage of mkfs with different block
sizes.  Enhance the existing _create_loop_device so that tests can force
the loop device block size to 512 bytes, which is implied by scenarios
such as "device size is 4T - 2048 bytes".

Also fix xfs/078 which simply needs the blocksize to be set.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc     |   20 +++++++++++++++++---
 tests/xfs/078 |    4 ++--
 tests/xfs/259 |    2 +-
 tests/xfs/613 |    3 ++-
 4 files changed, 22 insertions(+), 7 deletions(-)


diff --git a/common/rc b/common/rc
index 177e7748f4bb89..b3f63111c6ea6c 100644
--- a/common/rc
+++ b/common/rc
@@ -4579,17 +4579,31 @@ _require_userns()
 	$here/src/nsexec -U true 2>/dev/null || _notrun "userns not supported by this kernel"
 }
 
+# Create a loop device from a given file and configure it to support IOs
+# aligned to the specified block size, if provided.
 _create_loop_device()
 {
-	local file=$1 dev
-	dev=`losetup -f --show $file` || _fail "Cannot assign $file to a loop device"
+	local file="$1"
+	local blksize="$2"
+	local dev
+	local dio_args="--direct-io=on"
+	local args
+
+	test -n "$blksize" && args="--sector-size=$blksize"
 
 	# Try to enable asynchronous directio mode on the loopback device so
 	# that writeback started by a filesystem mounted on the loop device
 	# won't be throttled by buffered writes to the lower filesystem.  This
 	# is a performance optimization for tests that want to write a lot of
 	# data, so it isn't required to work.
-	test -b "$dev" && losetup --direct-io=on $dev 2> /dev/null
+	#
+	# Starting with 6.15-rc1 the kernel will set the loop device's sector
+	# size to the directio alignment of the underlying fs, so if we want to
+	# use our own sector size, we need to specify that at creation time.
+	if ! dev="$(losetup $dio_args $args -f --show $file 2>/dev/null)"; then
+		dev="$(losetup $args -f --show $file)" || \
+			_fail "Cannot assign $file to a loop device ($args)"
+	fi
 
 	echo $dev
 }
diff --git a/tests/xfs/078 b/tests/xfs/078
index 0d3c2eb23e51ce..6057aeea12abe9 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -55,7 +55,7 @@ _grow_loop()
 	agsize=$5
 
 	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
-	loop_dev=`_create_loop_device $LOOP_IMG`
+	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
 
 	dparam=""
 	if [ -n "$agsize" ]; then
@@ -73,7 +73,7 @@ _grow_loop()
 	echo "*** extend loop file"
 	_destroy_loop_device $loop_dev
 	$XFS_IO_PROG -c "pwrite $new_size $bsize" $LOOP_IMG | _filter_io
-	loop_dev=`_create_loop_device $LOOP_IMG`
+	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
 	echo "*** mount loop filesystem"
 	_mount $loop_dev $LOOP_MNT
 
diff --git a/tests/xfs/259 b/tests/xfs/259
index e367d35acc3956..b333ac02964b25 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -41,7 +41,7 @@ for del in $sizes_to_check; do
 		ddseek=$(_math "$four_TB - $del")
 		rm -f "$testfile"
 		truncate -s $ddseek "$testfile"
-		loop_dev=$(_create_loop_device $testfile)
+		loop_dev=$(_create_loop_device $testfile 512)
 		$MKFS_XFS_PROG -l size=32m -b size=$bs $loop_dev >> $seqres.full || \
 			echo "mkfs failed!"
 		sync
diff --git a/tests/xfs/613 b/tests/xfs/613
index c034ef60d28bad..9b27a7c1f2c23f 100755
--- a/tests/xfs/613
+++ b/tests/xfs/613
@@ -36,7 +36,8 @@ LOOP_MNT=$TEST_DIR/$seq.mnt
 
 echo "** create loop device"
 $XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
-loop_dev=`_create_loop_device $LOOP_IMG`
+# 512b sector size needed for v1 log
+loop_dev=`_create_loop_device $LOOP_IMG 512`
 
 echo "** create loop mount point"
 rmdir $LOOP_MNT 2>/dev/null

