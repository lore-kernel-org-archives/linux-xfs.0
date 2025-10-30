Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C804C277C96
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835807; cv=none; b=EhITEetfiIGuJBWpzS00Mel9+si7hmg1MywjMtw1eKw+nPMnhPjDPgHBQ//IsrSc2G+i+YcB/v0+nAyj1hqJfCPH6MWhAEsz7szt+PiPS+blT07cs8Mc0ItHbpGEYwdfZoedEEL/sd/2Vg5m7hCug9ORLq/LrDpocj7+XmVIGb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835807; c=relaxed/simple;
	bh=SM82q1E1K9S4srqpOKLKM3g8dQR46WD1YkIBnlo4ebY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6uF0i3rjffq97sv/SOGzjkHbsTSj26eAThMA1835Zqu9m1gpORTJNQA+QUlmulF8yxrm16YSAES+21UNiyuLggN40yBCcqfJ+9W0xtSCJv54sBUr4hOJ+9R8khx3zkloPcm778pVa0AZYlmc2qfWTWPGXGbtblEMbjF2jYjv8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kJ7rEAHl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kJ7rEAHl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q8Id+T7mQXwRsCO+YVDmMuNXYeiUOF7avi6dSq6NpPU=; b=kJ7rEAHlUrBjuopPRO8gS2AzZ7
	mSaoJBCJhxU+PqPduS1JlWkbgZvBrjxM33LnQqnqRIDQ+dB/cqFvgwh/HJYWi/xKu3gc1Og1RD3G4
	If0eR0E0ukLkMtujtkROhYoZtrRFf8g/p41e3gjlkaKRbcwqzrRkrqa9VFUVLqaWl3WCa1fO6dxrK
	Ku3Lhdgmx8CTmbXA8XHZZVyzREiEuCqpUbYleRb4xdAM46hrzGyr+k9nPO5OOtan2biJAdIo7KSBq
	0EK2NpQOClBQqyFC7wQMVRhasMT+nNYbVOSzu/x9+4vVqLSggT7sSIXIMAOx1xFuawB5rDJHqhuGv
	nLPD/3QQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyX-00000004KOT-0eO4;
	Thu, 30 Oct 2025 14:50:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: regularize iclog space accounting in xlog_write_partial
Date: Thu, 30 Oct 2025 15:49:16 +0100
Message-ID: <20251030144946.1372887-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030144946.1372887-1-hch@lst.de>
References: <20251030144946.1372887-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xlog_write_partial splits a log region over multiple iclogs, it
has to include the continuation ophder in the length requested for the
new iclog.  Currently is simply adds that to the request, which makes
the accounting of the used space below look slightly different from the
other users of iclog space that decrement it.  To prepare for more code
sharing, adding the ophdr size to the len variable before the call to
xlog_write_get_more_iclog_space and then decrement it later.

This changes the contents of len when xlog_write_get_more_iclog_space
returns an error, but as nothing looks at len in that case the
difference doesn't matter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 93e99d1cc037..539b22dff2d1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2048,10 +2048,10 @@ xlog_write_partial(
 			 * consumes hasn't been accounted to the lv we are
 			 * writing.
 			 */
+			*len += sizeof(struct xlog_op_header);
 			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset,
-					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt);
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt);
 			if (error)
 				return error;
 
@@ -2064,6 +2064,7 @@ xlog_write_partial(
 			ticket->t_curr_res -= sizeof(struct xlog_op_header);
 			*log_offset += sizeof(struct xlog_op_header);
 			*data_cnt += sizeof(struct xlog_op_header);
+			*len -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
-- 
2.47.3

