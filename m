Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4A4C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D3F208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PT2NABhV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgEGMTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DC7C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lZ6EBU155Y3oq5N52eGJZbFFvfD4G0jlHdbgqlRAMHU=; b=PT2NABhVsYA8Y/TmwZl7YuYeu3
        C7y5ZiLCZHsaWNRC6wsFnKp8wAsnNkAfGCqsZP0gkojA66q4EqPZEuqegFDkshlOkzTiyqnWNJW+M
        oLdlHQvgcnlsrfA9UR1J6kEp6AXem8P0gjlMbJYL/1z8ksEDYyJjDYNJtro5Fk65Uy3fCro5Av4Av
        kgHth+oH9iLKcyWwfYfMp1LsGNCcJxDNvFnyC3Row5l1d0QWNE5+EJJIpdkoLkn3xEAsK0MajXtNn
        wBvfSNNFtWEdzMQrZ93VC77RWsZWgW1dNdc4dMLBj6Iq6cTJ6W7vYwtdCVhh1lLqVUB15cJB70YXp
        AFg5D5cQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUg-00055s-6M; Thu, 07 May 2020 12:19:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/58] xfs: merge xfs_attr_remove into xfs_attr_set
Date:   Thu,  7 May 2020 14:18:01 +0200
Message-Id: <20200507121851.304002-9-hch@lst.de>
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

Source kernel commit: 0eb81a5f5c34429f0d86329260b3b07e2d4c5e22

The Linux xattr and acl APIs use a single call for set and remove.
Modify the high-level XFS API to match that and let xfs_attr_set handle
removing attributes as well.  With a little bit of reordering this
removes a lot of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c             |   3 +-
 libxfs/libxfs_api_defs.h |   1 -
 libxfs/xfs_attr.c        | 179 ++++++++++++++-------------------------
 libxfs/xfs_attr.h        |   2 -
 4 files changed, 65 insertions(+), 120 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index d96b78dc..4360e5f7 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -222,7 +222,8 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, strlen(name), flags)){
+	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
+			NULL, 0, flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1149e301..0ffad205 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -32,7 +32,6 @@
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
-#define xfs_attr_remove			libxfs_attr_remove
 #define xfs_attr_set			libxfs_attr_set
 
 #define xfs_bmapi_read			libxfs_bmapi_read
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5110bb43..248f9e83 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -21,6 +21,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
+#include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 
@@ -335,6 +336,10 @@ xfs_attr_remove_args(
 	return error;
 }
 
+/*
+ * Note: If value is NULL the attribute will be removed, just like the
+ * Linux ->setattr API.
+ */
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -349,149 +354,92 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, local;
-
-	XFS_STATS_INC(mp, xs_attr_set);
+	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
-	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
-
 	error = xfs_qm_dqattach(dp);
 	if (error)
 		return error;
 
-	/*
-	 * If the inode doesn't have an attribute fork, add one.
-	 * (inode must not be locked when we call this routine)
-	 */
-	if (XFS_IFORK_Q(dp) == 0) {
-		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
-
-		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
-		if (error)
-			return error;
-	}
-
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
-	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-
-	/*
-	 * Root fork attributes can use reserved data blocks for this
-	 * operation if necessary
-	 */
-	error = xfs_trans_alloc(mp, &tres, args.total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
-				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-				       XFS_QMOPT_RES_REGBLKS);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
-	if (error)
-		goto out_trans_cancel;
-	if (!args.trans) {
-		/* shortform attribute has already been committed */
-		goto out_unlock;
-	}
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
-	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
-
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	args.value = value;
+	args.valuelen = valuelen;
 
 	/*
-	 * Commit the last in the sequence of transactions.
+	 * We have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail as well.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
-out_unlock:
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
-
-out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
-	goto out_unlock;
-}
+	args.op_flags = XFS_DA_OP_OKNOENT;
 
-/*
- * Generic handler routine to remove a name from an attribute list.
- * Transitions attribute list from Btree to shortform as necessary.
- */
-int
-xfs_attr_remove(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
-{
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
-	int			error;
+	if (value) {
+		XFS_STATS_INC(mp, xs_attr_set);
 
-	XFS_STATS_INC(mp, xs_attr_remove);
+		args.op_flags |= XFS_DA_OP_ADDNAME;
+		args.total = xfs_attr_calc_size(&args, &local);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return -EIO;
+		/*
+		 * If the inode doesn't have an attribute fork, add one.
+		 * (inode must not be locked when we call this routine)
+		 */
+		if (XFS_IFORK_Q(dp) == 0) {
+			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
+						valuelen);
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
+			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
+			if (error)
+				return error;
+		}
 
-	/*
-	 * we have no control over the attribute names that userspace passes us
-	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail.
-	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args.total;
+	} else {
+		XFS_STATS_INC(mp, xs_attr_remove);
 
-	error = xfs_qm_dqattach(dp);
-	if (error)
-		return error;
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
 
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
-			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
-			&args.trans);
+	error = xfs_trans_alloc(mp, &tres, total, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	/*
-	 * No need to make quota reservations here. We expect to release some
-	 * blocks not allocate in the common case.
-	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
+	if (value) {
+		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
-	error = xfs_attr_remove_args(&args);
-	if (error)
-		goto out;
+		if (rsvd)
+			quota_flags |= XFS_QMOPT_FORCE_RES;
+		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
+				args.total, 0, quota_flags);
+		if (error)
+			goto out_trans_cancel;
+		error = xfs_attr_set_args(&args);
+		if (error)
+			goto out_trans_cancel;
+		/* shortform attribute has already been committed */
+		if (!args.trans)
+			goto out_unlock;
+	} else {
+		error = xfs_attr_remove_args(&args);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -508,15 +456,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans);
+out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
 	return error;
 
-out:
+out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
+	goto out_unlock;
 }
 
 /*========================================================================
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 71bcf129..db58a6c7 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -152,8 +152,6 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.26.2

