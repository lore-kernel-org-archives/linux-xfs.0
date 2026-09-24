Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E9545DF68
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244421; cv=none; b=K+hU52ZxaDCpV68h9yijXHfx4DOmrWi6wvKsYOWbKzpBUzNC0S5J57XVDdoXekE88z8clMJnqQ+9DFUcowuOedEvk8c4Ef0/qOVj8ob+G23INlqEDwHfmYoVKKUZlHNjXawZFnHrsVn2gllj3Mqkt49IXcOapMvK26pSABG1dQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244421; c=relaxed/simple;
	bh=mbQdfW8/BX3C6U3QeuGVo4s4226VJD2a5UNseZ10R3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuXhlYpMAS/JNCgBQfw83pI2qWJAKBl6fEUzcbX7cRYB+HjP/d9QUqcotu0f/uEhJ6liO1XGpUF2LJBNQsb1mETqvwcfU38+jIOfJ6IUa8JS9NscCx2D6AWbrgs/GlPHFwe6598rI3Bdx5YbLAM2R/k5hZkMTFjPtvE9CMi5jdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jcn2s70D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jcn2s70D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uLa932c23tH5qajKz1On9VmKR1A7peckNl8/oIn6mRc=; b=jcn2s70DGWMKJ/7nb86mW64SHD
	jrheMH9S6S+vNI29BBQps4jDJ28kIg/b4VrRJrqQj6NjYuCAc3x9CFup9xsNOLMqThjh8UoHat+gV
	Tap4cfn7ziH1/tiG5M9fXD3cOhb/KSnFERvqhXVPQsVsHy2REP6v/nMJ2ssXXsnJdd6+DPnrAlYNU
	Ctpk5CqJTkRUObuMlfOLh/YRnbxVuFH/Okj6CnApGZ7Y+XAPxIWtAJbX5fMbLfKc7rKydY0GClT8P
	GeNTkdRQcoTLblGBUiJpTzdASrb+4UG83LEV2YxjBHBTEtitczVkb+neaP7kapuDQ0uOANB+HDXU2
	BXVyw5zg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLp-0000000AfSq-0oca;
	Thu, 24 Sep 2026 10:06:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 23/32] xfs: calculate the log reservation for logging data checksum buffers
Date: Thu, 24 Sep 2026 12:04:13 +0200
Message-ID: <20260924100512.2733748-24-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 78980b5ca4f00b0f664396ff5a81f44762f5a07c

The data checksum is logged in its own transaction, and only logs
transactions buffers.  While the maximum size of a checksummed data write
is the same as that of a single checksum buffer, the Zone Append based
zoned write path can't guarantee alignment, so it might be spread over
up to three buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_resv.c | 21 +++++++++++++++++++++
 libxfs/xfs_trans_resv.h |  4 ++++
 2 files changed, 25 insertions(+)

diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 3a9de562ac2b..cc785b1476cd 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -11,6 +11,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_rtcsumfile.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_inode.h"
@@ -1226,6 +1227,22 @@ xfs_calc_qm_dqalloc_reservation_minlogsize(
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
@@ -1347,6 +1364,10 @@ xfs_trans_resv_calc(
 
 	xfs_calc_namespace_reservations(mp, resp);
 
+	resp->tr_csum.tr_logres =
+		xfs_calc_csum_reservation(mp, XFS_RTCSUM_MAX_WRITE);
+	resp->tr_csum.tr_logcount = XFS_DEFAULT_LOG_COUNT;
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 1804e821f382..127db4da31c1 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
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

