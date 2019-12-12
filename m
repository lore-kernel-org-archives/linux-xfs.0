Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284B0C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F26212077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L3gxy9hN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfLLKyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53124 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfLLKyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DCfWg0pKsieeIMyN7uzcKBzcKcOqyBOkz9xagGMRn8Q=; b=L3gxy9hN5R3snACVOe1ydAs9mJ
        t1kQsg3P5OiFCF+pCEtUpjnvmWYIQB3eelZOtasY+jCP2+4Cw8/vRaDavAIeEF/Ms004J3DMtOv9n
        6hWmcq/yG4+j3GOvinv7rZWDP3iE/zW7WI7Ip12OzBLNTwc5LqbHNGFZM/R3RK/C7vWWfPa5oE2fS
        Xlxt9AiZkqT+rFyp/gCgrUDOQaGRPkLuvRBbilPljInl0ZtM7yoci6Ory+gRHJyYDQEDE09CKNCY/
        Rg7xpOJJlZMuGLVzeOZJmbSePErOl9NAjZsJk5E8it/qn9USMo4NQysCO8fHb6KjxUmcCG3yoV6mp
        pYgG3v4A==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7C-00016f-NX; Thu, 12 Dec 2019 10:54:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 01/33] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Thu, 12 Dec 2019 11:54:01 +0100
Message-Id: <20191212105433.1692-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Don't allow passing arbitrary flags as they change behavior including
memory allocation that the call stack is not prepared for.

Fixes: ddbca70cc45c ("xfs: allocate xattr buffer on demand")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h | 7 +++++--
 fs/xfs/xfs_ioctl.c       | 2 ++
 fs/xfs/xfs_ioctl32.c     | 2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 94badfa1743e..91c2cb14276e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -26,7 +26,7 @@ struct xfs_attr_list_context;
  *========================================================================*/
 
 
-#define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
+#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
 #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
 #define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
@@ -37,7 +37,10 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
 #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
-#define ATTR_ALLOC	0x8000	/* allocate xattr buffer on demand */
+#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
+
+#define ATTR_KERNEL_FLAGS \
+	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b35d62ede9f..2f76d0a7b818 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -462,6 +462,8 @@ xfs_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				ops[i].am_attrname, MAXNAMELEN);
 		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4c4f09113d3..8b5acf8c42e1 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -450,6 +450,8 @@ xfs_compat_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				compat_ptr(ops[i].am_attrname),
 				MAXNAMELEN);
-- 
2.20.1

