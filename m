Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190307;
	b=2bku7xUWHArYShJCMdw4mV/Nzv+5rnZGG9am+txoqPtf2aZcwvTrLZKcAPWJzKt6FRaX
	 wshwHFcOWyWkK7c3FxPYLSAFhq9CYL9BUTkcEZUkCEON32Eg4H4Z1bS/lUVUPijlh/tun
	 egz58rRj9XlIAYLQ2m8KlG43k8B5RK4Od6DaKYTTQcnUP192Mder80Wnxfg1S39kh5ve2
	 aDG4hljl0Gz09cAVNDU0EmFh0804yWT34g2MYXdCFswpuCxXjfM+A0giMnYwHLtwf5rj9
	 nZIRJ/yMeIe82Gbcsu3WRoQpahpR4FfSnn//CEYiPPiBFJ2Lbv0rf0md8eJywYcpXKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IBFpVegh3cvG5KRWTrl5FJ/dopz+6UOQ8z+wNXQuz5k=;
	b=v4eNZJui6SztJxIddYIss0y6nKTKdzQEiyVkC67qy6RHTfijckmmDBZ4s4Uf6SqQxkbU
	 cqVmT4cQYY5l2tO+xU8IkSB5xJBPMD4UBl0CGX1UC1UUFm/IizhDmButWZoT4EmSzqQhu
	 wTePb59nFzUaRcBNU3RR83uVjkxdg3AbTFwdWbCssmCvYl2+xChcbCmXo7kCWftAuEdUM
	 MJLa10LRkXQpsxuz6Y/dtrK+az9HJn/KPQltyDyQGiQ5jxxPXoGbHlhNi62viH6zPZLum
	 2RJaK7EKQeLO8PMrOaphw6pvXseXRNw2NUiupmDr1PFPoDqM642mPHqn2adnOTAWp0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kHi+P65q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFE1606A32A;
	Fri, 20 Nov 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kHi+P65q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E329B1F000C4;
	Fri, 20 Nov 2026 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190307;
	bh=IBFpVegh3cvG5KRWTrl5FJ/dopz+6UOQ8z+wNXQuz5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHi+P65qoqc5Sceu5nJwTM54kRQdrIxh1sYXNORrQbBMBC+t8dpxP58A7J0RNXkh+
	 W9WVXwS6xgYvBPmvBj/sHi+t4Uin0i2y8Zl4+uHDvIcso3mRCEUCefGNIAgEPcz437
	 QzdNobdOnL0LMNkYInHZGKWQ5z/hHXXHgfmBZAsykGU7vzZUgZf/hzyhxmYjfTdInZ
	 htwQ4aKr4XDN7D92Sqh8g0Pmb6nTO4Y+oja5AlyO+oJOa9tdwjrM3GGDaPitDo+8md
	 K457S8lotLbzzmEbfkkTeUEG/n5MR2wuj3CJtZZL7aqeQVGBUiefTwDJGQsiy940um
	 FJNtI7OxyHaUA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 04/15] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Fri, 20 Nov 2026 16:57:38 +0100
Message-ID: <20261120155752.192025-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f5b3cbe7dce9..ff34f392dd55 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/iversion.h>
 #include <linux/fiemap.h>
+#include <linux/fsverity.h>
 
 /*
  * Directories have different lock order w.r.t. mmap_lock compared to regular
@@ -579,6 +580,18 @@ xfs_report_dioalign(
 	struct block_device	*bdev = target->bt_bdev;
 
 	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
+
+	/*
+	 * The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to
+	 * explicitly report if DIO is supported or not. They can not indicate
+	 * that fallback to the buffered IO is used for fsverity.
+	 *
+	 * Return zero alignment values which also mean that DIO is not
+	 * supported on this file, see statx(2).
+	 */
+	if (fsverity_active(VFS_I(ip)))
+		return;
+
 	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
 
 	/*
-- 
2.54.0

