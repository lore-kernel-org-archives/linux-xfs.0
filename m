Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363013E5EF6;
	Tue,  6 Oct 2026 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276979; cv=none; b=IO7VBPskkzhZzShiRUqn71tsJUWCuM95zFsheagSqyFXNpq8+9J//7wfIbkX/uH0BZDV5V+hyjQrtTM9TpYShnX0M4D+vSmFn1Z2Z+m3VgDKw7t2KDo4kh265vkgZLMy5BffLZF3ZiB9FxhCSxyLaQU+3ofFm0+Bv/qMVgH+RTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276979; c=relaxed/simple;
	bh=DzJ65S62sVH3hRup1MrNqXuZzgAiPJGAAFx9IHiPFVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0ohD/gwWX5TgpYTWgK0eG+lf04LjiCsAnA0TkCVA4yMxRwy6WlJpAa+E3A+5MXb9hbAEXjKvXSYpM0qGJTiwrZKHJV79YMx5OIMv7Ze9hbu16+LXpt0BeM2oBgecN9VlKPjv0HpERNa7/KW3MnhxtQ3RxX4MBWxTvbEBYlceu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDPPkKYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDPPkKYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B61F00898;
	Tue,  6 Oct 2026 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276978;
	bh=CmbVMI7lUvfkO3SWgb3kTNHaNpNWSR/IBSLglzGhdUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDPPkKYg+C5Z298ieT/s7vXoeq4QvnbG4MW4RSyrfbTeLiNilJdOyDJOonKZEE9bW
	 B3Zv50r1hGkwHWRGAOtHyHPoZzIrxBb93GY8i5jjsumdmY8RyJekt2vubJG37z3A82
	 OnIqvEhwagNMXDmz5OjeceUYtzHRPIaOUj2JhiWuNcEAeeP7GfM4I6x8fOKriFrsch
	 0VYz5oyx8MZyjZoRKqumUrKiTYIeQledlxA9/r751g3M8m/apiGzsra0Ae4ADmegU9
	 YsfHCXPELw7LXPPWGmXMtS7bY0SxKsqz14AMUWerpwK3N402E1AD8Z847zN/lvl+iQ
	 qX+AEO8f4g+ww==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 02/21] fstests: introduce _create_cloned_loop_devs() helper
Date: Tue,  6 Oct 2026 16:55:28 +0800
Message-ID: <d97b87a346488157df940edbf89c62b71bbd0340.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce _create_cloned_loop_devs() and _destroy_cloned_loop_devs to mkfs an
image file and clone it to another image file, and attach a loop device to
them. And its destroy part.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/common/rc b/common/rc
index 7868e6d311a2..f2ab4bc491af 100644
--- a/common/rc
+++ b/common/rc
@@ -1534,6 +1534,72 @@ _scratch_resvblks()
 	esac
 }
 
+# Create a small loop image, run an optional tuning function ($2) on it,
+# clone it, and attach both to loop devices, returned in ($1).
+# Args:
+#   $1: Nameref to return the array of allocated loop devices [base, clone].
+#   $2: Optional callback function to tune the base filesystem before cloning.
+_create_cloned_loop_devs()
+{
+	local -n _ret=$1
+	local pre_clone_tune_func="$2"
+	local img_file="$TEST_DIR/${seq}/orig.img"
+	local img_file_clone="$TEST_DIR/${seq}/clone.img"
+	local size=$(_small_fs_size_mb 128) # Smallest possible
+	local temp_dev
+	local loop_devs=()
+
+	# All current callers mount the original and the clone simultaneously.
+	_require_clone_mount
+
+	# Since we copy the block device image, we keep its size small.
+	_require_fs_space $TEST_DIR $((size * 1024 * 2))
+
+	_create_file_sized $((size * 1024 * 1024)) $img_file ||
+				_fail "Failed: Create $img_file $size"
+
+	temp_dev=("$(_create_loop_device_like_bdev $img_file ${TEST_DEV})")
+	_mkfs_dev "${temp_dev}"
+
+	# Only execute if the function argument is not empty
+	if [ -n "$pre_clone_tune_func" ]; then
+		$pre_clone_tune_func "${temp_dev}"
+	fi
+
+	# We are about to copy the loop device's backing file
+	# Flush loop device's buffer cache
+	blockdev --flushbufs "${temp_dev}"
+	# Sync system's dirty pages including backing file's
+	sync
+	_destroy_loop_device "${temp_dev}"
+
+	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"
+
+	loop_devs=("$(_create_loop_device_like_bdev $img_file ${TEST_DEV})")
+	loop_devs+=("$(_create_loop_device_like_bdev $img_file_clone ${TEST_DEV})")
+
+	# Help debug
+	losetup --list "${loop_devs[0]}" >> $seqres.full
+	losetup --list "${loop_devs[1]}" >> $seqres.full
+
+	_ret=("${loop_devs[@]}")
+}
+
+# Teardown loop devices and delete their underlying backing image files.
+# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
+_destroy_cloned_loop_devs()
+{
+	for d in "$@"; do
+		# Retrieve the path of the backing file
+		local f=$(losetup --noheadings --output BACK-FILE $d)
+
+		# Detach the loop device from the backing file
+		_destroy_loop_device "$d"
+
+		# Clean up the backing disk image file
+		[ -n "$f" ] && rm -f "$f"
+	done
+}
 
 # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
 # errors found or errors were fixed) and nonzero otherwise; also spits out
-- 
2.43.0

