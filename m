Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36609C3565A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0212B24673
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iDcS/4sV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBUOL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgBUOL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gtSp/E2NE8jyvN5jwpr/CGwYQvguyJPLdg6z3T+3pYA=; b=iDcS/4sV8SDbODy5d2nE/kk2VU
        UKAlQf4dX5ZiZZfCahR39bwGGO22IqusXU4LSr8muYHKMth1+DTPDPA/2JYatUEsXMPoOfvIDiXJd
        H+JdZnEStZyLbKnA+ofTJ/g2g24VvL0d+4Cm6ey0fhXyonjYK/tsXtqodADVAUyr4OsRBuyj6aQKT
        riNiqtUz+WLMSnpQuLBaMmDAPDDWtlJotV4oJtfHVnImxJQcxaoFMWEfDQpgnFZv2hxXlX5QfEjR5
        VFo+szge4mPg5xAnRQKJFKCeUPboo+U3cStnumYRHVdVSfA9GHgsXWSVJDrnT6ofwLTknwgU6QwhG
        7FNmCnOw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5925-0000HY-PX; Fri, 21 Feb 2020 14:11:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/31] xfs: remove the xfs_inode argument to xfs_attr_get_ilocked
Date:   Fri, 21 Feb 2020 06:11:36 -0800
Message-Id: <20200221141154.476496-14-hch@lst.de>
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

The inode can easily be derived from the args structure.  Also
don't bother with else statements after early returns.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 15 +++++++--------
 fs/xfs/libxfs/xfs_attr.h |  2 +-
 fs/xfs/scrub/attr.c      |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 288b39e81efd..fd095e3d4a9a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -77,19 +77,18 @@ xfs_inode_hasattr(
  */
 int
 xfs_attr_get_ilocked(
-	struct xfs_inode	*ip,
 	struct xfs_da_args	*args)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
-	if (!xfs_inode_hasattr(ip))
+	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
-	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+
+	if (args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
-	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
 		return xfs_attr_leaf_get(args);
-	else
-		return xfs_attr_node_get(args);
+	return xfs_attr_node_get(args);
 }
 
 /*
@@ -133,7 +132,7 @@ xfs_attr_get(
 		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
-	error = xfs_attr_get_ilocked(args->dp, args);
+	error = xfs_attr_get_ilocked(args);
 	xfs_iunlock(args->dp, lock_mode);
 
 	/* on error, we have to clean up allocated value buffers */
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index be77d13a2902..b8c4ed27f626 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -145,7 +145,7 @@ int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
-int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
+int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d804558cdbca..f983c2b969e0 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -162,7 +162,7 @@ xchk_xattr_listent(
 	args.value = xchk_xattr_valuebuf(sx->sc);
 	args.valuelen = valuelen;
 
-	error = xfs_attr_get_ilocked(context->dp, &args);
+	error = xfs_attr_get_ilocked(&args);
 	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
 			&error))
 		goto fail_xref;
-- 
2.24.1

