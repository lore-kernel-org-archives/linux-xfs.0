Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AD1200D2
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324489; cv=none; b=azwquYb/n7UuYxaxXVDu0AX1LkTW17o4vHJ83LEQX3TYopxSLv5Uty2dkGAQfuilQ3Y7MgNomicq1Nr+Wd3jZT7wobUQwxOlcHtdjxFO26sNhcBSlUQJE19VLYGW/7+yhV5WZC+RYQaXoX0t+tX/hN5oMzRRy9wHZ1G0KZcn9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324489; c=relaxed/simple;
	bh=Kq3ngQZOdEknLc/h55F4FcpvlhfXHVNzHT8XG2nsK5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CXKPn0cbOkiiwowtA+jzQ7Q8A9HlUosMR0XU4qTTrrEVe2PvqpS0+gEWcEbLbSwqsolPOMnKp3ZFbaPDq+p1yUTQHoRjFRJyr7ZhrHenDohI01Hxx89uC8Q5UokyJ2Cj7FuVp+4SHual78vIK7mmHX49ENNo4e6f0kCwhpehh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2vM6XMyA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2vM6XMyA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C5qlLo8hHOkFtPjQ8HnbKKNCcAM+7DRApC8rFXKHU+Y=; b=2vM6XMyABeTpDxR5imwhwbS9mJ
	cExjAnTLsFGW4R/w5DWCp0vbYLSYZP+3CtYb71w2ii7uKdavQhGe/nMZkyuNXXFFx4+a0LaOllNSN
	epM2qyElX5tGQTUIZSIzO/WpH4SGNGM5qVYoiT6LxlKoNKwrB9uLgH7oadD9nwUmqTkqwHITZOn/i
	5Yuk7GMERbO0jg0SxZNGkNqJkQZWgZ/qLEF/FZr6Jc+gAGy4xJ/UN/8meyrcev/xCaNiT7DlZJW1+
	BieQNuKHU7VTZWPS6OI3xiqqU7Nr418AePVu0u4o0jziN4tQI/u91L1S6w04DXehcWEsAKH58lgMw
	zee5EfzQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEl-00000009GJp-03zG;
	Mon, 19 Feb 2024 06:34:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
Date: Mon, 19 Feb 2024 07:34:42 +0100
Message-Id: <20240219063450.3032254-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
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

