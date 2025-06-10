Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1C27083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532648; cv=none; b=ZFnGJukaw4p1l4fH8Dr6wSwuOytk9nNNGUHtwqfB6KTbhfFAlUonRF7ho25+F4V1e4wHbfO7fRAeG2oaUfuyCKTgWgO1DO37h6DpevX1RiJiefdEaYqb5XOjxHolqV4JopYdwQydKQVKfOsDtsuBHbmqF+GO7GSs8Q9ZV+Qcov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532648; c=relaxed/simple;
	bh=wz9OkMVTtf6JaK4gdS3G1EVMccvB9Y919JmFLGd3wPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHKRKcdqg5ekQyu/r4eJQQPnO0xRy0uNJPCq9GEqzDBz4ANKnu1Ub0VJKYQeQTxC+18SfcSprKs/lY/lh42MjohPCKuliaxXcH/lkxbD00ur/9lGAKrr4TweKQPJva8Y6rPE8dnkokguCPTnzfwgfVjONVZngn4673kiVE/JfWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0C38AF3S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0C38AF3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kDcrUEZBuAwxF78pdD4FoycTpQz3Uo6jpzjVDxSqd3g=; b=0C38AF3SmdonRzIoj5sU0gP4KQ
	en9oYW2gHbHZTSwDzEow3Wva8ZKSoROPZ2l557AZoGSDxQG2pFJJaZlV2sxtpuhBEluaNvqgMlnXN
	L+5k78BKA0/WqQUR0v3j8MPPMRqCFvBWeXrFNXe0VLW0+gR9M/5J4M32lQTwyqamXRW0oZyXhUWa7
	9i+fUNPN4a51AXTg5/BLPXnhHpLJz2obtMp7Kgpd0kVzcDVuD7ZQee/I8cDJRrrQ9Gyj/vR/0Q/bu
	+sPkTxgSfisiOcndoxvaEooCN/uCQphKrGRTNpQEYyLScLHK4ZTiVH5YGcD00c+eFezjzKtWiYyKk
	D7K58l/A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMU-00000005pNe-2h6c;
	Tue, 10 Jun 2025 05:17:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/17] xfs: remove the xlog_op_header_t typedef
Date: Tue, 10 Jun 2025 07:15:11 +0200
Message-ID: <20250610051644.2052814-15-hch@lst.de>
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

Almost no users of the typedef left, kill it and switch the remaining
users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |  5 ++---
 fs/xfs/xfs_log.c               | 17 +++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 4f12664d1005..6cdcc6eef539 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -141,14 +141,13 @@ struct xfs_unmount_log_format {
 #define XLOG_END_TRANS		0x10	/* End a continued transaction */
 #define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
 
-
-typedef struct xlog_op_header {
+struct xlog_op_header {
 	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
 	__be32	   oh_len;	/* bytes in data region		:  4 b */
 	__u8	   oh_clientid;	/* who sent me this		:  1 b */
 	__u8	   oh_flags;	/*				:  1 b */
 	__u16	   oh_res2;	/* 32 bit align			:  2 b */
-} xlog_op_header_t;
+};
 
 /* valid values for h_fmt */
 #define XLOG_FMT_UNKNOWN  0
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 18316612b16f..601edfd7f33c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2541,10 +2541,11 @@ xlog_state_get_iclog_space(
 	 * until you know exactly how many bytes get copied.  Therefore, wait
 	 * until later to update ic_offset.
 	 *
-	 * xlog_write() algorithm assumes that at least 2 xlog_op_header_t's
+	 * xlog_write() algorithm assumes that at least 2 xlog_op_header's
 	 * can fit into remaining data section.
 	 */
-	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
+	if (iclog->ic_size - iclog->ic_offset <
+	    2 * sizeof(struct xlog_op_header)) {
 		int		error = 0;
 
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
@@ -3039,11 +3040,11 @@ xlog_calc_unit_res(
 	 */
 
 	/* for trans header */
-	unit_bytes += sizeof(xlog_op_header_t);
+	unit_bytes += sizeof(struct xlog_op_header);
 	unit_bytes += sizeof(xfs_trans_header_t);
 
 	/* for start-rec */
-	unit_bytes += sizeof(xlog_op_header_t);
+	unit_bytes += sizeof(struct xlog_op_header);
 
 	/*
 	 * for LR headers - the space for data in an iclog is the size minus
@@ -3066,12 +3067,12 @@ xlog_calc_unit_res(
 	num_headers = howmany(unit_bytes, iclog_space);
 
 	/* for split-recs - ophdrs added when data split over LRs */
-	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
+	unit_bytes += sizeof(struct xlog_op_header) * num_headers;
 
 	/* add extra header reservations if we overrun */
 	while (!num_headers ||
 	       howmany(unit_bytes, iclog_space) > num_headers) {
-		unit_bytes += sizeof(xlog_op_header_t);
+		unit_bytes += sizeof(struct xlog_op_header);
 		num_headers++;
 	}
 	unit_bytes += log->l_iclog_hsize * num_headers;
@@ -3208,7 +3209,7 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	xlog_op_header_t	*ophead;
+	struct xlog_op_header	*ophead;
 	xlog_in_core_t		*icptr;
 	xlog_in_core_2_t	*xhdr;
 	void			*base_ptr, *ptr, *p;
@@ -3286,7 +3287,7 @@ xlog_verify_iclog(
 				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
 			}
 		}
-		ptr += sizeof(xlog_op_header_t) + op_len;
+		ptr += sizeof(struct xlog_op_header) + op_len;
 	}
 }
 #endif
-- 
2.47.2

