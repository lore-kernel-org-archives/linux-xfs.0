Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B2AC33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B648A21744
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bUfV9fX/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgAGQys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:54:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGQyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vIvuVt2fY3VUuV1knM+rjYXU5OqZwZpaAmhbjkcSRZU=; b=bUfV9fX/9bq117OGDsLu6jlMl
        NxSH6DvTJFkRCGDAbTqa2F9SQFZYkaAADvAPw8GwdTBaz9XQreK89yRAcb483IuBNYTkLEnmq/RpD
        jM2d496D4T3GxxmqajxssQA+ngd71J13xHbAwNVJse20JQ1dsgy9AExONc0vY/o7VBXJwlAjcbPDX
        tBTYGEb4FBB3h3ygXj841njJRnWc7rbtEaXqB50GrqbHGr6Z7HcUJK9r9p8SfT1cds/oMYc5HtLGg
        I0a4BmBwaZmj/NPht6NYF47VdGrOs8XbrQmdC9REA8Xz1nK9BS09VwucEJjzxANL5afrCMw4nFnf7
        GMatdPEXA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios7y-0002PG-O4
        for linux-xfs@vger.kernel.org; Tue, 07 Jan 2020 16:54:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Tue,  7 Jan 2020 17:54:39 +0100
Message-Id: <20200107165442.262020-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107165442.262020-1-hch@lst.de>
References: <20200107165442.262020-1-hch@lst.de>
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
index 7b35d62ede9f..edfbdb8f85e2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -462,6 +462,8 @@ xfs_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				ops[i].am_attrname, MAXNAMELEN);
 		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4c4f09113d3..bd9d9ebf85d8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -450,6 +450,8 @@ xfs_compat_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				compat_ptr(ops[i].am_attrname),
 				MAXNAMELEN);
-- 
2.24.1

