Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C04C3565B
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3234F24650
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W4m35vHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgBUOMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59594 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgBUOMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:12:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0HA864KCGBerK1+P6JX+PPAw3EHz5y/ZPy3g0lUZCIA=; b=W4m35vHtJ3rvryuujb3+L8ye2w
        kbFNwAcUeW69hdncN86tfQCJH8hegQB4mrIAU2GnGGTvpQvxGx0K1So0J3DDMgvr1Ij8BWeixYxJ6
        2MfBJEiqXNVj8Uibcg9G1UKyaSFp4LGS1V4uPhWB5vGVfHbEodgYFjJxK8rBZiVeAFPr7aEbmG2Gv
        6U8CriUOML26bzNEQxVqUXCF7t6gktWoEq+uUEqqmby2GLqwkYx48Pw2KEOTtYenQigWCJZDglyEB
        vCfcK6tC2bEgyKP8qtlrjrY+uzWIbed5oIcokYCrHSGJSNlC6J6o847SEXN62sMdiL37fsSBXSE2b
        9cYA/tEw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5929-0000Lo-Ks; Fri, 21 Feb 2020 14:12:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 31/31] xfs: clean up bufsize alignment in xfs_ioc_attr_list
Date:   Fri, 21 Feb 2020 06:11:54 -0800
Message-Id: <20200221141154.476496-32-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
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
index 4b126f5e9bed..0690e1a8ef1a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -414,7 +414,7 @@ xfs_ioc_attr_list(
 	context.resynch = 1;
 	context.attr_filter = xfs_attr_filter(flags);
 	context.buffer = buffer;
-	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
+	context.bufsize = round_down(bufsize, sizeof(uint32_t));
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_ioc_attr_put_listent;
 
-- 
2.24.1

