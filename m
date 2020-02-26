Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86F8C4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9892B2072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WVoJQbG5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgBZUZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35092 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Kt+ak/msDDzKxaD1yZUazMt/Y7/snwxaymL9YIVW1zY=; b=WVoJQbG54roAW0hNGOsfDvr8MM
        PR+LOKJPFsEVyA/oTCQd47+O4ZqIIXYnOQN76pXT6+qMDOrUpu31YrG+EMTHtLzwGzMTgym5qP48j
        JTmW6OAx9FHb9jPKhSjec7sY2HkwCjXlkXmAzjlCXR5K5tSRxllfYn7uFDZD9ZappzubK6NitV0U5
        5G5vgYMtVtSr6VOoCzXiu3nFVSKWbu2zzAjGxj0cqphhbwUKhl6qnE98IB/9kwzxx0Zyt6SdnNzwu
        Cd8gjQwTbgVZA8kGH/GVTxvt4JpU0f1qmuxjRcFuBK7h4MCekfxLxR6ddCPuzrB0vmLFOOHwcZrmS
        YpTObEtA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Et-0000Sc-UM; Wed, 26 Feb 2020 20:25:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/32] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Wed, 26 Feb 2020 12:22:55 -0800
Message-Id: <20200226202306.871241-22-hch@lst.de>
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

The version taking the context structure is the main interface to list
attributes, so drop the _int postfix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 09901aa4ad99..ba71bf4303f8 100644
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
index bafa47e36119..a8fe9553b432 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -394,7 +394,7 @@ xfs_ioc_attr_list(
 	alist->al_more = 0;
 	alist->al_offset[0] = context.bufsize;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	ASSERT(error <= 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index b5f2831fad95..260287552ad4 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,7 +234,7 @@ xfs_vn_listxattr(
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	if (error)
 		return error;
 	if (context.count < 0)
-- 
2.24.1

