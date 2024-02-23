Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460DB4414
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672545; cv=none; b=gG414fzuff+VEB14OiHSJ+yV0ZK0AA8VB2NJpg1QuFSnW1K41n5QCSRgxIhxR49cXXbPYLmvRDXPBOG7pDdBM50Vc5eLt/USV8bTJwqE2eRugjd+mipJA0rTH9OKXi8shFI76dvlULPtNPodcVq0274VpmWtKagPiQNnB0lfqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672545; c=relaxed/simple;
	bh=Kq3ngQZOdEknLc/h55F4FcpvlhfXHVNzHT8XG2nsK5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vo/obORWNx4X/oed8mF1PAEvuhKybJlGtcZ74TLy4tZXxjT82wJbsdgkmbEQS6jXpJ/bLueAGBVl9m5pX75obMacaS8Ayxy94C5o6EpyIe3Fb1FNLZBYs8TACOsICEq0h9IQqmOBWKqM/H2hKCgqaovrKWdesgBRa8UR/vPnk1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RqUxrB3I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RqUxrB3I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C5qlLo8hHOkFtPjQ8HnbKKNCcAM+7DRApC8rFXKHU+Y=; b=RqUxrB3Il/jJXoTzgAucucK271
	c1nv+BVeKVK92P1WpfnBTHzNZGBhDLeCVzktefeo7RFEzbyFmp2KvI0zbxcO9yvjupZmO09g4cFae
	TLD4K/HZgbbftjZ+4O46ERDBD68sxWjMgFm4x+pugdQZT9S2psKj3GU8uOMiOJuCdphCJCgOSscdh
	v7vjLE5qcPgbf9BeRdWkWo+EEFkviOTZR9jpUK1i2xRgNcUxyraHtiZxPwrdiYVnS0pUUTJCB9red
	Ucjrit6thTjnt4gakh9YlLCdhlirfzJ+CjQ5S3j7JUs2+APtX+VlygoANbcFDfXx4k6P6ohVj4OAz
	3wji7Kzg==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmG-00000008GrR-07EN;
	Fri, 23 Feb 2024 07:15:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
Date: Fri, 23 Feb 2024 08:14:57 +0100
Message-Id: <20240223071506.3968029-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
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

