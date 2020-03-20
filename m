Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98750C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720F020782
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lLqwp/Eo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgCTGxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:53:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VrKCKjnwigpDfTvcbQkHB2wGN/NmcEIONYVRiL1Oz3w=; b=lLqwp/EoQxRkXsDaUu28X3OwN8
        DQWmRDyrzHqeWbSusX4bKAETWFMvDZjZRKWrfF/4J/TaAwC0CzbDtED477fQE5cSekqOa5CjJNarR
        aKKEQe2pEcCny6LI8J0x7N24zOVuqWCJMiyuBu+U4lcUm7mvgOtqmr+xIW7avaSNHIiy1luLVUOp+
        SHOg9/aG6t+pnbSuR08zLTFxFlxWntj72sQeUzTa4xH+59fSyCfhf5QCYyFwooJNpx3Woyb87Pq7/
        LAyMDL6514LDGrJgsifBpc+AQoGzXDk4J2Rz9JV9diKxqN2EQF9mM1TJxLn4e6pvzMCsP9JGyOHe7
        Tglsm/jw==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBX0-0006F5-BT; Fri, 20 Mar 2020 06:53:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/8] xfs: simplify the xfs_log_release_iclog calling convention
Date:   Fri, 20 Mar 2020 07:53:06 +0100
Message-Id: <20200320065311.28134-4-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320065311.28134-1-hch@lst.de>
References: <20200320065311.28134-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only caller of xfs_log_release_iclog doesn't care about the return
value, so remove it.  Also don't bother passing the mount pointer,
given that we can trivially derive it from the iclog.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c     | 10 ++++------
 fs/xfs/xfs_log.h     |  3 +--
 fs/xfs/xfs_log_cil.c |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 955df2902c2c..17ba92b115ea 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -597,12 +597,11 @@ xlog_state_release_iclog(
 	return 0;
 }
 
-int
+void
 xfs_log_release_iclog(
-	struct xfs_mount        *mp,
 	struct xlog_in_core	*iclog)
 {
-	struct xlog		*log = mp->m_log;
+	struct xlog		*log = iclog->ic_log;
 	bool			sync;
 
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
@@ -618,10 +617,9 @@ xfs_log_release_iclog(
 		if (sync)
 			xlog_sync(log, iclog);
 	}
-	return 0;
+	return;
 error:
-	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	return -EIO;
+	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 84e06805160f..b38602216c5a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -121,8 +121,7 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
-int	  xfs_log_release_iclog(struct xfs_mount *mp,
-			 struct xlog_in_core	 *iclog);
+void	  xfs_log_release_iclog(struct xlog_in_core *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   length,
 			  int		   count,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9ef0f8b555a4..278166811c80 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -866,7 +866,7 @@ xlog_cil_push_work(
 	spin_unlock(&cil->xc_push_lock);
 
 	/* release the hounds! */
-	xfs_log_release_iclog(log->l_mp, commit_iclog);
+	xfs_log_release_iclog(commit_iclog);
 	return;
 
 out_skip:
-- 
2.25.1

