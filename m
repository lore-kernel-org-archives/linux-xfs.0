Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42610C4708F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE25613E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFCDOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D83D61263;
        Thu,  3 Jun 2021 03:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689980;
        bh=eNLSUYXV9mJskelyylWCzFDII6mk2w7eiuv1s7HnM3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lGhl/8DVBiP6Cz1amRfknGhTyUkj3KwXe3oNGeAPtpyf7B7ID28JZcZT+1JfeLrbf
         7NgCWPNGhqnnolZNYCJWycA37+urZTjYZ+cKBcqDbQJdHBFMr72b5Lphzgl+D7Dguv
         mG3Ft2hnRtS96P44E/UiJzjePuMafuCeIdpBP8mpDN93MkiomSZhQ9CD0zW0dmkNP2
         FFTPivnc5OP/ubvPey+nIkFGy8AwJ7DiHCvs/m1wD2fGOWZSTwXR0n6Nk9S69McdCH
         XdaTuzMvbVNHYCJf+hDypy1ocKQNlGh37wmRGGQjW3bCJ6Pejd2+SeKrllnKvJMO+Q
         0ufyQeypfDuWA==
Subject: [PATCH 1/2] xfs: change the prefix of XFS_EOF_FLAGS_* to
 XFS_ICWALK_FLAG_
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 02 Jun 2021 20:12:59 -0700
Message-ID: <162268997987.2724263.8793609361184652026.stgit@locust>
In-Reply-To: <162268997425.2724263.18220495607834735216.stgit@locust>
References: <162268997425.2724263.18220495607834735216.stgit@locust>
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
parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    4 ++--
 fs/xfs/xfs_icache.c |   40 ++++++++++++++++++++--------------------
 fs/xfs/xfs_icache.h |   19 +++++++++++++++++--
 3 files changed, 39 insertions(+), 24 deletions(-)


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
index 54285d1ad574..052db2d5d9c4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,7 +63,7 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
- * with XFS_EOF_FLAGS_*.
+ * with XFS_ICWALK_FLAGS_VALID.
  */
 #define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
 #define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
@@ -1094,15 +1094,15 @@ xfs_inode_match_id(
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
 
@@ -1118,15 +1118,15 @@ xfs_inode_match_id_union(
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
 
@@ -1148,7 +1148,7 @@ xfs_inode_matches_eofb(
 	if (!eofb)
 		return true;
 
-	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
+	if (eofb->eof_flags & XFS_ICWALK_FLAG_UNION)
 		match = xfs_inode_match_id_union(ip, eofb);
 	else
 		match = xfs_inode_match_id(ip, eofb);
@@ -1156,7 +1156,7 @@ xfs_inode_matches_eofb(
 		return false;
 
 	/* skip the inode if the file size is too small */
-	if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
+	if ((eofb->eof_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
 	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 		return false;
 
@@ -1188,7 +1188,7 @@ xfs_inode_free_eofblocks(
 {
 	bool			wait;
 
-	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
+	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
@@ -1351,7 +1351,7 @@ xfs_inode_free_cowblocks(
 	bool			wait;
 	int			ret = 0;
 
-	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
+	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
@@ -1541,7 +1541,7 @@ xfs_blockgc_free_space(
  * scan.
  *
  * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
- * (XFS_EOF_FLAGS_SYNC), the caller also must not hold any inode's IOLOCK or
+ * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
  * MMAPLOCK.
  */
 int
@@ -1550,7 +1550,7 @@ xfs_blockgc_free_dquots(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	unsigned int		eof_flags)
+	unsigned int		iwalk_flags)
 {
 	struct xfs_eofblocks	eofb = {0};
 	bool			do_work = false;
@@ -1562,23 +1562,23 @@ xfs_blockgc_free_dquots(
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
 
@@ -1592,12 +1592,12 @@ xfs_blockgc_free_dquots(
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
@@ -1817,5 +1817,5 @@ xfs_icwalk(
 		}
 	}
 	return last_error;
-	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
+	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_ICWALK_FLAGS_VALID);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 191620a069af..2f4a27a3109c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -18,6 +18,21 @@ struct xfs_eofblocks {
 	int		icw_scan_limit;
 };
 
+/* Flags that we borrowed from struct xfs_fs_eofblocks */
+#define XFS_ICWALK_FLAG_SYNC		(XFS_EOF_FLAGS_SYNC)
+#define XFS_ICWALK_FLAG_UID		(XFS_EOF_FLAGS_UID)
+#define XFS_ICWALK_FLAG_GID		(XFS_EOF_FLAGS_GID)
+#define XFS_ICWALK_FLAG_PRID		(XFS_EOF_FLAGS_PRID)
+#define XFS_ICWALK_FLAG_MINFILESIZE	(XFS_EOF_FLAGS_MINFILESIZE)
+#define XFS_ICWALK_FLAG_UNION		(XFS_EOF_FLAGS_UNION)
+
+#define XFS_ICWALK_FLAGS_VALID		(XFS_ICWALK_FLAG_SYNC | \
+					 XFS_ICWALK_FLAG_UID | \
+					 XFS_ICWALK_FLAG_GID | \
+					 XFS_ICWALK_FLAG_PRID | \
+					 XFS_ICWALK_FLAG_MINFILESIZE | \
+					 XFS_ICWALK_FLAG_UNION)
+
 /*
  * Flags for xfs_iget()
  */
@@ -43,8 +58,8 @@ void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
-		unsigned int eof_flags);
-int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
+		unsigned int iwalk_flags);
+int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);

