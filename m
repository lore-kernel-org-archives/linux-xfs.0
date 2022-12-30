Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AD4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiLaBIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiLaBID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:08:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506BA1573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:08:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C996B81D68
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA9AC433EF;
        Sat, 31 Dec 2022 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448879;
        bh=lwioL8W9ZJ7M7InmKZSRhkaWAgihqA1xRwT1HjQkQvg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CWSEncBODh1ISVRYhEDsuO1QD27B9mDG4Q1kk63GjGTAnz/nBHYC9NAP+ip0uhnkR
         EDJ0HrORIVoik9IHIVUg0UiC43PnAkgZ1WhgolY0rn2LdZ407DeFHxxuTSSZ2pNIS8
         c3xGQ4wb7RekVjbJUobttGitXaYutpone0zg8BPpqzL3biW0aj0pyoyqMDq+nY48uo
         XdeFiswb4szm+swAAE7qW5vQceeGjXwK3ejaH9P+NuLKahwNjv+KyGB4wxIocJjfkB
         CtLszRdM0yFUuLsTw5ZuBuOlhGzXWjIz6HCrrNgYoq/fYYpFsC6QVIQ5A0m1c7UVSJ
         +oAU8OMFS3vbA==
Subject: [PATCH 11/20] xfs: wrap inode creation dqalloc calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863987.707335.4838141657069838555.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper that calls dqalloc to allocate and grab a reference to
dquots for the user, group, and project ids listed in an icreate
structure.  This simplifies the creat-related dqalloc callsites
scattered around the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    9 ++++-----
 fs/xfs/xfs_inode.c      |   38 ++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h      |    3 +++
 fs/xfs/xfs_symlink.c    |   10 ++++------
 4 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 2c630a5e23ea..6efaab50440f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -43,9 +43,9 @@ xrep_tempfile_create(
 	struct xfs_icreate_args	args = { .pip = sc->mp->m_rootip, };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	struct xfs_inode	*dp = mp->m_rootip;
 	xfs_ino_t		ino;
@@ -69,8 +69,7 @@ xrep_tempfile_create(
 	 * inode should be completely root owned so that we don't fail due to
 	 * quota limits.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
-			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5350c55ac25f..db1f521ac6d0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -806,6 +806,24 @@ xfs_nlink_hook_del(
 # define xfs_nlink_backref_delta(dp, ip, delta)		((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+int
+xfs_icreate_dqalloc(
+	const struct xfs_icreate_args	*args,
+	struct xfs_dquot		**udqpp,
+	struct xfs_dquot		**gdqpp,
+	struct xfs_dquot		**pdqpp)
+{
+	unsigned int			flags = XFS_QMOPT_QUOTALL;
+
+	*udqpp = *gdqpp = *pdqpp = NULL;
+
+	if (!(args->flags & XFS_ICREATE_ARGS_FORCE_GID))
+		flags |= XFS_QMOPT_INHERIT;
+
+	return xfs_qm_vop_dqalloc(args->pip, args->uid, args->gid, args->prid,
+			flags, udqpp, gdqpp, pdqpp);
+}
+
 int
 xfs_create(
 	struct xfs_inode	*dp,
@@ -816,9 +834,9 @@ xfs_create(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	xfs_ino_t		ino;
 	bool			unlock_dp_on_error = false;
@@ -835,9 +853,7 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -974,9 +990,9 @@ xfs_create_tmpfile(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	struct xfs_trans_res	*tres;
 	xfs_ino_t		ino;
 	uint			resblks;
@@ -991,9 +1007,7 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args->uid, args->gid, args->prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9617079f0a73..b99c62f14919 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -625,5 +625,8 @@ void xfs_nlink_hook_del(struct xfs_mount *mp, struct xfs_nlink_hook *hook);
 void xfs_icreate_args_inherit(struct xfs_icreate_args *args, struct xfs_inode *dp,
 		struct user_namespace *mnt_userns, umode_t mode);
 void xfs_icreate_args_rootfile(struct xfs_icreate_args *args, umode_t mode);
+int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
+		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
+		struct xfs_dquot **pdqpp);
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index c27bf49de7bf..6dc15f125895 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -98,9 +98,9 @@ xfs_symlink(
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
 	xfs_filblks_t		fs_blocks;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_dquot	*udqp;
+	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 	uint			resblks;
 	xfs_ino_t		ino;
 
@@ -125,9 +125,7 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, args.uid, args.gid, args.prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-			&udqp, &gdqp, &pdqp);
+	error = xfs_icreate_dqalloc(&args, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 

