Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9CC21019C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532633; cv=none; b=B5kpqILVw3ESsNhQ1sPz5bT4+iNZx36n+96fn8BE7w+ocfZWVRXQ//W8wsEHSFXFfUHoKF7LbfWTS+fVCDw4yZn9a8TSJTBH0l5o2JC+e1JpRdGnfF2CjbRhRzuJ0Nm2l151AX2Ls7HVokTslZuTu3CZNl5VmnrpqfZ5V1Kn320=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532633; c=relaxed/simple;
	bh=f+9aFz/P4LtG5hwLOY0WTP/KF52+5zcC3MYeiyBKm1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAgw+Bo9rYZzY339hn+ZFJ15T2ZRC6UaaAAwTDYC4iFxPwJI9JJ9CE1evBJbo4ZxUKjvJGiXbL1E7yO/YJEsmsBNk6fQtZK7pHaXtfkmWTVqYmxWKaq3gt7Q8pjXZaoXWFQ25uq4cgXEVNNrJ7MTfgpgpSim7B2Koc9GmITbaGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R5rKqYtn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R5rKqYtn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F6ylnDPaY53/6RP3vN5MeXRwZazpu3E9pAt8eGWDZuA=; b=R5rKqYtnSsdjuycdFULJUi77km
	nTw326HsSa4O/Q2wSbGD2dGPcAIFdgDQpkiMdwmQ00ssD+MJn0JPO+hDuZlVD9lotxLCje0SwrxEx
	EtBr+hAZHI7XCRYRYcPdEwikBgfWQXW1KTkEFeDnHzerDgZ6Wu1zG6bN0OOOnuRLWv3poIw9Tl+OB
	vE3krvX58m/G0lhG9LaJm9PXTKJFs9gYt2DoVRQTF088sTBpLmycTi4+JpKKMA9lx67CoTzxHvu4K
	d0q0hGKn4odE7SmGonJX7bya3nA0ttSqxbXaiLpPNudKmm7+rEpizrJ3coMT50LycQB+mF2oyBiMF
	sJpZ6irg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrME-00000005pL2-45i4;
	Tue, 10 Jun 2025 05:17:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/17] xfs: special case continuation records in xlog_write_region a litte less
Date: Tue, 10 Jun 2025 07:15:07 +0200
Message-ID: <20250610051644.2052814-11-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xlog_write_partial already needs to add the size of the op_header  to the
log space reservation requested from xlog_write_get_more_iclog_space.
Adding to the len variable tracking the available reservation instead,
so that xlog_write_region can unconditionally use the reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 223f08a50ca7..00b1174d4a30 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1912,8 +1912,7 @@ xlog_write_region(
 	ASSERT(reg->i_len % sizeof(int32_t) == 0);
 
 	*log_offset += sizeof(struct xlog_op_header);
-	if (reg->i_op != XLOG_OP_CONT_TRANS)
-		*bytes_left -= sizeof(struct xlog_op_header);
+	*bytes_left -= sizeof(struct xlog_op_header);
 	*data_cnt += sizeof(struct xlog_op_header);
 
 	ASSERT(iclog->ic_size - *log_offset > 0);
@@ -2104,10 +2103,9 @@ xlog_write_partial(
 			 * consumes hasn't been accounted to the lv we are
 			 * writing.
 			 */
-			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset,
-					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt);
+			*len += sizeof(struct xlog_op_header);
+			error = xlog_write_get_more_iclog_space(ticket, &iclog,
+					log_offset, *len, record_cnt, data_cnt);
 			if (error)
 				return error;
 
-- 
2.47.2

