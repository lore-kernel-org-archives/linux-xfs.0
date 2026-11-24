Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795560590;
	b=raIdjrQJXSi4htpz1xqQvSpLHNoVHsdMSjx7Uep5uCMTMYf0xsS3do2GcbTXRc2GhVsK
	 nIlKQHLkvHYi34mdh/gLoSyIS46jVErIoP5vYNRUJPNpDbHSD0pQbPVjNMCXLmhZI8ABz
	 pbQJYXGpXAosCml6jC9ryi7pDOSbp0FL2e5nDUSikvBX8dyNcwyrxcGKRBg9PCt0A3kT7
	 DCnyZ26DrKbkZ+fxeGNWmvp3XZflSxPUv1LleuYyNmmD8MNZb/FibJDffdcY9TmDZ8NRU
	 R4pUHykWlZ9gzuvd7CTXoPCmb/+TgGFH0Yhi6Y/7YtLCe8FhSmjejTkrB/HD14kmwNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795560590;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YV2JdqZdNOI7ycmBXV78PiZO7JzjZmcHuQmjmgwRjME=;
	b=wT7f6MmOuPsRhALFtlk7wqeEc+9AFaawGsnfSMUD+J0SzkY8+YeR8gXFAggqnRWJiuEK
	 dlrzB63KCdYQLF9wAVDT70wic+kXneC1ztqpezttKMRFFN2bEZiwkC+d/nOg3EPTo9Kx3
	 J3X8UlPk14GjBrxcPlS/zhNahBdOt1o6QPjIQUFfkrf7IddRxn4hEU72BilNTDCtNDtrw
	 vPwi5JDuOVyTpfJx9fHF3G4ObkRbOBf0nJTDZeY5QS9YI2YRSbd3+UTAOacB7jPi4i0w1
	 sZIR8h4XP7KEihd7aBAdVD/hW+ly8nPs80bhPLATeCIOXukCBEutuWolmLoD4udAZUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fVslJqv/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D644606A32C;
	Tue, 24 Nov 2026 22:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVslJqv/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795560590;
	b=c27Kr1txmcoPMSfZuGOtM1+L6Im9bNo9gOxwTqRs89lSMDpk3I12xfPprQEmpmgNL9wy
	 373rDHGmqXzx4RN10G7ymCxPxnzM9TICwc/RhnjGf9usQl8/fTuvNfVmLF2YzA7TDJEFv
	 F92nAwPddXNvAdIzefB6mwzhvkggRb8gx2Ak8r/zkS/ufWZMkDxvpRw0s+qp4VeoXtCJk
	 ZM0yIBSzVh1bRWT8FMCIdDvLCRYdiK2ZR6vsD451L+bZWU3ySjFJeUko6LfjHB4h63P9i
	 aMT9rF8qRAPw0sOot/KOLOruDKzlIUSFG4000s7ZSujArE0rgUF6BhZCqR96FaysuUA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795560590;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YV2JdqZdNOI7ycmBXV78PiZO7JzjZmcHuQmjmgwRjME=;
	b=q05SUFOYTml8VwEeeC306xW/bxepOhVh9n5zuoK+sJaPu4wpE9lQ+YTKKgmwv62MjR0u
	 L347vdN0agUZjfz7oIwV2HVr93yOtRlWHpWTebtntBDrw/Bv11P9aTU8gXASQhd+NQ2Uj
	 vNujyfXUzDlIXZqnoRDMHWl6I/fReSvEreQAHLkEMj+rY1A890YDjWIfxMRpHzCrxsKjZ
	 8YtniEQSEXDoM3IL8dXFJlRZVlk96SvMiMLOJxL6oJOM0bhkYIavgVSNLMRMQiyaUJ41A
	 Ks5OA9q5wC1SXGRHDlK1LhMvPFHs4If3MZmHoXw48m6Gn97Qa9VYawyq7dJkWzGcaSQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7F2151F000CF;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795560590;
	bh=YV2JdqZdNOI7ycmBXV78PiZO7JzjZmcHuQmjmgwRjME=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fVslJqv/6O5vS8nHFZeoHg4/d5Y4sWEbtfBih27WjfLqRbxYlHwMFnUrcptR6T7o8
	 iL/KKCKxGNZ3I45H+LMu6W9AtmLy75xrGvkdU8u8Feg4fmhNudB0PYYO9tpeGLc5Nb
	 oz3SHlX/eF08W2sLIeKOohavdJtw/Or9uODOsWMIblIy0GCZQgzrk6ZEg5kMwZNYIw
	 trQ4qwtQT5u66T8SRQ8On7va4w/lIfJ46dXrLX4pepxpirxNk1ZLPjeECu1+Cl9cAZ
	 96sHwVxqIu0fJN3j+DjI07idO77i+7sbnfPILqOlipeWc5wBhiT5VqmyQAWr84snOt
	 TGHk7+tEpVsEg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 10DAC4CC14;
	Tue, 24 Nov 2026 22:49:38 +0000 (UTC)
