Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E1DCA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF17421726
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IOKrg2Ac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfJ0O4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bpURd3b1EaKZ8Sbz115STRLLVVkQdWZC+J+RFsY6ZHo=; b=IOKrg2AcQAO091SZeyIdad3dgP
        GxlJPOX/ar4ncyYgE3gqIRJxkbos2bI430HJKXzQwZjX1zpQNwP1bemQDhtaN4OjJvnoaFPrDYEE0
        TcwO/NzB9e4dwwJV22pehwoySYjvtODrS2VC/KgEjcXd9ba3GIpOqpS1aD5RBLWAwXCOZ9pfTlP52
        juP04/p6wcbtlnsVa4r8Q8q7hf5ufPwlWPmPLl0vizfHhMyNWebDpDls431MWaFqurhzlZqAzV/VN
        THcH8orKGlQWzYHoD+vcbfoEYP7TRg6RGQVknWIk9g3rttlH69gcSbeXRUXk5/6kQW9G/PHDSQTNn
        C+B+ATlQ==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxq-0005P6-Jw; Sun, 27 Oct 2019 14:56:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 10/12] xfs: clean up printing the allocsize option in xfs_showargs
Date:   Sun, 27 Oct 2019 15:55:45 +0100
Message-Id: <20191027145547.25157-11-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove superflous cast.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f21c59822a38..93ed0871b1cf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -446,7 +446,7 @@ xfs_showargs(
 
 	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
 		seq_printf(m, ",allocsize=%dk",
-				(int)(1 << mp->m_allocsize_log) >> 10);
+			   (1 << mp->m_allocsize_log) >> 10);
 
 	if (mp->m_logbufs > 0)
 		seq_printf(m, ",logbufs=%d", mp->m_logbufs);
-- 
2.20.1

