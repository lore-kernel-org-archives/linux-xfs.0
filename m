Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE4831352A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942833; cv=none; b=bMlv67VuDkpNj5qsK6prJfLZDr0dkLtWfp1IeV3lHv0OolKHDXu78125xnzokJs5yClTYP/iWclJBjbK5v8kHhi+CbSJclu1d4LLkEqbld+8p4LCkzASiH1M022kzw2nf70OI3QYkQgt4Sy6+eejfm1I2zftBRiB7BUKm49Tsjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942833; c=relaxed/simple;
	bh=FGSkU9TG/Ja1S10qth1TVcOcVfZyXIrpHQWxucwUZkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPkCkMLJnQP9yihmgkjM8REH2fMEE5OcQC55voUajenduvxVlo4Ktk1PwSVtip/TNwDDBehyWn9P9WhXnpNWmIyjSK8QMhB9q6jPVbK3Ie8XaVo16n9rGuI/r2W76EW05fRyYvLob4dcqsi8B/a7tHPBm/HEVzhsCNryq9i6AKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QsrjdD03; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QsrjdD03"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XzPP7Rx9KSOcXXz15Ba5cfScSjijdRH2W0tZKIiGmHQ=; b=QsrjdD03jvI9tRUwqBmvyruEnk
	QF/RSr/pTJ9dkNPeWqMR9sXKTg4uFStWkH+6KaO42651DjA0UF6aPuWj4R54b47JFAcLO0pkfms9K
	1QG0brjiZVL4l7w4kUnlOAKQI5VI1JNnObaDtCyg470VUVDetNEgy9vW9IfECPfFN8262PfarNhGU
	khnhMIBmwhLhddtGGjQ9vUtHQ5XcCOWxnjYiGcVkRkOMx8f5RA9SQk3abgwKPJp7TCbYL3YkyMriE
	pYZnSDbF3CyFi7zi2snjgZBlj3cVmpGI5rIo5eoUTvSDzNjPz7sgTT6wC0Zt+VnizDAr339AV1a7t
	FEofo18g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004Jar-1XmX;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/15] xfs: remove the xfs_efi_log_format_32_t typedef
Date: Mon, 15 Sep 2025 06:26:57 -0700
Message-ID: <20250915132709.160247-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 fs/xfs/xfs_extfree_item.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c5013951c06a..c9e3b3f178cb 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -640,13 +640,13 @@ xfs_efi_log_format_sizeof(
 			nr * sizeof(struct xfs_extent);
 }
 
-typedef struct xfs_efi_log_format_32 {
+struct xfs_efi_log_format_32 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
-} __attribute__((packed)) xfs_efi_log_format_32_t;
+} __attribute__((packed));
 
 static inline size_t
 xfs_efi_log_format32_sizeof(
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 47ee598a9827..0190cc55d75b 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -202,7 +202,7 @@ xfs_efi_copy_format(
 			       sizeof(struct xfs_extent));
 		return 0;
 	} else if (buf->iov_len == len32) {
-		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->iov_base;
+		struct xfs_efi_log_format_32 *src_efi_fmt_32 = buf->iov_base;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
-- 
2.47.2

