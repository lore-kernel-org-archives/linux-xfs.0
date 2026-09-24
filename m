Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6641DE19;
	Thu, 24 Sep 2026 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244114; cv=none; b=tdoR7AQJJECqnzcFIqnMs2SQqjb8e4LIWMg8dBo80iSlKn64oeIgXtuSgmYHpcMlRb3ccaKplW13+C5on+1CeWYPTYZbgY7t8ZkuABA7mLik+VsY81dx7lAvqPXKzzZJO3SjVSxkU8qe1dcVdsZc7U0HORJcjhiQsDNgbfVb7CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244114; c=relaxed/simple;
	bh=yKmrmVc/E4L4YZ3vQZRXfJj7dzndWjj/RGaT36JTeHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1CB5fEpFYJMf98fqOH3Luw15P79UN11UZC92I0GkcKUmLAKbYmWxoGh5gaaWs/ie5bGIpTjn13FyKO33Xi2K3QXz1A7PPr9QJHcL3/+T2fz48lBlMM51UJ7EAz/Cv+FArRe7/xJo9L2tgoLAar4bKKZRdxMONEhWQgPjvdTXJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hdYmmJEv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hdYmmJEv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtCisMu5sBajFUA1PlZFL6/zksexv7O/P73/h8efGdo=; b=hdYmmJEvUbUCKqTspP0feP7fXv
	xi9W6mTFSR5lm141nGB6mYe0l6cbmSwl1yn5fkSfb0+1jgv7zdf69mGFno8DOrgqDhNe8X8tTUg0L
	TFq2LKe4pizBmgGPIVSwDvA7KnKaN8gXjKGQqnM1c/hVOf4fY0J5UE+r05WgSs+qEC+dtYlBGT+1q
	yoFP7nDzocXJ19NVrY010UaadFl3V4Ay3J848U/dZRl4xHcTvh6grpGv36DsRp+n3sWcmavPXijbT
	pUpv23ICpHqTdFv6p6jlSotQi3slUw55M2/9XC8cMIpY8wjjuqr+GerGjqtX8UhWeEI9TYxc2Xbv9
	NDSH6+kg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGj-0000000AeYY-42KY;
	Thu, 24 Sep 2026 10:01:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/21] xfs: calculate the log reservation for logging data checksum buffers
Date: Thu, 24 Sep 2026 11:59:42 +0200
Message-ID: <20260924100032.2733101-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The data checksum is logged in its own transaction, and only logs
transactions buffers.  While the maximum size of a checksummed data write
is the same as that of a single checksum buffer, the Zone Append based
zoned write path can't guarantee alignment, so it might be spread over
up to three buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 21 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5382ece51812..8854253afba0 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -11,6 +11,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_rtcsumfile.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
@@ -1233,6 +1234,22 @@ xfs_calc_qm_dqalloc_reservation_minlogsize(
 	return xfs_calc_qm_dqalloc_reservation(mp, true);
 }
 
+/*
+ * Log data checksums for a write.
+ *
+ * Must cover a checksum for each FSB of data written, and the checksums can
+ * span the FSB-sized checksum buffers at both ends.
+ */
+unsigned int
+xfs_calc_csum_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		csum_len)
+{
+	return xfs_calc_buf_res(
+			howmany(csum_len, xfs_rtcsum_payload_size(mp)) + 1,
+			mp->m_rtcsum_bsize);
+}
+
 /*
  * Syncing the incore super block changes to disk.
  *     the super block to reflect the changes: sector size
@@ -1354,6 +1371,10 @@ xfs_trans_resv_calc(
 
 	xfs_calc_namespace_reservations(mp, resp);
 
+	resp->tr_csum.tr_logres =
+		xfs_calc_csum_reservation(mp, XFS_RTCSUM_MAX_WRITE);
+	resp->tr_csum.tr_logcount = XFS_DEFAULT_LOG_COUNT;
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 1804e821f382..127db4da31c1 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -49,6 +49,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 	struct xfs_trans_res	tr_atomic_ioend; /* untorn write completion */
+	struct xfs_trans_res	tr_csum;	/* data checksums in metafile */
 };
 
 /* shorthand way of accessing reservation structure */
@@ -122,6 +123,9 @@ unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
 
+unsigned int xfs_calc_csum_reservation(struct xfs_mount *mp,
+		unsigned int csum_len);
+
 xfs_extlen_t xfs_calc_max_atomic_write_fsblocks(struct xfs_mount *mp);
 xfs_extlen_t xfs_calc_atomic_write_log_geometry(struct xfs_mount *mp,
 		xfs_extlen_t blockcount, unsigned int *new_logres);
-- 
2.53.0

