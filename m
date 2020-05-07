Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4726EC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1215120CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OAbW1XvL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEGMTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A9C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DWCaS57WxTwZqqG0H7Tz59sJXeEQE2+9HXYOmr47AY8=; b=OAbW1XvLBnKk1un0PMucBVdgVd
        qWotCeiFCt51wZ3/qq8BZcWbkmR+0QhucRSS/NlvqFAMwWWBtQb3oo0rFgWHts6PXe7WUsXBHGT/C
        h9sqbm1KPrU1Iwq8CJxQ1JULia9DpkfBQ1ttvQ9RcpvA0Gx1ytSbg/4fraGLURZzt9xyOF1EGCHxj
        0ok7vNmu1LhBlV4EFABox+Exml11crzMc6NdVkwOhs1134TYJ7bFjNGMuL6kQU7nsy7rJtq3bmp2W
        RxeA1x9fLRZXdigY64+YJaNnbhj9gxTm8Pi0/UdMZwqhOcpcXAmhyuafhblzbFfxc/zcaczLNIQ8u
        QEpcAYaA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUp-00057m-Uw; Thu, 07 May 2020 12:19:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/58] xfs: pass an initialized xfs_da_args structure to xfs_attr_set
Date:   Thu,  7 May 2020 14:18:05 +0200
Message-Id: <20200507121851.304002-13-hch@lst.de>
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

Source kernel commit: a25446224353a773c7f4ba9ee5ae137515204efe

Instead of converting from one style of arguments to another in
xfs_attr_set, pass the structure from higher up in the call chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c      | 106 ++++++++++++++++++++++------------------------
 libxfs/xfs_attr.c |  69 ++++++++++++++----------------
 libxfs/xfs_attr.h |   3 +-
 3 files changed, 83 insertions(+), 95 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index c39782b3..21103d8e 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -63,13 +63,12 @@ attrset_init(void)
 
 static int
 attr_set_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	xfs_inode_t	*ip = NULL;
-	char		*name, *value, *sp;
-	int		c, valuelen = 0, flags = 0;
-	size_t		namelen;
+	struct xfs_da_args	args = { };
+	char			*sp;
+	int			c;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -84,23 +83,23 @@ attr_set_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			flags |= LIBXFS_ATTR_ROOT;
-			flags &= ~LIBXFS_ATTR_SECURE;
+			args.flags |= LIBXFS_ATTR_ROOT;
+			args.flags &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			args.flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
 			break;
 		case 's':
-			flags |= LIBXFS_ATTR_SECURE;
-			flags &= ~LIBXFS_ATTR_ROOT;
+			args.flags |= LIBXFS_ATTR_SECURE;
+			args.flags &= ~LIBXFS_ATTR_ROOT;
 			break;
 
 		/* modifiers */
 		case 'C':
-			flags |= LIBXFS_ATTR_CREATE;
+			args.flags |= LIBXFS_ATTR_CREATE;
 			break;
 		case 'R':
-			flags |= LIBXFS_ATTR_REPLACE;
+			args.flags |= LIBXFS_ATTR_REPLACE;
 			break;
 
 		case 'n':
