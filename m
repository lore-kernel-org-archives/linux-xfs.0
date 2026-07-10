Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F343C278F;
	Fri, 10 Jul 2026 08:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673635; cv=none; b=JZbWw4GqDTfzRtIYmLg4V07bdAsBTJfb6HTEnwL8HwKpF48xeMeOpz960vWS0jZdV1K7fKdqSzKwxm0H7m03N4IytSlLGHwuR76idrqBB3idbEBJOyRF88f69nEpkXfkjKRDT83zjDzHpICWnvKGYkNqH7FDWkXbTi1yFxmI03Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673635; c=relaxed/simple;
	bh=D8pvOb9i84Gt/+h+XnKvul7Yx8ta1LxwPWNa1Y/y9W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mErl2bqKn04Qk+YSyi4nUPadMW3L/C0+/FSLRerh86I7A4qwkLd0m7TMjNMo8xTjDaDQz6oUnNuN0kJU7Ecn2o2pej4UyIIlI5YvbR1MgmO7aLS6Acq1JoV5zJkQ4dYR8Dpj4cXbhCtFdDMovgVlbLq9YXnRU9iYpVKzYI0X9MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOPGIi2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOPGIi2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C9E1F00A3E;
	Fri, 10 Jul 2026 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673634;
	bh=wjtx2lzB3uvb4xU+DIuox4Zw+1tx5e8JwgBOS4wBSrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOPGIi2qT/sDSUu1YE04vKmbro26o2XNX87EpoLSHZ3+O7hcik009cJCb7S5J7fMY
	 v+rKRa2zqfBXE+UIOFnKDKbZUrntwXpfq415MoxBdLiOsfOyNKhocJCVmwLFLrmjD6
	 jQ9zwTMbFkrBmSPTJD7b4eO8PJYhs3Il4cvjKC/QcaaDEAfN0zh6Aw/JNaEegHIC7r
	 2bQL7Juuo2BShXDLOQsfRSu1Tynw5LRMJupkDupzUok7+M4x+TmekBERhqQOxAofBG
	 /jeU1WsJp1zbEw47ibS360In0xhg7L7SEnY5uDIP6uYKpvJDLgma/1FDaJ4ZQX3AZj
	 SmVS2/vV6NCYw==
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
Subject: [PATCH v11 10/20] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Fri, 10 Jul 2026 10:52:38 +0200
Message-ID: <20260710085256.3464201-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

