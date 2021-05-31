Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ED5C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6B9611CB
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhEaWmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhEaWmh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED32A60FDC;
        Mon, 31 May 2021 22:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500857;
        bh=egRICAkw17b7GYUc6RQshfGpFY/JWDVgRP3qIe03SKs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gRbwa04BJ2VwkpQJzc91XFF9/R5tH0THfh+59VVs/CglbB4ZtPxoVuexE2kH+uqTa
         Q3Qe9+tnpsS5gtPXeU4cm7qCK6Ewtan3w0j7ggGC3Cg7bQ4yHUb13WooLqKBnofIfN
         24b881FUoIQdzXXQUN2JG/CouAE9C4sygwaWgt1OF9lSr2AQz/kNyYiVn0aOe8Rlv5
         ZLPvd8NPmpXK/t8e0B5f6f36CxwwCoYdqyVfGBOB9gZs8wPUBiXj3qEiYeelp1DlI7
         LabbfPg07v1SJzaeBJJVsrw/aeNrJXGnyqxIBjdRLgDwPu1mq7zRITWsG/TMUwfvju
         09kg2h+PcYAtA==
Subject: [PATCH 1/5] xfs: move the quotaoff dqrele inode walk into
 xfs_icache.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:56 -0700
Message-ID: <162250085666.490412.5742339414043345426.stgit@locust>
In-Reply-To: <162250085103.490412.4291071116538386696.stgit@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The only external caller of xfs_inode_walk* happens in quotaoff, when we
want to walk all the incore inodes to detach the dquots.  Move this code
to xfs_icache.c so that we can hide xfs_inode_walk as the starting step
in more cleanups of inode walks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   52 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h      |   13 +++++++++--
 fs/xfs/xfs_qm.h          |    1 -
 fs/xfs/xfs_qm_syscalls.c |   54 ++--------------------------------------------
 4 files changed, 63 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c81daca0e9a..32c17e84efa0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -890,7 +890,7 @@ xfs_inode_walk_get_perag(
  * Call the @execute function on all incore inodes matching the radix tree
  * @tag.
  */
-int
+static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
@@ -917,6 +917,56 @@ xfs_inode_walk(
 	return last_error;
 }
 
+/* Drop this inode's dquots. */
+static int
+xfs_dqrele_inode(
+	struct xfs_inode	*ip,
+	void			*priv)
+{
+	struct xfs_eofblocks	*eofb = priv;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (eofb->eof_flags & XFS_EOFB_DROP_UDQUOT) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (eofb->eof_flags & XFS_EOFB_DROP_GDQUOT) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	if (eofb->eof_flags & XFS_EOFB_DROP_PDQUOT) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Detach all dquots from incore inodes if we can.  The caller must already
+ * have dropped the relevant XFS_[UGP]QUOTA_ACTIVE flags so that dquots will
+ * not get reattached.
+ */
+int
+xfs_dqrele_all_inodes(
+	struct xfs_mount	*mp,
+	unsigned int		qflags)
+{
+	struct xfs_eofblocks	eofb = { .eof_flags = 0 };
+
+	BUILD_BUG_ON(XFS_EOFB_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
+
+	if (qflags & XFS_UQUOTA_ACCT)
+		eofb.eof_flags |= XFS_EOFB_DROP_UDQUOT;
+	if (qflags & XFS_GQUOTA_ACCT)
+		eofb.eof_flags |= XFS_EOFB_DROP_GDQUOT;
+	if (qflags & XFS_PQUOTA_ACCT)
+		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
+
+	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
+			&eofb, XFS_ICI_NO_TAG);
+}
+
 /*
  * Grab the inode for reclaim exclusively.
  *
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d1fddb152420..77029e92ba4c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -17,6 +17,15 @@ struct xfs_eofblocks {
 	__u64		eof_min_file_size;
 };
 
+/* Special eof_flags for dropping dquots. */
+#define XFS_EOFB_DROP_UDQUOT	(1U << 31)
+#define XFS_EOFB_DROP_GDQUOT	(1U << 30)
+#define XFS_EOFB_DROP_PDQUOT	(1U << 29)
+
+#define XFS_EOFB_PRIVATE_FLAGS	(XFS_EOFB_DROP_UDQUOT | \
+				 XFS_EOFB_DROP_GDQUOT | \
+				 XFS_EOFB_DROP_PDQUOT)
+
 /*
  * tags for inode radix tree
  */
@@ -68,9 +77,7 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
-	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
+int xfs_dqrele_all_inodes(struct xfs_mount *mp, unsigned int qflags);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index e3dabab44097..ebbb484c49dc 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -142,7 +142,6 @@ extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* dquot stuff */
 extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
-extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 11f1e2fbf22f..13a56e1ea15c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -201,7 +201,8 @@ xfs_qm_scall_quotaoff(
 	 * depend on the quota inodes (and other things) being valid as long as
 	 * we keep the lock(s).
 	 */
-	xfs_qm_dqrele_all_inodes(mp, flags);
+	error = xfs_dqrele_all_inodes(mp, flags);
+	ASSERT(!error);
 
 	/*
 	 * Next we make the changes in the quota flag in the mount struct.
@@ -747,54 +748,3 @@ xfs_qm_scall_getquota_next(
 	xfs_qm_dqput(dqp);
 	return error;
 }
-
-STATIC int
-xfs_dqrele_inode(
-	struct xfs_inode	*ip,
-	void			*args)
-{
-	uint			*flags = args;
-
-	/* skip quota inodes */
-	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
-		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_pdquot == NULL);
-		return 0;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
-		xfs_qm_dqrele(ip->i_udquot);
-		ip->i_udquot = NULL;
-	}
-	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
-		xfs_qm_dqrele(ip->i_gdquot);
-		ip->i_gdquot = NULL;
-	}
-	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
-		xfs_qm_dqrele(ip->i_pdquot);
-		ip->i_pdquot = NULL;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
-}
-
-
-/*
- * Go thru all the inodes in the file system, releasing their dquots.
- *
- * Note that the mount structure gets modified to indicate that quotas are off
- * AFTER this, in the case of quotaoff.
- */
-void
-xfs_qm_dqrele_all_inodes(
-	struct xfs_mount	*mp,
-	uint			flags)
-{
-	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
-}

