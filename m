Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01ACEC2D0E6
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA4B02076F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HjS7ltsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCYSty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:49:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYSty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VJMPtaDvLFu7Jq2VT2uWp+Q381Z2nOavjTab/uTI2p4=; b=HjS7ltsXb8ctKPn7lfHEjDa2NM
        8ruL91JEEP+vhEzbN2YwR3Vvh276dd5z0RIom864MpiwOP97eJCgokG1fsFvKHVxLNmIxZcFYbpcX
        S9V8r9yE9gocpyxFVG/DLHKaMpGQWPM7oT0WmZgvsSlXTYTt/OQZ77BAdUzKt9wxeRxCrtehtF9MU
        58CP8klGbK6Yzc/sciJPf7Q1RrQlFgfHESMSgtfkpjG4UzHmwLCrEr/ENRMgdCURKUrTj88xQ9mRL
        sa80BGqBS+XdtzIw63WbAjKngPr2u/HxF3UP4CLAiSZIHagh9sMl0FEeBixEhpGSZQaX9E1FW7AL3
        tngSXV0A==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB69-00036i-Oy; Wed, 25 Mar 2020 18:49:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/8] xfs: merge xlog_commit_record with xlog_write_done
Date:   Wed, 25 Mar 2020 19:43:03 +0100
Message-Id: <20200325184305.1361872-7-hch@lst.de>
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

xlog_write_done() is just a thin wrapper around xlog_commit_record(), so
they can be merged together easily.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      | 43 ++++++++++---------------------------------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 227a8e49e540..aca470296fc5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -24,13 +24,6 @@
 kmem_zone_t	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
-STATIC int
-xlog_commit_record(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp);
-
 STATIC struct xlog *
 xlog_alloc_log(
 	struct xfs_mount	*mp,
@@ -478,22 +471,6 @@ xfs_log_reserve(
  *		marked as with WANT_SYNC.
  */
 
-/*
- * Write a commit record to the log to close off a running log write.
- */
-int
-xlog_write_done(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*lsn)
-{
-	if (XLOG_FORCED_SHUTDOWN(log))
-		return -EIO;
-
-	return xlog_commit_record(log, ticket, iclog, lsn);
-}
-
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -1463,20 +1440,17 @@ xlog_alloc_log(
 	return ERR_PTR(error);
 }	/* xlog_alloc_log */
 
-
 /*
  * Write out the commit record of a transaction associated with the given
- * ticket.  Return the lsn of the commit record.
+ * ticket to close off a running log write. Return the lsn of the commit record.
  */
-STATIC int
+int
 xlog_commit_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
-	xfs_lsn_t		*commitlsnp)
+	xfs_lsn_t		*lsn)
 {
-	struct xfs_mount *mp = log->l_mp;
-	int	error;
 	struct xfs_log_iovec reg = {
 		.i_addr = NULL,
 		.i_len = 0,
@@ -1486,12 +1460,15 @@ xlog_commit_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	int	error;
 
-	ASSERT_ALWAYS(iclog);
-	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
-					XLOG_COMMIT_TRANS, false);
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
+
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
+			   false);
 	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0ae187fa9af2..e3dd405ea767 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -839,7 +839,7 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	error = xlog_write_done(log, tic, &commit_iclog, &commit_lsn);
+	error = xlog_commit_record(log, tic, &commit_iclog, &commit_lsn);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0941b465de9e..f4a54469d7d0 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -441,7 +441,7 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint flags,
 		bool need_start_rec);
-int	xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
+int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
-- 
2.25.1

