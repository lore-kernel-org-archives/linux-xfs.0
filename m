Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A8E4E36F4;
	Fri, 18 Sep 2026 11:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730183; cv=none; b=iTaRM6wJ0vUgUJJt/RdoeNugSp0JE1U0R1ZKmpG8T0GKnBeTYeSwsOovsbI83M7x9OzCH05RWWhBboTi6bHZdM4ki5TGhMstYZ3T7tAGmDhzCiN646pTICe/DTAIH8+veSDZDLw3Y+Lzr8vD+LVbVjf9/ttILMwtn/XqTPez2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730183; c=relaxed/simple;
	bh=kI3gumtKLRQWMTMAXEpDV7dndwtPFc184oyMWIaFzT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZN6ZROwmiUsG+ufJE2Qxa7S5bCU82JJGGnc2LKHnnDe3UnK3K4EHR2SAH2NGR4k4CbHNL8RIJ4eAgtDXO9ruJQgPk2RYuVhiZp+Mqjnys4ivRBJoqp3ucjio8BFTHrlWKDUf2rkEIcvrjWNNpKbizq7G3XMFo0whXVqUOpOxag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jn5hJOSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jn5hJOSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F83F1F000FF;
	Fri, 18 Sep 2026 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730182;
	bh=ieVuD4QM5J41nXjMBZicua2S6B/WM0wDRAu86VZATUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jn5hJOSXkhQTgxMZ6+67pbKiFhvgTmIccZbzhLTzu0r8KBX0RkNM4qMPH2MkzfDGA
	 ne0fBfp8nTVf5ivqI7cO8xRfr0ZK2L9Z5FFv+fKJCm0jUrMfASVpe+1zg5fsNNV3/1
	 7Cc/cCfQfLxOHNJ5gEqHCW5BxfQk5lSEZ7x6eradEMGfcmAdrdZzJ8HdkMGEfWVCXT
	 gWNYYax9OLLg8taJ/1L4t90bYhPMBFhQ/SryMQB4ciqybrJhink+8drBztK/mpcuk8
	 fYKhBMJ4E0JyL9UpANPIALwh5qmiC4lddny3+jBnJS4lrHWHXqnOGjVSxSNdGDYUuY
	 aarKnvL0LwaDA==
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
Subject: [PATCH v16 10/21] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Fri, 18 Sep 2026 13:15:22 +0200
Message-ID: <20260918111539.1003439-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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

