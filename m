Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5B3C2D0E5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544922078A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VbIKjinL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCYSts (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:49:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYSts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bn784AFTkB2y17Xgc0ShVy85MJ+RWqUQNx1UfhCQrXo=; b=VbIKjinLqZAh7wp0W6zSXGdDzx
        0W8A5vGGTW9HPZTZdeIqQnyKpVhaOEvfVnZcZSQkCWO7T29Yym67F8unAG9sbKJJhd/x7GNevbJ3v
        AdN+ixUvgcO8yV0NHZS8txcUelktlpwX8SldqlG4VZVRbxPewyPMIclNG/8OWiHmQwc55Mluo/D6/
        Vex89T2wZT7V1tw1OVO3d5tubJHIoEqdzlhOPFxDxXs2pctoFJ8gdHMv9zqHO2T4OldW4gTiSMj5P
        tuXOoiVgpGcnmk5+U9Z75TicjG7tQlUN9YCgFOaNO9ou2GsqOwnqbxVnG+rCrqwKkbaihkn3m8Gl6
        cAsKAq7w==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB64-00035r-5g; Wed, 25 Mar 2020 18:49:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/8] xfs: kill XLOG_TIC_INITED
Date:   Wed, 25 Mar 2020 19:43:01 +0100
Message-Id: <20200325184305.1361872-5-hch@lst.de>
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

It is not longer used or checked by anything, so remove the last
traces from the log ticket code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      | 4 ----
 fs/xfs/xfs_log_priv.h | 6 ++----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f1a8f303722f..7ce551502a47 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2346,9 +2346,6 @@ xlog_write(
 	 * to account for an extra xlog_op_header here.
 	 */
 	ticket->t_curr_res -= sizeof(struct xlog_op_header);
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		ticket->t_flags &= ~XLOG_TIC_INITED;
-
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
@@ -3487,7 +3484,6 @@ xlog_ticket_alloc(
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
-	tic->t_flags		= XLOG_TIC_INITED;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1f450ea6192c..fd63400fff6d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -51,13 +51,11 @@ enum xlog_iclog_state {
 };
 
 /*
- * Flags to log ticket
+ * Log ticket flags
  */
-#define XLOG_TIC_INITED		0x1	/* has been initialized */
-#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
+#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
 
 #define XLOG_TIC_FLAGS \
-	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
 	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
 /*
-- 
2.25.1

