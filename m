Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE81CC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF700206D9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f0/a7lmy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgGNVrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:47:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:47:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELc5fl065568;
        Tue, 14 Jul 2020 21:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hwjmDxfHIyw0FTBEKnbAFnBmNNPzwEFVj7vw09l3pgw=;
 b=f0/a7lmyUkcBEnE/cWcVfFR8P1oeZBGUpeGfmMUzansCw5/7PuIMCZDM1pOMpot80SO8
 3dXaG7ssZX+ytbshfNdBqHaTPWh1g1c8AOuoChMNZo7uTVLQbflWVD5B/c8TP/mSpVNh
 GkfSURYabkzEl35UfpzC6ZWNs/FwKHlRSi1p1srviCHzSY6XtjOoFDlwOszm6uN2mYVU
 5km3yTQWCNZ9zMNB/YFaL8pzRu5ktvPVjlp0Y3F09eesTktK0E/Fu5rta4fFf7W8v2EP
 u0UA7rTalYvWsfVTTHqmgcPIKZyzE/1AgJY0hEX9xKa7E3O2xFOQVca/qc/WsEZ5K2yn VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur82vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhbEQ182851;
        Tue, 14 Jul 2020 21:46:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 327q6t48qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:57 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELkvjW025052;
        Tue, 14 Jul 2020 21:46:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:56 -0700
Subject: [PATCH 3/3] libxfs: remove ifork_ops from all client programs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:55 -0700
Message-ID: <159476321566.3156851.5591166832235063760.stgit@magnolia>
In-Reply-To: <159476319690.3156851.8364082533532014066.stgit@magnolia>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're removing ifork_ops from libxfs in 5.8, so start by collapsing the
usages back into a single place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrset.c             |    6 +--
 include/xfs_inode.h      |    6 ++-
 libxfs/libxfs_api_defs.h |    1 -
 libxfs/rdwr.c            |    5 +--
 libxfs/util.c            |    3 +-
 repair/phase6.c          |   80 ++++++----------------------------------------
 repair/phase7.c          |    2 +
 repair/quotacheck.c      |    4 +-
 repair/xfs_repair.c      |    3 +-
 9 files changed, 22 insertions(+), 88 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index b86ecec7..98a08a49 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -153,8 +153,7 @@ attr_set_f(
 		memset(args.value, 'v', args.valuelen);
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
-			&xfs_default_ifork_ops)) {
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
@@ -238,8 +237,7 @@ attr_remove_f(
 		return 0;
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
-			&xfs_default_ifork_ops)) {
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 3caeeb39..ce8f6599 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -160,9 +160,9 @@ extern struct timespec64 current_time(struct inode *inode);
 
 /* Inode Cache Interfaces */
 extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip);
-extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-				uint, struct xfs_inode **,
-				struct xfs_ifork_ops *);
+extern int	libxfs_iget(struct xfs_mount *mp, struct xfs_trans *tp,
+				xfs_ino_t ino, uint lock_flags,
+				struct xfs_inode **ipp);
 extern void	libxfs_irele(struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1a7cdbf9..e7e42e93 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -60,7 +60,6 @@
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
 #define xfs_da_shrink_inode		libxfs_da_shrink_inode
-#define xfs_default_ifork_ops		libxfs_default_ifork_ops
 #define xfs_defer_cancel		libxfs_defer_cancel
 #define xfs_defer_finish		libxfs_defer_finish
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 13a414d7..2eaf099e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1262,8 +1262,7 @@ libxfs_iget(
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
 	uint			lock_flags,
-	struct xfs_inode	**ipp,
-	struct xfs_ifork_ops	*ifork_ops)
+	struct xfs_inode	**ipp)
 {
 	struct xfs_inode	*ip;
 	int			error = 0;
@@ -1281,7 +1280,7 @@ libxfs_iget(
 		return error;
 	}
 
-	ip->i_fork_ops = ifork_ops;
+	ip->i_fork_ops = &xfs_default_ifork_ops;
 	if (!libxfs_inode_verify_forks(ip)) {
 		libxfs_irele(ip);
 		return -EFSCORRUPTED;
diff --git a/libxfs/util.c b/libxfs/util.c
index 914e4ca5..4bf06082 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -247,8 +247,7 @@ libxfs_ialloc(
 	}
 	ASSERT(*ialloc_context == NULL);
 
-	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
 	if (error != 0)
 		return error;
 	ASSERT(ip != NULL);
diff --git a/repair/phase6.c b/repair/phase6.c
index b6391326..f69582d4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -26,58 +26,6 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
 						1,
 						XFS_DIR3_FT_DIR};
 
-/*
- * When we're checking directory inodes, we're allowed to set a directory's
- * dotdot entry to zero to signal that the parent needs to be reconnected
- * during phase 6.  If we're handling a shortform directory the ifork
- * verifiers will fail, so temporarily patch out this canary so that we can
- * verify the rest of the fork and move on to fixing the dir.
- */
-static xfs_failaddr_t
-phase6_verify_dir(
-	struct xfs_inode		*ip)
-{
-	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp;
-	struct xfs_dir2_sf_hdr		*sfp;
-	xfs_failaddr_t			fa;
-	xfs_ino_t			old_parent;
-	bool				parent_bypass = false;
-	int				size;
-
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
-
-	/*
-	 * If this is a shortform directory, phase4 may have set the parent
-	 * inode to zero to indicate that it must be fixed.  Temporarily
-	 * set a valid parent so that the directory verifier will pass.
-	 */
-	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
-	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
-		old_parent = libxfs_dir2_sf_get_parent_ino(sfp);
-		if (old_parent == 0) {
-			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
-			parent_bypass = true;
-		}
-	}
-
-	fa = libxfs_default_ifork_ops.verify_dir(ip);
-
-	/* Put it back. */
-	if (parent_bypass)
-		libxfs_dir2_sf_put_parent_ino(sfp, old_parent);
-
-	return fa;
-}
-
-static struct xfs_ifork_ops phase6_ifork_ops = {
-	.verify_attr	= xfs_attr_shortform_verify,
-	.verify_dir	= phase6_verify_dir,
-	.verify_symlink	= xfs_symlink_shortform_verify,
-};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass
@@ -529,8 +477,7 @@ mk_rbmino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime bitmap inode -- error - %d\n"),
@@ -628,8 +575,7 @@ fill_rbmino(xfs_mount_t *mp)
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime bitmap inode -- error - %d\n"),
@@ -699,8 +645,7 @@ fill_rsumino(xfs_mount_t *mp)
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime summary inode -- error - %d\n"),
@@ -772,8 +717,7 @@ mk_rsumino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime summary inode -- error - %d\n"),
@@ -871,8 +815,7 @@ mk_root_dir(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rootino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rootino, 0, &ip);
 	if (error) {
 		do_error(_("could not iget root inode -- error - %d\n"), error);
 	}
@@ -946,8 +889,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * would have been cleared in phase3 and phase4.
 	 */
 
-	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip,
-			&xfs_default_ifork_ops);
+	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip);
 	if (i)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
@@ -971,8 +913,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * use iget/ijoin instead of trans_iget because the ialloc
 	 * wrapper can commit the transaction and start a new one
 	 */
-/*	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip,
-			&xfs_default_ifork_ops);
+/*	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip);
 	if (i)
 		do_error(_("%d - couldn't iget root inode to make %s\n"),
 			i, ORPHANAGE);*/
@@ -1080,8 +1021,7 @@ mv_orphanage(
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
 
-	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip,
-			&xfs_default_ifork_ops);
+	err = -libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip);
 	if (err)
 		do_error(_("%d - couldn't iget orphanage inode\n"), err);
 	/*
@@ -1094,7 +1034,7 @@ mv_orphanage(
 					(unsigned long long)ino, ++incr);
 
 	/* Orphans may not have a proper parent, so use custom ops here */
-	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
+	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p);
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
@@ -2868,7 +2808,7 @@ process_dir_inode(
 
 	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
 	if (error) {
 		if (!no_modify)
 			do_error(
diff --git a/repair/phase7.c b/repair/phase7.c
index 47e76b56..30cb46f9 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -33,7 +33,7 @@ update_inode_nlinks(
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
 	ASSERT(error == 0);
 
-	error = -libxfs_iget(mp, tp, ino, 0, &ip, &xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, tp, ino, 0, &ip);
 	if (error)  {
 		if (!no_modify)
 			do_error(
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 0df1f2be..87f81c3d 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -210,7 +210,7 @@ quotacheck_adjust(
 	    ino == mp->m_sb.sb_pquotino)
 		return;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
 	if (error) {
 		do_warn(
 	_("could not open file %"PRIu64" for quotacheck, err=%d\n"),
@@ -367,7 +367,7 @@ quotacheck_verify(
 	if (!dquots || !chkd_flags)
 		return;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
 	if (error) {
 		do_warn(
 	_("could not open %s inode %"PRIu64" for quotacheck, err=%d\n"),
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d687edea..5efc5586 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -459,8 +459,7 @@ has_plausible_rootdir(
 	int			error;
 	bool			ret = false;
 
-	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
-			&xfs_default_ifork_ops);
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
 	if (error)
 		goto out;
 	if (!S_ISDIR(VFS_I(ip)->i_mode))

