Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6943D3332;
	Mon, 20 Jul 2026 09:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538328; cv=none; b=M9WH1UanrhSQdK1camaQvs3VRXC9D7sSFlAKrQuTEeQVl53KH45aJaSM9aKVs2fs9KhLPV7r9MC+8piXjgBg4hV2Zz2tQaPPjMWBsOB9CegltqvS+us9UaWbSA6DrKuYoruUJjDRdEsHeYfJ+xjGj82cttFmbf3x7dQS9J4a4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538328; c=relaxed/simple;
	bh=D8pvOb9i84Gt/+h+XnKvul7Yx8ta1LxwPWNa1Y/y9W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bobyddzLu5cXV+dalTUsEekQ/dlR9v0mfPXLmL3XMVrV21sIrymvtUhNCvhHYvih70d2f1tE5ow1gufvUdEARjrxZJ8/1yKTV7ddN/dIDE9EI4ICsExqNzYhLyEey2X+flEsTXosgpfn4jlRmvwPcOsFTguaeocGjFHX9qQB7Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5A1ewnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5A1ewnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3271F00A3A;
	Mon, 20 Jul 2026 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538327;
	bh=wjtx2lzB3uvb4xU+DIuox4Zw+1tx5e8JwgBOS4wBSrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5A1ewnf2yWgs9Ej+zVBFNx8P864V5/ghhTgdFMN6uh+7L10Qmsv3xFSwXjUQ1i0z
	 LNWk1ze25e/GK/1YvbDMY72SRoBuFpqJFkUWV11bGjp0D+NSswc+CrFpI7prvSCotj
	 7E8ElFHISr65637ZclACrpTTPsQbNBLjV5L5oE2uxHg57rLyyv2XmKpyNIYc0PG8oK
	 y8VIBJc96LWSqCI2mKDfpQsGAn56FZPxqUETkkYVnh20J4+MQYORES/9fnOMDdd0fe
	 7MUJRWZeROLbMTF5YBHFCTrYg5+CHjxghUd8e4o2zQ9CdRxgpf6uKdPjUgLeG/MmNf
	 bu1pq319TfDZA==
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
Subject: [PATCH v12 11/21] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Mon, 20 Jul 2026 11:03:39 +0200
Message-ID: <20260720090410.3487990-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

