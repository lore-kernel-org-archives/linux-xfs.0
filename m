Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FF9C54FD2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB60D206F6
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GwtggUBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgCXRpR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:45:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fYU0kLCXs/2uTYs5hFLuX0FwIKpoQad7nvvECsyvDNg=; b=GwtggUBHaHyT9XHgi8HSeExjZn
        mDmUxzjCvmXn0UIx4Tu0MpML5SOzkWVooq5SGggqDyITQNj9gA8mlio4pPnJCGyGwlQLjo49kVRzR
        2JYORFUVEIRMoS9RUuKtCuqfNHeFCs9immKszKzsgO6S2ErfiUlchQZ+iSg5cCO2rkimYAVn88XhL
        m407Pt0THnJ/Vxs/SdJxc59XEuva3l5a1f+gqyqnsIYIcng5n7HMMea0r/PRyaHaKFAFsCkU5aLWT
        RGqvtlblk2MR5rtnzSdsQYy33hHPtwUGQIj8eov/IGSyofZE2zxv4xepXREPBPfhPsJq57j3d/ptj
        CWr4UjsA==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnc3-0003Hp-BV; Tue, 24 Mar 2020 17:45:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/8] xfs: merge xlog_commit_record with xlog_write_done()
Date:   Tue, 24 Mar 2020 18:44:57 +0100
Message-Id: <20200324174459.770999-7-hch@lst.de>
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

xlog_write_done() is just a thin wrapper around
xlog_commit_record(), so they can be merged together easily. Convert
all the xlog_commit_record() callers to use xlog_write_done() and
merge the implementations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 44 +++++++++++---------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9a26ee8db238..a173b5925d1b 100644
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
-xlog_commit_record(
+int
+xlog_write_done(
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
@@ -1486,12 +1460,16 @@ xlog_commit_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	int	error;
 
 	ASSERT_ALWAYS(iclog);
-	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
-					XLOG_COMMIT_TRANS);
+
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
+
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
 	if (error)
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
 }
 
-- 
2.25.1

