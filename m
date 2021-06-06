Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DBEC47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F616136D
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhFFR4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhFFR4U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 412F46136D;
        Sun,  6 Jun 2021 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002070;
        bh=3h5caWt18qOOGu+sUFCm+9BMd/UYSK9+CnwB4CEjB7o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SvTWJQzzYsp94uQAzd+/BZV8I9dCZP+bTjAYOptz+/AQzsrW14pLj0NTphSaj8s5D
         yPBhvU2sFmiHOcmXU//elhPQd+SBO/pYyzWlywRPnvE6AE6NR+OlBRgpSbjbXaFIYP
         7uNYSbGf0QkhJDOA40t2F4CYgpUyl+/dmZvS6mQcVwf5d+8l3Dj2dQ6VXbKia50AW+
         ZSnUFFOCfmZ80FMQ4wo3U+XsWu94wPoEGFOgXUwWmSmOmmB9ls2TURFSGKPqgi2H5l
         IlLbzIdixDgAQNEHpFGG5/9YozkKFcxldV84qTZ/qYkf0J6wibW0XkOPb7laOII+d3
         wanwtIRM6oUJA==
Subject: [PATCH 1/2] xfs: change the prefix of XFS_EOF_FLAGS_* to
 XFS_ICWALK_FLAG_
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 06 Jun 2021 10:54:29 -0700
Message-ID: <162300206990.1202657.3281876344287883806.stgit@locust>
In-Reply-To: <162300206433.1202657.5753685964265403056.stgit@locust>
References: <162300206433.1202657.5753685964265403056.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for renaming struct xfs_eofblocks to struct xfs_icwalk,
change the prefix of the existing XFS_EOF_FLAGS_* flags to
XFS_ICWALK_FLAG_ and convert all the existing users.  This adds a degree
of interface separation between the ioctl definitions and the incore
parameters.  Since FLAGS_UNION is only used in xfs_icache.c, move it
there as a private flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    4 ++--
 fs/xfs/xfs_icache.c |   44 +++++++++++++++++++++++---------------------
 fs/xfs/xfs_icache.h |   17 +++++++++++++++--
 fs/xfs/xfs_ioctl.c  |   13 ++++++++++++-
 4 files changed, 52 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c068dcd414f4..eb39c3777491 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -769,7 +769,7 @@ xfs_file_buffered_write(
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		xfs_blockgc_free_quota(ip, XFS_EOF_FLAGS_SYNC);
+		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
 		cleared_space = true;
 		goto write_retry;
 	} else if (ret == -ENOSPC && !cleared_space) {
@@ -779,7 +779,7 @@ xfs_file_buffered_write(
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
+		eofb.eof_flags = XFS_ICWALK_FLAG_SYNC;
 		xfs_blockgc_free_space(ip->i_mount, &eofb);
 		goto write_retry;
 	}
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 53dab8959e1d..ce6ac32a0c29 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -62,7 +62,7 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
- * with XFS_EOF_FLAGS_*.
+ * with XFS_ICWALK_FLAGS_VALID.
  */
 #define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
 #define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
@@ -72,12 +72,14 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 #define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
 
 #define XFS_ICWALK_FLAG_RECLAIM_SICK	(1U << 27)
+#define XFS_ICWALK_FLAG_UNION		(1U << 26) /* union filter algorithm */
 
 #define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
 					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
 					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
 					 XFS_ICWALK_FLAG_SCAN_LIMIT | \
-					 XFS_ICWALK_FLAG_RECLAIM_SICK)
+					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
+					 XFS_ICWALK_FLAG_UNION)
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -1113,15 +1115,15 @@ xfs_inode_match_id(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
 	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
 	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
 	    ip->i_projid != eofb->eof_prid)
 		return false;
 
@@ -1137,15 +1139,15 @@ xfs_inode_match_id_union(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
 	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
 	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
 	    ip->i_projid == eofb->eof_prid)
 		return true;
 
