Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110E1ECE58C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3CDD21D56
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nj+IV1+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfJKND1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 09:03:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbfJKND1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 09:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ezLWSOH/o7CPyGIyxwF21qdi04LS8Kl3Tprxv3BAWqM=; b=nj+IV1+SHX5HovQH1bG1LW/Hs
        pr4lRfrAOaTGApQulk06lZzSTriG+jSq8otIM5grWQl3OevC9d96xW/wJN4u6DY21431nQrGj8zcI
        fC7gnIDqlKmo1UZKJ+nQbzwE4J9ovUPbe/iLsNmxAclVUPxiexVfeVrRgdNa6z+uAfEImGw3KUa3r
        rYIa/Ji5iig3STvFSVlxnGLlNFD5IA8MC9PGf+Tu1mP7kqx+DVxL37e6K/4vyBfpVuHjCAfh2LkmV
        Tqlwycp1NGK6qqhcK8O9n5fF0Sayaa66JUXjSep9MQm+x4tXnVbJd78lZSHEN1Nv/lf6Mfp9Vg/i5
        slIS36lyw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIuZq-00079w-S8
        for linux-xfs@vger.kernel.org; Fri, 11 Oct 2019 13:03:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: disable xfs_ioc_space for always COW inodes
Date:   Fri, 11 Oct 2019 15:03:15 +0200
Message-Id: <20191011130316.13373-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011130316.13373-1-hch@lst.de>
References: <20191011130316.13373-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we always have to write out of place preallocating blocks is
pointless.  We already check for this in the normal falloc path, but
the check was missig in the legacy ALLOCSP path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d58f0d6a699e..abf7a102376f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -33,6 +33,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_reflink.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -607,6 +608,9 @@ xfs_ioc_space(
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	if (xfs_is_always_cow_inode(ip))
+		return -EOPNOTSUPP;
+
 	if (filp->f_flags & O_DSYNC)
 		flags |= XFS_PREALLOC_SYNC;
 	if (filp->f_mode & FMODE_NOCMTIME)
-- 
2.20.1

