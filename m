Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9A7C2D0E5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2529F2076F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NT09RNyf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCYStn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:49:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYStn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=getuyuGqJNHo2ItryTxyooWHoCVTRa0RIy01pgjfBJw=; b=NT09RNyf3kACsFxk8aanekh+BV
        bNu66f5MxKFmKYGvRm4cBaO4PnbA1FXRk9/P30xKlKrr8hi/qvvsBe0ZLNxG0Jfa8vb4mn7zxYGFs
        /Al1bd8vZxOAQNtJ1XJAyjc7azRpidzqziU0vHknyoW5uqu0Hiivn5o1ndCH/yYncSN3SIFiWnPVa
        mdFQ9/k2KdAahYMwqVXp8hKzSlWYxhXktWMAG674NjS8oOboOSG7CDttQcsjNykshaJQxVMaSWl7h
        c2vKX1Qi8zXBOIbJHbEiYe8vo8Ga0ewVNalbKbygfEwpyauNnsv5AD32b6K1aVJRIe2Ij8rxQKT17
        eDNkE79g==;
Received: from 213-225-10-87.nat.highway.a1.net ([213.225.10.87] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB5z-00035F-1Q; Wed, 25 Mar 2020 18:49:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/8] xfs: re-order initial space accounting checks in xlog_write
Date:   Wed, 25 Mar 2020 19:42:59 +0100
Message-Id: <20200325184305.1361872-3-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325184305.1361872-1-hch@lst.de>
References: <20200325184305.1361872-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 617b393272de..c14f8f14a381 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2350,10 +2350,10 @@ xlog_write(
 	bool			need_start_rec)
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
@@ -2361,24 +2361,16 @@ xlog_write(
 	int			data_cnt = 0;
 	int			error = 0;
 
-	*start_lsn = 0;
-
-
 	/*
-	 * Region headers and bytes are already accounted for.  We only need to
-	 * take into account start records and split regions in this function.
+	 * If this is a commit or unmount transaction, we don't need a start
+	 * record to be written.  We do, however, have to account for the
+	 * commit or unmount header that gets written. Hence we always have
+	 * to account for an extra xlog_op_header here.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED) {
-		ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	if (ticket->t_flags & XLOG_TIC_INITED)
 		ticket->t_flags &= ~XLOG_TIC_INITED;
-	}
 
-	/*
-	 * Commit record headers and unmount records need to be accounted for.
-	 * These come in as separate writes so are easy to detect.
-	 */
-	if (!need_start_rec)
-		ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
@@ -2387,10 +2379,7 @@ xlog_write(
 	}
 
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

