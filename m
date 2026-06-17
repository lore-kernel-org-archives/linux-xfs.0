Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A72A3C09E0;
	Wed, 17 Jun 2026 11:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695254; cv=none; b=lQvhPzBezFtg5iewexeDYPuiofOMIFjed3krsJtJ4TYVmcsLcE+5CxkT5shhNFZsyG0fXX99C356CYSzaWK+xaRCI+h7arLmRFbQxSfNLSp41p+rns6vbNgBtOkTU6VsB7wKywIYMJwhP4M5lWC0ESwfJ3eJoBgGfwf7pvVvFVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695254; c=relaxed/simple;
	bh=QmQyfZ3MaHTLMusDKSGpcf2z2925quY4Jx/NmRm3M+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+eK62Lt238Lof9omR2xZ38JfpFYl/VW/ENZfQYD8ktz/BfKaN//EUltYwk8sms1gOUXz3GEkHcGvYKn2JU/66nCY+vkVt3+Dm+2XSNe2yv1i+RUnTte1b1gWiJ+5+VmkDXHmViejR3jQfH2ZBQs3CGHGQatUlQrKdEURaowNUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bubuyOk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bubuyOk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42D11F00A3A;
	Wed, 17 Jun 2026 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695251;
	bh=81pf5d6d5QrOm2o8qa6SqtrOWC9C6qeuxU6yd+94e28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bubuyOk4od7zpTKgWLnnIhJLQvr96mkbLVOsDKdNxMhtCEYVxj0hmscaledlAmkD7
	 c4rlixHjO/TnAnUgoSJgS5Dy1zP1m/qb2e8icLhhV/UfAcO5MeTZEZjNuIuE4Z4PgL
	 WeCTjH+FZppGgpNx/jobR9jsYodYo51JDgY1gPC54yGNegRAq4LIqY47vY2Hnf+Ydp
	 /QDcNLJt9Z6C9p3JQ7+IV3wVaSbIGJQ4ujX8HkvHaVz+91TrDQskbKwVHu82q+o1Ef
	 FzJpvGEJRrPTZQJYFrR7YHYMKOI31am/j/n3xjnmVHHFQpw9+/y+xpVPFwiwueK4s/
	 5s2LnmFObNMtQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 01/11] fstests: add _loop_image_create_clone() helper
Date: Wed, 17 Jun 2026 19:20:28 +0800
Message-ID: <421c7cdd5aae27b99d04dddf08c5d9df79c2f790.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
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

