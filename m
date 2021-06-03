Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACD2C4708F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3AB61360
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFCDOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A722561360;
        Thu,  3 Jun 2021 03:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689985;
        bh=1dcMwytLGvyoHIJeHmd4Ye7rhVZsdr/fafAUrauiL5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t4rXFaeuwUpDOx7Un5MeJSf+4V03AP9qF5aUAMWYz8eDS1bdAiJ7Kjn/wVgrw/1Jl
         4wY7IPnvn4rkfnXU3P7WsxMkmH4IMP/axl4I4Ao0CRSFtQbsiSNrMud6YVtnuMKNUq
         In2zpyVIqYAFZZwJfi6Y08MsMa1geCyaKg02bZE5exx8o7GvMo8JZSPnv8XTXDl1fP
         d95vCZnGlD8qZGH9ivmMV5c6PEqSUXIT2feYIUfBbLdGYYDroqHjq56Fg//KjJJHza
         Ds+hfQ9d+FpTd9DEbocT82EBw9Lhq36YDpNC3WCXcMRp7Trd89QwAYzIXIJf+n2BIP
         ZO93sN4agisGQ==
Subject: [PATCH 2/2] xfs: rename struct xfs_eofblocks to xfs_icwalk
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 02 Jun 2021 20:13:05 -0700
Message-ID: <162268998538.2724263.16964371295618826505.stgit@locust>
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

