Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876E1F461A
	for <linux-xfs@vger.kernel.org>; Sat, 13 Sep 2025 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757734658; cv=none; b=ElxlyQW04mvIUGZWdJxkZUctdskwH/mYl4blbR2CiuXx05kjz39fBQmSlpev1/cJlCnqwYPCuVUxDK7DqeT00N9Y6tw9sR6xK7z+ywCX4GqDUNw8aH4fqI5spuWlvrsh88kN7bA2Gx55+P2KyDX0VDVfq2+z7b0AYhsY30tzCmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757734658; c=relaxed/simple;
	bh=oxoLeYkcBF241PpwFv0BAx+rwkzBjJ2c1sGVHg2zOuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmC1gIekZpOJjq6EKj9gqghE1YB85B4T70uPXvYczZakq54XqA46ZLf7L6FlufVG75Pu9qiDE3i6RuE/n0I7DvS42B5iqDL0RljgHGfGaE8bzVD28+gMoiULDynzfjPC8y1Zn8OImR/QQSz7yu00nVwpv8EfLvuOalCzrDEqMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXX+SM89; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXX+SM89"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-25634c5ebdeso22701985ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 20:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757734656; x=1758339456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfcXJBZLCmfYyA3YbUkaDw3XHxbE6UhRnVQlKyLTp6Q=;
        b=MXX+SM89/q5fvlIEbup8ihwJxEILb2Dg2u8AE70nb7yrUp2R2bXRRCosZFQb9nLW6C
         csdWZPuPyy7DY/+0r9b3RQg8BYGhJj8YHnAvOJTZsNzYtENrA3Utsahl+O3St905nXwX
         eCvNvqOoDKz7cD+pOukBPM0neDLI4T5/jRlVXrgEF+pdoQ8LWNndoihtvgLBUKIUuoHA
         Yr1qjRX3Z9SIpVnNntjDAiT/KgHEGmxvlUzQzIwzp3uJLW1IJA6J09caqF0W5VfoAfwG
         DHgfji4tD/Ngbs9k8oQr/zrT3M8kz1rmY9Udvs+xFp0b8qIXw/R/cG/Er/KuJk3lB4Ie
         wiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757734656; x=1758339456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfcXJBZLCmfYyA3YbUkaDw3XHxbE6UhRnVQlKyLTp6Q=;
        b=IySXBU9t0gpm2izbzXpMVTx2UEMB2TEJK5/c/t9pMtKbm5lmEKgVGgkpREXal4YTN0
         LRsqZU46e0pq+P/Aj6YTZdqBFdwlGKlROEbf5ezSx7L/wKJTMzDpdM2sPlQIkpRoKYXF
         Fp12AOZslzzLwMzgm/cT4cl4sWWiG1REouWrUUHYElvf7iUC6P4CNdo/2+mxt1hZNefA
         l3h+K87yFlD3iIXvRyn/YaXzfcqy7zwiaI2w/mMuFfv9lSgnm9Wq9jFCsugZsZbrRrwO
         B8I2qE2jUH3jFKWFv7IHqjqit3hwZgJPlbuuabuEE/C7ZHPASCtcso3IKk6SGZPhvvea
         99vA==
X-Forwarded-Encrypted: i=1; AJvYcCVBYGSGRFS4UZwum0n8zUmpPgC9C6DuBxdXMriVhls6ybSOxupGoyfF/KymJRBp0X1SoQNtoT0C1Dw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuni9cRDQFY6CH61pMKtG0jbqXdVinJOT9lKMV6iOMgUNO7y89
	h5UlWj5m/zVm5MCfbntpCQAaoZg5/JlG1+p3KKIQuTeLiLB3tmiZ1FVQ
X-Gm-Gg: ASbGncsEyAC/1z9j10CcXzlqLGeKpOYniBhR2Q2FpbZLlJj36n/DWXIqwpMFpT/1+M9
	tskbqrCg7fKY9v7IlLp/mjxaRuVCRkWL0kaih0hCZViBECPg8RDm6HkrFf2p083cF85GrKdsgRy
	b+rCIU3CV29RykYhSK+F9QHdVIugdKdy8KFlUEqAjkjuUYp2uQ6VGijTXjSTSpwpIsN0ZFNEmli
	nAeH4HuRVMsFLjaUKzlAhAob11sP/vSNhYPCQYyUvuqySA3dIdKLeoKF4cHpXeLjTsXoXGMKCgZ
	RDWBlSWaChf7ZWCgC15fUnr04ABcje9eHGACDJDI95OQ9QdEw3IsPaqv0HdpHJNS7THvh7jgYe5
	mzl2UvFYim8rRZpygCOcTI4R7udCw5hQ8nQ==
