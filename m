Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5FE3502AA;
	Tue, 28 Apr 2026 06:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358595; cv=none; b=dkTBWKhP5AvpPICQpcO9K4imCnF+J3Oivuno9O5NmbydbjOz1g+5EIO3QE0sTZI69vST4EPt96NbZ03ldO96vMJk3kq4uIbTTBysE80Spja8lKmFiodLtLW6lF+WW8RBD0NOPp9XgsRbTUyaioWtW70NZMAWO8oN+NEHEzL+Ono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358595; c=relaxed/simple;
	bh=elQgkUeErhlv15tJrd1NtcpSP5p/NhgQJp99u70EEQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+Ils7GIyFKrUpJBeDz1l0IwRSZ+mGBCBys8CA0iTz3DvsmLR2RB5sX+D8rVKevlUGBi45lWyUdqpqBW8QrGJB1x6h+5s112R8T4StXSdNH3ZC2zjeisqSINB7Pd/YrqT34aVMy+yY3a2ukhzQQjfcwKE78KTWX97Iix36Ui/6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3PkWLob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3PkWLob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716DAC2BCB8;
	Tue, 28 Apr 2026 06:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358595;
	bh=elQgkUeErhlv15tJrd1NtcpSP5p/NhgQJp99u70EEQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3PkWLobkRPD9XbZGvpb9yWvhIR/NdIJkNiAzEc4D5m4HiWleI9bYE74VLEBmJ0Fg
	 jt/P4fJziHLNcaZ1Hpt6BRx3cs2FXOmwhv4KF2ffmpJg9FhLHfvvO4qqzmxFyAbQc6
	 qX0gxNxGgtVt6jizmCN1sZ0cSZ+7higEHapA9MBv+AIU/yrAgQs4HFiRLQsWcNd3OS
	 k/puKaQ7Dx3rsVSL9fWsRYnYQQPLNLpysadVC7eonqxFFYNpKt9DNirRI4ru4T+JX9
	 kVUBnfhVBrkP4OcC1egxlfiYU1KDrzVA01OsW+FwGO2Do5okN5AJ1lsfSmOhryGSOL
	 nxquOTuZW8NjA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 1/9] fstests: add _loop_image_create_clone() helper
Date: Tue, 28 Apr 2026 14:42:51 +0800
Message-ID: <66f9768551f15fc448239335ae500bc86833c256.1777357321.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777357320.git.asj@kernel.org>
References: <cover.1777357320.git.asj@kernel.org>
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
 common/rc | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/common/rc b/common/rc
index 9632b211b58f..754365e80dca 100644
--- a/common/rc
+++ b/common/rc
@@ -1503,6 +1503,53 @@ _scratch_resvblks()
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
+	($pre_clone_tune_func)
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

