Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B35C3F2CE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EED720753
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n9IlsGQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbgCPOvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cJhcTzjYOK2sGbuw49vYU2OzoV/HWdkKuPkUYVhQP5c=; b=n9IlsGQIy3ndG3m8bxdXYgnWex
        VUWMtFssuC784EmMFQ8YAmQuSnC/v3XwdaRCXsulDqdh9GhqQYJaKg619zQx8V7eW9A5JjUjUz4UF
        AGbyoxWEkwoleo5cjKO9/foRQxmEq99x2CzShZcscgv+4O0BE0eRRRNKO6tEqziVo1/hH4RE/5cVY
        c5f7ioQlcaWRfydbkRCXm5lGLfHbfeI3o8jm8uVStRHlmmK7FmM2c7yqrpRdkOFcLdtz6d6+4PVsv
        1zSrYBJMQsSk2vrMlsEA92gDXFtYdRG7kVSXVEN+IZzAnPl5whQzfV7UwZTn//UrAhSDruq1KmKSb
        ELQe6lvA==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5q-00009I-Fn; Mon, 16 Mar 2020 14:51:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: remove xlog_state_want_sync
Date:   Mon, 16 Mar 2020 15:42:32 +0100
Message-Id: <20200316144233.900390-14-hch@lst.de>
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

Open code the xlog_state_want_sync logic in its two callers given that
this function is a trivial wrapper around xlog_state_switch_iclogs.

Move the lockdep assert into xlog_state_switch_iclogs to not lose this
debugging aid, and improve the comment that documents
xlog_state_switch_iclogs as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 50 +++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 865dd1e08679..761b138d97ec 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -62,11 +62,6 @@ xlog_state_switch_iclogs(
 	struct xlog_in_core	*iclog,
 	int			eventual_size);
 STATIC void
-xlog_state_want_sync(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog);
-
-STATIC void
 xlog_grant_push_ail(
 	struct xlog		*log,
 	int			need_bytes);
@@ -938,7 +933,11 @@ xfs_log_write_unmount_record(
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
 	atomic_inc(&iclog->ic_refcnt);
-	xlog_state_want_sync(log, iclog);
+	if (iclog->ic_state == XLOG_STATE_ACTIVE)
+		xlog_state_switch_iclogs(log, iclog, 0);
+	else
+		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+		       iclog->ic_state == XLOG_STATE_IOERROR);
 	error = xlog_state_release_iclog(log, iclog);
 	xlog_wait_on_iclog(iclog);
 
@@ -2293,7 +2292,11 @@ xlog_write_copy_finish(
 		*record_cnt = 0;
 		*data_cnt = 0;
 
-		xlog_state_want_sync(log, iclog);
+		if (iclog->ic_state == XLOG_STATE_ACTIVE)
+			xlog_state_switch_iclogs(log, iclog, 0);
+		else
+			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+			       iclog->ic_state == XLOG_STATE_IOERROR);
 		if (!commit_iclog)
 			goto release_iclog;
 		spin_unlock(&log->l_icloglock);
@@ -3069,11 +3072,12 @@ xlog_ungrant_log_space(
 }
 
 /*
- * This routine will mark the current iclog in the ring as WANT_SYNC
- * and move the current iclog pointer to the next iclog in the ring.
- * When this routine is called from xlog_state_get_iclog_space(), the
- * exact size of the iclog has not yet been determined.  All we know is
- * that every data block.  We have run out of space in this log record.
+ * Mark the current iclog in the ring as WANT_SYNC and move the current iclog
+ * pointer to the next iclog in the ring.
+ *
+ * When called from xlog_state_get_iclog_space(), the exact size of the iclog
+ * has not yet been determined, all we know is that we have run out of space in
+ * the current iclog.
  */
 STATIC void
 xlog_state_switch_iclogs(
@@ -3082,6 +3086,8 @@ xlog_state_switch_iclogs(
 	int			eventual_size)
 {
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+	assert_spin_locked(&log->l_icloglock);
+
 	if (!eventual_size)
 		eventual_size = iclog->ic_offset;
 	iclog->ic_state = XLOG_STATE_WANT_SYNC;
@@ -3323,26 +3329,6 @@ xfs_log_force_lsn(
 	return ret;
 }
 
-/*
- * Called when we want to mark the current iclog as being ready to sync to
- * disk.
- */
-STATIC void
-xlog_state_want_sync(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-{
-	assert_spin_locked(&log->l_icloglock);
-
-	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
-		xlog_state_switch_iclogs(log, iclog, 0);
-	} else {
-		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-		       iclog->ic_state == XLOG_STATE_IOERROR);
-	}
-}
-
-
 /*****************************************************************************
  *
  *		TICKET functions
-- 
2.24.1

