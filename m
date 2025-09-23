Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A59283141
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758601334; cv=none; b=kkZ+KIipNTUZSuldOAWfgCKpj7XuJTuRTAvuVm+62ugeITM7InyEb0DW2CioRLxP8JzVFovWfjBaWjP9T01hsMl89iGGWrR5DmPDukgC6UpJOoRYB5LB1XW9qKeCWMU0lYLWCZfUMFrHUsFGlYxpUk+ZmUvAhdzIpNKcdSA0Gmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758601334; c=relaxed/simple;
	bh=zpvEKZqLhwIOmRHUipSf1LyZBL80ITB37XK2LvCaT4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C34RsPmbY6Lf7op4i90hN2zL1IN2qOrReppxbT/V8dbd+fisuBYueG+gVL8vzAzPSt9P04mTLsg8WwxCAn3vA0eXWhsP9WwFTAruz3VCmvvvw3JeiPKNjPti3EGh0upYSVNIOuxMD8v4eJs2eAoIIMO1MtFWWWpbAw3YAb8WQmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=np7XVXeh; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="np7XVXeh"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-329e1c8e079so4603218a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 21:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758601331; x=1759206131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nDNxXFU6/HO7z5iXuMR9cVnSyuTgICPbquGVbvl6vg=;
        b=np7XVXehliYilDBlAhJdCZXRHsSa4eV3yIB3vm1tEaexFoM4zthPU49+XCWe88jd9m
         HTOC29E2ZbtC0Ybpqi7lL+PwBjAb+V420zF2u/NAjHoPcWnNAs1qfk8LloMGVSs8yBpc
         xBJcmxeaX2kskV2tXhzhT76dUJUGC4Jchm5/1aq8wjojwXQFiwkAbwLBxxPxVcclNzdO
         OAggBCuGk5YgvHo2MZqdxc3Z+5fHADOnK17xZoiKR4QlPlHSLY0X6T5ZF8fQZgz4MwNz
         S/EDRVxKzyx9js7a3VywfYN3Y0zYZ/28Uvpy/2IVie7eJ4iFGfMQtgHTON9c45ceIzPq
         Hwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758601331; x=1759206131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1nDNxXFU6/HO7z5iXuMR9cVnSyuTgICPbquGVbvl6vg=;
        b=o02m1w4cgC+W06BENAk4ANCqdJgZE0VZMQJli9lx/mGJtEBFckrXBE/eeIkLPra13q
         l5VXM80Rw5IUaIGYdDufs4Fk7aGnJ2OH8silTpVJgKAnh3xgFPWmos+t0Ekng058AyLi
         8LXDVzf7EygfVkoE/wTYhRXeD0UqrWLRmuID6+D3W1DNP46E0Iwjn/o+ZmnUaMVtMPI1
         Fw6jJ0n0upgSg937wHPB5t8Auo9vwTq/8oiQ3Yg1EFDGU2Yb/+pY8+9a4pSNRgDGN8kL
         X11XKruXOeO1/xs0WM+J7kb0Hfp4HXNsN+6bAJ3jyWgRsXOAozKa+SJxpZB8w5SYMHDI
         Obsg==
X-Gm-Message-State: AOJu0YxzxWeiPOCaiqAWrcPh24P0YlK2ceAvbVEP7aWXuYk7Ik+6iRv7
	/ESTs01ROOJx1PGNg4gXInWv9vMNRcxRsgaWeModgJilgSXLfdALTIYm
X-Gm-Gg: ASbGnct0C40o0QhrOYBdjpPDroqPMuwVy7bg/NA4IrDds++EDvr3qPWUWelYqzXlONM
	sn6B0Zf0vSIkeXCFC8xlc/IXtOjqjW+pMAtEZNtEO3TKYEWyIkmuxUOcHh1fSQVm3t088RI7RhY
	NTrV+PwRGVqeRyNkFnPqsFtRWwQP801LjGHKn8NPbcMO1QLMrd9mYKAs7t6QWyWmpjtjVal3A4b
	XSzmLtvGq7JAbgJY8kw6BarB4RV3x1KmcqnYgoGCBkXHOv5WQSALaI2IrhwAdrB8/HdFEi0vhvH
	RQcykkf3qHMiuVNA8q9g+XU/Jo3fJIaJAGspoDzHVgZuBDHQsG8KAaqtMCh/SmC9ik0kqXbyO5W
	HmhYF6MxT7nmgQDuQ+mV33ag5e8XxcVShfQ==
X-Google-Smtp-Source: AGHT+IF7vHoIXKK7ahfVkrWmvrmfXhwv4d6xCB5n1yI9ZZQycPuvOWR5cPz7VJstzs3WJ12MlmIo+Q==
X-Received: by 2002:a17:90b:4b82:b0:330:604a:1009 with SMTP id 98e67ed59e1d1-332a95c82d3mr1254994a91.23.1758601330689;
        Mon, 22 Sep 2025 21:22:10 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77d8c3adfd4sm13316513b3a.82.2025.09.22.21.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 21:22:10 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	kernel@pankajraghav.com
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v5 4/4] iomap: don't abandon the whole copy when we have iomap_folio_state
Date: Tue, 23 Sep 2025 12:21:58 +0800
Message-ID: <20250923042158.1196568-5-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250923042158.1196568-1-alexjlzheng@tencent.com>
References: <20250923042158.1196568-1-alexjlzheng@tencent.com>
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
index 6e516c7d9f04..3304028ce64f 100644
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

