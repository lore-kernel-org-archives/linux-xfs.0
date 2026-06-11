Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9654F3E7164
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781178060; cv=none; b=agA829RbAl5orJmc54ddUpoqi1R6Enu+2r8z3f4AcLjFkgNZL3+2WmMaSFS4FOlsCFuw9i5yf0jssA70f2jXZiHZcDvBz3dqW3rmJIwWar4DTCqIAaTADKkjqJvbqjEhn3VhU1uZt2wDicAy2DOXypPxWt1R3+COSZwZs3Gc8kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781178060; c=relaxed/simple;
	bh=Ie4LrJB6r5P+WavpUCXn9K+vL1BG83kJLsMOJtqzUys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4Jx3IWyfEZ00wC01RHjUN6lYzjXWzw/mOcTrN1/9Z/lb+IqV7HJa/x8/o9Rg0+n55aiic+WXeP2oe/3Scv5s/d1az2i8RucpHiavMaOyVOU6EHuBmqwbrtnMZnjw7Itc7l6RmMF3yDvxumexw5vdJFO71k3g5sphcGFfPZW2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4gbgh11lh3z9tWl;
	Thu, 11 Jun 2026 13:40:49 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	hch@lst.de,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 1/3] xfs: widen xfs_setfilesize() size argument to xfs_off_t
Date: Thu, 11 Jun 2026 13:40:27 +0200
Message-ID: <20260611114029.176200-2-p.raghav@samsung.com>
In-Reply-To: <20260611114029.176200-1-p.raghav@samsung.com>
References: <20260611114029.176200-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gbgh11lh3z9tWl

xfs_setfilesize() takes the written length as a size_t, which is only 32
bits wide on 32-bit architectures. The upcoming FALLOC_FL_WRITE_ZEROES
support calls it with a 64-bit fallocate length that can exceed 4GB.

Sashiko reported this[1].

Widen the size argument to xfs_off_t so large lengths are handled
correctly. The existing writeback caller passes a size_t and is unaffected
by the widening.

[1] https://sashiko.dev/#/patchset/20260604101442.2613872-1-p.raghav%40samsung.com

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/xfs/xfs_aops.c  | 2 +-
 fs/xfs/xfs_aops.h  | 2 +-
 fs/xfs/xfs_trace.h | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1a82cf625a08..0766c5667b95 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -52,7 +52,7 @@ int
 xfs_setfilesize(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	size_t			size)
+	xfs_off_t		size)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 5a7a0f1a0b49..d8c4051f2a85 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -9,7 +9,7 @@
 extern const struct address_space_operations xfs_address_space_operations;
 extern const struct address_space_operations xfs_dax_aops;
 
-int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
+int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t size);
 void xfs_end_bio(struct bio *bio);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d478693674f9..d5b50c033873 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1857,7 +1857,7 @@ DEFINE_IMAP_EVENT(xfs_iomap_alloc);
 DEFINE_IMAP_EVENT(xfs_iomap_found);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t count),
 	TP_ARGS(ip, offset, count),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1865,7 +1865,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__field(loff_t, isize)
 		__field(loff_t, disize)
 		__field(loff_t, offset)
-		__field(size_t, count)
+		__field(xfs_off_t, count)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
@@ -1876,7 +1876,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "pos 0x%llx bytecount 0x%zx",
+		  "pos 0x%llx bytecount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -1887,7 +1887,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 
 #define DEFINE_SIMPLE_IO_EVENT(name)	\
 DEFINE_EVENT(xfs_simple_io_class, name,	\
-	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),	\
+	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t count),	\
 	TP_ARGS(ip, offset, count))
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
-- 
2.51.2

