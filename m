Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782808;
	b=mbB0EtSWdE0uadisd+WP6RtkvLtSPhbkNdSqEbKRla/1gn7/LHq0qgiDVtgeu4wUgooc
	 5dlunEXjy6TLSals9PLhwXsr0oN1WmKIQJw2d78IGmwO5Khf6E9W/jdqBryAFuG7YuFcn
	 7esy4TifyTawiM2bLVSh7QqJ0yMd4vSG8zh3R7LbMRZvFM+cdWsrNERxSf+jhxBAl784Y
	 8X2MFEWgsE26xsLNBYP4I6fOtxHYRHNDq6yvBv1ZIkzhRYRKAZFKHb7IwSV1/JR1M6RQ4
	 yeJ83XLqZnqUvLtY/ffmA/+/18vFS9egYzSS8OPvrr0SjuPlWZqACev4YFd9d3tOY1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782808;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=oTeUtPEa9aAfP6RlCq9QFduF0XyrniNu4Ye5Y4RGKLs=;
	b=OzMXUu14h5Fn9Gh7UPGK1DqAgBwYYmLEb3om0y/Q/+zy0JEx5TqXQerLEdKFprW0RDy3
	 48ZVkJXh1lq5igNF0oW72XDWoQur23MvYmtyaqGDhV4qWPeJHrej5CGuSLT4Z18Crb7K0
	 /40EZudhv8Uwv4hSUK2+7qBKhs9RQb1E+LGATdeNg3E0AmVlvRhkQMfgQnCmrQ/TSOy8C
	 IhKkhXPyITqzxdSWgt4J8XPQ9L6/w9YToRd843wEgkpA5HLgbv5ZWzveXJ1Y/UrwahYek
	 VvfEE8wXHSjNSq4RbE9EmyHhiJNWboE8m29Qp7SCleNBb6up03+7lAc80gpbmkwDp8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=07hZFkeg;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4364606A332;
	Wed,  4 Nov 2026 09:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4364606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=07hZFkeg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oTeUtPEa9aAfP6RlCq9QFduF0XyrniNu4Ye5Y4RGKLs=; b=07hZFkegzr5r8D0FAYMTM8nCnr
	O6Zn/PQ88E5aSIfJ5eUdKiz5fgdd2HbXxfF2nKakKPoPRZNrr2Q0XZ2v1S/8WMfcQR58ncHipw2sQ
	pi2/YnYBhyzjZApiBHwoPluds9D8eX5KgzwaQDR64HS3Y8bIu90wupxSLeXHujsrKQ0MuNxlJ9S9s
	ZF8N25c8TJbUoe1KD0SJuO9/qIAd6/RuDho01qK2P/OcoDcxj3ehhiQscuvxW2+MNUpVZvvd3tJtj
	Euh14ihXWABXhoZ6v+F7+frrO0MdarBUVRspgETscZb6wOfhY+J15YyAV+pK0RnwmMCZKhC7GqmoS
	KLCB2OVw==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqk-00000004oPV-3xaS;
	Wed, 04 Nov 2026 09:00:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 12/25] xfs: calculate the log reservation for logging data checksum buffers
Date: Wed,  4 Nov 2026 09:57:16 +0100
Message-ID: <20261104085929.317544-13-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The data checksum is logged in its own transaction, which only logs the
checksum buffers.  While the maximum size of a checksummed data write
is the same as that of a single checksum buffer, the Zone Append based
zoned write path can't guarantee alignment, so a reservation for an
extra slack buffer is needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b09c88aec185..25f7581ea90c 100644
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
@@ -1235,6 +1236,24 @@ xfs_calc_qm_dqalloc_reservation_minlogsize(
 	return xfs_calc_qm_dqalloc_reservation(mp, true);
 }
 
+/*
+ * Log data checksums for a write.
+ *
+ * Writes do not have to be aligned to checksum file blocks and thus can
+ * spill into an extra buffer that needs to be accounted for.
+ */
+unsigned int
+xfs_calc_csum_reservation(
+	struct xfs_mount	*mp,
+	unsigned int		csum_len)
+{
+	unsigned int		payload_size = xfs_rtcsum_payload_size(mp);
+
+	return xfs_calc_buf_res(
+			howmany(csum_len + payload_size, payload_size),
+			mp->m_rtcsum_bsize);
+}
+
 /*
  * Syncing the incore super block changes to disk.
  *     the super block to reflect the changes: sector size
@@ -1355,6 +1374,10 @@ xfs_trans_resv_calc(
 
 	xfs_calc_namespace_reservations(mp, resp);
 
+	resp->tr_csum.tr_logres =
+		xfs_calc_csum_reservation(mp, XFS_RTCSUM_MAX_WRITE);
+	resp->tr_csum.tr_logcount = XFS_DEFAULT_LOG_COUNT;
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 336279e0fc61..fbd978a91cc8 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -49,6 +49,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 	struct xfs_trans_res	tr_atomic_ioend; /* untorn write completion */
+	struct xfs_trans_res	tr_csum;	/* data checksums in metafile */
 };
 
 /* shorthand way of accessing reservation structure */
@@ -121,6 +122,9 @@ unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
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

