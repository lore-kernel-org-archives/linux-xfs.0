Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6965839FCB1;
	Mon,  3 Aug 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787781; cv=none; b=PVZIaSsetad3BI8t26bxr78s+OJA7n47LP7UFh2Rm1wbVhUTyqLkcbpwE4CgF01q/Jan5S7pOoLg1MCl+BcKXm0Q4anX/lqwjwHaacdSTS2/VIE94pazsIVCFkl8IIkGb+3SUt9VKKqg1L4jypuxPykNSBrLlx8aBJVjbnUxpB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787781; c=relaxed/simple;
	bh=D8pvOb9i84Gt/+h+XnKvul7Yx8ta1LxwPWNa1Y/y9W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6fjfYm3fJ3t9LsMDj4mYIvMltxcTRKUe2JYp26bVeB3p+JJPlFSBpVzhw42GWqSu47nSDTOHrE4ieutzkUSemWGP7AS1/CIduO4FEqI2ACvitQwCL+dgQQ/dJ575JtzmzVPeIEKS8ms0StTZSUrGJQFHJEeLaHU6o7oh3GYj18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hh8QvR+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh8QvR+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C45B1F000E9;
	Mon,  3 Aug 2026 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787780;
	bh=wjtx2lzB3uvb4xU+DIuox4Zw+1tx5e8JwgBOS4wBSrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh8QvR+JFM2vn4N8VLB37XpPKP5uUHDwceciA0yfCjevTsXCLlnwKeeOb129Ju6t3
	 2zCMkCj4OKZHfvUFjTinanm2t2oJzRF3BRQ0sobK/7EZebjRpIR70tSHwNjHAEAcVo
	 hXn/COW8tAx/oAWUU7SL8hlg5obYE3oJuFa++OxPqrko+JiJD/gLhUVduqCjyp/+7T
	 QX96xsvInL7laJSob55Ir8joh70s0rpH64v9kXjddPSAV4IF9UAvXANpT0ZMsyqmH8
	 wRH0CsH+c+lKBScybPP+N69Eg7FrcYDF97ciWIMO7m+5lBZU3l0V6Ar2ZKgLSGDHBt
	 Mv4fGIOq/wSUg==
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
Subject: [PATCH v14 11/21] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Mon,  3 Aug 2026 22:08:01 +0200
Message-ID: <20260803200820.393203-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
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