@@ -1167,7 +1169,7 @@ xfs_inode_matches_eofb(
 	if (!eofb)
 		return true;
 
-	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
+	if (eofb->eof_flags & XFS_ICWALK_FLAG_UNION)
 		match = xfs_inode_match_id_union(ip, eofb);
 	else
 		match = xfs_inode_match_id(ip, eofb);
@@ -1175,7 +1177,7 @@ xfs_inode_matches_eofb(
 		return false;
 
 	/* skip the inode if the file size is too small */
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
 	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 		return false;
 
@@ -1207,7 +1209,7 @@ xfs_inode_free_eofblocks(
 {
 	bool			wait;
 
-	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
+	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
@@ -1370,7 +1372,7 @@ xfs_inode_free_cowblocks(
 	bool			wait;
 	int			ret = 0;
 
-	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
+	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
@@ -1560,7 +1562,7 @@ xfs_blockgc_free_space(
  * scan.
  *
  * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
- * (XFS_EOF_FLAGS_SYNC), the caller also must not hold any inode's IOLOCK or
+ * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
  * MMAPLOCK.
  */
 int
@@ -1569,7 +1571,7 @@ xfs_blockgc_free_dquots(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	unsigned int		eof_flags)
+	unsigned int		iwalk_flags)
 {
 	struct xfs_eofblocks	eofb = {0};
 	bool			do_work = false;
@@ -1581,23 +1583,23 @@ xfs_blockgc_free_dquots(
 	 * Run a scan to free blocks using the union filter to cover all
 	 * applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
+	eofb.eof_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
 		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
-		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+		eofb.eof_flags |= XFS_ICWALK_FLAG_UID;
 		do_work = true;
 	}
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
-		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+		eofb.eof_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;
 	}
 
 	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
 		eofb.eof_prid = pdqp->q_id;
-		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+		eofb.eof_flags |= XFS_ICWALK_FLAG_PRID;
 		do_work = true;
 	}
 
@@ -1611,12 +1613,12 @@ xfs_blockgc_free_dquots(
 int
 xfs_blockgc_free_quota(
 	struct xfs_inode	*ip,
-	unsigned int		eof_flags)
+	unsigned int		iwalk_flags)
 {
 	return xfs_blockgc_free_dquots(ip->i_mount,
 			xfs_inode_dquot(ip, XFS_DQTYPE_USER),
 			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
-			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
+			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
 }
 
 /* XFS Inode Cache Walking Code */
@@ -1836,5 +1838,5 @@ xfs_icwalk(
 		}
 	}
 	return last_error;
-	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
+	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_ICWALK_FLAGS_VALID);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 191620a069af..b29048c493b6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -18,6 +18,19 @@ struct xfs_eofblocks {
 	int		icw_scan_limit;
 };
 
+/* Flags that reflect xfs_fs_eofblocks functionality. */
+#define XFS_ICWALK_FLAG_SYNC		(1U << 0) /* sync/wait mode scan */
+#define XFS_ICWALK_FLAG_UID		(1U << 1) /* filter by uid */
+#define XFS_ICWALK_FLAG_GID		(1U << 2) /* filter by gid */
+#define XFS_ICWALK_FLAG_PRID		(1U << 3) /* filter by project id */
+#define XFS_ICWALK_FLAG_MINFILESIZE	(1U << 4) /* filter by min file size */
+
+#define XFS_ICWALK_FLAGS_VALID		(XFS_ICWALK_FLAG_SYNC | \
+					 XFS_ICWALK_FLAG_UID | \
+					 XFS_ICWALK_FLAG_GID | \
+					 XFS_ICWALK_FLAG_PRID | \
+					 XFS_ICWALK_FLAG_MINFILESIZE)
+
 /*
  * Flags for xfs_iget()
  */
@@ -43,8 +56,8 @@ void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
-		unsigned int eof_flags);
-int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
+		unsigned int iwalk_flags);
+int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1fe4c1fc0aea..c6450fd059f1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1887,7 +1887,18 @@ xfs_fs_eofblocks_from_user(
 	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
 		return -EINVAL;
 
-	dst->eof_flags = src->eof_flags;
+	dst->eof_flags = 0;
+	if (src->eof_flags & XFS_EOF_FLAGS_SYNC)
+		dst->eof_flags |= XFS_ICWALK_FLAG_SYNC;
+	if (src->eof_flags & XFS_EOF_FLAGS_UID)
+		dst->eof_flags |= XFS_ICWALK_FLAG_UID;
+	if (src->eof_flags & XFS_EOF_FLAGS_GID)
+		dst->eof_flags |= XFS_ICWALK_FLAG_GID;
+	if (src->eof_flags & XFS_EOF_FLAGS_PRID)
+		dst->eof_flags |= XFS_ICWALK_FLAG_PRID;
+	if (src->eof_flags & XFS_EOF_FLAGS_MINFILESIZE)
+		dst->eof_flags |= XFS_ICWALK_FLAG_MINFILESIZE;
+
 	dst->eof_prid = src->eof_prid;
 	dst->eof_min_file_size = src->eof_min_file_size;
 

