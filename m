Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB132BDC1D;
	Tue, 29 Jul 2025 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819837; cv=none; b=gq+zYtWCgzelbWz+2Y1at/74JYgXOmrUtUbrrTtlKcXBcU43wX5cHFtVt0lYZm1UwwSmnWx7T9lrGLTTr6zU82UtQ1EZkjEZHZckw40RgwbhCVFbPpsOx+QfthSHOFnVd/JxK9jA6vBtvGqx/KmBj9YHyHg03ro9OOC4aRREFQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819837; c=relaxed/simple;
	bh=mkM/4oTPkGuVFiCg1THma3BEAP4D/4KFHify4SIUGfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTsCare/+xMyhU+YNuiYu2+cK3JMEY348zdLU3usn0794f+VyKlRZYCeWiIvg7y5Y14CMHnwYV6ECATLrGgtvRQ4Q+7SrCiR+tspi5feVU6PNhcB0IqscF6DVrRCt7/lhfNLDp4Cf7HBm7P0iCZYVegHrD/e4hs+GUuWoKTzwvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMpDfChE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMpDfChE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF3C4CEF7;
	Tue, 29 Jul 2025 20:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819835;
	bh=mkM/4oTPkGuVFiCg1THma3BEAP4D/4KFHify4SIUGfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BMpDfChElH4pQUNRYRRpIBZITVZhTvp3kKQcsGWC3ZwPK/TahjBv+lPPXV8os4VP/
	 ceuw6ePGFWQhyhAScvrc43qq4qZDDZ32Ag6mhvW+x1TwnJrQ1nXj66RK4re358g0qV
	 aasHYBgg39GLL7Zzx0x/PGHsiSlbBolaaPoGJYwqG58sBR47wD1d5bGN8Eust4JlDB
	 AcqFQmCOHFSa2YrGwikBMkj2QNmenwMWIA7RDOKUsYBElHOxpMhjaaisTNbLDsj8tE
	 5v3eyO2VF6SeyR6Ixo3MQCqoMMDwKguxG319VC+nLgVc9u1VuuY8wEUEpY1mP318lM
	 vV3R2/UN8d1kg==
Date: Tue, 29 Jul 2025 13:10:35 -0700
Subject: [PATCH 2/2] xfs/432: fix metadump loop device blocksize problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958234.3021057.8571406990911180650.stgit@frogsfrogsfrogs>
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

Make sure the lba size of the loop devices created for the metadump
tests actually match that of the real SCRATCH_ devices or else the tests
will fail.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/metadump   |   12 ++++++++----
 common/rc         |   17 +++++++++++++++++
 tests/generic/563 |    2 +-
 3 files changed, 26 insertions(+), 5 deletions(-)


diff --git a/common/metadump b/common/metadump
index 61ba3cbb91647c..d411bc0d32d792 100644
--- a/common/metadump
+++ b/common/metadump
@@ -75,7 +75,7 @@ _xfs_verify_metadump_v1()
 	SCRATCH_DEV=$data_img _scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
-	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
+	METADUMP_DATA_LOOP_DEV=$(_create_loop_device_like_bdev $data_img $SCRATCH_DEV)
 
 	# Mount fs, run an extra test, fsck, and unmount
 	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV _scratch_mount
@@ -122,13 +122,17 @@ _xfs_verify_metadump_v2()
 		_scratch_xfs_mdrestore $metadump_file
 
 	# Create loopdev for data device so we can mount the fs
-	METADUMP_DATA_LOOP_DEV=$(_create_loop_device $data_img)
+	METADUMP_DATA_LOOP_DEV=$(_create_loop_device_like_bdev $data_img $SCRATCH_DEV)
 
 	# Create loopdev for log device if we recovered anything
-	test -s "$log_img" && METADUMP_LOG_LOOP_DEV=$(_create_loop_device $log_img)
+	if [ -s "$log_img" ]; then
+		METADUMP_LOG_LOOP_DEV=$(_create_loop_device_like_bdev $log_img $SCRATCH_LOGDEV)
+	fi
 
 	# Create loopdev for rt device if we recovered anything
-	test -s "$rt_img" && METADUMP_RT_LOOP_DEV=$(_create_loop_device $rt_img)
+	if [ -s "$rt_img" ]; then
+		METADUMP_RT_LOOP_DEV=$(_create_loop_device_like_bdev $rt_img $SCRATCH_RTDEV)
+	fi
 
 	# Mount fs, run an extra test, fsck, and unmount
 	SCRATCH_DEV=$METADUMP_DATA_LOOP_DEV SCRATCH_LOGDEV=$METADUMP_LOG_LOOP_DEV SCRATCH_RTDEV=$METADUMP_RT_LOOP_DEV _scratch_mount
diff --git a/common/rc b/common/rc
index b3f63111c6ea6c..04b721b7318a7e 100644
--- a/common/rc
+++ b/common/rc
@@ -4608,6 +4608,23 @@ _create_loop_device()
 	echo $dev
 }
 
+# Create a loop device from a given file and configure it to support the same
+# sector size as the given block device.
+_create_loop_device_like_bdev()
+{
+	local file=$1
+	local bdev=$2
+	local dev
+	local blksize
+
+	test -b "$bdev" || \
+		_fail "$file: must be a block device"
+
+	blksize="$(blockdev --getss "$bdev")"
+
+	_create_loop_device "$file" "$blksize"
+}
+
 _destroy_loop_device()
 {
 	local dev=$1
diff --git a/tests/generic/563 b/tests/generic/563
index 89a71aa44938ea..a43ffcbd127e17 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -91,7 +91,7 @@ reset()
 
 # cgroup I/O accounting doesn't work on partitions. Use a loop device to rule
 # that out.
-loop_dev=$(_create_loop_device $SCRATCH_DEV)
+loop_dev=$(_create_loop_device_like_bdev $SCRATCH_DEV $SCRATCH_DEV)
 smajor=$((0x`stat -L -c %t $loop_dev`))
 sminor=$((0x`stat -L -c %T $loop_dev`))
 

