Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAD044AB68;
	Fri,  2 Oct 2026 22:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980669; cv=none; b=qMO2uG/KoLN9vMEy4eI3EXnohJyBsP2mXhs+20jo7s+Si94EBXXhg+/eiq/KYrUwB87rpCCEheT/DDRZ0UnACtJ1tto9BIhIBRiBTcquU0z+DNgJKnX0jJtDzL4DR3CasE0f6sjnP9MkBq6MdR9XXu1ms5YBTHDoS1Lce/H2PCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980669; c=relaxed/simple;
	bh=kI3gumtKLRQWMTMAXEpDV7dndwtPFc184oyMWIaFzT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEps0uxykNpvfiJ/w3QpqXJQD0HVZDq/Uz4Y4BQVpVgE/SN/qYflyakfgjykFEfW63twzGwz861035yX6sY7eealhyISK7b22LF4SzKf3+vJwZ0TrtBNQAhnn4FIoXX6+OiYhNdZE7W04eB/Yb0fo0EiSjCWHe8+QWaC0bFz2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laeAvlxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laeAvlxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7D11F000FF;
	Fri,  2 Oct 2026 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980668;
	bh=ieVuD4QM5J41nXjMBZicua2S6B/WM0wDRAu86VZATUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laeAvlxHHeZ6Gte499h9yTtQJvpFgsdWN+gvKWUOCNP7KOHdNtYZMYj3fwWTfNjXr
	 pq8f2uFqJbR1EKTTKCOKIYg4ZJzzWY1xpfXeMtssLVo+ORkuobos6oJOSbPBSjXp1J
	 o++FLhVXeMGL3o4k74vh+VS7vftXkT/xXEnoBM9lWPgEFxsN2pzyTDdRgLCpjYXZBY
	 RsFt2zuA1HMsR3ErbZ6Tl7OGqvcRwmsCEe5jnFsaVRnlmJJHk5XEL4Lfodf3xOToi3
	 Z786P3kwJBXjGqxIN6vxA95vzkKiO83v3Ljg2UwEAcSvAjWx9Flk3oavfJibauapaQ
	 htYUNR0YTBuUQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 10/21] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Sat,  3 Oct 2026 00:36:51 +0200
Message-ID: <20261002223705.2175542-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b07ca2a33c64..d9c25c06cc60 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/iversion.h>
 #include <linux/fiemap.h>
+#include <linux/fsverity.h>
 
 /*
  * Directories have different lock order w.r.t. mmap_lock compared to regular
@@ -579,6 +580,10 @@ xfs_report_dioalign(
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

