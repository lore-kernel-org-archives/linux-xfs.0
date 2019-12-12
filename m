Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43110C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186642077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gKiyUqVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfLLKzg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:55:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbfLLKzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n4E8k4FBdBgTf5L7n/J8yGoCi6a36KCC9p4UOmAvH98=; b=gKiyUqVxaAmQBTMQQ7Gq5FHGvh
        dzVFN6i2jNVgA7oaUyqL8aN7uTDvv1SUHzM0iVg+mAvqAaTrFjbSKveKLKwZkmz72fY5obpzwuEth
        4YO5nl6Bivgf/Hq0gpsNxXG37F+y/lnX/JUJ/D8KU0D0mAPEMCg2/Aq/rPlcxZIMbK5/5c8Thj0Me
        zwM3ofg9h5gSbdvwC+L8b2yql7eVi/CqIMhHdGNvNG8I0NggSveMrUOX69gj8kVK+Q0wTNcuMPB5g
        4HMKaMskeoe44+RjRuzgndd6Zs8zvea3LWXgijMZcH3LhitEnD5rmiijENUIOqBsUJfGvfXkycghN
        4RzJ6NGg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM88-0002Vx-1d; Thu, 12 Dec 2019 10:55:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 25/33] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Thu, 12 Dec 2019 11:54:25 +0100
Message-Id: <20191212105433.1692-26-hch@lst.de>
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

The version taking the context structure is the main interface to list
attributes, so drop the _int postfix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h | 4 ++--
 fs/xfs/scrub/attr.c      | 4 ++--
 fs/xfs/xfs_attr_list.c   | 6 +++---
 fs/xfs/xfs_ioctl.c       | 2 +-
 fs/xfs/xfs_xattr.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0e3c213f78ce..8d42f5782ff7 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -102,8 +102,8 @@ struct xfs_attr_list_context {
  * Overall external interface routines.
  */
 int xfs_attr_inactive(struct xfs_inode *dp);
-int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
+int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
+int xfs_attr_list(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 05537627211d..9e336d797616 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -98,7 +98,7 @@ struct xchk_xattr {
 /*
  * Check that an extended attribute key can be looked up by hash.
  *
- * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
+ * We use the XFS attribute list iterator (i.e. xfs_attr_list_ilocked)
  * to call this function for every attribute key in an inode.  Once
  * we're here, we load the attribute value to see if any errors happen,
  * or if we get more or less data than we expected.
@@ -516,7 +516,7 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xfs_attr_list_int_ilocked(&sx.context);
+	error = xfs_attr_list_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		goto out;
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 369ce1d3dd45..ea79219859a0 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -507,7 +507,7 @@ xfs_attr_leaf_list(
 }
 
 int
-xfs_attr_list_int_ilocked(
+xfs_attr_list_ilocked(
 	struct xfs_attr_list_context	*context)
 {
 	struct xfs_inode		*dp = context->dp;
@@ -527,7 +527,7 @@ xfs_attr_list_int_ilocked(
 }
 
 int
-xfs_attr_list_int(
+xfs_attr_list(
 	struct xfs_attr_list_context	*context)
 {
 	struct xfs_inode		*dp = context->dp;
@@ -540,7 +540,7 @@ xfs_attr_list_int(
 		return -EIO;
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
-	error = xfs_attr_list_int_ilocked(context);
+	error = xfs_attr_list_ilocked(context);
 	xfs_iunlock(dp, lock_mode);
 	return error;
 }
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0fa943084363..5a88e4d3c8b9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -395,7 +395,7 @@ xfs_ioc_attr_list(
 	alist->al_more = 0;
 	alist->al_offset[0] = context.bufsize;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	ASSERT(error <= 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 8880dee3400f..e1951d2b878e 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -232,7 +232,7 @@ xfs_vn_listxattr(
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	if (error)
 		return error;
 	if (context.count < 0)
-- 
2.20.1

