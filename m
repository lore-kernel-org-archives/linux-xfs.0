Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14022C35659
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A412073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ieqDL9LO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgBUOME (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59454 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbgBUOL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=B49G+A9JwZh0yTpfapF4ncPg3q+Oj1NCTHZ41mt1fCA=; b=ieqDL9LOcgvijcjnGYQPjGWiBF
        7bWgN5VroCLewXbatxhiz7Z1MEEKzZ8fcv0MX738gkHA97V0UR8/5amRJLOg1GnOt/5G65ZTGhOcy
        VtGydPTbBIa672168FkNZJ3pXTnXdqNxxB8+AsyI3Szd6H5uxWm/0ncAv1pfiYiT+77vAdHrNiGtS
        Ev4INvhoeRBIUu0NrMFi2TFUsKJbMXb4TUHgY2fYNglGjsRPECK4jnWn10m7M36J6Jp+VqWUEYqNM
        QR7qVUY0YdT9xrxN4ESpbzgGSgdkNur5MUOJV/xoro7kAztJflCjGDiL5AVT3GxEI+6OpBoLvwkZE
        RMM+6Sfw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5927-0000K3-NN; Fri, 21 Feb 2020 14:11:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/31] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Fri, 21 Feb 2020 06:11:45 -0800
Message-Id: <20200221141154.476496-23-hch@lst.de>
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
index 1cc819d77fd3..4304028d8837 100644
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

