Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F071EDA09
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582720; cv=none; b=lHqhoIkh1bK/E9wITw8NY6NJWSP/Jg1rjUUMwmo4peyaEHLTLfflFQ4DQC9BDFf1SASPv9Ax8cHOEKzpnCIE+9wfwL/dNgPVBObRUqvh0k8XePtdu+IjjcGOrWlsetnBAe23Yq4h8XxNS9dUm50/KFfquQVp28QcGjjsRqThTes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582720; c=relaxed/simple;
	bh=LBLAZ6HhFNJfwfVhkf/KVVIXhsHcgo0t4egaqp5Q+80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge9YPYNjrqMujtjwi3ul4y5Hu8LtPMWl0roTtElh8UsW8GmjIpnHyvXeClOsTXaOY5FGYyfKuBefx7AGmXtgTt/u8Ke/3izTu/k6Lg0gwRN5zqHgWDwacOPdJhrY3Z5VohzwY1SPWKaN+etzbIPKxke1D6qFBGweIpJkwH48eIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MQfo8GPA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MQfo8GPA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fp+ZVFjBBIQNTxEZ0Kezn2LngHa5YCZzss7ReJfuuE4=; b=MQfo8GPA2H4bH/tXJDnO1j2E5T
	yoP883SCXEhOBq7uz1KNC1gPfxWC7RtkZ0cIJbsxKuSetqGJi7q1x5a6OBN9w6VsBiD67Ckv7/o65
	/M6+s7tancXLvn8Y2A+NKkG7W2u1YJF+kBLrNJy9OqWPGbwizGD2Lnr2CxQLjj3vnYm9xNDJl0x2z
	Hg9sf3mCN3rEHuCfKFgheTfQmYwPcmjLe7f63SAmZbTsi7uchiUs885Hmmc7NRCPmWym7NLoDtCYe
	75m67oLAOq5jA1tWlC291SdGbvtQbXfJRYdU2rOFz/EmbRzZ+C49U2xbTK2WQTPxE0j2svtcrTlhe
	mejAbQOg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepC-000000054sh-2a0B;
	Tue, 15 Jul 2025 12:31:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/18] xfs: remove the xlog_op_header_t typedef
Date: Tue, 15 Jul 2025 14:30:16 +0200
Message-ID: <20250715123125.1945534-12-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
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
index 621d22328622..aa7a4c7ae49b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2608,10 +2608,11 @@ xlog_state_get_iclog_space(
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
@@ -3105,11 +3106,11 @@ xlog_calc_unit_res(
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
@@ -3132,12 +3133,12 @@ xlog_calc_unit_res(
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
@@ -3274,7 +3275,7 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	xlog_op_header_t	*ophead;
+	struct xlog_op_header	*ophead;
 	xlog_in_core_t		*icptr;
 	xlog_in_core_2_t	*xhdr;
 	void			*base_ptr, *ptr, *p;
@@ -3352,7 +3353,7 @@ xlog_verify_iclog(
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

