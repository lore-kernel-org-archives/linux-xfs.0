Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E8FC4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D732072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oNIcD/po"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgCWNHg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgCWNHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dvGQp+5ka9Er+oh+KGpAacpQYg7Ru/FUUtN71+j+47I=; b=oNIcD/po7NvTzFq1TsGRKgW3fG
        f97QjtlzPOp/snF16u9DyLjV1qCWfd2nG8Uxyj6EI/k0gC9EBDwOUs+nQ2FIizqIN+AfQ2qGVTtBn
        V1Q71Tf38ooX1Bz2ByttH+w3reyW9NVtRWkdYuffIleMLZTsrFWv1mS18ZBVyks7eIT37h7jF1IZj
        6Mip+nkcq+B0RhIoanJ4l13lM/P5ULc2bAm7objNIF95R1vDIaF+JgvTolV5u0e6AzqzMK3c1ot7L
        wjWVySPuxijDTIJH3iyhDzspJ/gH9CDXaNdUDmBQlBNoOOyL/p9BG+KBvvDflLsTsKGdmMVvt3iSp
        bj/SxiPw==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMnn-0005kd-CH; Mon, 23 Mar 2020 13:07:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 9/9] xfs: kill XLOG_TIC_INITED
Date:   Mon, 23 Mar 2020 14:07:06 +0100
Message-Id: <20200323130706.300436-10-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323130706.300436-1-hch@lst.de>
References: <20200323130706.300436-1-hch@lst.de>
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
---
 fs/xfs/xfs_log.c      | 1 -
 fs/xfs/xfs_log_priv.h | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3eff7038e3ed..f70be8151a59 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3418,7 +3418,6 @@ xlog_ticket_alloc(
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
-	tic->t_flags		= XLOG_TIC_INITED;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d4f53664ae12..cfcf3f02e30a 100644
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

