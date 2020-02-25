Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F285C4BA0A
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445622176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AW9uUGQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgBYXKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:10:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729478AbgBYXKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JV+08fyLmp+zR7dnmFV4jUFnu1m+M3IHX6bxlmwVTw0=; b=AW9uUGQ/QhGmR8aeUubTo6QL9A
        3iqCRbwf1otHSwm2OA0OrEx9gfNMvd5IHUydD0Z/XxyoOxxarn4FZsyKEXnApGttR1dyFlHcnmPFI
        2I1AGphKQtNVqa36XOgcH0PuwEc+opdxIkEmuC9BolR6uX6IfEcMrCBRPlYiaQVeZyC1PivBePk+/
        pM7zp+a7KXUW8Su2yZo9zQEhBxJsyWv3l9VWtAXEQMRQ97raqeUr9c9Pq/Lx6ZjKoLgjnb72Zi1iP
        zR7n0YPUEuPPISHVfkTTQQmiPJpOmFcYeuB00yZ8+LFc5KrlzH/MSSje3ru/d0H2MmleA7Z/fGo1K
        9vW6mPdQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLa-0003FK-70; Tue, 25 Feb 2020 23:10:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 30/30] xfs: clean up bufsize alignment in xfs_ioc_attr_list
Date:   Tue, 25 Feb 2020 15:10:12 -0800
Message-Id: <20200225231012.735245-31-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use the round_down macro, and use the size of the uint32 type we
use in the callback that fills the buffer to make the code a little
more clear - the size of it is always the same as int for platforms
that Linux runs on.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 58fd2d219972..c805fdf4ea39 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -415,7 +415,7 @@ xfs_ioc_attr_list(
 	context.resynch = 1;
 	context.attr_filter = xfs_attr_filter(flags);
 	context.buffer = buffer;
-	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
+	context.bufsize = round_down(bufsize, sizeof(uint32_t));
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_ioc_attr_put_listent;
 
-- 
2.24.1

