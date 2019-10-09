Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BCDC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C4C206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aIJxl8/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfJIOca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NaJuP9MlpiEWtgdEDNNVMPTJ+zzOggF87z/WMUulaoo=; b=aIJxl8/2mlm9eS8CI27j5A5oE
        UcqrZwZQwUiw1zehAI0/vYwP1Z/nBHHbFvT2V9MaGwypecGekdBDM8I/epjf8QpUxys0j7HTDn6IA
        /rUo/eQ/iLE4Ymg8mRZDc1QZhDJgzzMRQUwKpyokM4dT9E+5a61xHSXTwcKFvcBX5tJH9GteOZ1z+
        8LyMV3X4z2TjUoFSAw4xHp3jCZjhRQzTA04R3f+kGPG1HuijXej6e3iCkKeHeRWt/3tNWHbxcWHeJ
        iGN1cgoKWOUA7H1uh0d1/x0GCP3eVOEvsQdk2v6Ehy9dXEx07Vx9ODN8tIPl9hF/VyauUgnI6Ts4J
        9lBcphAGA==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0v-0005dV-SF
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: remove dead ifdef XFSERRORDEBUG code
Date:   Wed,  9 Oct 2019 16:27:45 +0200
Message-Id: <20191009142748.18005-6-hch@lst.de>
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

XFSERRORDEBUG is never set and the code isn't all that useful, so remove
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 67a767d90ebf..7a429e5dc27c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3996,19 +3996,6 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log, true, NULL);
 
-#ifdef XFSERRORDEBUG
-	{
-		xlog_in_core_t	*iclog;
-
-		spin_lock(&log->l_icloglock);
-		iclog = log->l_iclog;
-		do {
-			ASSERT(iclog->ic_callback == 0);
-			iclog = iclog->ic_next;
-		} while (iclog != log->l_iclog);
-		spin_unlock(&log->l_icloglock);
-	}
-#endif
 	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
 }
-- 
2.20.1

