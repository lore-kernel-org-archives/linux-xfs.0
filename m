Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA5DF76;
	Thu, 28 May 2026 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941174; cv=none; b=Z0a8CPgRY72AHf/Wu/Tuh1ZBqE5ABoDrLLafSSgabxdd0lBAFDJBwLG42+lQ4EosLlki/xZ6wWKe0mypCJ2Lk3c1j8eq2VB9pu7A2aZsBfo2vfdFUTXiZd24HIyRLmdFIYDDrlQ9WXlWly5aDz6iORe9T9PKkbAC1egz5ndx3n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941174; c=relaxed/simple;
	bh=QmQyfZ3MaHTLMusDKSGpcf2z2925quY4Jx/NmRm3M+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RENg6HrWItjVkKVfkdms8IDBX83JChCuHsMnNvgdJDbMF5jad1BkLMeueyjSR1uXFW76elwnRNIYe8XAkmssZ7EbnitjA56Rnxn4xnR+kKhWFay41L296lrUuSzdnGM4KE4FxLhrZZjB9BsjfT3lx/wXH+IpJTsZYHO3ilWKbcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IABPO77o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IABPO77o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388AA1F00A3A;
	Thu, 28 May 2026 04:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941173;
	bh=81pf5d6d5QrOm2o8qa6SqtrOWC9C6qeuxU6yd+94e28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IABPO77o+8CFbBvKnTi/NY8j9oUYUabcUKrTg4KUCg8FJZ+1y/5L6OADuECanFWbI
	 /ucyHO+sYcw3MiL/MMseUTiWA76WBCsgOXu9/jTtgmK+5uB1jBzKKTcKsxfULa2T0c
	 P1Co6+StrGUoW7mI7dEt7kcR3IMbBINBPSnMTvH9l8m0opp2ud91K/gvDVjtcY573w
	 PBuVEGunSc7E6Gcg6+DveA5OXQkGWWeAv5Y4pW7YddxG1LXj/rcB2tRq5C+52H2nmx
	 VAlKHRy0glt+ZGFZtypfX7Bly/A1FreOKkfW12tuMC4H5EhIPDyiKbZCRT0IMTbX6u
	 7N0J+hSLsN+Zg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 01/11] fstests: add _loop_image_create_clone() helper
Date: Thu, 28 May 2026 12:05:32 +0800
Message-ID: <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
image file and clone it to another image file, and attach a loop device to
them. And its destroy part.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/common/rc b/common/rc
index 79189e7e6e94..d7e3e0bdfb1e 100644
--- a/common/rc
+++ b/common/rc
@@ -1520,6 +1520,69 @@ _scratch_resvblks()
 	esac
 }
 
+# Create a small loop image, run an optional tuning function ($2) on it,
+# clone it, and attach both to loop devices, returned in ($1).
+# Args:
+#   $1: Nameref to return the array of allocated loop devices [base, clone].
+#   $2: Optional callback function to tune the base filesystem before cloning.
+_loop_image_create_clone()
+{
+	local -n _ret=$1
+	local pre_clone_tune_func="$2"
+	local img_file=$TEST_DIR/${seq}.img
+	local img_file_clone=$TEST_DIR/${seq}_clone.img
+	local size=$(_small_fs_size_mb 128) # Smallest possible
+	local loop_devs
+
+	# Since we copy the block device image, we keep its size small.
+	_require_fs_space $TEST_DIR $((size * 1024))
+
+	_create_file_sized $((size * 1024 * 1024)) $img_file ||
+				_fail "Failed: Create $img_file $size"
+
+	loop_devs=$(_create_loop_device $img_file)
+	_ret=($loop_devs)
+
+	case $FSTYP in
+	xfs)
+		_mkfs_dev "-s size=4096" ${loop_devs[0]}
+		;;
+	btrfs)
+		_mkfs_dev ${loop_devs[0]}
+		;;
+	*)
+		_mkfs_dev ${loop_devs[0]}
+		;;
+	esac
+
+	# Only execute if the function argument is not empty
+	if [ -n "$pre_clone_tune_func" ]; then
+		$pre_clone_tune_func ${loop_devs[0]}
+	fi
+
+	sync ${loop_devs[0]}
+	cp $img_file $img_file_clone
+
+	loop_devs="$loop_devs $(_create_loop_device $img_file_clone)"
+
+	_ret=($loop_devs)
+}
+
+# Teardown loop devices and delete their underlying backing image files.
+# Accepts a list of loop device paths (e.g., /dev/loop0 /dev/loop1).
+_loop_image_destroy()
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

