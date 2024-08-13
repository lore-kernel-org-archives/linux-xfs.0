Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC9E4963A;
	Tue, 13 Aug 2024 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534536; cv=none; b=VM0CyDdh+kWf1F2oPjesBQ0SfGY6UfvE+xSX7+gVYLL+1pfxxEeiGn7c1NgbVKTJ2LXEzDONgmcW9eu2NbiC9ZcFWXwwNcosL4CwVLRLMHmRxWhIp4TqMrQztJ77ydzcRBz3kY4g+WblWy/eVd5FlfbMCHqGJjftJhARa2d2zPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534536; c=relaxed/simple;
	bh=6INRYbxyBaR90slWHt6AhzRSHNLCgqRi7avmBq7uSPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuqIvtDx9mxrVBeVko/XqUazatJEqOcs53Egg+UEyerqXU/A8uVI8Gm4dTEFSe8nQ6hyYgSI71oNzuLSfWg5gxoDTCL7TSoG8dWRNUJe+8sLjBtLFXRq6jBUXE9EYjXej4ZrEzSn1QOMlCcDC0yGKHOYt98z/yQzgPTRHftCoG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aoO1FrCS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aoO1FrCS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TKTq0g56Eciv+dfxSKJq7N+C4sB833hjuPkCX2eOkug=; b=aoO1FrCS75toEs1iFxwJ5Uvcpt
	OX1NsbJfOt4YBk5egdD7EOdGWHLZa57cJ8sNWG52E3qpnKqYGm5XTX0t0fQs8svvBlenfwPYi28AR
	QmONowwTojoSJ9oXwAyHewNbUF7kRwpXmAYsrpvdIgsOhgdHPUgnY4nZ74woV3Ba4+ZDsWIqTigaF
	KSnXeXIE4ZHenZN9Yw+7sMRHFf3XFV8TgNoeW+98V+uWolK3bM33iD3De++vadOmbBYwKPKp6yQ71
	E+zz2A3wBP1jq2R0QxvitXGeZipQS2omdS79MYjqTgfTXZSR7A56fwZjuBmeM8LZmEwBS2lOtc9+u
	m9xUDpHw==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm45-00000002kVv-3jsu;
	Tue, 13 Aug 2024 07:35:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] statx.h: update to latest kernel UAPI
Date: Tue, 13 Aug 2024 09:35:00 +0200
Message-ID: <20240813073527.81072-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073527.81072-1-hch@lst.de>
References: <20240813073527.81072-1-hch@lst.de>
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
 src/statx.h | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/src/statx.h b/src/statx.h
index 3f239d791..ab29fe22d 100644
--- a/src/statx.h
+++ b/src/statx.h
@@ -28,8 +28,6 @@
 # endif
 #endif
 
-#ifndef STATX_TYPE
-
 /*
  * Timestamp structure for the timestamps in struct statx.
  *
@@ -44,6 +42,7 @@
  *
  * __reserved is held in case we need a yet finer resolution.
  */
+#define statx_timestamp statx_timestamp_fstests
 struct statx_timestamp {
 	__s64	tv_sec;
 	__s32	tv_nsec;
@@ -87,6 +86,7 @@ struct statx_timestamp {
  * will have values installed for compatibility purposes so that stat() and
  * co. can be emulated in userspace.
  */
+#define statx statx_fstests
 struct statx {
 	/* 0x00 */
 	__u32	stx_mask;	/* What results were written [uncond] */
@@ -102,7 +102,8 @@ struct statx {
 	__u64	stx_ino;	/* Inode number */
 	__u64	stx_size;	/* File size */
 	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
-	__u64	__spare1[1];
+	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
+
 	/* 0x40 */
 	struct statx_timestamp	stx_atime;	/* Last access time */
 	struct statx_timestamp	stx_btime;	/* File creation time */
@@ -114,7 +115,18 @@ struct statx {
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
 
@@ -139,6 +151,12 @@ struct statx {
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
@@ -157,9 +175,11 @@ struct statx {
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