@@ -109,8 +108,9 @@ attr_set_f(
 
 		/* value length */
 		case 'v':
-			valuelen = (int)strtol(optarg, &sp, 0);
-			if (*sp != '\0' || valuelen < 0 || valuelen > 64*1024) {
+			args.valuelen = strtol(optarg, &sp, 0);
+			if (*sp != '\0' ||
+			    args.valuelen < 0 || args.valuelen > 64 * 1024) {
 				dbprintf(_("bad attr_set valuelen %s\n"), optarg);
 				return 0;
 			}
@@ -127,40 +127,38 @@ attr_set_f(
 		return 0;
 	}
 
-	name = argv[optind];
-	if (!name) {
+	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
 		dbprintf(_("invalid name\n"));
 		return 0;
 	}
 
-	namelen = strlen(name);
-	if (namelen >= MAXNAMELEN) {
+	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
 		dbprintf(_("name too long\n"));
 		return 0;
 	}
 
-	if (valuelen) {
-		value = (char *)memalign(getpagesize(), valuelen);
-		if (!value) {
-			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
+	if (args.valuelen) {
+		args.value = memalign(getpagesize(), args.valuelen);
+		if (!args.value) {
+			dbprintf(_("cannot allocate buffer (%d)\n"),
+				args.valuelen);
 			goto out;
 		}
-		memset(value, 'v', valuelen);
-	} else {
-		value = NULL;
+		memset(args.value, 'v', args.valuelen);
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, namelen,
-				(unsigned char *)value, valuelen, flags)) {
+	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			args.name, (unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -169,22 +167,20 @@ attr_set_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
-	if (value)
-		free(value);
+	if (args.dp)
+		libxfs_irele(args.dp);
+	if (args.value)
+		free(args.value);
 	return 0;
 }
 
 static int
 attr_remove_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	xfs_inode_t	*ip = NULL;
-	char		*name;
-	int		c, flags = 0;
-	size_t		namelen;
+	struct xfs_da_args	args = { };
+	int			c;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -199,15 +195,15 @@ attr_remove_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			flags |= LIBXFS_ATTR_ROOT;
-			flags &= ~LIBXFS_ATTR_SECURE;
+			args.flags |= LIBXFS_ATTR_ROOT;
+			args.flags &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			args.flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
 			break;
 		case 's':
-			flags |= LIBXFS_ATTR_SECURE;
-			flags &= ~LIBXFS_ATTR_ROOT;
+			args.flags |= LIBXFS_ATTR_SECURE;
+			args.flags &= ~LIBXFS_ATTR_ROOT;
 			break;
 
 		case 'n':
@@ -225,29 +221,29 @@ attr_remove_f(
 		return 0;
 	}
 
-	name = argv[optind];
-	if (!name) {
+	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
 		dbprintf(_("invalid name\n"));
 		return 0;
 	}
 
-	namelen = strlen(name);
-	if (namelen >= MAXNAMELEN) {
+	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
 		dbprintf(_("name too long\n"));
 		return 0;
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, namelen,
-			NULL, 0, flags)) {
+	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			(unsigned char *)args.name,
+			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -256,7 +252,7 @@ attr_remove_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
+	if (args.dp)
+		libxfs_irele(args.dp);
 	return 0;
 }
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ded952da..e42a8033 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -330,22 +330,17 @@ xfs_attr_remove_args(
 }
 
 /*
- * Note: If value is NULL the attribute will be removed, just like the
+ * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
 int
 xfs_attr_set(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	struct xfs_da_args	*args)
 {
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (args->flags & ATTR_ROOT) != 0;
 	int			error, local;
 	unsigned int		total;
 
@@ -356,25 +351,22 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
 	 * removal to fail as well.
 	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_OKNOENT;
 
-	if (value) {
+	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
 
-		args.op_flags |= XFS_DA_OP_ADDNAME;
-		args.total = xfs_attr_calc_size(&args, &local);
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		args->total = xfs_attr_calc_size(args, &local);
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
@@ -382,8 +374,8 @@ xfs_attr_set(
 		 */
 		if (XFS_IFORK_Q(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
-						valuelen);
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
+						args->valuelen);
 
 			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 			if (error)
@@ -391,10 +383,11 @@ xfs_attr_set(
 		}
 
 		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args.total;
+		total = args->total;
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
@@ -407,29 +400,29 @@ xfs_attr_set(
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc(mp, &tres, total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(args.trans, dp, 0);
-	if (value) {
+	xfs_trans_ijoin(args->trans, dp, 0);
+	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
 		if (rsvd)
 			quota_flags |= XFS_QMOPT_FORCE_RES;
-		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
-				args.total, 0, quota_flags);
+		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
+				args->total, 0, quota_flags);
 		if (error)
 			goto out_trans_cancel;
-		error = xfs_attr_set_args(&args);
+		error = xfs_attr_set_args(args);
 		if (error)
 			goto out_trans_cancel;
 		/* shortform attribute has already been committed */
-		if (!args.trans)
+		if (!args->trans)
 			goto out_unlock;
 	} else {
-		error = xfs_attr_remove_args(&args);
+		error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -439,23 +432,23 @@ xfs_attr_set(
 	 * transaction goes to disk before returning to the user.
 	 */
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
+		xfs_trans_set_sync(args->trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	if ((args->flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
+	if (args->trans)
+		xfs_trans_cancel(args->trans);
 	goto out_unlock;
 }
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index db58a6c7..07ca543d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -149,8 +149,7 @@ int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 size_t namelen, unsigned char **value, int *valuelenp,
 		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
-- 
2.26.2

