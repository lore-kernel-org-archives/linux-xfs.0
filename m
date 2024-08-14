Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F6C365;
	Wed, 14 Aug 2024 04:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611159; cv=none; b=FchudBjXI5iVGTkh+AlzVpEiZcW7vpysfoX1RhyIz1zSkrjTB5KfYjTq2xPvVvIhtEJiI9se3NaYGuClHhvmiM9bn/OZYUYhjHKzVN5cHtXfXFdnlk2moMn3rBTHqFJSL5JyF4AcdtKmjvE6o7fp4sFruwkAI7aMsmDHjwdPigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611159; c=relaxed/simple;
	bh=TyshqFx55BN2h/ekFelHp5JkOa2ChjyXWhHLZJSrQG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amW2grvV/bgkAmzhZgVdfH5ALDFz4tsu4V4oDHT4IPRWogm2STIbb4UyZGbjf0WNFJyMCSkUyLv2jruFlsKKMMn0VTQXRSoZ3bXfIu1tfW0xoSlK28wnavi6dkOeQvuz0MERHD4TjXucfRKjFidjU+z/34UOsTxKzIYH+bnmszU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ka9TfRWQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ka9TfRWQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nz/icJZIWEQmfZWtHl4b92sQ8biRSWlO73Zg7iEhTr4=; b=Ka9TfRWQsHJ8KxdlOdcwp1DpE1
	kFEDccLUKaHkkKeZVrf+W0nTWwFw4D+ktws9eXhW8D0syn+FjA4VeM0Mu+2Jiqxm62q7ZbMBwCApB
	CzvshORPmPEp1NwIMgX+N5aOhCdq9gMerAgtQWeoEdhlkJ/K3ZnERDx8XYBTtbv/AVq1Dk/GXpGTu
	0Qr1A1mRhJ7dltxLJHldMVTPcPs36SOvQPb49AkodwkhiDW9fgKsqw3RmA3YtaBVHKwG7VJsb7XF8
	jDkEG5uIppBZboMK5tNVLp881rbdSrwc4P936hql4h4hlXOAoyv9EfL+uY09yXPpR+ALXQSXaRvl6
	IGrd0rFQ==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se5zw-00000005jKq-3e8O;
	Wed, 14 Aug 2024 04:52:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] statx.h: update to latest kernel UAPI
Date: Wed, 14 Aug 2024 06:52:10 +0200
Message-ID: <20240814045232.21189-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814045232.21189-1-hch@lst.de>
References: <20240814045232.21189-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Update the localy provided statx definition to the latest kernel UAPI,
and use it unconditionally instead only if no kernel version is provided.

This allows using more recent additions than provided in the system
headers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 src/statx.h | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/src/statx.h b/src/statx.h
index 3f239d791..bae1c86f6 100644
--- a/src/statx.h
+++ b/src/statx.h
@@ -5,6 +5,14 @@
 #include <sys/syscall.h>
 #include <linux/types.h>
 
+/*
+ * Swizzle the symbol namespace so that we can provide our own version
+ * overriding the system one that might now have all the latest fields
+ * under the standard names even when <sys/stat.h> is included.
+ */
+#define statx_timestamp statx_timestamp_fstests
+#define statx statx_fstests
+
 #ifndef AT_STATX_SYNC_TYPE
 #define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
 #define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */
@@ -28,8 +36,6 @@
 # endif
 #endif
 
-#ifndef STATX_TYPE
-
 /*
  * Timestamp structure for the timestamps in struct statx.
  *
@@ -102,7 +108,8 @@ struct statx {
 	__u64	stx_ino;	/* Inode number */
 	__u64	stx_size;	/* File size */
 	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
-	__u64	__spare1[1];
+	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
+
 	/* 0x40 */
 	struct statx_timestamp	stx_atime;	/* Last access time */
 	struct statx_timestamp	stx_btime;	/* File creation time */
@@ -114,7 +121,18 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u64	stx_mnt_id;
+	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
+	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
+	/* 0xa0 */
+	__u64	stx_subvol;	/* Subvolume identifier */
+	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
+	/* 0xb0 */
+	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
+	__u32   __spare1[1];
+	/* 0xb8 */
+	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -139,6 +157,12 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
+#define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
+#define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
+#define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
+#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
+
 #define STATX_ALL		0x00000fffU	/* All currently supported flags */
 
 /*
@@ -157,9 +181,11 @@ struct statx {
 #define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
 #define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
 #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
-
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
-#endif /* STATX_TYPE */
+#define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
+#define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
+#define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
+#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
 
 static inline
 int xfstests_statx(int dfd, const char *filename, unsigned flags,
-- 
2.43.0

