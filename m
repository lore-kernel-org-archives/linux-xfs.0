Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5953126B9;
	Sat, 25 Jul 2026 07:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965170; cv=none; b=eErAm2kyoFnpbnWeEUn0EtpoMshD+dTyZjjiLmDaUbFI4ahVPTI+Njwg46AiIBMQBpwBr67t6dEgSqqhHuO+ZLnPAC7yYlPMxtXOIksaQCLYSvLwVdvgZZZGDA1vOw2OmGbfYV6GNOPuJ8H/xr3GrotKO44vlpDY7NGSofuImrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965170; c=relaxed/simple;
	bh=RhuNPFSsg64ZE5FX+SW6I+olTZRz+eoZ+k4Gm1JvvWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdcVRP2VefPmCPIDClic4E/lEs4d0OintyAWY/5+Hja616xYLv2p6v5UOBzFbmtf2V/oY2SEAO+DF1JaaKW3BPC7sYaJJdcuF40qDMNvy2Cry+C0X6hMIF+8Z3Zh/00JCYUch12/TSlPhFU79TLJ0VgW2znCq90Uh/3yJuGzRRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oggScPL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oggScPL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744441F00A3A;
	Sat, 25 Jul 2026 07:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965168;
	bh=DV7Jn2uM7I5dhJYWcrR98O8AGHL2werlvw5uBfEBhZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oggScPL1xubsVyIN8+2G7t3coZ7bAdyLP+KbDVb0M8TY4eJKuV5GDOtT3UtXRGiNz
	 lZoxowlzCqfbbzdgFEhC1iUeeZpQxOPrKPXeAjbpAkS5PLos7K2biXi68dTWvx+Her
	 jK93TW4HOx+t9wYjw0gcFv25CPQ6R0KbDxofNQ60SsjeF1bB+eUH+Cwfinc5v9YhQ9
	 Yz6xbmAZqQxheqTUIwQyeqgcvPQ07zFgTF+VDlbHUZd+OIRzqKBQUlZQaX1nKbipBh
	 Qe7hQyrhN6VLwWJou/rdpjVFMQsZ8hFaJ/ZgvqhP07WME95fL9kTxoNy/HqKIZ6TzY
	 BhAxeLtKpuLdw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 01/13] fstests: add _loop_image_create_clone() helper
Date: Sat, 25 Jul 2026 15:38:58 +0800
Message-ID: <4fa4f6bc500e0496e3d8598d38cf69597493a25b.1784949154.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
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
 common/rc | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/common/rc b/common/rc
index 106f044adc2d..e8ff5be0c547 100644
--- a/common/rc
+++ b/common/rc
@@ -1520,6 +1520,71 @@ _scratch_resvblks()
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
+	local loop_devs=()
+
+	# Since we copy the block device image, we keep its size small.
+	_require_fs_space $TEST_DIR $((size * 1024 * 2))
+
+	_create_file_sized $((size * 1024 * 1024)) $img_file ||
+				_fail "Failed: Create $img_file $size"
+
+	loop_devs=("$(_create_loop_device $img_file)")
+
+	case $FSTYP in
+	xfs)
+		_mkfs_dev -s size=4096 "${loop_devs[0]}"
+		;;
+	btrfs)
+		_mkfs_dev "${loop_devs[0]}"
+		;;
+	*)
+		_mkfs_dev "${loop_devs[0]}"
+		;;
+	esac
+
+	# Only execute if the function argument is not empty
+	if [ -n "$pre_clone_tune_func" ]; then
+		$pre_clone_tune_func "${loop_devs[0]}"
+	fi
+
+	sync "${loop_devs[0]}"
+	cp $img_file $img_file_clone || _fail "Failed to copy cloned image"
+
+	loop_devs+=("$(_create_loop_device $img_file_clone)")
+
+	_ret=()
+	for i in "${loop_devs[@]}"; do
+		_ret+=("$i")
+	done
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

