Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531BF158520;
	Thu, 16 Jan 2025 23:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070083; cv=none; b=ILmaNMzYJLSQmJEiZGb9cmdQak/WNhyCBcWYEmrpV/1V+ySbSjthh/TPOXgqVssdNzq1HZcTpcLFDNLO9yIMOLiTqK2FH0LeEoohziMEkBwm4TGhV2uKTItnsI8zeSYCqAc9j1N9qU32t3dH/IqXAbgZWzg1kThSNlfOLv9Bx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070083; c=relaxed/simple;
	bh=SF1mBj/m9kWKItneW0c2xDO8rz/3FsnINM96FO/7Y0I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMJ5kbsiZPt0SYrp5RbRMitD06TC6cR8dc4NPKj9fa4xZnGTipRr/k/bfUWuAH3WJjAlGoxHLfuMlN7R76lcD2EmdUjO2+daih5dEkAil9zhbGnRmDNEuSfmlfr/9/mhcdKOakLQW6iaXISNW8qwd/xUfCwIW9SU+BdpVZKHT6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R12rnhOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R12rnhOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11A5C4CED6;
	Thu, 16 Jan 2025 23:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070082;
	bh=SF1mBj/m9kWKItneW0c2xDO8rz/3FsnINM96FO/7Y0I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R12rnhOB0kD7UxXvn1rQ22l67zOvSptQjVVDBgNEJfVRkJaJOCVZxVUtYRLmxTV6H
	 Klz31mGJVR2IBrB4dDikkoOI32CNbnsrV8BuixOyNymRxdrXHCrnEdrm2rwavYens5
	 Kf0UQf5TUr1OWbZRqcw70pL+rxg/bNzc1nFEEgvjYPEg+PMQ5Xs5I7F1jxcgFeN5M2
	 2d+dClvYkRYCX48IZuOQrd7CFDJytY+0oG0UdiFDCtG4oXU9UWVv9tpU1cTG93Moks
	 GMrMmSRHZ4USqVs5k5Xv+aso319b66JUtSB1g99x3ab/7J/q5KFs3p1Kx7i1+aAeq3
	 sD9KKnkJ6u08g==
Date: Thu, 16 Jan 2025 15:28:02 -0800
Subject: [PATCH 11/23] common/xfs: find loop devices for non-blockdevs passed
 to _prepare_for_eio_shutdown
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974243.1927324.9105721327110864014.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/336 does this somewhat sketchy thing where it mdrestores into a
regular file, and then does this to validate the restored metadata:

SCRATCH_DEV=$TEST_DIR/image _scratch_mount

Unfortunately, commit 1a49022fab9b4d causes the following regression:

 --- /tmp/fstests/tests/xfs/336.out      2024-11-12 16:17:36.733447713 -0800
 +++ /var/tmp/fstests/xfs/336.out.bad    2025-01-04 19:10:39.861871114 -0800
 @@ -5,4 +5,5 @@ Create big file
  Explode the rtrmapbt
  Create metadump file
  Restore metadump
 -Check restored fs
 +Usage: _set_fs_sysfs_attr <mounted_device> <attr> <content>
 +(see /var/tmp/fstests/xfs/336.full for details)

This is due to the fact that SCRATCH_DEV is temporarily reassigned to
the regular file.  That path is passed straight through _scratch_mount
to _xfs_prepare_for_eio_shutdown, but that helper _fails because the
"dev" argument isn't actually a path to a block device.

Fix this by detecting non-bdevs and finding (we hope) the loop device
that was created to handle the mount.  While we're at it, have the
helper return the exit code from mount, not _prepare_for_eio_shutdown.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 1a49022fab9b4d ("fstests: always use fail-at-unmount semantics for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc  |    8 ++++++++
 common/xfs |    6 ++++++
 2 files changed, 14 insertions(+)


diff --git a/common/rc b/common/rc
index 885669beeb5e26..4419cfc3188374 100644
--- a/common/rc
+++ b/common/rc
@@ -441,6 +441,7 @@ _try_scratch_mount()
 	[ $mount_ret -ne 0 ] && return $mount_ret
 	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
 	_prepare_for_eio_shutdown $SCRATCH_DEV
+	return $mount_ret
 }
 
 # mount scratch device with given options and _fail if mount fails
@@ -658,6 +659,7 @@ _test_mount()
     [ $mount_ret -ne 0 ] && return $mount_ret
     _idmapped_mount $TEST_DEV $TEST_DIR
     _prepare_for_eio_shutdown $TEST_DEV
+    return $mount_ret
 }
 
 _test_unmount()
@@ -4469,6 +4471,12 @@ _destroy_loop_device()
 	losetup -d $dev || _fail "Cannot destroy loop device $dev"
 }
 
+# Find the loop bdev for a given file, if there is one.
+_find_loop_device()
+{
+	losetup --list -n -O NAME -j "$1"
+}
+
 _scale_fsstress_args()
 {
     local args=""
diff --git a/common/xfs b/common/xfs
index 0417a40adba3e2..c68bd6d7c773ac 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1110,6 +1110,12 @@ _xfs_prepare_for_eio_shutdown()
 	local dev="$1"
 	local ctlfile="error/fail_at_unmount"
 
+	# Is this a regular file?  Check if there's a loop device somewhere.
+	# Hopefully that lines up with a mounted filesystem.
+	if [ ! -b "$dev" ]; then
+		dev=$(_find_loop_device "$1" | tail -n 1)
+	fi
+
 	# Once we enable IO errors, it's possible that a writer thread will
 	# trip over EIO, cancel the transaction, and shut down the system.
 	# This is expected behavior, so we need to remove the "Internal error"

