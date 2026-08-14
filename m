Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E0145FFC3;
	Fri, 14 Aug 2026 09:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699609; cv=none; b=PwDHY9wiJ3sQp1yQt6AK3bjTxxr3NI2sdn5/jTRgJDObZEM1ABDyLDY+EMdAeIwAqJavhXxY4tt+Gi8sAsX47nGBbrcp0VLG5kCsAs1/KJGqJEmA0WBQPQRtItdsaA35wl/FWRw0eW9YrR43/Hlr34ylXMCEXaLcweWqh0Y7mDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699609; c=relaxed/simple;
	bh=Z8XZ4F1i0+dzAbgBp1oI3eSmoXbJKNaQ350f+zRO1Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4REvdoQw/M8D75aD8l5tVNODFAS+AC42yj599FYaNCfuMFtYeWw5dMGWSDvNS6cRcN+FWwmOIt1bpM3pzcYqYBdPk7SoKbsjyAILJNbG27W2SdfO/+GcKO18Nxc6hn6tSgp0nIyrXX0W/EiFkQXGfYWeaMM9CzU/ZIwZYZv6Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqtoLl1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqtoLl1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE94C1F000E9;
	Fri, 14 Aug 2026 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699608;
	bh=giX2dcWxgKGhap3ejBHZWfLPOTR0m2VLYbHv8ZTBG40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqtoLl1JIGWVjsvmfzz05rL/fwLue6wqzeHWtCWpIaPhh+RJSJR5BDIMmaLM9sC+S
	 tFrsXByWsr30zPcwDkKyQOYovjEe4bjbeSZGtNJVq0FPoa7Yv2ykyt5ytRyyNdbCsi
	 icOPUPmXbO2DlEzeaZ9gG7C/R/O7JueBDZHgKw1a0zqQnav9+9wp/ot0QQ460KR7+5
	 +TkX5H2e4W0C+o5WDaUqBmFHHKUeVB6qBJrAOeklTP1JLwaBQxBKDesKzWAkROZzjx
	 ZJFVt2hMPitfM7Y2xCY/FgsxK/4ck+dhLtilzZle0WUldYLjqXctmjnKrx/7NMuc+P
	 Sb8Y7RUiKQ0xQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 15/25] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Fri, 14 Aug 2026 11:24:32 +0200
Message-ID: <20260814092448.1818082-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
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

The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to explicitly
report if DIO is supported or not. They can not indicate that fallback
to the buffered IO is used in this case. The zero alignment values also
mean that DIO is not supported on this file, see statx(2).

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
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

