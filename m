Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9470AC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E621206C3
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t21PehvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKSKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:10:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKSKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uGHxGt5zO99D35iT63QOwpZl8+/vXlR2OqEMcrrMMp0=; b=t21PehvXqNWcHvDUAjnsi3h7H
        AL6ogZIdpIlJaVbtXQ3wAn6AZqpxwJu2xnRa2Nm9WwrmNpfolyYmklyCEDLlZZGaBuGtQxTMLcIIg
        Rc5ZPo5LGMoCK+Ry8Uat7AtnrByF7rqmKXivi06OEAW3SuoJsRVjY6en7euriGpsynYsRfocAbBOC
        9pkALyRrZH8VCzFLsx8lgDhPOGOYBuv2FbqTYX4LLNkC9ZCygY9tcNpDVZ+OLZnQ5QlXxdzLVQ6Vl
        ddda1l7G31LQ4uCaU75pKkQ8FPrnW94AlqJdScMSq1iRNNdpzsypHpkf1jh4cRXEphVhnH9hAfSOI
        4bfKpuy0A==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUE8W-0006VY-8i
        for linux-xfs@vger.kernel.org; Mon, 11 Nov 2019 18:10:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the unused m_chsize field
Date:   Mon, 11 Nov 2019 19:09:57 +0100
Message-Id: <20191111180957.23443-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2dceb446e651..43145a4ab690 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -155,7 +155,6 @@ typedef struct xfs_mount {
 	int			m_swidth;	/* stripe width */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
-	uint			m_chsize;	/* size of next field */
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-- 
2.20.1

