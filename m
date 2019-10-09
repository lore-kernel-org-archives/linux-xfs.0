Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A64ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52312206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IoKS4yjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbfJIOcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ucpA1/3WqBaaZMxyphnsYYhC8gDYoCfyJSCCgjhKBow=; b=IoKS4yjs+zFqLdkc4Gg0WhBNQ
        BEHJsZ+UGV+CIg20mrRhZGAfWzGZBwdRIdq6YMdaiKGvnZjZWnL37jtFfijHdHjFimAS+KapNozXf
        YlketlsuXLwejEBaGHpLjYqF9OCW/jN16YipKcUwTEJ66xZvRPihIVl7zcqCRfDkwh/IMhic/xjTj
        WKjB9WmtLVoBLP/KtGzMkV5E4A+CQ86GJQOAnkX/ccAohU8PGPLoj0IJJU/Y1wvsMZB/7PbMRbdzm
        SVPpUj92w3za4qh58BSga+fuHYgE19YV9Xkv88nD4zNNbHbOQm/aG/jJOGHKRejDzqvAI52vx2uk3
        oPlbCVRfw==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0n-0005c4-2n
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: remove the unused ic_io_size field from xlog_in_core
Date:   Wed,  9 Oct 2019 16:27:42 +0200
Message-Id: <20191009142748.18005-3-hch@lst.de>
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

ic_io_size is only used inside xlog_write_iclog, where we can just use
the count parameter intead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 6 ++----
 fs/xfs/xfs_log_priv.h | 3 ---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cd90871c2101..4f5927ddfa40 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1740,8 +1740,6 @@ xlog_write_iclog(
 		return;
 	}
 
-	iclog->ic_io_size = count;
-
 	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
 	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
 	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
@@ -1751,9 +1749,9 @@ xlog_write_iclog(
 	if (need_flush)
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 
-	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, iclog->ic_io_size);
+	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
 	if (is_vmalloc_addr(iclog->ic_data))
-		flush_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
+		flush_kernel_vmap_range(iclog->ic_data, count);
 
 	/*
 	 * If this log buffer would straddle the end of the log we will have
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b880c23cb6e4..90e210e433cf 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -179,8 +179,6 @@ typedef struct xlog_ticket {
  * - ic_next is the pointer to the next iclog in the ring.
  * - ic_log is a pointer back to the global log structure.
  * - ic_size is the full size of the log buffer, minus the cycle headers.
- * - ic_io_size is the size of the currently pending log buffer write, which
- *	might be smaller than ic_size
  * - ic_offset is the current number of bytes written to in this iclog.
  * - ic_refcnt is bumped when someone is writing to the log.
  * - ic_state is the state of the iclog.
@@ -205,7 +203,6 @@ typedef struct xlog_in_core {
 	struct xlog_in_core	*ic_prev;
 	struct xlog		*ic_log;
 	u32			ic_size;
-	u32			ic_io_size;
 	u32			ic_offset;
 	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
-- 
2.20.1

