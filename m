Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D5BC54FD0
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9138C208C3
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cH5bowZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgCXRpG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:45:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbgCXRpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vHBvLtuXLeGjq9za2Gs70xvSZkZ4SdQfORDNgkUlNt4=; b=cH5bowZmFi+Su1mt90IgX3YP7k
        DLaaV4hf5y2ULyCG7ktw3aDXj5gucntdSQRVnsJ/uOxaZf+Qzl7Ujb8ie+ygYm9KG8531ZFjXvNTb
        AtxfHZGPJwhBsre+RM2m0RtSd6mt4yp+k3GHFtUZv9oTuDGqCjPWbQpXazRJy9371DU+mHbgxq/IT
        9FkK8vbgSKvlM62bWKIvk9nZfgnTvtrt3BNvBFiz9ntIwla5nBfAeRi/LTDHgYlpQgI9+MDcC9FnE
        lvsQs8zhKDtFeEvABZTe7CnRHxOURIalqXw88G3WHupDqVsneANbqFPZ7YNgiGi8ZqJR2r6fg/P0d
        nCu0zfVg==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnbt-0002Q9-OM; Tue, 24 Mar 2020 17:45:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/8] xfs: re-order initial space accounting checks in xlog_write
Date:   Tue, 24 Mar 2020 18:44:53 +0100
Message-Id: <20200324174459.770999-3-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324174459.770999-1-hch@lst.de>
References: <20200324174459.770999-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Commit and unmount records records do not need start records to be
written, so rearrange the logic in xlog_write() to remove the need
to check for XLOG_TIC_INITED to determine if we should account for
the space used by a start record.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bf071552094a..116f59b16b04 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2349,39 +2349,27 @@ xlog_write(
 	uint			flags)
 {
 	struct xlog_in_core	*iclog = NULL;
-	struct xfs_log_iovec	*vecp;
-	struct xfs_log_vec	*lv;
+	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
+	int			index = 0;
 	int			len;
-	int			index;
 	int			partial_copy = 0;
 	int			partial_copy_len = 0;
 	int			contwr = 0;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
-	bool			need_start_rec = true;
-
-	*start_lsn = 0;
-
+	bool			need_start_rec;
 
 	/*
-	 * Region headers and bytes are already accounted for.
-	 * We only need to take into account start records and
-	 * split regions in this function.
+	 * If this is a commit or unmount transaction, we don't need a start
+	 * record to be written. We do, however, have to account for the
+	 * commit or unmount header that gets written. Hence we always have
+	 * to account for an extra xlog_op_header here.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED) {
-		ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	if (ticket->t_flags & XLOG_TIC_INITED)
 		ticket->t_flags &= ~XLOG_TIC_INITED;
-	}
-
-	/*
-	 * Commit record headers need to be accounted for. These
-	 * come in as separate writes so are easy to detect.
-	 */
-	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
-		ticket->t_curr_res -= sizeof(struct xlog_op_header);
-		need_start_rec = false;
-	}
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2390,11 +2378,9 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
+	need_start_rec = !(flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS));
 	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
-
-	index = 0;
-	lv = log_vector;
-	vecp = lv->lv_iovecp;
+	*start_lsn = 0;
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
-- 
2.25.1

