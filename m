Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF74C34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24CC207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KCAhhsN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBQNBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:01:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ym6Gx/SnENX4Z2oFZ12KeywcPImsdI1DfDUt2UD6Qtw=; b=KCAhhsN3wpKNCqMAnsnDFr6eGT
        yyM8SmCmYJSJV7t0lnNsw4m9GLQxvAMbUNjmFGd7Uebl7ehhzC6pSn6+XNM2tNH0/9MAW2DsxJCex
        Lakbni4Dfr5Rc/F6sz1/+LpasgOIr4DFkCOSBzpZAV1dQW1CQjUojNGxZkE1Fi5UbwWZbS5Ust5l7
        2DG1+444m1wvCR0ly1CZgrSxOvBXbPBOK2pYyFH02rEky7yCTcM1ZGcau0hVoza57w7vBq0w6uXb9
        je4LMueI0cb2PI5zKzeu+X87hpFkP6P3qhGtyel7jJjpjWb/byH9VsiyPsjs3vnqMgMSLM8cWidA1
        H88piJGg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1I-0001yK-Iv; Mon, 17 Feb 2020 13:01:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/31] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Mon, 17 Feb 2020 13:59:48 +0100
Message-Id: <20200217125957.263434-23-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
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
index 47c39895977b..0f9326bc055c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -393,7 +393,7 @@ xfs_ioc_attr_list(
 	alist->al_more = 0;
 	alist->al_offset[0] = context.bufsize;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	ASSERT(error <= 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 5276874a7aec..3b18e782bdd6 100644
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
2.24.1

