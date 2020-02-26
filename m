Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7912C4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FBDF20714
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tJ+Ft5TA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgBZUZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=l5nIo65zNVUuRANK+XB/oBebCMOJCs5q82C/puyD9Ug=; b=tJ+Ft5TAJBJPdfm2DMlgeUbFVP
        iYSlJca1KBnYd5qiFrlub1dA34HnpBX6UhKboX4HSsHKgiOSz8kLDZ7pKxN5P5q3Xh6YzjqqT4BIO
        4hx/lMRFT46HXOjjLCCJK5svQ3IpVWSWu/Djszq7Ho+88byQlOygKM4K3+bF1uVRL6Alc9NQV4Pjn
        iSu07lj+nl+8xt5x1lwHl4ilizCXXKQ9gidX4Zu896p2FAaNBcbBmX8Mig5lFp9OLofmbzE+FXKcy
        MPDM00RJZAEW5iEhM1io7b0cdEsceZ/lL1ZmsK54jroXwJaroxbktUAaBUSjJBUbdzJmBlg9TGl0g
        yL/puS3w==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Fl-0001W2-0h; Wed, 26 Feb 2020 20:25:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 31/32] xfs: only allocate the buffer size actually needed in __xfs_set_acl
Date:   Wed, 26 Feb 2020 12:23:05 -0800
Message-Id: <20200226202306.871241-32-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need to allocate the max size if we can just allocate the easily
known actual ACL size.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_acl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 552258399648..5807f11aed3e 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -187,16 +187,11 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	args.namelen = strlen(args.name);
 
 	if (acl) {
-		args.valuelen = XFS_ACL_MAX_SIZE(ip->i_mount);
+		args.valuelen = XFS_ACL_SIZE(acl->a_count);
 		args.value = kmem_zalloc_large(args.valuelen, 0);
 		if (!args.value)
 			return -ENOMEM;
-
 		xfs_acl_to_disk(args.value, acl);
-
-		/* subtract away the unused acl entries */
-		args.valuelen -= sizeof(struct xfs_acl_entry) *
-			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 	}
 
 	error = xfs_attr_set(&args);
-- 
2.24.1