The xfs_eofblocks structure is no longer well-named -- nowadays it
provides optional filtering criteria to any walk of the incore inode
cache.  Only one of the cache walk goals has anything to do with
clearing of speculative post-EOF preallocations, so change the name to
be more appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    6 +-
 fs/xfs/xfs_icache.c |  154 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |   14 ++---
 fs/xfs/xfs_ioctl.c  |   30 +++++-----
 fs/xfs/xfs_trace.h  |   36 ++++++------
 5 files changed, 120 insertions(+), 120 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index eb39c3777491..9fd5a82a814c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -773,14 +773,14 @@ xfs_file_buffered_write(
 		cleared_space = true;
 		goto write_retry;
 	} else if (ret == -ENOSPC && !cleared_space) {
-		struct xfs_eofblocks eofb = {0};
+		struct xfs_icwalk	icw = {0};
 
 		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_ICWALK_FLAG_SYNC;
-		xfs_blockgc_free_space(ip->i_mount, &eofb);
+		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
+		xfs_blockgc_free_space(ip->i_mount, &icw);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 052db2d5d9c4..deb91eb54a4f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -57,13 +57,13 @@ xfs_icwalk_tag(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_icwalk(struct xfs_mount *mp,
-		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
+		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
-		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
+		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 
 /*
- * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
- * with XFS_ICWALK_FLAGS_VALID.
+ * Private inode cache walk flags for struct xfs_icwalk.  Must not
+ * coincide with XFS_ICWALK_FLAGS_VALID.
  */
 #define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
 #define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
@@ -844,21 +844,21 @@ xfs_dqrele_igrab(
 static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	if (xfs_iflags_test(ip, XFS_INEW))
 		xfs_inew_wait(ip);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
@@ -876,16 +876,16 @@ xfs_dqrele_all_inodes(
 	struct xfs_mount	*mp,
 	unsigned int		qflags)
 {
-	struct xfs_eofblocks	eofb = { .eof_flags = 0 };
+	struct xfs_icwalk	icw = { .icw_flags = 0 };
 
 	if (qflags & XFS_UQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
 	if (qflags & XFS_GQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
 	if (qflags & XFS_PQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &eofb);
+	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
@@ -912,7 +912,7 @@ xfs_dqrele_all_inodes(
 static bool
 xfs_reclaim_igrab(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -928,7 +928,7 @@ xfs_reclaim_igrab(
 	 * Don't reclaim a sick inode unless we're under memory pressure or the
 	 * filesystem is unmounting.
 	 */
-	if (ip->i_sick && eofb == NULL &&
+	if (ip->i_sick && icw == NULL &&
 	    !(ip->i_mount->m_flags & XFS_MOUNT_UNMOUNTING)) {
 		spin_unlock(&ip->i_flags_lock);
 		return false;
@@ -1056,8 +1056,8 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
-	struct xfs_eofblocks	eofb = {
-		.eof_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
 		.icw_scan_limit	= nr_to_scan,
 	};
 
@@ -1065,7 +1065,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
+	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &icw);
 	return 0;
 }
 
@@ -1090,20 +1090,20 @@ xfs_reclaim_inodes_count(
 }
 
 STATIC bool
-xfs_inode_match_id(
+xfs_icwalk_match_id(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
-	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_UID) &&
+	    !uid_eq(VFS_I(ip)->i_uid, icw->icw_uid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
-	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_GID) &&
+	    !gid_eq(VFS_I(ip)->i_gid, icw->icw_gid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
-	    ip->i_projid != eofb->eof_prid)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_PRID) &&
+	    ip->i_projid != icw->icw_prid)
 		return false;
 
 	return true;
@@ -1114,20 +1114,20 @@ xfs_inode_match_id(
  * criteria match. This is for global/internal scans only.
  */
 STATIC bool
-xfs_inode_match_id_union(
+xfs_icwalk_match_id_union(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
-	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_UID) &&
+	    uid_eq(VFS_I(ip)->i_uid, icw->icw_uid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
-	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_GID) &&
+	    gid_eq(VFS_I(ip)->i_gid, icw->icw_gid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
-	    ip->i_projid == eofb->eof_prid)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_PRID) &&
+	    ip->i_projid == icw->icw_prid)
 		return true;
 
 	return false;
@@ -1135,29 +1135,29 @@ xfs_inode_match_id_union(
 
 /*
  * Is this inode @ip eligible for eof/cow block reclamation, given some
- * filtering parameters @eofb?  The inode is eligible if @eofb is null or
+ * filtering parameters @icw?  The inode is eligible if @icw is null or
  * if the predicate functions match.
  */
 static bool
-xfs_inode_matches_eofb(
+xfs_icwalk_match(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	bool			match;
 
-	if (!eofb)
+	if (!icw)
 		return true;
 
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_UNION)
-		match = xfs_inode_match_id_union(ip, eofb);
+	if (icw->icw_flags & XFS_ICWALK_FLAG_UNION)
+		match = xfs_icwalk_match_id_union(ip, icw);
 	else
-		match = xfs_inode_match_id(ip, eofb);
+		match = xfs_icwalk_match_id(ip, icw);
 	if (!match)
 		return false;
 
 	/* skip the inode if the file size is too small */
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
-	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
+	    XFS_ISIZE(ip) < icw->icw_min_file_size)
 		return false;
 
 	return true;
@@ -1183,12 +1183,12 @@ xfs_reclaim_worker(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb,
+	struct xfs_icwalk	*icw,
 	unsigned int		*lockflags)
 {
 	bool			wait;
 
-	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
+	wait = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
@@ -1200,7 +1200,7 @@ xfs_inode_free_eofblocks(
 	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (!xfs_inode_matches_eofb(ip, eofb))
+	if (!xfs_icwalk_match(ip, icw))
 		return 0;
 
 	/*
@@ -1345,13 +1345,13 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb,
+	struct xfs_icwalk	*icw,
 	unsigned int		*lockflags)
 {
 	bool			wait;
 	int			ret = 0;
 
-	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
+	wait = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
@@ -1359,7 +1359,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
-	if (!xfs_inode_matches_eofb(ip, eofb))
+	if (!xfs_icwalk_match(ip, icw))
 		return 0;
 
 	/*
@@ -1484,16 +1484,16 @@ xfs_blockgc_igrab(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	unsigned int		lockflags = 0;
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
+	error = xfs_inode_free_eofblocks(ip, icw, &lockflags);
 	if (error)
 		goto unlock;
 
-	error = xfs_inode_free_cowblocks(ip, eofb, &lockflags);
+	error = xfs_inode_free_cowblocks(ip, icw, &lockflags);
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
@@ -1527,11 +1527,11 @@ xfs_blockgc_worker(
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
+	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, eofb);
+	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
 }
 
 /*
@@ -1552,7 +1552,7 @@ xfs_blockgc_free_dquots(
 	struct xfs_dquot	*pdqp,
 	unsigned int		iwalk_flags)
 {
-	struct xfs_eofblocks	eofb = {0};
+	struct xfs_icwalk	icw = {0};
 	bool			do_work = false;
 
 	if (!udqp && !gdqp && !pdqp)
@@ -1562,30 +1562,30 @@ xfs_blockgc_free_dquots(
 	 * Run a scan to free blocks using the union filter to cover all
 	 * applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
+	icw.icw_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
-		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
-		eofb.eof_flags |= XFS_ICWALK_FLAG_UID;
+		icw.icw_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		icw.icw_flags |= XFS_ICWALK_FLAG_UID;
 		do_work = true;
 	}
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
-		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
-		eofb.eof_flags |= XFS_ICWALK_FLAG_GID;
+		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;
 	}
 
 	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
-		eofb.eof_prid = pdqp->q_id;
-		eofb.eof_flags |= XFS_ICWALK_FLAG_PRID;
+		icw.icw_prid = pdqp->q_id;
+		icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
 		do_work = true;
 	}
 
 	if (!do_work)
 		return 0;
 
-	return xfs_blockgc_free_space(mp, &eofb);
+	return xfs_blockgc_free_space(mp, &icw);
 }
 
 /* Run cow/eofblocks scans on the quotas attached to the inode. */
@@ -1619,7 +1619,7 @@ static inline bool
 xfs_icwalk_igrab(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
@@ -1627,7 +1627,7 @@ xfs_icwalk_igrab(
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
-		return xfs_reclaim_igrab(ip, eofb);
+		return xfs_reclaim_igrab(ip, icw);
 	default:
 		return false;
 	}
@@ -1642,16 +1642,16 @@ xfs_icwalk_process_inode(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	int			error = 0;
 
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
-		xfs_dqrele_inode(ip, eofb);
+		xfs_dqrele_inode(ip, icw);
 		break;
 	case XFS_ICWALK_BLOCKGC:
-		error = xfs_blockgc_scan_inode(ip, eofb);
+		error = xfs_blockgc_scan_inode(ip, icw);
 		break;
 	case XFS_ICWALK_RECLAIM:
 		xfs_reclaim_inode(ip, pag);
@@ -1668,7 +1668,7 @@ static int
 xfs_icwalk_ag(
 	struct xfs_perag	*pag,
 	enum xfs_icwalk_goal	goal,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1716,7 +1716,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip, eofb))
+			if (done || !xfs_icwalk_igrab(goal, ip, icw))
 				batch[i] = NULL;
 
 			/*
@@ -1745,7 +1745,7 @@ xfs_icwalk_ag(
 			if (!batch[i])
 				continue;
 			error = xfs_icwalk_process_inode(goal, batch[i], pag,
-					eofb);
+					icw);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -1760,9 +1760,9 @@ xfs_icwalk_ag(
 
 		cond_resched();
 
-		if (eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SCAN_LIMIT)) {
-			eofb->icw_scan_limit -= XFS_LOOKUP_BATCH;
-			if (eofb->icw_scan_limit <= 0)
+		if (icw && (icw->icw_flags & XFS_ICWALK_FLAG_SCAN_LIMIT)) {
+			icw->icw_scan_limit -= XFS_LOOKUP_BATCH;
+			if (icw->icw_scan_limit <= 0)
 				break;
 		}
 	} while (nr_found && !done);
@@ -1799,7 +1799,7 @@ static int
 xfs_icwalk(
 	struct xfs_mount	*mp,
 	enum xfs_icwalk_goal	goal,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1808,7 +1808,7 @@ xfs_icwalk(
 
 	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, goal, eofb);
+		error = xfs_icwalk_ag(pag, goal, icw);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2f4a27a3109c..345ce49ff5f1 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -9,12 +9,12 @@
 struct xfs_mount;
 struct xfs_perag;
 
-struct xfs_eofblocks {
-	__u32		eof_flags;
-	kuid_t		eof_uid;
-	kgid_t		eof_gid;
-	prid_t		eof_prid;
-	__u64		eof_min_file_size;
+struct xfs_icwalk {
+	__u32		icw_flags;
+	kuid_t		icw_uid;
+	kgid_t		icw_gid;
+	prid_t		icw_prid;
+	__u64		icw_min_file_size;
 	int		icw_scan_limit;
 };
 
@@ -60,7 +60,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
-int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
+int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1fe4c1fc0aea..a0fcadb1a04f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1875,7 +1875,7 @@ xfs_ioc_setlabel(
 static inline int
 xfs_fs_eofblocks_from_user(
 	struct xfs_fs_eofblocks		*src,
-	struct xfs_eofblocks		*dst)
+	struct xfs_icwalk		*dst)
 {
 	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
 		return -EINVAL;
@@ -1887,21 +1887,21 @@ xfs_fs_eofblocks_from_user(
 	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
 		return -EINVAL;
 
-	dst->eof_flags = src->eof_flags;
-	dst->eof_prid = src->eof_prid;
-	dst->eof_min_file_size = src->eof_min_file_size;
+	dst->icw_flags = src->eof_flags;
+	dst->icw_prid = src->eof_prid;
+	dst->icw_min_file_size = src->eof_min_file_size;
 
-	dst->eof_uid = INVALID_UID;
+	dst->icw_uid = INVALID_UID;
 	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
-		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
-		if (!uid_valid(dst->eof_uid))
+		dst->icw_uid = make_kuid(current_user_ns(), src->eof_uid);
+		if (!uid_valid(dst->icw_uid))
 			return -EINVAL;
 	}
 
-	dst->eof_gid = INVALID_GID;
+	dst->icw_gid = INVALID_GID;
 	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
-		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
-		if (!gid_valid(dst->eof_gid))
+		dst->icw_gid = make_kgid(current_user_ns(), src->eof_gid);
+		if (!gid_valid(dst->icw_gid))
 			return -EINVAL;
 	}
 	return 0;
@@ -2164,8 +2164,8 @@ xfs_file_ioctl(
 		return xfs_errortag_clearall(mp);
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_fs_eofblocks eofb;
-		struct xfs_eofblocks keofb;
+		struct xfs_fs_eofblocks	eofb;
+		struct xfs_icwalk	icw;
 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -2176,14 +2176,14 @@ xfs_file_ioctl(
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -EFAULT;
 
-		error = xfs_fs_eofblocks_from_user(&eofb, &keofb);
+		error = xfs_fs_eofblocks_from_user(&eofb, &icw);
 		if (error)
 			return error;
 
-		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
+		trace_xfs_ioc_free_eofblocks(mp, &icw, _RET_IP_);
 
 		sb_start_write(mp->m_super);
-		error = xfs_blockgc_free_space(mp, &keofb);
+		error = xfs_blockgc_free_space(mp, &icw);
 		sb_end_write(mp->m_super);
 		return error;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0171d93239a2..f5b241b23941 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,7 +37,7 @@ struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
-struct xfs_eofblocks;
+struct xfs_icwalk;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3885,10 +3885,10 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
 
-DECLARE_EVENT_CLASS(xfs_eofblocks_class,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+DECLARE_EVENT_CLASS(xfs_icwalk_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_icwalk *icw,
 		 unsigned long caller_ip),
-	TP_ARGS(mp, eofb, caller_ip),
+	TP_ARGS(mp, icw, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(__u32, flags)
@@ -3901,14 +3901,14 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->flags = eofb ? eofb->eof_flags : 0;
-		__entry->uid = eofb ? from_kuid(mp->m_super->s_user_ns,
-						eofb->eof_uid) : 0;
-		__entry->gid = eofb ? from_kgid(mp->m_super->s_user_ns,
-						eofb->eof_gid) : 0;
-		__entry->prid = eofb ? eofb->eof_prid : 0;
-		__entry->min_file_size = eofb ? eofb->eof_min_file_size : 0;
-		__entry->scan_limit = eofb ? eofb->icw_scan_limit : 0;
+		__entry->flags = icw ? icw->icw_flags : 0;
+		__entry->uid = icw ? from_kuid(mp->m_super->s_user_ns,
+						icw->icw_uid) : 0;
+		__entry->gid = icw ? from_kgid(mp->m_super->s_user_ns,
+						icw->icw_gid) : 0;
+		__entry->prid = icw ? icw->icw_prid : 0;
+		__entry->min_file_size = icw ? icw->icw_min_file_size : 0;
+		__entry->scan_limit = icw ? icw->icw_scan_limit : 0;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
@@ -3921,13 +3921,13 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 		  __entry->scan_limit,
 		  (char *)__entry->caller_ip)
 );
-#define DEFINE_EOFBLOCKS_EVENT(name)	\
-DEFINE_EVENT(xfs_eofblocks_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
+#define DEFINE_ICWALK_EVENT(name)	\
+DEFINE_EVENT(xfs_icwalk_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, struct xfs_icwalk *icw, \
 		 unsigned long caller_ip), \
-	TP_ARGS(mp, eofb, caller_ip))
-DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
-DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
+	TP_ARGS(mp, icw, caller_ip))
+DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

