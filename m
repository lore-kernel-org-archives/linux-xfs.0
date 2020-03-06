Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C732BC10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AEEF20717
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KonF0eVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCFObh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCFObh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=quvN83Iv0Rmc1Md4XSQ1Swg3IIsZIWdf7YeLJPuG3XU=; b=KonF0eVHg5SRdeigWZBB+nyg3M
        WnB6ZIwULajAj1LB72HgZymMafdJ9ktpX5vXfs0+CqObb0JHA0IEzQRnNpnW46AWCKAjK1JABEAtU
        hB1HxYYu7PunkcGXWKeXjEXPQiQUdL23EKalCvDlSvABl+3QbckxiNAOFI9kiLtoW9WxRQbmUHpkV
        O8c+VRuDi3dpsRJhEoU3y6jPF02g+6RMSdb4ThBLuu+uoLQBMwP6vR6P53GRjDKObOkjjepWA0oaZ
        mzxadB3tsA/nD9CRN8YN9iCTU3ERhGE0oNFwDPonBaEr9At1okiMyXd1FnmSjJ6RPxxsn9pwl0Z9o
        jdFfcTrA==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0m-0008H2-Nk; Fri, 06 Mar 2020 14:31:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: remove the unused return value from xfs_log_unmount_write
Date:   Fri,  6 Mar 2020 07:31:31 -0700
Message-Id: <20200306143137.236478-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306143137.236478-1-hch@lst.de>
References: <20200306143137.236478-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the ignored return value from xfs_log_unmount_write, and also
remove a rather pointless assert on the return value from xfs_log_force.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 796ff37d5bb5..fa499ddedb94 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -953,8 +953,7 @@ xfs_log_write_unmount_record(
  * currently architecture converted and "Unmount" is a bit foo.
  * As far as I know, there weren't any dependencies on the old behaviour.
  */
-
-static int
+static void
 xfs_log_unmount_write(xfs_mount_t *mp)
 {
 	struct xlog	 *log = mp->m_log;
@@ -962,7 +961,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
 #endif
-	int		 error;
 
 	/*
 	 * Don't write out unmount record on norecovery mounts or ro devices.
@@ -971,11 +969,10 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
 	    xfs_readonly_buftarg(log->l_targ)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
-		return 0;
+		return;
 	}
 
-	error = xfs_log_force(mp, XFS_LOG_SYNC);
-	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
+	xfs_log_force(mp, XFS_LOG_SYNC);
 
 #ifdef DEBUG
 	first_iclog = iclog = log->l_iclog;
@@ -1007,7 +1004,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		iclog = log->l_iclog;
 		atomic_inc(&iclog->ic_refcnt);
 		xlog_state_want_sync(log, iclog);
-		error =  xlog_state_release_iclog(log, iclog);
+		xlog_state_release_iclog(log, iclog);
 		switch (iclog->ic_state) {
 		case XLOG_STATE_ACTIVE:
 		case XLOG_STATE_DIRTY:
@@ -1019,9 +1016,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			break;
 		}
 	}
-
-	return error;
-}	/* xfs_log_unmount_write */
+}
 
 /*
  * Empty the log for unmount/freeze.
-- 
2.24.1

