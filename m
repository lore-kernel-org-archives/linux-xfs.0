Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF29C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2209A206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PJNxB3cN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfJIOcY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/okIwFT8JfS5oN5xnfc+XnZz38I7/f8zXOM7vO897eo=; b=PJNxB3cNueCm0uQykR9V6swIV
        oxgJVPYVxpQMXOrm1Ft1DgjnUHmt0ZfWj2clNfUsmvL+HuuI010qtG+bAkguZgHW/EUlV30IIww/d
        0xj/zD/tOi+OyWEveFItAavMgjW0zRXmkMgZbrskes3EfvF1jCmhuIlTHlsLRiwE0N+ubhKvdclBf
        eiJK5WUubeJPof4vIoYo68DHdmNvOVMx4GG0S/GCqCTPlTKBJ9MnYKtfkni1qrdrCYcPegmoDCcOK
        iLBnAbZtVb0D7FI9uuk/DbaGZKEfbS5h6X/JmoECT5SFx06pIdBQJvTdw7EkVyFT7/Ky2TilXsb+Q
        hBxFRuVYw==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0q-0005cj-1T
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: move the locking from xlog_state_finish_copy to the callers
Date:   Wed,  9 Oct 2019 16:27:43 +0200
Message-Id: <20191009142748.18005-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009142748.18005-1-hch@lst.de>
References: <20191009142748.18005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This will allow optimizing various locking cycles in the following
patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4f5927ddfa40..860a555772fe 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1967,7 +1967,6 @@ xlog_dealloc_log(
 /*
  * Update counters atomically now that memcpy is done.
  */
-/* ARGSUSED */
 static inline void
 xlog_state_finish_copy(
 	struct xlog		*log,
@@ -1975,16 +1974,11 @@ xlog_state_finish_copy(
 	int			record_cnt,
 	int			copy_bytes)
 {
-	spin_lock(&log->l_icloglock);
+	lockdep_assert_held(&log->l_icloglock);
 
 	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
 	iclog->ic_offset += copy_bytes;
-
-	spin_unlock(&log->l_icloglock);
-}	/* xlog_state_finish_copy */
-
-
-
+}
 
 /*
  * print out info relating to regions written which consume
@@ -2266,7 +2260,9 @@ xlog_write_copy_finish(
 		 * This iclog has already been marked WANT_SYNC by
 		 * xlog_state_get_iclog_space.
 		 */
+		spin_lock(&log->l_icloglock);
 		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
+		spin_unlock(&log->l_icloglock);
 		*record_cnt = 0;
 		*data_cnt = 0;
 		return xlog_state_release_iclog(log, iclog);
@@ -2277,11 +2273,11 @@ xlog_write_copy_finish(
 
 	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
 		/* no more space in this iclog - push it. */
+		spin_lock(&log->l_icloglock);
 		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
 		*record_cnt = 0;
 		*data_cnt = 0;
 
-		spin_lock(&log->l_icloglock);
 		xlog_state_want_sync(log, iclog);
 		spin_unlock(&log->l_icloglock);
 
@@ -2504,7 +2500,9 @@ xlog_write(
 
 	ASSERT(len == 0);
 
+	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	spin_unlock(&log->l_icloglock);
 	if (!commit_iclog)
 		return xlog_state_release_iclog(log, iclog);
 
-- 
2.20.1

