Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbfAACTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EFTH173623
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:22 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx42r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:21 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012JLR9008974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:21 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012JLr3026940
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:21 GMT
Subject: [PATCH 03/22] xfs: convert projid get/set functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:19 -0800
Message-ID: <154630915987.18437.2499418741534604769.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the projid get and set functions to work on xfs_icdinode like
they do in userspace.  xfs_db needs the icdinode version.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c   |    2 +-
 fs/xfs/xfs_icache.c  |    4 ++--
 fs/xfs/xfs_inode.c   |   12 +++++++-----
 fs/xfs/xfs_inode.h   |   17 ++++++++---------
 fs/xfs/xfs_ioctl.c   |   10 +++++-----
 fs/xfs/xfs_iops.c    |    2 +-
 fs/xfs/xfs_qm.c      |    9 +++++----
 fs/xfs/xfs_qm_bhv.c  |    3 ++-
 fs/xfs/xfs_symlink.c |    2 +-
 9 files changed, 32 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 978ce0c2e0aa..d67c3449a846 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -883,7 +883,7 @@ xfs_qm_id_for_quotatype(
 	case XFS_DQ_GROUP:
 		return ip->i_d.di_gid;
 	case XFS_DQ_PROJ:
-		return xfs_get_projid(ip);
+		return xfs_get_projid(&ip->i_d);
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 064c5de9dce3..f00c6f4bc515 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -41,7 +41,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) != eofb->eof_prid)
+	    xfs_get_projid(&ip->i_d) != eofb->eof_prid)
 		return 0;
 
 	return 1;
@@ -65,7 +65,7 @@ xfs_inode_match_id_union(
 		return 1;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    xfs_get_projid(ip) == eofb->eof_prid)
+	    xfs_get_projid(&ip->i_d) == eofb->eof_prid)
 		return 1;
 
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1df5c5ecac41..79c8876e9f61 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -722,7 +722,7 @@ xfs_ialloc(
 	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
 	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	inode->i_rdev = rdev;
-	xfs_set_projid(ip, prid);
+	xfs_set_projid(&ip->i_d, prid);
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
@@ -1062,7 +1062,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	prid = xfs_get_initial_prid(&dp->i_d);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
@@ -1216,7 +1216,7 @@ xfs_create_tmpfile(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	prid = xfs_get_initial_prid(dp);
+	prid = xfs_get_initial_prid(&dp->i_d);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
@@ -1335,7 +1335,8 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
+		     (xfs_get_projid(&tdp->i_d) !=
+		      xfs_get_projid(&sip->i_d)))) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -2997,7 +2998,8 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
+		     (xfs_get_projid(&target_dp->i_d) !=
+		      xfs_get_projid(&src_ip->i_d)))) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 29aedfdf3d05..ca2623e0dd4f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -171,24 +171,23 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
  * to retain compatibility with "old" filesystems).
  */
 static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
+xfs_get_projid(struct xfs_icdinode *id)
 {
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
+	return (prid_t)id->di_projid_hi << 16 | id->di_projid_lo;
 }
 
 static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
+xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
 {
-	ip->i_d.di_projid_hi = (uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (uint16_t) (projid & 0xffff);
+	id->di_projid_hi = (uint16_t) (projid >> 16);
+	id->di_projid_lo = (uint16_t) (projid & 0xffff);
 }
 
 static inline prid_t
-xfs_get_initial_prid(struct xfs_inode *dp)
+xfs_get_initial_prid(struct xfs_icdinode *id)
 {
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return xfs_get_projid(dp);
+	if (id->di_flags & XFS_DIFLAG_PROJINHERIT)
+		return xfs_get_projid(id);
 
 	return XFS_PROJID_DEFAULT;
 }
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 78a3d315fa82..8cd9f5757732 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -886,7 +886,7 @@ xfs_ioc_fsgetxattr(
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa.fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = xfs_get_projid(ip);
+	fa.fsx_projid = xfs_get_projid(&ip->i_d);
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -1243,7 +1243,7 @@ xfs_ioctl_setattr_check_projid(
 	if (current_user_ns() == &init_user_ns)
 		return 0;
 
-	if (xfs_get_projid(ip) != fa->fsx_projid)
+	if (xfs_get_projid(&ip->i_d) != fa->fsx_projid)
 		return -EINVAL;
 	if ((fa->fsx_xflags & FS_XFLAG_PROJINHERIT) !=
 	    (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT))
@@ -1306,7 +1306,7 @@ xfs_ioctl_setattr(
 
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    xfs_get_projid(ip) != fa->fsx_projid) {
+	    xfs_get_projid(&ip->i_d) != fa->fsx_projid) {
 		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
@@ -1338,13 +1338,13 @@ xfs_ioctl_setattr(
 		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
 
 	/* Change the ownerships and register project quota modifications */
-	if (xfs_get_projid(ip) != fa->fsx_projid) {
+	if (xfs_get_projid(&ip->i_d) != fa->fsx_projid) {
 		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
 		ASSERT(ip->i_d.di_version > 1);
-		xfs_set_projid(ip, fa->fsx_projid);
+		xfs_set_projid(&ip->i_d, fa->fsx_projid);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..1081dd376f86 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -657,7 +657,7 @@ xfs_setattr_nonsize(
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
-					   xfs_get_projid(ip),
+					   xfs_get_projid(&ip->i_d),
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 116b24c980fd..32f400867727 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -345,7 +345,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, xfs_get_projid(&ip->i_d), XFS_DQ_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -1732,7 +1732,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (xfs_get_projid(ip) != prid) {
+		if (xfs_get_projid(&ip->i_d) != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
 					true, &pq);
@@ -1865,7 +1865,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
+	    xfs_get_projid(&ip->i_d) != be32_to_cpu(pdqp->q_core.d_id)) {
 		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
@@ -1966,7 +1966,8 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(xfs_get_projid(&ip->i_d) ==
+				be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 3091e4bc04ef..2032fe6bb22a 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,8 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, xfs_get_projid(&ip->i_d), XFS_DQ_PROJ,
+				false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e554e8264b6..0096cdbad34e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -267,7 +267,7 @@ xfs_symlink(
 	ASSERT(pathlen > 0);
 
 	udqp = gdqp = NULL;
-	prid = xfs_get_initial_prid(dp);
+	prid = xfs_get_initial_prid(&dp->i_d);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
