Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D216C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49A522166E
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gektYv25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgCPOtL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:49:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57432 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731549AbgCPOtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fo8/2wTa5CtmtlPQtM7qWjKZ+Bcm2Uvtz3QS4+jJFi0=; b=gektYv259R5TYi7yZ1cnHOw/cn
        1BVsuIqo8DUEni1/q1h5Diqj+X3D05m9wZYJiU+pUlUu8LWLBJEMrQaCTzn9zrqixqZkmiq2907wJ
        Qx54N6VDNQQKHI19xDKebOn8KWjUVq0TN2ABleoYVKss0n4sfORpreCr7AjbUYVWQZ423oFkheyCr
        S3+IPvkX3Aj7xmytO8Sh6C3YMqzwDsGVfU9tOGWVdbVYarxMbHkMLOGxIplGGnBB9ACXoeOKuQ+6M
        gk7iIzq3ajuzD+XunCC9LIy4wH2WwOIo5qBZjMiOquqzBSVZQ9zstHE+P3jgEGztXb+5inEbFjl9S
        HLpHeCbA==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr3H-0007BQ-7f; Mon, 16 Mar 2020 14:49:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/14] xfs: factor out a xlog_wait_on_iclog helper
Date:   Mon, 16 Mar 2020 15:42:21 +0100
Message-Id: <20200316144233.900390-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316144233.900390-1-hch@lst.de>
References: <20200316144233.900390-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out the shared code to wait for a log force into a new helper.
This helper uses the XLOG_FORCED_SHUTDOWN check previous only used
by the unmount code over the equivalent iclog ioerror state used by
the other two functions.

There is a slight behavior change in that the force of the unmount
record is now accounted in the log force statistics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 76 ++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0986983ef6b5..955df2902c2c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -859,6 +859,31 @@ xfs_log_mount_cancel(
 	xfs_log_unmount(mp);
 }
 
+/*
+ * Wait for the iclog to be written disk, or return an error if the log has been
+ * shut down.
+ */
+static int
+xlog_wait_on_iclog(
+	struct xlog_in_core	*iclog)
+		__releases(iclog->ic_log->l_icloglock)
+{
+	struct xlog		*log = iclog->ic_log;
+
+	if (!XLOG_FORCED_SHUTDOWN(log) &&
+	    iclog->ic_state != XLOG_STATE_ACTIVE &&
+	    iclog->ic_state != XLOG_STATE_DIRTY) {
+		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
+		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
+	} else {
+		spin_unlock(&log->l_icloglock);
+	}
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
+	return 0;
+}
+
 /*
  * Final log writes as part of unmount.
  *
@@ -926,18 +951,7 @@ xfs_log_write_unmount_record(
 	atomic_inc(&iclog->ic_refcnt);
 	xlog_state_want_sync(log, iclog);
 	error = xlog_state_release_iclog(log, iclog);
-	switch (iclog->ic_state) {
-	default:
-		if (!XLOG_FORCED_SHUTDOWN(log)) {
-			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-			break;
-		}
-		/* fall through */
-	case XLOG_STATE_ACTIVE:
-	case XLOG_STATE_DIRTY:
-		spin_unlock(&log->l_icloglock);
-		break;
-	}
+	xlog_wait_on_iclog(iclog);
 
 	if (tic) {
 		trace_xfs_log_umount_write(log, tic);
@@ -3230,9 +3244,6 @@ xfs_log_force(
 		 * previous iclog and go to sleep.
 		 */
 		iclog = iclog->ic_prev;
-		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
-		    iclog->ic_state == XLOG_STATE_DIRTY)
-			goto out_unlock;
 	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		if (atomic_read(&iclog->ic_refcnt) == 0) {
 			/*
@@ -3248,8 +3259,7 @@ xfs_log_force(
 			if (xlog_state_release_iclog(log, iclog))
 				goto out_error;
 
-			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
-			    iclog->ic_state == XLOG_STATE_DIRTY)
+			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
 				goto out_unlock;
 		} else {
 			/*
@@ -3269,17 +3279,8 @@ xfs_log_force(
 		;
 	}
 
-	if (!(flags & XFS_LOG_SYNC))
-		goto out_unlock;
-
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
-		goto out_error;
-	XFS_STATS_INC(mp, xs_log_force_sleep);
-	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
-		return -EIO;
-	return 0;
-
+	if (flags & XFS_LOG_SYNC)
+		return xlog_wait_on_iclog(iclog);
 out_unlock:
 	spin_unlock(&log->l_icloglock);
 	return 0;
@@ -3310,9 +3311,6 @@ __xfs_log_force_lsn(
 			goto out_unlock;
 	}
 
-	if (iclog->ic_state == XLOG_STATE_DIRTY)
-		goto out_unlock;
-
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		/*
 		 * We sleep here if we haven't already slept (e.g. this is the
@@ -3346,20 +3344,8 @@ __xfs_log_force_lsn(
 			*log_flushed = 1;
 	}
 
-	if (!(flags & XFS_LOG_SYNC) ||
-	    (iclog->ic_state == XLOG_STATE_ACTIVE ||
-	     iclog->ic_state == XLOG_STATE_DIRTY))
-		goto out_unlock;
-
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
-		goto out_error;
-
-	XFS_STATS_INC(mp, xs_log_force_sleep);
-	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
-		return -EIO;
-	return 0;
-
+	if (flags & XFS_LOG_SYNC)
+		return xlog_wait_on_iclog(iclog);
 out_unlock:
 	spin_unlock(&log->l_icloglock);
 	return 0;
-- 
2.24.1

