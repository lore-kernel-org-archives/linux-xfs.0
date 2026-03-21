Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA08938B7A1;
	Sat, 21 Mar 2026 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094323; cv=none; b=QtvzvWRSra1GGoO7XeS/qxfPy86zlBa0XoqN1M8ZvwXDZClnqSLaCZoNBg+oKKZA3yJu4K/4HCsrfdXN2gYUVvIU+SlXtoU5IDJcbMxQqx3yQza7KnOGXLPgA+wOAmp5ne2+1fnhO/Fwqq/ht9zzbMTOg4LullSxl8SGpHIgDuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094323; c=relaxed/simple;
	bh=OAybrJcisASp4RbJQ7oe3h9GcR7M0fmJtj6h6l7S9xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ1ARxydATDJF8zCAF3OD0Cc+e0eOp0mdZ9sC0F7AiNjFT3XEwCCQLAiLnUMpPAijSBKkSkvIA2wJ7180EsCgFpz9wslbuuTw3CcsykWil2A0FJumOorEDu9oKZJ84Xyf69uAw9jrIYO2Al25hkijBMB0xYMJ7g8Sjhe9Do9dow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNEjxI9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNEjxI9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06E8C19421;
	Sat, 21 Mar 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094323;
	bh=OAybrJcisASp4RbJQ7oe3h9GcR7M0fmJtj6h6l7S9xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNEjxI9JKRwhX+20dYgZppD8P+603EwfNfjPOfQLwmTr7EObDZnTWnSTRQFbaIWNL
	 18B/WNGnRop5wHkVy51hmr8BiiusoIE42uehomfZK8uxnKxpfoPqMzTu1RzgLwpvu2
	 0W3qiKeOFy/BmL8ed1ABm9GCPRKcchKGS5oV6VXkXPaO1ZA2doWxuIq+JXBUJElbGd
	 HNw2BHNHiGaqa1GTOP9dtR9SGPkOPdyyy6GBiAIiRzjZjOI6ADr/ztnM9b71elp7ic
	 Muqvo0/MENku+b+pdrVRc2XpXROUoG7pDAqhraOgcZTU6qsb7grg6KaUj/tlPIEm8i
	 BsE4i7Q9d6fjg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 2/9] fstests: add _loop_image_create_clone() helper
Date: Sat, 21 Mar 2026 19:58:23 +0800
Message-ID: <93269c3ab851f9c9543058399e5b5b7cec804d7d.1774090817.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774090817.git.asj@kernel.org>
References: <cover.1774090817.git.asj@kernel.org>
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
 common/rc | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/common/rc b/common/rc
index 9e3041beee2f..a8e6af5d1a1b 100644
--- a/common/rc
+++ b/common/rc
@@ -1503,6 +1503,57 @@ _scratch_resvblks()
 	esac
 }
 
+_loop_image_create_clone()
+{
+	local -n _ret=$1
+	local img_file=$TEST_DIR/${seq}.img
+	local img_file_clone=$TEST_DIR/${seq}_clone.img
+	local size=$(_small_fs_size_mb 128) # Smallest possible
+	local loop_devs
+	local temp_mnt=$TEST_DIR/${seq}_mnt
+
+	size=$((size * 1024 * 1024))
+	$XFS_IO_PROG -f -c "truncate $size" $img_file
+
+	case $FSTYP in
+	xfs)
+		_mkfs_dev "-s size=4096" $img_file
+		;;
+	*)
+		_mkfs_dev $img_file
+		;;
+	esac
+
+	case $FSTYP in
+	btrfs)
+		loop_devs=$(_create_loop_device $img_file)
+		mkdir -p $temp_mnt
+		_mount $loop_devs $temp_mnt
+		$BTRFS_UTIL_PROG subvolume create $temp_mnt/sv1 &> /dev/null
+		_unmount $temp_mnt
+		rm -r -f $temp_mnt
+		_destroy_loop_device $loop_devs
+		;;
+	*)
+		;;
+	esac
+
+	cp $img_file $img_file_clone
+
+	loop_devs=$(_create_loop_device $img_file)
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

