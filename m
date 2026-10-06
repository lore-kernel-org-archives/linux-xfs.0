Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEB33F3283;
	Tue,  6 Oct 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277017; cv=none; b=BeNqv5EKcf6u2p9ut+2PhAVaw7IhWhlXWZ4ys+lCRsXO3Bh+HRWqCXeHxxecteHy+LwzRfFui8ew53Y1XaJEUfrmt+N3FhRW40PCy1ZTQZA1K3NrvVPUZkIrAVplAmwwgqRApL0eX/AzXhUpFmzCKhZhrnqO4RGKYKfzwiF4pt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277017; c=relaxed/simple;
	bh=FmOwez8zygZ40xE3tGCSpXh7Fq7E9DBIrEdMKn7ZbDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2sOI57DG2IuYLf3gD6fupVbDehSL/cs+Cb67hBgRA5ma6upw/YsF0DGx101EucamgLjj4ATpp5xlf0rhNybtgzmaIBdxVHO/rA6vZSqw/d5+IX97MbL1V8OJjMfdQPOeDfUAPTKfsFJ1JjWOe793bH13yiBZ9Yle12xg1x9KKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftRZk7nW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftRZk7nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174471F00893;
	Tue,  6 Oct 2026 08:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277016;
	bh=GUebb0cGvHp4BdkfYsUDUeqJGoIKudolDlGlrishWBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftRZk7nW1BpZgcaBlEa3E9brge7CnBItaVC9XUi9foeP1xoJ4BlItlOa6rD+wwwBz
	 IfHAq5rdM5Ll70vEeQfd+/fpskwp9IshiWIdSTY7zOfvdoeBfGtdXqlRH4LZPfhTBk
	 Oz6lZ3UvR/eziKyrTypFjaSoR6KSX3zQlMBr+d3Vf5HPJX28GNP+kfqitpMOcLtDk1
	 3h67mLLhmJ59UAuZLOXKIPjogiAn9p0B97V+gcTnLG9YNNt+U+KD3ybukjzbqC40Ls
	 y/P7C1gfuec3GZXhpuMklFnOf67KVuxdncgWroWoy4UPRzYk4YLxPjqdexppu9E9eA
	 SuClHAo/EqH+w==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 21/21] fstests: _create_loop_device_like_bdev() remove unused variable
Date: Tue,  6 Oct 2026 16:55:47 +0800
Message-ID: <caf98f05a61c028dc1af75c11785cece28d400da.1791272793.git.asj@kernel.org>
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

Remove unused local dev.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 1 -
 1 file changed, 1 deletion(-)

diff --git a/common/rc b/common/rc
index 58e4c234b0f4..5bc4c52bb8d0 100644
--- a/common/rc
+++ b/common/rc
@@ -4815,7 +4815,6 @@ _create_loop_device_like_bdev()
 {
 	local file=$1
 	local bdev=$2
-	local dev
 	local blksize
 
 	test -b "$bdev" || \
-- 
2.43.0

