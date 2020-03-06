Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F79DC10F00
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C8520717
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F4su1DKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCFObj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgCFObj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5n+WY7IMndO3+WvSd56tUoe9by01YBM8AxNS3tmsTPk=; b=F4su1DKPYK0/SSw830rpfSWqip
        u6eykWxpce6nBbB3yfwZKwxdQ18h3fpZC/240BN1lW4RPX4GUefGeE/V607jDghMiamgcrBk0sxkW
        Tr6JXl/oTarqu48U0CgViZF2V1gMxfHtwLTdWrDSm+VIKyDy/Zs9y6bupeVtYVTHXIfDPcDKUZuUV
        Uc8U2N//hOj4XxdZo9/ua6nnP7ojlhOuv13OlhrRm/orN3danoELkgF/WznlOO4lWbwjQQbIc2h/5
        AbEEDQrLFvS0PXj2Jak6DrNi7b6/PmgyaTj482N5RLhj5SOaJBd7SZTWBaoxgbqdq7LLBAVA+ExIt
        HX/FRJqA==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0p-0008HE-4Z; Fri, 06 Mar 2020 14:31:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] xfs: cleanup xfs_log_unmount_write
Date:   Fri,  6 Mar 2020 07:31:33 -0700
Message-Id: <20200306143137.236478-4-hch@lst.de>
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

Move the code for verifying the iclog state on a clean unmount into a
helper, and instead of checking the iclog state just rely on the shutdown
check as they are equivalent.  Also remove the ifdef DEBUG as the
compiler is smart enough to eliminate the dead code for non-debug builds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b56432d4a9b8..89f2e68eb570 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -946,6 +946,18 @@ xfs_log_write_unmount_record(
 	}
 }
 
+static void
+xfs_log_unmount_verify_iclog(
+	struct xlog	 	*log)
+{
+	struct xlog_in_core	 *iclog = log->l_iclog;
+
+	do {
+		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+		ASSERT(iclog->ic_offset == 0);
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+}
+
 /*
  * Unmount record used to have a string "Unmount filesystem--" in the
  * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
@@ -954,13 +966,10 @@ xfs_log_write_unmount_record(
  * As far as I know, there weren't any dependencies on the old behaviour.
  */
 static void
-xfs_log_unmount_write(xfs_mount_t *mp)
+xfs_log_unmount_write(
+	struct xfs_mount	*mp)
 {
-	struct xlog	 *log = mp->m_log;
-	xlog_in_core_t	 *iclog;
-#ifdef DEBUG
-	xlog_in_core_t	 *first_iclog;
-#endif
+	struct xlog	 	*log = mp->m_log;
 
 	/*
 	 * Don't write out unmount record on norecovery mounts or ro devices.
@@ -974,18 +983,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-#ifdef DEBUG
-	first_iclog = iclog = log->l_iclog;
-	do {
-		if (iclog->ic_state != XLOG_STATE_IOERROR) {
-			ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
-			ASSERT(iclog->ic_offset == 0);
-		}
-		iclog = iclog->ic_next;
-	} while (iclog != first_iclog);
-#endif
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
+	xfs_log_unmount_verify_iclog(log);
 	xfs_log_write_unmount_record(mp);
 }
 
-- 
2.24.1

