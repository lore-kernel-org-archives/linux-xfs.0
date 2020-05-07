Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58491C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3612520CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AJyqgFJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEGMTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99050C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9uoMhEUPzDXw4IO1dqPnoZfyVZKStj5mlIKh0aY1/m0=; b=AJyqgFJFPggp2y/5JfGnaOb4dR
        P/u45SK5pg/Tgh1B+PIcUMdRwiOYzAAxNl2ilsaFvFUtjWjGEzbJ9rEM4zoZAHu2QCQvDIUUlScTq
        VJeixQWXK6THAyJz5Tv4ysAnCzW50Yxp6yXxqwZBzjbrmG7aqS6c971EzDUKHJPfMwiQACzrj6GmD
        5FUF5WLl/KKIoGnmM2I0wX/XsX3fPLN2yspC0aS+EVCqUwOaHncuf+1gX1BMdyj/0Nn+MBrcGJipH
        jBR9xtAMQ/NBOd2RIKwx3Z9luCej/zPSwp7EA8ri8Y+qPoolZS8FskJQVCyy16jDFwDzSQxGMiBND
        1aTOHtoQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUl-000572-4Y; Thu, 07 May 2020 12:19:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/58] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Thu,  7 May 2020 14:18:03 +0200
Message-Id: <20200507121851.304002-11-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 4df28c64e4388ac5fa59cd58f9fd6592aae533a2

All the callers already check the length when allocating the
in-kernel xattrs buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c      | 18 ++++++++++++++++--
 libxfs/xfs_attr.c |  3 ---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index d4b812e6..c39782b3 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -69,6 +69,7 @@ attr_set_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
 	int		c, valuelen = 0, flags = 0;
+	size_t		namelen;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -132,6 +133,12 @@ attr_set_f(
 		return 0;
 	}
 
+	namelen = strlen(name);
+	if (namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
+
 	if (valuelen) {
 		value = (char *)memalign(getpagesize(), valuelen);
 		if (!value) {
@@ -150,7 +157,7 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
+	if (libxfs_attr_set(ip, (unsigned char *)name, namelen,
 				(unsigned char *)value, valuelen, flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
@@ -177,6 +184,7 @@ attr_remove_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name;
 	int		c, flags = 0;
+	size_t		namelen;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -223,6 +231,12 @@ attr_remove_f(
 		return 0;
 	}
 
+	namelen = strlen(name);
+	if (namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
+
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
@@ -230,7 +244,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
+	if (libxfs_attr_set(ip, (unsigned char *)name, namelen,
 			NULL, 0, flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ee2225a3..ded952da 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -72,9 +72,6 @@ xfs_attr_args_init(
 	args->flags = flags;
 	args->name = name;
 	args->namelen = namelen;
-	if (args->namelen >= MAXNAMELEN)
-		return -EFAULT;		/* match IRIX behaviour */
-
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return 0;
 }
-- 
2.26.2

