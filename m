Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F5B313286
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=fwbZswBuGviujkiN0qtMWKxSwcsPIghjtph+83LTzn7xSAPExmA5BZE4yLng06lpCaHKj6PuvAlMmUQ+w94SRcXYwPXfbwalu4UxxB8YHiVGM60YruS7oPYvzYrvHzAfo3OpCD4mLOPt3a/hizaZnpydlTuzCe6nga1MaxIOLCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=1dtJoPbXvPtf0EAfh7GPwR4uMdMU5pRwP8ucmrurVY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtLLw8tcwt7BsP1ba7G/JDPlQUGw45RQXv0f5Pl4vRDlNgo+4ERTU6EKV3ZXvGQWkYezU03QSv0+j6CrHh/R2+t9VGDgxbEDXfjZbleDJmPT9pvWSySHNbG9MrzrrgYIxNHkimFTz3/H5ljx1Ry+UqEdWLAlNA0jPAfNdj2sfX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k/HvtM9u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k/HvtM9u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O3piKmf/HEV6rFhceoX0e9ndM3NB3+/8pIJZ8vj+c1Y=; b=k/HvtM9ucfqJ0r/9lDcV4JxtbK
	pipeF7EMmhoyxa1bwX4an2LXBAz+UnXKDoNOA2PxMr1/K5666zEygfB9PMki5RlLsr7KlDK+mycgg
	RqqFLk+nKKeT51//HSSGJ5Y+sY/qfM+gtvcZ3myrPlunqVD4W4ioXrP6UldkBBpuF9ms+7Pqs+F0a
	j8uajOg1A5IDQTxR5dmXE+Pg8/QsRn9OZVGHvrG5extULP7BZOi2Kag31R+DXoKr18mh66qjr0Erq
	cF48vxAdhN63ch4eqSD0Q+aLWMQAWSG7HwjKl8EMFc26QvRqeRC5zBZXIbZMSLHa9vVUapXWKD+hT
	bJasbx7A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ec-00000004JZr-1B4n;
	Mon, 15 Sep 2025 13:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] xfs: remove the xlog_op_header_t typedef
Date: Mon, 15 Sep 2025 06:26:51 -0700
Message-ID: <20250915132709.160247-2-hch@lst.de>
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
 fs/xfs/libxfs/xfs_log_format.h |  5 ++---
 fs/xfs/xfs_log.c               | 17 +++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 890646b5c87a..e6070ad72af4 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -104,14 +104,13 @@ struct xfs_unmount_log_format {
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
index 69703dc3ef94..354e8e0114a6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2656,10 +2656,11 @@ xlog_state_get_iclog_space(
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
@@ -3153,11 +3154,11 @@ xlog_calc_unit_res(
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
@@ -3180,12 +3181,12 @@ xlog_calc_unit_res(
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
@@ -3322,7 +3323,7 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	xlog_op_header_t	*ophead;
+	struct xlog_op_header	*ophead;
 	xlog_in_core_t		*icptr;
 	xlog_in_core_2_t	*xhdr;
 	void			*base_ptr, *ptr, *p;
@@ -3400,7 +3401,7 @@ xlog_verify_iclog(
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

