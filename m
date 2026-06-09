Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECCB3E9C21
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991634; cv=none; b=gPqzzLJtrG60fbgrZmKNrRndcWId17rkoBHzu8sG4bq4QWhze641ksIQjYua2FrxopMTKyO6NaZvEqeSzUeU4WzQ6DLMdKG+8JwHC0yN1ezszm9KbT0726fUxwER5qclCm2ma5ZJn0YjEjJhZyeiz1w6/mfa62LDUfyueY2H2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991634; c=relaxed/simple;
	bh=eCBhZxUtrHqdi0WpQJ/p1+SqctcFveyLDHdiB5DI+PE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aDw1KH1dIlPWaxcoR0lD8BMipCL5MOH+gLSs7zPV3+MJKcmSLJHL+taRq1dsmTgmiioKTurYI0TLwQ3tFBP4++SCtAyF8ZZ8MKar7FuvD4DgSv/xUoMuWR9o1QSingLolC8DqkenJnv5dROYQRORV3H7LvOu6eq/N7Mzfh/54Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dVQycRgu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dVQycRgu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4A6DKwb3A6JqKAlZL0FJBhoi8yNONXKbVxu8KLK9fv8=; b=dVQycRgunlrHlAK6h3LHIYG9ZG
	Vx+aUlGMla6mWIK4Ele+jD1KBBjWfyCBdxKSmpxBZjfTFw4L0KDzKWuVkQgo+4849qIqLZmc6xdIT
	MUEPgxo5llyHq9T5/EdJlX/GSp0QeOWhCzSohmG61/LsbQFA8P3lmCZ/wkFUhwceL7SlIjaBEiDA5
	s+dGkujF+2lluj0q7vwpb507pWmzkl6MkLL018USKEwuuGIyLoWOf5uoJjmJX34sMJbdBPwvf/4nP
	WzIt7PQgk+EwIbhGa6C/5CfEBzxN00NeLtcdUUT5RPfgjPk3tGSJX+3TVE1IjaQdLNMNGPxLqHmSG
	U1IPQ2Xw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrHU-0000000509B-3wRB;
	Tue, 09 Jun 2026 07:53:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
Date: Tue,  9 Jun 2026 09:53:44 +0200
Message-ID: <20260609075350.1698528-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise we lose the IOMAP_IOEND_BOUNDARY assingment for writes to the
first block in a realtime group, and could cause incorrect merges for
such writes.

Fixes: b91afef72471 ("xfs: don't merge ioends across RTGs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..1403d568a442 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -113,6 +113,7 @@ xfs_bmbt_to_iomap(
 		return xfs_alert_fsblock_zero(ip, imap);
 	}
 
+	iomap->flags = iomap_flags;
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_HOLE;
@@ -143,7 +144,6 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->flags = iomap_flags;
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {
-- 
2.53.0

