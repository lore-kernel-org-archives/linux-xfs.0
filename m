Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19B246EC85;
	Tue, 21 Jul 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659471; cv=none; b=KGwtfWXM+Wu3ywoNevbAOXP9uwoGChGi8ao1nqGIhl+j+8Lx31S+Ltm+kNYbpAznlS8QpV6Ohxrbm/Oh/spNNpj1YONFcnawz9oC0K1T0pWzlR6krUG8WLpQHJqEsAfisX9+/8qD/HKUr1EmHHREsk1PJreYFrTqagYdi2UVBNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659471; c=relaxed/simple;
	bh=D8pvOb9i84Gt/+h+XnKvul7Yx8ta1LxwPWNa1Y/y9W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1+DnGoqCzP7huuWmvsJYMc/YtVO7tnxqy1vb694ollmUiJoZaVMTdgLogPBm89CwKb19N+G6D118EXOsldGZkQTTrtHhwi/azZXnTYo/nm55jTQGRS2Z75KXEW9UjsRDC5mmj3EpOKThIn8TJqipTPDmhe+6/7bxl7vyFnV2yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1aNh133; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1aNh133"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB451F000E9;
	Tue, 21 Jul 2026 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659470;
	bh=wjtx2lzB3uvb4xU+DIuox4Zw+1tx5e8JwgBOS4wBSrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1aNh133LaOr+veWURHQdGc2XGiZKvo8KSp2tkJ9AohhNSRRwgxYI4BSjWTZDZu9p
	 JSdQ5hRIQXzsdB1A+jK3Ut0TEpUBotTPNfdzbm8kqFXMgilK0WHXxF4rTtwgRElbwq
	 gt71KVal9gMebJUpZToY1VctlGmoXBhD0IdNjJ23rcw5RAXf7ubB5q7jx3wmU00biU
	 KeVB4X1SSzXlrcP1qyl3Q3isnNrLaDRD/q5sxfKb4R155MOvj7neSQO6O5aqnAcbOb
	 LsFa+LnE6ozBPhnGvsW/64uEXxSPGFs8AtWm8T1PQaFaaoq/pcsqRKAsHfUifXGON1
	 oHbmGOA1YF3NQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v13 12/23] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Tue, 21 Jul 2026 20:40:49 +0200
Message-ID: <20260721184346.416657-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko.dev reported that while fsverity files falls back to the
buffered IO for Direct I/O, they should not report non-zero values in
dio_mem_align and dio_offset_align, meaning it's not supported.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 55667cc762f8..70637cdcc299 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/iversion.h>
 #include <linux/fiemap.h>
+#include <linux/fsverity.h>
 
 /*
  * Directories have different lock order w.r.t. mmap_lock compared to regular
@@ -580,6 +581,10 @@ xfs_report_dioalign(
 	struct block_device	*bdev = target->bt_bdev;
 
 	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
+
+	if (fsverity_active(VFS_I(ip)))
+		return;
+
 	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
 
 	/*
-- 
2.54.0

