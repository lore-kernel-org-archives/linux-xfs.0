Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089A6C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9032077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c3TtA6z5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfLLKyw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbfLLKyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xrN9ae4IDLeSIesOIAa2iCcAHrSaWB/sMJDXZYDhD3M=; b=c3TtA6z5KHKjDMO9Ih3t+HMU2s
        lcP5Zb9sMLneLx+zJunl5G6oaXsJWP1TiLukw5AZQz3Jm97YGr63JqBt/5PPtjnaglRsTHCb+QKLL
        2EFSioUkWQ7dFDKmYYY0EfJ/J7rOeTS3HdXuMV//jL6PP0LbUmFIzOqDLUwtkjFPCla1d5AoPl8/n
        6/Wty3lnHrpdqNx9xM6MReEydPnvpH+cygawgDGNcN49QB9J/zrDsyWSQAKZHOg9AsPO8SGXio1Bt
        idIVyWeZeJYsaE4j6tYpDiWMjiY5RFgFrfAu5dZv3mlfBjRrYrQT2XdApVGIQrtKQE9TV+olqSH8I
        4rgvPbJQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7P-00019S-Ov; Thu, 12 Dec 2019 10:54:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 07/33] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Thu, 12 Dec 2019 11:54:07 +0100
Message-Id: <20191212105433.1692-8-hch@lst.de>
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

Merge the ioctl handlers just like the low-level xfs_attr_set function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
 fs/xfs/xfs_ioctl.h   |  6 ------
 fs/xfs/xfs_ioctl32.c |  4 ++--
 3 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 75ab6e384c16..7f3cd5648e7a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -384,17 +384,19 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags)
 {
-	unsigned char		*kbuf;
+	unsigned char		*kbuf = NULL;
 	int			error;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	if (len > XFS_XATTR_SIZE_MAX)
-		return -EINVAL;
 
-	kbuf = memdup_user(ubuf, len);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
+	if (ubuf) {
+		if (len > XFS_XATTR_SIZE_MAX)
+			return -EINVAL;
+		kbuf = memdup_user(ubuf, len);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+	}
 
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
 	if (!error)
@@ -403,22 +405,6 @@ xfs_attrmulti_attr_set(
 	return error;
 }
 
-int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags)
-{
-	int			error;
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-	error = xfs_attr_set(XFS_I(inode), name, NULL, 0, flags);
-	if (!error)
-		xfs_forget_acl(inode, name, flags);
-	return error;
-}
-
 STATIC int
 xfs_attrmulti_by_handle(
 	struct file		*parfilp,
@@ -497,8 +483,8 @@ xfs_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 420bd95dc326..819504df00ae 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -46,12 +46,6 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags);
 
-extern int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags);
-
 extern struct dentry *
 xfs_handle_to_dentry(
 	struct file		*parfilp,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 720eb72f3be3..76b1382c2214 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -486,8 +486,8 @@ xfs_compat_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
-- 
2.20.1

