Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7357120C01C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 23:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740440947; cv=none; b=Kk+Ae7rig94ZaEZlwfyDKlYUrb2pfybt/bZTgfmrHUt1OCLekqKZW2sQcRYa0MyTl5ZsgBCzhcmeM9TfJTlDPd4S2fS5ttxjC1r/LHwi2Vo/LMu7+AXWSLBBf8k41Py2LTrDL/YEUE875XjwVa+k2fVXmpBVMEz73FOIYMu2WRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740440947; c=relaxed/simple;
	bh=KGbjL0GomzG+qzR0VcxuzUalR8Ka9hnisuF4VHZwkpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMEvaZwmL3g9b1OHJNdVvJt/KDmtuf8BFDsUUzVncdw/AohOijavHwLmQrg6ynOWGcLI5LJuBpqTCY9iwnfJZP0wpKd05Vazm5aMNB/hFIiYTReuz/uCYDIB597rk1PZ4ensZKht6DL76nBLgqqyxcYbNpHjVT8Z+u6a5/kQeaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=khky7piO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="khky7piO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HTH4GcehuWKuLETrWDgWASw/D0q+IIny+VfIni7OisM=; b=khky7piO9T7WVYi4V0U03naJj/
	smMxVPBqZpsIAuwZeKLkOg4JgbwB+R4N2RsoI+aeuctElnEvBV/vFOukQNBiws5G37JgismPhmyjg
	1Y0gMe3jGuRN6A2MC1Vw90CuAUhSOVG8MHGVlsRRs+GgpwR2H4y09Zim/mbimn6MVSSPEQ3xNFFDO
	GW/UGTMOuGL9oLlm4TsLjVeSxIYALo1bpGR/9wmhm5iPKZyW/w7QxpvC1gS6XRN+NIeiWBK3b/SmC
	aXHYqLZfyFS4Ao2Mxi3H23RnPy+AzPOSz1XpDM4m4vIo9lTvE8oiYJcAlpY+OI7n8Binib2Fy0ysQ
	OcP/PUrw==;
Received: from [208.223.66.147] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmiC8-0000000FXJW-3SAC;
	Mon, 24 Feb 2025 23:49:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 1/4] xfs: reduce context switches for synchronous buffered I/O
Date: Mon, 24 Feb 2025 15:48:52 -0800
Message-ID: <20250224234903.402657-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250224234903.402657-1-hch@lst.de>
References: <20250224234903.402657-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..dfc1849b3314 100644
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
+/* returns false if the caller needs to resubmit the I/O, else true */
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

