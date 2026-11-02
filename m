Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630540;
	b=lripPpzCWAduDGCvhjXxCd+Yu4Ka6eaiHKc3mrbtzUgf2dy7ansJsa9rG0Ff06VJvlBw
	 PPkaMX0zU+wqyI4QAF4XNw6NZ5tbECblSCkE/RgaNsvQr/9qfo2BUl4cxcXfUGhCWZ8Ik
	 BUIEM3MGimWBOAgGI8WYvT+gYJlYGVpN59c9aCFkA/reYj6DTCx6hM/wkSVQgAn5OH/28
	 0C4X9ANT7u3BTqpp0xxTkTR3d+kT8l5FusnnUnOfv0d+VGMmeXP5wScwCIJQIvNf72YYO
	 D30gT2x/45i6MmqcOSfskRfWN1KIPXM4kh4+yOst7U46NW46qzHQpgWr27H5MC03fHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=scH5makfD+kPOCHKz8ax+TaK5RFmTgNMd72fLm9fceM=;
	b=NVS5JohvPtmAKBOPHR8vgRvExNo00wrkZobVbZwQflE0IHNpuyeAoH/IxzLcWGfZj+9m
	 rBu6n+VLikn02CV/M4JJmU3jUb7omit8kmkwraOTuNauwZ1RP517mvqMgd5bG4ZISt0Ji
	 3UW82U7jIGBU2gVnQdB6CoTuD2spCyT05+OGK9Zd3znN4+Qsa/+Zp4+wADOnanFAinsmq
	 wAzcwjOconWFBCQY0Sg3pFMfbPD4HNBV7zHzlowvInGDsQbhPwowMIGj390+1nZizwbkQ
	 qm4ecJz17FHAGWxs1YLVbzM252X6IrKunimvUyJZkAyVhUTekXzPf4lBePZTVVK/uPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="mvMsvT/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C3607E0C8;
	Mon,  2 Nov 2026 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvMsvT/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA281F00A16;
	Mon,  2 Nov 2026 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630540;
	bh=scH5makfD+kPOCHKz8ax+TaK5RFmTgNMd72fLm9fceM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvMsvT/kRdNf2NqLe9WPQ+J90fXPhWv8HzMDZ5M973lvs5QogXhTPAQzAoZeQP0EL
	 lAjD3mlL67nyB2u8+GwTERwThNbYfRU+Tj65LjnZxp2KieYS8Jq+PzL4sX8vlg6Al4
	 wZZ2eMlBiF8W+sW2yBxgHUPkXv90n8JurrM9Aiq+b7teWh1h65hYoLrNQOj0NSTt9e
	 SrjeXiRuNGy5kB3ymOfuwJvfH7/gDMJc8dB0WxvHGwDwe0yp/XwDZmITys5l85nQ/E
	 2TGTUEBIp+hpfTttCAqpql+pPZW8/aOXlAUeSHixaY1NF8OdU6s/6HxeqtwYMr7/tw
	 PrX2gPj0qAinw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 04/15] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
Date: Mon,  2 Nov 2026 15:41:34 +0100
Message-ID: <20261102144147.2393369-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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
---
 fs/xfs/xfs_iops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b25a0c2fbd2a..150bbd705807 100644
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

