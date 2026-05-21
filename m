Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA99C3C4B6F;
	Thu, 21 May 2026 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368421; cv=none; b=rLAxkcaxh5iDAXl+dUFPWRZJmhPSjkGw3hrgzN15XA1yO5gLAc4ZwrJ6ico+LpXxNVm1zDT/US8Pv1S7lWnJ2U3VjEOcAIIttAkBhEL+5gFSkOSkKwdjsX7Hg+kd101HIdbxNeEChyGCTZ4gQKg+F57SYxFeiqCXCmocmoS+IDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368421; c=relaxed/simple;
	bh=lTrvuXxExE10OEigacKYmmIjXxJQhiTwCHFqDdH9hqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge7xOOiCkAHFM4D/PURHeNzf10dIPdtBe0BktynJ5A7XDu2s1ZOPJMnAB7Gc6ivCsVuAcP4iVJ1B2kr0YId6CFakumttCCBrP4La2s7Kt+CTp1FeWvauFXMbSm16myMbZq/ZmK0zoA2rzJZiq5KdPtTuto9dXMBvWkE5QQ3BV/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtM5dhXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtM5dhXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01691F00A3B;
	Thu, 21 May 2026 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368420;
	bh=9Z4SvBTgWBlzorMQ2pTfq/12pqow7XUweRVuHGZ3yNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtM5dhXKbEElXaYgTzsZk1X8NTzZCMV4gtwbktgkoz0jpGsfjo77n6TBgsufHJE8V
	 1x9UqmQdnTihYpxn89aDMVDpQQVlfqKsYvmv3dIGjr6yznlnS5RW5plVUtKny5ScWv
	 hvoIasU7dT+UoaiBjxEy81ylTnOJQM63gBaxTffuwkn6AaPdhPveuOUocn2ZdPEJhY
	 Xq0jhSic+yz5PSNWzAcJDYbIsiInZH5Zh7JFH04SN4CrgCcEUEVH7dP9qw4rT3OIui
	 axPQl1rWOpw+yFhuA5JsdTD28h1y2VtdsqOSbzY84XZQsXu8m/CZVZO/emPMYbJmR0
	 HQVO8upebX6tg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 01/10] fstests: add _loop_image_create_clone() helper
Date: Thu, 21 May 2026 20:54:51 +0800
Message-ID: <7b0edc0be51fd3ba222a4d0f204cd406c98085d8.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779367627.git.asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
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
 common/rc | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/common/rc b/common/rc
index 9632b211b58f..a2ee23c45003 100644
--- a/common/rc
+++ b/common/rc
@@ -1503,6 +1503,56 @@ _scratch_resvblks()
 	esac
 }
 
+_loop_image_create_clone()
+{
+	local -n _ret=$1
+	local pre_clone_tune_func="$2"
+	local img_file=$TEST_DIR/${seq}.img
+	local img_file_clone=$TEST_DIR/${seq}_clone.img
+	local size=$(_small_fs_size_mb 128) # Smallest possible
+	local loop_devs
+
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
+_loop_image_destroy()
+{
+	for d in "$@"; do
+		local f=$(losetup --noheadings --output BACK-FILE $d)
+		_destroy_loop_device "$d"
+		[ -n "$f" ] && rm -f "$f"
+	done
+}
 
 # Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
 # errors found or errors were fixed) and nonzero otherwise; also spits out
-- 
2.43.0