X-Google-Smtp-Source: AGHT+IGMBnPdZGGHXedTN9wIo2T02B3lU73VKw9Kl9ZgQvq7+Z196AYaCvOiDVt6BXSPu9nMY+sLTg==
X-Received: by 2002:a17:902:db09:b0:24b:1d30:5b06 with SMTP id d9443c01a7336-25d243ef699mr61019425ad.15.1757734656466;
        Fri, 12 Sep 2025 20:37:36 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98b439asm7150770a91.15.2025.09.12.20.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 20:37:36 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: hch@infradead.org,
	brauner@kernel.org
Cc: djwong@kernel.org,
	yi.zhang@huawei.com,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 4/4] iomap: don't abandon the whole copy when we have iomap_folio_state
Date: Sat, 13 Sep 2025 11:37:18 +0800
Message-ID: <20250913033718.2800561-5-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250913033718.2800561-1-alexjlzheng@tencent.com>
References: <20250913033718.2800561-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

Currently, if a partial write occurs in a buffer write, the entire write will
be discarded. While this is an uncommon case, it's still a bit wasteful and
we can do better.

With iomap_folio_state, we can identify uptodate states at the block
level, and a read_folio reading can correctly handle partially
uptodate folios.

Therefore, when a partial write occurs, accept the block-aligned
partial write instead of rejecting the entire write.

For example, suppose a folio is 2MB, blocksize is 4kB, and the copied
bytes are 2MB-3kB.

Without this patchset, we'd need to recopy from the beginning of the
folio in the next iteration, which means 2MB-3kB of bytes is copy
duplicately.

 |<-------------------- 2MB -------------------->|
 +-------+-------+-------+-------+-------+-------+
 | block |  ...  | block | block |  ...  | block | folio
 +-------+-------+-------+-------+-------+-------+
 |<-4kB->|

 |<--------------- copied 2MB-3kB --------->|       first time copied
 |<-------- 1MB -------->|                          next time we need copy (chunk /= 2)
                         |<-------- 1MB -------->|  next next time we need copy.

 |<------ 2MB-3kB bytes duplicate copy ---->|

With this patchset, we can accept 2MB-4kB of bytes, which is block-aligned.
This means we only need to process the remaining 4kB in the next iteration,
which means there's only 1kB we need to copy duplicately.

 |<-------------------- 2MB -------------------->|
 +-------+-------+-------+-------+-------+-------+
 | block |  ...  | block | block |  ...  | block | folio
 +-------+-------+-------+-------+-------+-------+
 |<-4kB->|

 |<--------------- copied 2MB-3kB --------->|       first time copied
                                         |<-4kB->|  next time we need copy

                                         |<>|
                              only 1kB bytes duplicate copy

Although partial writes are inherently a relatively unusual situation and do
not account for a large proportion of performance testing, the optimization
here still makes sense in large-scale data centers.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/iomap/buffered-io.c | 44 +++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7b9193f8243a..0952a3debe11 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -873,6 +873,25 @@ static int iomap_write_begin(struct iomap_iter *iter,
 	return status;
 }
 
+static int iomap_trim_tail_partial(struct inode *inode, loff_t pos,
+		size_t copied, struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	unsigned block_size, last_blk, last_blk_bytes;
+
+	if (!ifs || !copied)
+		return 0;
+
+	block_size = 1 << inode->i_blkbits;
+	last_blk = offset_in_folio(folio, pos + copied - 1) >> inode->i_blkbits;
+	last_blk_bytes = (pos + copied) & (block_size - 1);
+
+	if (!ifs_block_is_uptodate(ifs, last_blk))
+		copied -= min(copied, last_blk_bytes);
+
+	return copied;
+}
+
 static int __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 		size_t copied, struct folio *folio)
 {
@@ -881,17 +900,24 @@ static int __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	/*
 	 * The blocks that were entirely written will now be uptodate, so we
 	 * don't have to worry about a read_folio reading them and overwriting a
-	 * partial write.  However, if we've encountered a short write and only
-	 * partially written into a block, it will not be marked uptodate, so a
-	 * read_folio might come in and destroy our partial write.
+	 * partial write.
 	 *
-	 * Do the simplest thing and just treat any short write to a
-	 * non-uptodate page as a zero-length write, and force the caller to
-	 * redo the whole thing.
+	 * However, if we've encountered a short write and only partially
+	 * written into a block, we must discard the short-written _tail_ block
+	 * and not mark it uptodate in the ifs, to ensure a read_folio reading
+	 * can handle it correctly via iomap_adjust_read_range(). It's safe to
+	 * keep the non-tail block writes because we know that for a non-tail
+	 * block:
+	 * - is either fully written, since copy_from_user() is sequential
+	 * - or is a partially written head block that has already been read in
+	 *   and marked uptodate in the ifs by iomap_write_begin().
 	 */
-	if (unlikely(copied < len && !folio_test_uptodate(folio)))
-		return 0;
-	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
+	if (unlikely(copied < len && !folio_test_uptodate(folio))) {
+		copied = iomap_trim_tail_partial(inode, pos, copied, folio);
+		if (!copied)
+			return 0;
+	}
+	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), copied);
 	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
 	filemap_dirty_folio(inode->i_mapping, folio);
 	return copied;
-- 
2.49.0

