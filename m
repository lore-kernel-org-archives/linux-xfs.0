Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D331329C
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=VA15Rk6Z70Mb6VcSLtO86nYkkCCJjcZnWH36pDcW8Qpe9YQJ8g9xblVpN6VxNyDuX+gtuTSaK6tLTWgjqloan0UoIxx1mbWHCCDPwh8kkFbFbKXzmnP11fGTwqFE9EXlSW75l078xEXCdE8v54cU77cmXb0kulwQu8lGXnAKjfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=9aBRPwiya0ndt1YU5xTFfkHpvQDhr3M9zvyhoYqrbqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyBQ8BHxM7jZFl6+/aKOdtjj+JUWsMYIRERtKZKZfBBvuc74NjUpytYK3ZjsOwIgcAHhBuQxR4xzmdyAG9vmAtstcjJONnNQ1O2qHtaFUqZ06CH0f7V00XhiIUSmjYIsXoURFsW4hySaw3cm0q548Lf+Uus2m22nF9e1rKUUljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qjadvT9j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qjadvT9j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XgORcZoTJeEY+SAju/kR/SYbAjm0na189V6LIVl+gJg=; b=qjadvT9jbkbyf0Akd6VHMVA6+X
	8+54FriPzHtPFnn4L0gBSNRChyx/H1w1XaEsA/nbUxwLj1mtR4x8/HezxkQwyfE3VJQ/Kx5BGqDi8
	bLNrwCOsnZSpDcLa2JQxsEm7RfTTts3k4VRFpzfBtZ/gPF0gyeK+FMe0tjv4aFUf5WgC4mit3AelV
	hLQKQDcTEgOKWVloj6lXDk/9+N+Zp3z5zfRGUURdKZfxvHkHXA6kaSjN5BLc6IGyjH3wmB1UHJwXq
	urnCQvMERPtBjhd1rIUJDXCMS9CRoGqPtfxs0IsZQTFzqUZLAtus6/DMamf5Mx6fIFKCZt6RZPGJf
	rJLoq1Zw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004JaV-02Ji;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/15] xfs: remove the xfs_extent64_t typedef
Date: Mon, 15 Sep 2025 06:26:55 -0700
Message-ID: <20250915132709.160247-6-hch@lst.de>
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
 fs/xfs/libxfs/xfs_log_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 56d0484132cf..c6cb41955088 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -613,11 +613,11 @@ struct xfs_extent_32 {
 	uint32_t	ext_len;
 } __attribute__((packed));
 
-typedef struct xfs_extent_64 {
+struct xfs_extent_64 {
 	uint64_t	ext_start;
 	uint32_t	ext_len;
 	uint32_t	ext_pad;
-} xfs_extent_64_t;
+};
 
 /*
  * This is the structure used to lay out an efi log item in the
@@ -661,7 +661,7 @@ typedef struct xfs_efi_log_format_64 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
 static inline size_t
@@ -714,7 +714,7 @@ typedef struct xfs_efd_log_format_64 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
 static inline size_t
-- 
2.47.2

