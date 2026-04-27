Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92ED305E3B;
	Mon, 27 Apr 2026 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285198; cv=none; b=PkpwVfIKnwkK98WGM/LEDfAFtfVUWqrRqF+YHGMpl6y5UhfSMb6at9KZ1bXBcYSyRE/adYLMcvjBd07uB3ZGZyXgyAUa5GlXTXT144xRZ5vARqRhE0Q5MVIxIEoYnCu3V2/2H7eJwrAX6qx4CZRPCvT59kZblDjTZox26Xr/wNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285198; c=relaxed/simple;
	bh=TudFNrJ7xMN4t5aKEhti1ZuJdx6eszXGY1fn2YNMtMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG4us4KkfGfamvd1gkm6wU9GPzVWDoF7JPRgd+PyvX+2r+SBlzTMHxYcAHQdCXKohvekGFg4K7KzulBIgzHXRfJ/sFQH3k6v0xxblNcimO9ozQALUdmqqdjQnZs5ESqkdZT7h6zpRXXzEb1tPF0gFsJous0gxklQ1SqAKxwMGS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqSFxQI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqSFxQI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059DAC19425;
	Mon, 27 Apr 2026 10:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285197;
	bh=TudFNrJ7xMN4t5aKEhti1ZuJdx6eszXGY1fn2YNMtMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqSFxQI0eBLR8WvX6VXiJegb7KGUSeV/bs6S+/KKrw+6ot6W4RwLP/0bCY4A6koBS
	 qsTyNRDzBNblheGaWJFpYwyY+FSK6UNyEA0hTcmZWxQ8FrBPTV2PX7CDNlY3X04+qI
	 ePRJVi9GerXung5D+MW+MpB5D6VaF0ojZlrcQxz3huN/Q7wskVWV3Eoh61zISnGVkb
	 j3wfT0CKupQo/9nfVjJtMnuqfNpCs8HnRUrTq3a1+8HbiFoJKEp7atZ84kwZ/2pTQl
	 XEg1YsuvqiLNBI9Pd1JGJF60qWAlPKZM0BXhyg2MSJDMgpUsRyLBwk6WCq+SBeHw8W
	 roWj9tztd1bNQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
Date: Mon, 27 Apr 2026 18:19:33 +0800
Message-ID: <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281778.git.asj@kernel.org>
References: <cover.1777281778.git.asj@kernel.org>
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
 common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/common/rc b/common/rc
index 9632b211b58f..0e7b7eb1d98f 100644
--- a/common/rc
+++ b/common/rc
@@ -1503,6 +1503,50 @@ _scratch_resvblks()
 	esac
 }
 
+_loop_image_create_clone()
+{
+	local -n _ret=$1
+	local pre_clone_tune_func=$2
+	local img_file=$TEST_DIR/${seq}.img
+	local img_file_clone=$TEST_DIR/${seq}_clone.img
+	local size=$(_small_fs_size_mb 128) # Smallest possible
+	local loop_devs
+
+	size=$((size * 1024 * 1024))
+	$XFS_IO_PROG -f -c "truncate $size" $img_file
+
+	loop_devs=$(_create_loop_device $img_file)
+	_ret=($loop_devs)
+
+	case $FSTYP in
+	xfs)
+		_mkfs_dev "-s size=4096" $img_file
+		;;
+	btrfs)
+		_mkfs_dev $img_file
+		;;
+	*)
+		_mkfs_dev $img_file
+		;;
+	esac
+
+	($pre_clone_tune_func)
+
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

