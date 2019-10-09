Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BBEC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2417A206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DkML6wdV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfJIOcS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43976 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SqQisiBSnbAcZpioLOU3Z2JZO39roaAYUMHeddu0SXY=; b=DkML6wdVTAUAFPo/xwJ0yqaO9
        L+dBykpa0YQWilCKXuU8WhLSH0xQi/00+3Bzy1OsL3AjaZUtfylEUkR36ILNtN2URTrxMZfyyTL5k
        tpRiO4FPP1BUTrPUHuOifkfztZEudg2Px42sEc2q5QZJmkdP73vbgD3lnCXty0O/2W0Gc9gk0A1om
        VwEDa8cVP+VOi+LY1p+nR49O0bYz+ax8IYnaLAq+gLnge2sITVnFcc5omSdsU2+mABq+bfFGVfEKA
        FmolE1aSzLjSIEivCwguH8R+6FaVL5TRBRxwNl0LONnYBvf4ANPyH1c++TAB8nsT4C3ZiLn8gbqqn
        KyLRK/L3g==;
Received: from 089144204014.atnat0013.highway.webapn.at ([89.144.204.14] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0k-0005c0-3Z
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: pass the correct flag to xlog_write_iclog
Date:   Wed,  9 Oct 2019 16:27:41 +0200
Message-Id: <20191009142748.18005-2-hch@lst.de>
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

xlog_write_iclog expects a bool for the second argument.  While any
non-0 value happens to work fine this makes all calls consistent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2beee9f74da..cd90871c2101 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1735,7 +1735,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
+		xlog_state_done_syncing(iclog, true);
 		up(&iclog->ic_sema);
 		return;
 	}
-- 
2.20.1

