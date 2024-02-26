Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4963854BC1
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941872; cv=none; b=b9khLlox+F83LFjZO4wn7mxwQiBHZw1y2bAbA5Mggw+VeKXVk+RMU4F/nEBDqPZ3zpYaI9fyxUNhiNT/mlc/BiaEq4LrwphmRV7e+UGrl8WZf5XcJR5I29S9DaEADEUfVpmPraB9+zPxcRpXMsHg4LRH8gV1L0kXw+zTtau+LEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941872; c=relaxed/simple;
	bh=BvC79FvtMCAdHsXIFIRyBkV74fBIiprtBD2zTdMSq8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k1aXkBSWhj0qTl23skjaoo2XxcKFL2e1xzdpcCUrJ/wNN+SuRzzxLc/vC55v49dSDz+T2tKz81vTy36AEpiYE1zZE23286bqvVpVoCud14Wo3gQGAyJGeFVpav1kzQIP7FvxlxlVdCOv/FTc7PA8QGfN84BZsDbSE/zGQFE7B4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pi4KZEQ/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pi4KZEQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RrTw5AjvNqqoxCRCDgLReyYm4LY4T4qEMgiFYzs9Vy8=; b=pi4KZEQ/WDk0LOmAL+COwr/Icy
	aSx0kQphuQ5JMS17h9M3fwm0O8epMw6q68lvIdKacJu7d+1a63TdNQtpn+lUg425bWcMq1rVWHRb6
	OgqpVPvCYJCJaHGYKJNl5StT3OY/coxgUJ5PV0duzTljb3bf4jwmLcwDsyvGgPgoeoTftuqXwPjDf
	Ratb9siFAdfDG+zpF3DrjwdmfOkLciXl7G6Zly0tboiTEXU9rlEUrzXhMT4Mw1M9w6J0OZdGyB28k
	VYpLT/wntYXHAsbYK0Tkfg5qGZLElVjHgOCAIdrcXvlj//dLmmxNB/H7/+B97rF2XWqf1hOTRUYYS
	4wld/Vsg==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXqX-0000000HWtE-2JI4;
	Mon, 26 Feb 2024 10:04:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
Date: Mon, 26 Feb 2024 11:04:11 +0100
Message-Id: <20240226100420.280408-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
items") switched the XFS_TRANS_ definitions to be bit based, and using
comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
a big fat comment it was missed.  Switch it to the same style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 4220d3584c1b0b..6f1cedb850eb39 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -70,7 +70,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_RES_FDBLKS		(1u << 6)
 /* Transaction contains an intent done log item */
 #define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
-
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
@@ -82,7 +81,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * for free space from AG 0. If the correct transaction reservations have been
  * made then this algorithm will eventually find all the space it needs.
  */
-#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_LOWMODE		(1u << 8)
 
 /*
  * Field values for xfs_trans_mod_sb.
-- 
2.39.2