From: Ernest Borowski via B4 Relay <devnull+ernest.borowski.git.proton.me@kernel.org>
Date: Tue, 24 Nov 2026 23:49:36 +0100
Subject: [PATCH v2 02/11] iomap: add a helper to mark a range of a folio
 dirty
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-b4-ntfs-delalloc-fixes-v2-2-f394c800ec03@proton.me>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me>
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
 Baolin Liu <liubaolin12138@163.com>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zhan Xusheng <zhanxusheng1024@gmail.com>, 
 stable@vger.kernel.org, Ernest Borowski <ernest.borowski.git@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2884;
 i=ernest.borowski.git@proton.me; s=default; h=from:subject:message-id;
 bh=i0mxnQ4RlIZOshN7UDhDAACtyhM3XWJqWt2QLrbCFUc=;
 b=owGbwMvMwCVWzJ65uCpJ5D/jabUkhmw2kfpnRkdrvuo8To/XeT6tzSlc+Yqky/ZHC5ZwC29sl
 43vr57cUcrCIMbFICumyNLx/0aIT8i3T8vitPpg5rAygQxh4OIUgImInmFkmMbxpLUycMqCH9uu
 pJmtDvCdJ/ynqv/Ah9ser/jenT31/CXDfxdGNaWJdy7Z+h/7runOIbC/etNZ8cpLu2Kany+Z/4z
 jPhsA
X-Developer-Key: i=ernest.borowski.git@proton.me; a=openpgp;
 fpr=88FFD8544C54F6F2A65E2A8E730769A37A6214FF
X-Endpoint-Received: by B4 Relay for ernest.borowski.git@proton.me/default
 with auth_id=1589
X-Original-From: Ernest Borowski <ernest.borowski.git@proton.me>
Reply-To: ernest.borowski.git@proton.me
Content-Transfer-Encoding: 7bit

From: Ernest Borowski <ernest.borowski.git@proton.me>

A filesystem that allocates in units larger than a block may need
writeback to write blocks that a buffered write did not copy into.  ntfs
reserves whole clusters for delayed allocation, and after a short copy
into a cluster that was a hole, writeback must also write the rest of
that cluster, or the cluster shows its old contents on the disk there.
folio_mark_dirty() marks every block of the folio dirty, so the delalloc
release that follows no longer finds the clean blocks of the clusters
the write did not reach and keeps them reserved: with 1 KiB and 2 KiB
clusters, writeback then allocates a cluster that holds no data.

Add iomap_dirty_folio_range(), which marks the folio and only the blocks
covering a byte range dirty.

"ntfs: zero the rest of a new cluster after a short buffered write"
later in this series needs this, so it goes to stable with it.

Cc: stable@vger.kernel.org
Signed-off-by: Ernest Borowski <ernest.borowski.git@proton.me>
---
 fs/iomap/buffered-io.c | 19 +++++++++++++++++++
 include/linux/iomap.h  |  1 +
 2 files changed, 20 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 2eb8070e34..8c8851d16f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -858,6 +858,25 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(iomap_dirty_folio);
 
+/**
+ * iomap_dirty_folio_range - mark a range of a folio dirty
+ * @folio: the locked, uptodate folio
+ * @off: byte offset of the range in @folio
+ * @len: length of the range in bytes
+ *
+ * Mark the blocks that cover [@off, @off + @len) and @folio dirty, but none
+ * of the other blocks of @folio, so that writeback writes only those blocks.
+ */
+void iomap_dirty_folio_range(struct folio *folio, size_t off, size_t len)
+{
+	struct address_space *mapping = folio->mapping;
+
+	ifs_alloc(mapping->host, folio, 0);
+	iomap_set_range_dirty(folio, off, len);
+	filemap_dirty_folio(mapping, folio);
+}
+EXPORT_SYMBOL_GPL(iomap_dirty_folio_range);
+
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 78a1b7603a..6a6e67b87f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -445,6 +445,7 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
 bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
+void iomap_dirty_folio_range(struct folio *folio, size_t off, size_t len);
 void iomap_folio_mark_uptodate(struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		iomap_iter_next_fn next,

-- 
2.56.1


