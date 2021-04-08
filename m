Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC04C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 01:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 426DD6121E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 01:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhDHBB0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 21:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhDHBB0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 21:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EA261205
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 01:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617843675;
        bh=rDfL+BdKio1o6lFmybKFZUYhl3ir0bVcuTFf40zEMr4=;
        h=Date:From:To:Subject:From;
        b=d0CtzkyJ51mNsAFF0hc0f9fxCjTFYjP4alXj7ECjXDdM2bXpAFQGuJ5QngpWvqp8u
         8lFYme81HjVWiTuBo+2yidN/6fwJDmCk/iSlI+jdeJCz/Xg4jn4bKZtqebxgtRcSbQ
         onlI6+gyARGiQLPrAS9QP6zEU8gDL8fZlaJTzWxDmx9/2PuQYDOeDan/8dNY4SR4XU
         Flk0DJJxQ3amv6fMcd+LgHUDyGO/OzBcA9Q0YxSVKLPja1gOZ3NyyJ97wD08dEyth4
         ez5kTYHfyFlKnrFn70eCkXalo9TXaCACqpfG6qZxmiWji2KZ3UD8Ef7fvtrcXOs76r
         tfvnwm/OA/LTA==
Date:   Wed, 7 Apr 2021 18:01:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: get rid of the ip parameter to xchk_setup_*
Message-ID: <20210408010114.GT3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that the scrub context stores a pointer to the file that was used to
invoke the scrub call, the struct xfs_inode pointer that we passed to
all the setup functions is no longer necessary.  This is only ever used
if the caller wants us to scrub the metadata of the open file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc.c      |    5 ++--
 fs/xfs/scrub/attr.c       |    5 ++--
 fs/xfs/scrub/bmap.c       |    5 ++--
 fs/xfs/scrub/common.c     |   13 ++++-------
 fs/xfs/scrub/common.h     |   53 +++++++++++++++++----------------------------
 fs/xfs/scrub/dir.c        |    5 ++--
 fs/xfs/scrub/fscounters.c |    3 +--
 fs/xfs/scrub/ialloc.c     |    5 ++--
 fs/xfs/scrub/inode.c      |    5 ++--
 fs/xfs/scrub/parent.c     |    5 ++--
 fs/xfs/scrub/quota.c      |    5 ++--
 fs/xfs/scrub/refcount.c   |    5 ++--
 fs/xfs/scrub/repair.c     |    5 ++--
 fs/xfs/scrub/repair.h     |    6 +++--
 fs/xfs/scrub/rmap.c       |    5 ++--
 fs/xfs/scrub/rtbitmap.c   |    5 ++--
 fs/xfs/scrub/scrub.c      |   11 ++++-----
 fs/xfs/scrub/scrub.h      |    3 +--
 fs/xfs/scrub/symlink.c    |    5 ++--
 19 files changed, 61 insertions(+), 93 deletions(-)

diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 73d924e47565..2720bd7fe53b 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -21,10 +21,9 @@
  */
 int
 xchk_setup_ag_allocbt(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, false);
 }
 
 /* Free space btree scrubber. */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9faddb334a2c..552af0cf8482 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -69,8 +69,7 @@ xchk_setup_xattr_buf(
 /* Set us up to scrub an inode's extended attributes. */
 int
 xchk_setup_xattr(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	int			error;
 
@@ -85,7 +84,7 @@ xchk_setup_xattr(
 			return error;
 	}
 
-	return xchk_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, 0);
 }
 
 /* Extended Attributes */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 33559c3a4bc3..613e2aa7e4e7 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -26,12 +26,11 @@
 /* Set us up with an inode's bmap. */
 int
 xchk_setup_inode_bmap(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	int			error;
 
-	error = xchk_get_inode(sc, ip);
+	error = xchk_get_inode(sc);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index d8da0ea772bc..6457a6d7e867 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -593,8 +593,7 @@ xchk_trans_alloc(
 /* Set us up with a transaction and an empty context. */
 int
 xchk_setup_fs(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	uint			resblks;
 
@@ -606,7 +605,6 @@ xchk_setup_fs(
 int
 xchk_setup_ag_btree(
 	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip,
 	bool			force_log)
 {
 	struct xfs_mount	*mp = sc->mp;
@@ -624,7 +622,7 @@ xchk_setup_ag_btree(
 			return error;
 	}
 
-	error = xchk_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
 
@@ -652,11 +650,11 @@ xchk_checkpoint_log(
  */
 int
 xchk_get_inode(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip_in)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_imap		imap;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->filp));
 	struct xfs_inode	*ip = NULL;
 	int			error;
 
@@ -717,12 +715,11 @@ xchk_get_inode(
 int
 xchk_setup_inode_contents(
 	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip,
 	unsigned int		resblks)
 {
 	int			error;
 
-	error = xchk_get_inode(sc, ip);
+	error = xchk_get_inode(sc);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5e2c6f693503..0410faf7d735 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -72,48 +72,37 @@ bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
 /* Setup functions */
-int xchk_setup_fs(struct xfs_scrub *sc, struct xfs_inode *ip);
-int xchk_setup_ag_allocbt(struct xfs_scrub *sc,
-			       struct xfs_inode *ip);
-int xchk_setup_ag_iallocbt(struct xfs_scrub *sc,
-				struct xfs_inode *ip);
-int xchk_setup_ag_rmapbt(struct xfs_scrub *sc,
-			      struct xfs_inode *ip);
-int xchk_setup_ag_refcountbt(struct xfs_scrub *sc,
-				  struct xfs_inode *ip);
-int xchk_setup_inode(struct xfs_scrub *sc,
-			  struct xfs_inode *ip);
-int xchk_setup_inode_bmap(struct xfs_scrub *sc,
-			       struct xfs_inode *ip);
-int xchk_setup_inode_bmap_data(struct xfs_scrub *sc,
-				    struct xfs_inode *ip);
-int xchk_setup_directory(struct xfs_scrub *sc,
-			      struct xfs_inode *ip);
-int xchk_setup_xattr(struct xfs_scrub *sc,
-			  struct xfs_inode *ip);
-int xchk_setup_symlink(struct xfs_scrub *sc,
-			    struct xfs_inode *ip);
-int xchk_setup_parent(struct xfs_scrub *sc,
-			   struct xfs_inode *ip);
+int xchk_setup_fs(struct xfs_scrub *sc);
+int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
+int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
+int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
+int xchk_setup_ag_refcountbt(struct xfs_scrub *sc);
+int xchk_setup_inode(struct xfs_scrub *sc);
+int xchk_setup_inode_bmap(struct xfs_scrub *sc);
+int xchk_setup_inode_bmap_data(struct xfs_scrub *sc);
+int xchk_setup_directory(struct xfs_scrub *sc);
+int xchk_setup_xattr(struct xfs_scrub *sc);
+int xchk_setup_symlink(struct xfs_scrub *sc);
+int xchk_setup_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
-int xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_rt(struct xfs_scrub *sc);
 #else
 static inline int
-xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip)
+xchk_setup_rt(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
-int xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_quota(struct xfs_scrub *sc);
 #else
 static inline int
-xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
+xchk_setup_quota(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
 #endif
-int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_fscounters(struct xfs_scrub *sc);
 
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
@@ -126,11 +115,9 @@ void xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
 
-int xchk_setup_ag_btree(struct xfs_scrub *sc, struct xfs_inode *ip,
-		bool force_log);
-int xchk_get_inode(struct xfs_scrub *sc, struct xfs_inode *ip_in);
-int xchk_setup_inode_contents(struct xfs_scrub *sc, struct xfs_inode *ip,
-		unsigned int resblks);
+int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
+int xchk_get_inode(struct xfs_scrub *sc);
+int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 /*
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e7cc04b7454b..28dda391d5df 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -22,10 +22,9 @@
 /* Set us up to scrub directories. */
 int
 xchk_setup_directory(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, 0);
 }
 
 /* Directories */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index ec2064ed3c30..7b4386c78fbf 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -116,8 +116,7 @@ xchk_fscount_warmup(
 
 int
 xchk_setup_fscounters(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_fscounters	*fsc;
 	int			error;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 1644199c29a8..8d9f3fb0cd22 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -29,10 +29,9 @@
  */
 int
 xchk_setup_ag_iallocbt(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_ag_btree(sc, ip, sc->flags & XCHK_TRY_HARDER);
+	return xchk_setup_ag_btree(sc, sc->flags & XCHK_TRY_HARDER);
 }
 
 /* Inode btree scrubber. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index faf65eb5bd31..61f90b2c9430 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -28,8 +28,7 @@
  */
 int
 xchk_setup_inode(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	int			error;
 
@@ -37,7 +36,7 @@ xchk_setup_inode(
 	 * Try to get the inode.  If the verifiers fail, we try again
 	 * in raw mode.
 	 */
-	error = xchk_get_inode(sc, ip);
+	error = xchk_get_inode(sc);
 	switch (error) {
 	case 0:
 		break;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 076c812ed18d..ab182a5cd0c0 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -20,10 +20,9 @@
 /* Set us up to scrub parents. */
 int
 xchk_setup_parent(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, 0);
 }
 
 /* Parent pointers */
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 343f96f48b82..acbb9839d42f 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -37,8 +37,7 @@ xchk_quota_to_dqtype(
 /* Set us up to scrub a quota. */
 int
 xchk_setup_quota(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	xfs_dqtype_t		dqtype;
 	int			error;
@@ -53,7 +52,7 @@ xchk_setup_quota(
 	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
-	error = xchk_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
 	sc->ip = xfs_quota_inode(sc->mp, dqtype);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index dd672e6bbc75..744530a66c0c 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -19,10 +19,9 @@
  */
 int
 xchk_setup_ag_refcountbt(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, false);
 }
 
 /* Reference count btree scrubber. */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 61bc43418a2a..952c8eae16cb 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -37,19 +37,18 @@
  */
 int
 xrep_attempt(
-	struct xfs_inode	*ip,
 	struct xfs_scrub	*sc)
 {
 	int			error = 0;
 
-	trace_xrep_attempt(ip, sc->sm, error);
+	trace_xrep_attempt(XFS_I(file_inode(sc->filp)), sc->sm, error);
 
 	xchk_ag_btcur_free(&sc->sa);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
 	error = sc->ops->repair(sc);
-	trace_xrep_done(ip, sc->sm, error);
+	trace_xrep_done(XFS_I(file_inode(sc->filp)), sc->sm, error);
 	switch (error) {
 	case 0:
 		/*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index fe77de01abe0..3bb152d52a07 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -17,7 +17,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 /* Repair helpers */
 
-int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc);
+int xrep_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
@@ -64,8 +64,8 @@ int xrep_agi(struct xfs_scrub *sc);
 
 #else
 
-static inline int xrep_attempt(
-	struct xfs_inode	*ip,
+static inline int
+xrep_attempt(
 	struct xfs_scrub	*sc)
 {
 	return -EOPNOTSUPP;
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index f4fcb4719f41..a4f17477c5d1 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -21,10 +21,9 @@
  */
 int
 xchk_setup_ag_rmapbt(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
-	return xchk_setup_ag_btree(sc, ip, false);
+	return xchk_setup_ag_btree(sc, false);
 }
 
 /* Reverse-mapping scrubber. */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 1fb12928d8ef..37c0e2266c85 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -20,12 +20,11 @@
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rt(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	int			error;
 
-	error = xchk_setup_fs(sc, ip);
+	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9f8be81baf16..3c893a2c9ac8 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -468,8 +468,7 @@ xfs_scrub_metadata(
 			.agno		= NULLAGNUMBER,
 		},
 	};
-	struct xfs_inode		*ip = XFS_I(file_inode(filp));
-	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_mount		*mp = XFS_I(file_inode(filp))->i_mount;
 	int				error = 0;
 
 	sc.mp = mp;
@@ -477,7 +476,7 @@ xfs_scrub_metadata(
 	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
 		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
 
-	trace_xchk_start(ip, sm, error);
+	trace_xchk_start(XFS_I(file_inode(filp)), sm, error);
 
 	/* Forbidden if we are shut down or mounted norecovery. */
 	error = -ESHUTDOWN;
@@ -507,7 +506,7 @@ xfs_scrub_metadata(
 	}
 
 	/* Set up for the operation. */
-	error = sc.ops->setup(&sc, ip);
+	error = sc.ops->setup(&sc);
 	if (error)
 		goto out_teardown;
 
@@ -553,7 +552,7 @@ xfs_scrub_metadata(
 		 * If it's broken, userspace wants us to fix it, and we haven't
 		 * already tried to fix it, then attempt a repair.
 		 */
-		error = xrep_attempt(ip, &sc);
+		error = xrep_attempt(&sc);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
@@ -574,7 +573,7 @@ xfs_scrub_metadata(
 out_teardown:
 	error = xchk_teardown(&sc, error);
 out:
-	trace_xchk_done(ip, sm, error);
+	trace_xchk_done(XFS_I(file_inode(filp)), sm, error);
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
 		sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		error = 0;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 2a90642bac1a..389eb5217459 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -18,8 +18,7 @@ enum xchk_type {
 
 struct xchk_meta_ops {
 	/* Acquire whatever resources are needed for the operation. */
-	int		(*setup)(struct xfs_scrub *,
-				 struct xfs_inode *);
+	int		(*setup)(struct xfs_scrub *sc);
 
 	/* Examine metadata for errors. */
 	int		(*scrub)(struct xfs_scrub *);
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 8c1c3875b31d..ad7b85e248c7 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -18,15 +18,14 @@
 /* Set us up to scrub a symbolic link. */
 int
 xchk_setup_symlink(
-	struct xfs_scrub	*sc,
-	struct xfs_inode	*ip)
+	struct xfs_scrub	*sc)
 {
 	/* Allocate the buffer without the inode lock held. */
 	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xchk_setup_inode_contents(sc, ip, 0);
+	return xchk_setup_inode_contents(sc, 0);
 }
 
 /* Symbolic links. */
