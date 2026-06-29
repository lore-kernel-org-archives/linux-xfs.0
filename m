Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32B346E40
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734540; cv=none; b=mCVUhBIjPirn/+qDEJGEjwtYRoDqCoRU512kEri3AwAlkhSkwws+nHvRFK0GJJ6BLkVbTEZErsc1Wa286kHzUoP1RQr+TlGJjypjUxYBkf8lT8mcbX/5grxW+en/Cym46WmMExB4IAjmb5voMCbzJLQQmgRSK3W1J8oXN+ZAnxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734540; c=relaxed/simple;
	bh=RdoN+2mNjmLNEZV7ijHXLPiGNlA7kn9dRsmA5tBVwWA=;
	h=Cc:Date:To:References:Content-Type:From:Mime-Version:In-Reply-To:
	 Subject:Message-Id; b=G1pFyUnkue6sakaQ4sLT4FMFmaQV9199Ua0SWcDTXC0095Ro7Y0dYtOIlunJv7Bs+SLM+1J3jxC8PaQEah9gNjkkXBWRBG9DLmzYi022b3FoFk4XpbCvDpkPD2uhUJcZXBCo6AQLNSgEInL7nlw66mHU5VEip90cmZbolFHg4Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Gn14ZrxB; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Gn14ZrxB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782734528; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wW6xB+xNd+JG/sL1EjxqQkHI6kiLRVs1FvgRph25KTY=;
 b=Gn14ZrxB2M+S91oe6KKSdjCOOfzcJjkhBRJXNNn1VTJnBGes3sT87HF9eOAEzrmwPtuSOQ
 WOoJYRPA2Eb7hs90dKFX1j4BXYW8ttX34ebRKVQGAz0zli0bZf3dbGRhaY1ovAIdvHmepM
 foVmVncCjwsuL8779gPoRGbJ2/qcsyso2LLi3SgEsybI4rbZyn+wr98mpFE59hByfBnNiw
 IMLZ2E2K6kYkm7aH/wGtpNb6JZX7qzVWJeeE+hxX8GiC/wYXn/6lUJeo18DBcwYp/s9Pxi
 II4FPrNa05e68u1HlefkvzKyLYher6b0Jg5KntZ335beemIPdZQ+kPIL6eCufA==
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Mon, 29 Jun 2026 20:01:21 +0800
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Content-Transfer-Encoding: 7bit
References: <20260629120124.25223-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Fengnan Chang" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260629120124.25223-1-changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v5 1/4] iomap: factor out iomap_dio_alignment helper
Message-Id: <20260629120124.25223-2-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a425ebe+31daaa+vger.kernel.org+changfengnan@bytedance.com>

Extract the alignment computation from iomap_dio_bio_iter() into a
standalone helper so the upcoming simple direct I/O path can reuse it
without requiring a struct iomap_dio.

No functional change.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b485e3b191daf..487c4763f3fde 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -398,6 +398,14 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	return ret;
 }
 
+static inline unsigned int iomap_dio_alignment(struct inode *inode,
+		struct block_device *bdev, unsigned int dio_flags)
+{
+	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
+		return i_blocksize(inode);
+	return bdev_logical_block_size(bdev);
+}
+
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -416,10 +424,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
 	 */
-	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
-		alignment = fs_block_size;
-	else
-		alignment = bdev_logical_block_size(iomap->bdev);
+	alignment = iomap_dio_alignment(inode, iomap->bdev, dio->flags);
 
 	if ((pos | length) & (alignment - 1))
 		return -EINVAL;
-- 
2.39.5 (Apple Git-154)
