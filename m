Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3232315D26
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=PGyE7HpmH6YpLGWmkJsc2P8ESTyWzkF608qAZayjM9L9rDEBWnMrObe3lesElZ17r0BARp2KMPNY5ZxdpPjy4a/JpjdN6yMJSqL2qbOHr5xra3ik0yvgllxbFPGPdoc/dnVkM6ZR6BiUnNN0uSl+zmRnIBr/a9kxuXgKzqh73r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=MO6yxhi59E6+r8lvYc0iZYnRuUblSt1iBj+ZSuW08C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXjXIxnkL8jjxCht8CDi+QacQ/udQUM/exwX+lPDK8FUeKrJcDubIG3kIJpZ38vwssTOcNOQhFZHPYsOu3o6ZgZ5m1WqIaKlfBQcUKwzQcxi5o1tZIgVkeIGcAUVTKe6GMxotptwp2MuIEr1HW0OuLGNZKF5P1nlnxcnY42bTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m5U5BO9p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m5U5BO9p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=98HhN+YE5XyIvO6KLplwrTZnGj0jj+DLBUUhWBSoKWw=; b=m5U5BO9pTK6c8o03d974VS0IR9
	JZ50x/KrOOd2ExgMxRGkz5SId5hhFoUM+NkdcgSMRcT3UKpuO8MFq2zPaGyl72OoVamMYXoH1Dt0d
	dDPqHX3wRHdVUd5erdp9sh/WRJQr5Vme7v1idMhKW2rk7vNVjeReQxmUdpIEQtq5pgfWGNwJgGqfk
	8EFlWdCwddKvPP+Hgszxid9/uJYMuhcW04BK3teFr1uVwnVis8lscS/N7hbD/pfv4LzP7BmFdyZVa
	0e+u7Pi7JDJf3CdW1fYtEoQgJ1pPDOsEcz4/TNIZVYi7Z3R1IIZPhRFmGXmADy6OEa8Dbsk6AOC4v
	v6567gGQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ee-00000004JbY-0Vcc;
	Mon, 15 Sep 2025 13:27:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: remove the unused xfs_efd_log_format_64_t typedef
Date: Mon, 15 Sep 2025 06:27:01 -0700
Message-ID: <20250915132709.160247-12-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 214c3a6d9683..754838518a2f 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -709,13 +709,13 @@ xfs_efd_log_format32_sizeof(
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efd_log_format_64 {
+struct xfs_efd_log_format_64 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_64_t;
+};
 
 static inline size_t
 xfs_efd_log_format64_sizeof(
-- 
2.47.2

