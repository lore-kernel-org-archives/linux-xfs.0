Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC9631329A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=Pm2rbRzjEL+kRYu/ubuXwIVLymY9zIN75MDUDa2LHuHG6HCHirDaJHGlSISpdsQ5WvRFD0hD9cSSSyg7O860avcSJ6iYSbPHM5fRjVh6q4MLoVdoxwwj3VO3i0UaiuVag7aadHhP7Na0px5fcsQyCfTuGO52N59bXhA3qKFqW4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=HcFM3lTGeCXn+NruhWjtUEXucvOeEJ7KoygN/KiW/TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaGCtlC6AfwgUfgSQYZQfpVNluJkRLqC97uDIDp4CItqaUpvF2LClCWNDV0lHXe3gRqdZ0BB2JNbvKWvkZjRjUoELssDa2Cw1OWoJ6YvdQuy5k+IaZuwNdKvgNO6AVmI2OyICcY6whQRs+S9U1Z8IJhz3XG149h58GessFToexg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=faSo4Unp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="faSo4Unp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HuitrQ48PnOwOxneK4rrscOfH5m0X8VeAukxzSRmBaQ=; b=faSo4UnpzpCIAyX4dDs94b0Lwb
	mC4YxHtujI8VI7AoNqjjbFpiJdh//V3W/GIutQVrLCifa3srtrYQ6/sCx6KlfEkwwRnME/8PZqA3Q
	gsaMhsWv4xSQi8cH81MiAUmNyh59i3ql9zjMe8D4oDGZKjgCgEPlm7IFCH7MzNbmqEkLtL2BgpiMU
	XxDeA9H5cULoSRJTSInXFcVLFWPJM5pqbJidZNQCdRp5yYBKe1lkrMaJLK3D6Onn6fIsgdkt7Sx8b
	2JFVQfm0M4cOQTz1vYlWEi7MYKB8Iv8t+EwNlKWtnMih2juaK6jxUkPSG01UCTbqDruU6SvYtGn7+
	55Jgw1Bg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ec-00000004JaP-3UCs;
	Mon, 15 Sep 2025 13:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: remove the xfs_extent32_t typedef
Date: Mon, 15 Sep 2025 06:26:54 -0700
Message-ID: <20250915132709.160247-5-hch@lst.de>
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
index 2cfbadae3f53..56d0484132cf 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -608,10 +608,10 @@ struct xfs_extent {
  *
  * Provide the different variants for use by a conversion routine.
  */
-typedef struct xfs_extent_32 {
+struct xfs_extent_32 {
 	uint64_t	ext_start;
 	uint32_t	ext_len;
-} __attribute__((packed)) xfs_extent_32_t;
+} __attribute__((packed));
 
 typedef struct xfs_extent_64 {
 	uint64_t	ext_start;
@@ -645,7 +645,7 @@ typedef struct xfs_efi_log_format_32 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
 static inline size_t
@@ -698,7 +698,7 @@ typedef struct xfs_efd_log_format_32 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent_32	efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
 static inline size_t
-- 
2.47.2

