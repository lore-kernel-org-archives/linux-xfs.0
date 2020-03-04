Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FA4C3F2CD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23CDF20866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgCDHyF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:05 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33739 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgCDHyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:05 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0D9B43A278E
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lR-RJ
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005cW-Ou
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/11] xfs: re-order initial space accounting checks in xlog_write
Date:   Wed,  4 Mar 2020 18:53:52 +1100
Message-Id: <20200304075401.21558-3-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=0r_Sge7i62rNiU-H2-0A:9
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
---
 fs/xfs/xfs_log.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5b0568a86c07..d6c42954b70c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2381,10 +2381,10 @@ xlog_write(
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
@@ -2393,27 +2393,17 @@ xlog_write(
 	int			error = 0;
 	int			start_rec_size = sizeof(struct xlog_op_header);
 
-	*start_lsn = 0;
-
-
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
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	if (ticket->t_flags & XLOG_TIC_INITED)
 		ticket->t_flags &= ~XLOG_TIC_INITED;
-	}
-
-	/*
-	 * Commit record headers need to be accounted for. These
-	 * come in as separate writes so are easy to detect.
-	 */
-	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		start_rec_size = 0;
-	}
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2423,10 +2413,7 @@ xlog_write(
 	}
 
 	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);
-
-	index = 0;
-	lv = log_vector;
-	vecp = lv->lv_iovecp;
+	*start_lsn = 0;
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
-- 
2.24.0.rc0

