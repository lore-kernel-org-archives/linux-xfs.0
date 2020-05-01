Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6E4C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBFC2166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SG2YoAup"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgEAIOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BD3C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=qaed+lGHJ8Wp0pSTnVESboZzNgOzdkWxhrnT/lfY7Qo=; b=SG2YoAupgWo/RXmFAtTqC3MO1x
        kk0MXab8M9lqOFg4sNNZHyvTza/my50RbuniZq+oegp/rqDAgRFIrx/Pmnok42qXz3Q2Nj/80IWcp
        1hp1RZum3/MRD49cEXQMAD5EZNArjs/qVwyl/iHCOIXK1fqc+C+lNyr9NNeM5E/m5rHtkmNsDXn3p
        8EFYMC7TeIkbVq2RXhn8pES2G7hzmq6GB25tg8ZrgXVwjbStn2rnvz4LCfNvB+RyiSJSnleyMNm1Q
        wUXSUcDThCgvv1s8K8D5u03AAcdLGHdsF6fMhPvo1bOm8H6rH6ID5XZN9JTix7K/qM1bXHE1WQaW+
        OlGpEugw==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQon-0002vW-8a
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: remove xfs_ifork_ops
Date:   Fri,  1 May 2020 10:14:20 +0200
Message-Id: <20200501081424.2598914-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_ifork_ops add up to two indirect calls per inode read and flush,
despite just having a single instance in the kernel.  In xfsprogs
phase6 in xfs_repair overrides the verify_dir method to deal with inodes
that do not have a valid parent.  Instead of the costly indirection just
life the repair code into xfs_dir2_sf.c under a condition that ensures
it is compiled as part of a kernel build, but instantly eliminated as
it is unreachable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c    | 64 ++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.c | 19 +++-------
 fs/xfs/libxfs/xfs_inode_fork.h | 15 ++------
 fs/xfs/xfs_inode.c             |  4 +--
 4 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 7b7f6fb2ea3b2..1f6c30b68917c 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -705,8 +705,8 @@ xfs_dir2_sf_check(
 #endif	/* DEBUG */
 
 /* Verify the consistency of an inline directory. */
-xfs_failaddr_t
-xfs_dir2_sf_verify(
+static xfs_failaddr_t
+__xfs_dir2_sf_verify(
 	struct xfs_inode		*ip)
 {
 	struct xfs_mount		*mp = ip->i_mount;
@@ -804,6 +804,66 @@ xfs_dir2_sf_verify(
 	return NULL;
 }
 
+/*
+ * When we're checking directory inodes, we're allowed to set a directory's
+ * dotdot entry to zero to signal that the parent needs to be reconnected
+ * during xfs_repair phase 6.  If we're handling a shortform directory the ifork
+ * verifiers will fail, so temporarily patch out this canary so that we can
+ * verify the rest of the fork and move on to fixing the dir.
+ */
+static xfs_failaddr_t
+xfs_dir2_sf_verify_dir_check(
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_dir2_sf_hdr		*sfp =
+		(struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
+	int				size = ifp->if_bytes;
+	bool				parent_bypass = false;
+	xfs_ino_t			old_parent;
+	xfs_failaddr_t			fa;
+
+	/*
+	 * If this is a shortform directory, phase4 in xfs_repair may have set
+	 * the parent inode to zero to indicate that it must be fixed.
+	 * Temporarily set a valid parent so that the directory verifier will
+	 * pass.
+	 */
+	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
+	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
+		old_parent = xfs_dir2_sf_get_parent_ino(sfp);
+		if (!old_parent) {
+			xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
+			parent_bypass = true;
+		}
+	}
+
+	fa = __xfs_dir2_sf_verify(ip);
+
+	/* Put it back. */
+	if (parent_bypass)
+		xfs_dir2_sf_put_parent_ino(sfp, old_parent);
+	return fa;
+}
+
+/*
+ * Allow xfs_repair to enable the parent bypass mode.  For now this is entirely
+ * unused in the kernel, but might come in useful for online repair eventually.
+ */
+#ifndef xfs_inode_parent_bypass
+#define xfs_inode_parent_bypass(ip)	0
+#endif
+
+xfs_failaddr_t
+xfs_dir2_sf_verify(
+	struct xfs_inode		*ip)
+{
+	if (xfs_inode_parent_bypass(ip))
+		return xfs_dir2_sf_verify_dir_check(ip);
+	return __xfs_dir2_sf_verify(ip);
+}
+
 /*
  * Create a new (shortform) directory.
  */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f30d43364aa92..f6dcee919f59e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -673,18 +673,10 @@ xfs_ifork_init_cow(
 	ip->i_cnextents = 0;
 }
 
-/* Default fork content verifiers. */
-struct xfs_ifork_ops xfs_default_ifork_ops = {
-	.verify_attr	= xfs_attr_shortform_verify,
-	.verify_dir	= xfs_dir2_sf_verify,
-	.verify_symlink	= xfs_symlink_shortform_verify,
-};
-
 /* Verify the inline contents of the data fork of an inode. */
 xfs_failaddr_t
 xfs_ifork_verify_data(
-	struct xfs_inode	*ip,
-	struct xfs_ifork_ops	*ops)
+	struct xfs_inode	*ip)
 {
 	/* Non-local data fork, we're done. */
 	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
@@ -693,9 +685,9 @@ xfs_ifork_verify_data(
 	/* Check the inline data fork if there is one. */
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFDIR:
-		return ops->verify_dir(ip);
+		return xfs_dir2_sf_verify(ip);
 	case S_IFLNK:
-		return ops->verify_symlink(ip);
+		return xfs_symlink_shortform_verify(ip);
 	default:
 		return NULL;
 	}
@@ -704,13 +696,12 @@ xfs_ifork_verify_data(
 /* Verify the inline contents of the attr fork of an inode. */
 xfs_failaddr_t
 xfs_ifork_verify_attr(
-	struct xfs_inode	*ip,
-	struct xfs_ifork_ops	*ops)
+	struct xfs_inode	*ip)
 {
 	/* There has to be an attr fork allocated if aformat is local. */
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
 		return NULL;
 	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
 		return __this_address;
-	return ops->verify_attr(ip);
+	return xfs_attr_shortform_verify(ip);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8487b0c88a75e..3f84d33abd3b7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -176,18 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
-typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
-
-struct xfs_ifork_ops {
-	xfs_ifork_verifier_t	verify_symlink;
-	xfs_ifork_verifier_t	verify_dir;
-	xfs_ifork_verifier_t	verify_attr;
-};
-extern struct xfs_ifork_ops	xfs_default_ifork_ops;
-
-xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
-		struct xfs_ifork_ops *ops);
-xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
-		struct xfs_ifork_ops *ops);
+xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
+xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29d..93967278355de 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3769,7 +3769,7 @@ xfs_inode_verify_forks(
 	struct xfs_ifork	*ifp;
 	xfs_failaddr_t		fa;
 
-	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
+	fa = xfs_ifork_verify_data(ip);
 	if (fa) {
 		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
@@ -3777,7 +3777,7 @@ xfs_inode_verify_forks(
 		return false;
 	}
 
-	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
+	fa = xfs_ifork_verify_attr(ip);
 	if (fa) {
 		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-- 
2.26.2

