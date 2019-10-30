Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50F6CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA772087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NUxWC3Cs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfJ3SEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:04:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJ3SEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iS01O+4BV7lgBIkcD52NMlNdJfIjsdhjkrcO50yK2XQ=; b=NUxWC3Csn7nLUBa6CQ7fvteKrG
        qkxAX69yWHXb035eea3iXM1z0ROHNdU4JggPbFXxCwgCVPojkO2rgN/SJoKNCfo8AIIJDR5vT0DwE
        WumpH9tQsu3HVcDNLRDh9bFM41K4yH5TdoE8ciyfBZy5duZGCISw5GCmOvdoB7ZozvJUmHeE4BYVP
        EzfOeinIbErI9K37jIKYcwp3kY9Ci8uCrfU4Q/xlEAHTT4R6dwjnt972ltU2lNzoShFt5m4rWw5tB
        lpWLv5kO0lU7vg9JfDEdtIQ1cfFObJWwmkPJlypTnB5or40jks4/G2A/ql+7e3U5fIcuvuKGImNs4
        k0/avhag==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKj-0005eT-Mk; Wed, 30 Oct 2019 18:04:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/9] xfs: mark xfs_eof_alignment static
Date:   Wed, 30 Oct 2019 11:04:12 -0700
Message-Id: <20191030180419.13045-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c | 2 +-
 fs/xfs/xfs_iomap.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4209c32db96d..02526cffc5a3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -116,7 +116,7 @@ xfs_iomap_end_fsb(
 		   XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));
 }
 
-xfs_extlen_t
+static xfs_extlen_t
 xfs_eof_alignment(
 	struct xfs_inode	*ip,
 	xfs_extlen_t		extsize)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 7aed28275089..d5b292bdaf82 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -17,7 +17,6 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *, u16);
-xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 static inline xfs_filblks_t
 xfs_aligned_fsb_count(
-- 
2.20.1

