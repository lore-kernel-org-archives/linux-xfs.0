Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F96191F66
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409908; cv=none; b=c9Gc+l38fAZc37FE3FdqN3YsxJGYMffFF12p2qn0ZTu6v05XUzmnOTZG2OzZn/K+UdsDtH1odcmQjvj9Oj0j8UTb2p2RiYojO74Id/C/zx9hzonjLXLRHMhpZPMdXhLYyBCDZT+Yt7YgAx7E3xR1p5DWClHAslRQ3yKnB20/eWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409908; c=relaxed/simple;
	bh=nWPN/glIHz//MWuR5IXLJZzgMKvrSBluHqOU7N9sCX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT7buAZMg6WOzM2ntsLl4Tg5J9MQOrerw4wBkBrO2J9vTJN6ZHj3NxhKRecipSoR562v9Z1AMV9sMVz27OWtvTvTH8CvPAuGECy2oVlX+tOk8yUs1sTnO24f7uSbyHtX4RUWh70a/y6uwa8muTvSsBbIETt6yAXAxKLln+olxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ao0WsBI0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ao0WsBI0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1vnoU54dONEl0ZLPcywh74EK/F56wmpS871zXtwKIOU=; b=Ao0WsBI06xFX5Nd9fxpoIQRmSd
	dnPSJ+ciH8YcDbHpKH63WozXSfH97v47iZC4uqr7GDGM8TAWCqmVf+7TnjAwEKDz+1g3G/tV9Jx6E
	D4/aprIiJ6ktkAhyvVBXKrttKs9yU19W9v7Cr4eOcUmXC+lfzNhG67BWzz0DIr7iuL1tanHma9wfB
	d43ML0oJnjoZqdVnKfYZRIJLUerhKRBvwqAYxygNmwUNS2lyxvlV+Os1c3hqw8DJ+9AP/WCDltlkr
	P+Jp44+TVL78SD12Fw6fJRxNRSm/9PZVwy7569Qx6nPM4Gi6v+dR/uqIFfybuQNye1FJ+lmO7M5Bi
	cMK3j4Vg==;
Received: from syn-035-131-028-085.biz.spectrum.com ([35.131.28.85] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tma7W-0000000EEfp-2ZNm;
	Mon, 24 Feb 2025 15:11:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: reduce context switches for synchronous buffered I/O
Date: Mon, 24 Feb 2025 07:11:35 -0800
Message-ID: <20250224151144.342859-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250224151144.342859-1-hch@lst.de>
References: <20250224151144.342859-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently all metadata I/O completions happen in the m_buf_workqueue
workqueue.  But for synchronous I/O (i.e. all buffer reads) there is no
need for that, as there always is a called in process context that is
waiting for the I/O.  Factor out the guts of xfs_buf_ioend into a
separate helper and call it from xfs_buf_iowait to avoid a double
an extra context switch to the workqueue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..821aa85e2ce5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1345,6 +1345,7 @@ xfs_buf_ioend_handle_error(
 resubmit:
 	xfs_buf_ioerror(bp, 0);
 	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
+	reinit_completion(&bp->b_iowait);
 	xfs_buf_submit(bp);
 	return true;
 out_stale:
@@ -1355,8 +1356,9 @@ xfs_buf_ioend_handle_error(
 	return false;
 }
 
-static void
-xfs_buf_ioend(
+/* returns false if the caller needs to resubmit the I/O, else false */
+static bool
+__xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
 	trace_xfs_buf_iodone(bp, _RET_IP_);
@@ -1376,7 +1378,7 @@ xfs_buf_ioend(
 		}
 
 		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
-			return;
+			return false;
 
 		/* clear the retry state */
 		bp->b_last_error = 0;
@@ -1397,7 +1399,15 @@ xfs_buf_ioend(
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
 			 _XBF_LOGRECOVERY);
+	return true;
+}
 
+static void
+xfs_buf_ioend(
+	struct xfs_buf	*bp)
+{
+	if (!__xfs_buf_ioend(bp))
+		return;
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
 	else
@@ -1411,15 +1421,8 @@ xfs_buf_ioend_work(
 	struct xfs_buf		*bp =
 		container_of(work, struct xfs_buf, b_ioend_work);
 
-	xfs_buf_ioend(bp);
-}
-
-static void
-xfs_buf_ioend_async(
-	struct xfs_buf	*bp)
-{
-	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
-	queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
+	if (__xfs_buf_ioend(bp))
+		xfs_buf_relse(bp);
 }
 
 void
@@ -1491,7 +1494,13 @@ xfs_buf_bio_end_io(
 		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		xfs_buf_ioerror(bp, -EIO);
 
-	xfs_buf_ioend_async(bp);
+	if (bp->b_flags & XBF_ASYNC) {
+		INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
+		queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
+	} else {
+		complete(&bp->b_iowait);
+	}
+
 	bio_put(bio);
 }
 
@@ -1568,9 +1577,11 @@ xfs_buf_iowait(
 {
 	ASSERT(!(bp->b_flags & XBF_ASYNC));
 
-	trace_xfs_buf_iowait(bp, _RET_IP_);
-	wait_for_completion(&bp->b_iowait);
-	trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	do {
+		trace_xfs_buf_iowait(bp, _RET_IP_);
+		wait_for_completion(&bp->b_iowait);
+		trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	} while (!__xfs_buf_ioend(bp));
 
 	return bp->b_error;
 }
-- 
2.45.2

