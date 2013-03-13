Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B9C07F4C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:24:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2DDFF30405F
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:24:56 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:05 -0700
Message-Id: <1363213395-10988-4-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 04/14] xfs: Update inode uids, gids, and projids to be kuids,
	kgids, and kprojids
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

Update i_projid on struct xfs_inode to be of type  kprojid_t.

Update the logic in xfs_inode_from_disk when the values are read from
disk to convert their on-disk values into the internal kernel
representation.

Update xfs_inode_to_disk and xfs_inode_to_log to convert from the
internal kernel representation to the on-disk values when updating the
on-disk fields.

Update comparisons against these fields to use uid_eq, gid_eq
and projid_eq.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c   |    6 +++---
 fs/xfs/xfs_inode.c    |   37 +++++++++++++++++++++++--------------
 fs/xfs/xfs_inode.h    |    6 +++---
 fs/xfs/xfs_ioctl.c    |    8 ++++----
 fs/xfs/xfs_itable.c   |   10 ++++++----
 fs/xfs/xfs_qm.c       |   20 ++++++++++----------
 fs/xfs/xfs_rename.c   |    2 +-
 fs/xfs/xfs_vnodeops.c |    2 +-
 8 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f62227..03a4427 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1202,15 +1202,15 @@ xfs_inode_match_id(
 	struct xfs_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
-	    ip->i_d.di_uid != eofb->eof_uid)
+	    !uid_eq(ip->i_d.di_uid, eofb->eof_uid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
-	    ip->i_d.di_gid != eofb->eof_gid)
+	    !gid_eq(ip->i_d.di_gid, eofb->eof_gid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
-	    ip->i_d.di_projid != eofb->eof_prid)
+	    !projid_eq(ip->i_d.di_projid, eofb->eof_prid))
 		return 0;
 
 	return 1;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f6c9652..8d77e49 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -834,16 +834,18 @@ xfs_iformat_btree(
 
 static void xfs_inode_from_disk(struct xfs_inode *to, struct xfs_dinode *from)
 {
+	projid_t projid;
 	to->i_d.di_magic	= be16_to_cpu(from->di_magic);
 	to->i_d.di_mode		= be16_to_cpu(from->di_mode);
 	to->i_d.di_version	= from ->di_version;
 	to->i_d.di_format	= from->di_format;
 	to->i_d.di_onlink	= be16_to_cpu(from->di_onlink);
-	to->i_d.di_uid		= be32_to_cpu(from->di_uid);
-	to->i_d.di_gid		= be32_to_cpu(from->di_gid);
+	to->i_d.di_uid		= make_kuid(&init_user_ns, be32_to_cpu(from->di_uid));
+	to->i_d.di_gid		= make_kgid(&init_user_ns, be32_to_cpu(from->di_gid));
 	to->i_d.di_nlink	= be32_to_cpu(from->di_nlink);
-	to->i_d.di_projid 		= (((u32)be16_to_cpu(from->di_projid_hi)) << 16) |
+	projid			= (((u32)be16_to_cpu(from->di_projid_hi)) << 16) |
 					 be16_to_cpu(from->di_projid_lo);
+	to->i_d.di_projid 	= make_kprojid(&init_user_ns, projid);
 	memcpy(to->i_d.di_pad, from->di_pad, sizeof(to->i_d.di_pad));
 	to->i_d.di_flushiter	= be16_to_cpu(from->di_flushiter);
 	to->i_d.di_atime.t_sec	= be32_to_cpu(from->di_atime.t_sec);
@@ -867,16 +869,19 @@ static void xfs_inode_from_disk(struct xfs_inode *to, struct xfs_dinode *from)
 
 static void xfs_inode_to_disk(struct xfs_dinode *to, struct xfs_inode *from)
 {
+	uid_t uid = from_kuid(&init_user_ns, from->i_d.di_uid);
+	gid_t gid = from_kgid(&init_user_ns, from->i_d.di_gid);
+	projid_t projid = from_kprojid(&init_user_ns, from->i_d.di_projid);
 	to->di_magic		= cpu_to_be16(from->i_d.di_magic);
 	to->di_mode		= cpu_to_be16(from->i_d.di_mode);
 	to->di_version		= from->i_d.di_version;
 	to->di_format		= from->i_d.di_format;
 	to->di_onlink		= cpu_to_be16(from->i_d.di_onlink);
-	to->di_uid		= cpu_to_be32(from->i_d.di_uid);
-	to->di_gid		= cpu_to_be32(from->i_d.di_gid);
+	to->di_uid		= cpu_to_be32(uid);
+	to->di_gid		= cpu_to_be32(gid);
 	to->di_nlink		= cpu_to_be32(from->i_d.di_nlink);
-	to->di_projid_lo	= cpu_to_be16(from->i_d.di_projid & 0xffff);
-	to->di_projid_hi	= cpu_to_be16(from->i_d.di_projid >> 16);
+	to->di_projid_lo	= cpu_to_be16(projid & 0xffff);
+	to->di_projid_hi	= cpu_to_be16(projid >> 16);
 	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
 	to->di_flushiter	= cpu_to_be16(from->i_d.di_flushiter);
 	to->di_atime.t_sec	= cpu_to_be32(from->i_d.di_atime.t_sec);
@@ -901,16 +906,19 @@ static void xfs_inode_to_disk(struct xfs_dinode *to, struct xfs_inode *from)
 void xfs_inode_to_log(struct xfs_icdinode *to, struct xfs_inode *from)
 {
 	/* xfs_inode_to_disk without the endian changes */
+	uid_t uid = from_kuid(&init_user_ns, from->i_d.di_uid);
+	gid_t gid = from_kgid(&init_user_ns, from->i_d.di_gid);
+	projid_t projid = from_kprojid(&init_user_ns, from->i_d.di_projid);
 	to->di_magic		= from->i_d.di_magic;
 	to->di_mode		= from->i_d.di_mode;
 	to->di_version		= from->i_d.di_version;
 	to->di_format		= from->i_d.di_format;
 	to->di_onlink		= from->i_d.di_onlink;
-	to->di_uid		= from->i_d.di_uid;
-	to->di_gid		= from->i_d.di_gid;
+	to->di_uid		= uid;
+	to->di_gid		= gid;
 	to->di_nlink		= from->i_d.di_nlink;
-	to->di_projid_lo	= from->i_d.di_projid & 0xffff;
-	to->di_projid_hi	= from->i_d.di_projid >> 16;
+	to->di_projid_lo	= projid & 0xffff;
+	to->di_projid_hi	= projid >> 16;
 	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
 	to->di_flushiter	= from->i_d.di_flushiter;
 	to->di_atime.t_sec	= from->i_d.di_atime.t_sec;
@@ -1112,7 +1120,7 @@ xfs_iread(
 	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
-		ip->i_d.di_projid = 0;
+		ip->i_d.di_projid = make_kprojid(&init_user_ns, 0);
 	}
 
 	ip->i_delayed_blks = 0;
@@ -1299,7 +1307,7 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
+	    (!in_group_p(ip->i_d.di_gid))) {
 		ip->i_d.di_mode &= ~S_ISGID;
 	}
 
@@ -2895,7 +2903,8 @@ xfs_iflush_int(
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 			memset(&(dip->di_pad[0]), 0,
 			      sizeof(dip->di_pad));
-			ASSERT(ip->i_d.di_projid == 0);
+			ASSERT(projid_eq(ip->i_d.di_projid,
+					 make_kprojid(&init_user_ns, 0)));
 		}
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a722f7a..095bcbb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -249,10 +249,10 @@ typedef struct xfs_inode {
 		s8		di_version;	/* inode version */
 		s8		di_format;	/* format of di_c data */
 		u16		di_onlink;	/* old number of links to file */
-		u32		di_uid;		/* owner's user id */
-		u32		di_gid;		/* owner's group id */
+		kuid_t		di_uid;		/* owner's user id */
+		kgid_t		di_gid;		/* owner's group id */
 		u32		di_nlink;	/* number of links to file */
-		projid_t	di_projid;	/* owner's project id */
+		kprojid_t	di_projid;	/* owner's project id */
 		u8		di_pad[6];	/* unused, zeroed space */
 		u16		di_flushiter;	/* incremented on flush */
 		xfs_ictimestamp_t di_atime;	/* time last accessed */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 79e9b13..1dd72d9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -815,7 +815,7 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = ip->i_d.di_projid;
+	fa.fsx_projid = from_kprojid_munged(current_user_ns(), ip->i_d.di_projid);
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -975,7 +975,7 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+	if (!uid_eq(current_fsuid(), ip->i_d.di_uid) && !capable(CAP_FOWNER)) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
@@ -986,7 +986,7 @@ xfs_ioctl_setattr(
 	if (mask & FSX_PROJID) {
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    ip->i_d.di_projid != fa->fsx_projid) {
+		    !projid_eq(ip->i_d.di_projid, fa->fsx_projid)) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -1104,7 +1104,7 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (ip->i_d.di_projid != fa->fsx_projid) {
+		if (!projid_eq(ip->i_d.di_projid, fa->fsx_projid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 3529f2e..6e57195 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -63,6 +63,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct xfs_bstat	*buf;		/* return buffer */
 	int			error = 0;	/* error value */
+	projid_t		projid;
 
 	*stat = BULKSTAT_RV_NOTHING;
 
@@ -88,12 +89,13 @@ xfs_bulkstat_one_int(
 	 * further change.
 	 */
 	buf->bs_nlink = ip->i_d.di_nlink;
-	buf->bs_projid_lo = (u16)(ip->i_d.di_projid & 0xffff);
-	buf->bs_projid_hi = (u16)(ip->i_d.di_projid >> 16);
+	projid = from_kprojid_munged(current_user_ns(), ip->i_d.di_projid);
+	buf->bs_projid_lo = projid & 0xffff;
+	buf->bs_projid_hi = projid >> 16;
 	buf->bs_ino = ino;
 	buf->bs_mode = ip->i_d.di_mode;
-	buf->bs_uid = ip->i_d.di_uid;
-	buf->bs_gid = ip->i_d.di_gid;
+	buf->bs_uid = from_kuid_munged(current_user_ns(), ip->i_d.di_uid);
+	buf->bs_gid = from_kgid_munged(current_user_ns(), ip->i_d.di_gid);
 	buf->bs_size = ip->i_d.di_size;
 	buf->bs_atime.tv_sec = ip->i_d.di_atime.t_sec;
 	buf->bs_atime.tv_nsec = ip->i_d.di_atime.t_nsec;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c0904fc..3324dd3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1649,7 +1649,7 @@ xfs_qm_vop_dqalloc(
 
 	uq = gq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (!uid_eq(ip->i_d.di_uid, uid)) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1684,7 +1684,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (!gid_eq(ip->i_d.di_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
 						 XFS_DQ_GROUP,
@@ -1704,7 +1704,7 @@ xfs_qm_vop_dqalloc(
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (ip->i_d.di_projid != prid) {
+		if (!projid_eq(ip->i_d.di_projid, prid)) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
@@ -1805,7 +1805,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
+	    !uid_eq(ip->i_d.di_uid, (uid_t)be32_to_cpu(udqp->q_core.d_id))) {
 		delblksudq = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1819,12 +1819,12 @@ xfs_qm_vop_chown_reserve(
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
 		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		     ip->i_d.di_projid != be32_to_cpu(gdqp->q_core.d_id))
+		    !projid_eq(ip->i_d.di_projid, be32_to_cpu(gdqp->q_core.d_id)))
 			prjflags = XFS_QMOPT_ENOSPC;
 
 		if (prjflags ||
 		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
-		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
+		     !gid_eq(ip->i_d.di_gid, be32_to_cpu(gdqp->q_core.d_id)))) {
 			delblksgdq = gdqp;
 			if (delblks) {
 				ASSERT(ip->i_gdquot);
@@ -1908,7 +1908,7 @@ xfs_qm_vop_create_dqattach(
 	if (udqp) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(XFS_IS_UQUOTA_ON(mp));
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(uid_eq(ip->i_d.di_uid, be32_to_cpu(udqp->q_core.d_id)));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
@@ -1916,9 +1916,9 @@ xfs_qm_vop_create_dqattach(
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			ip->i_d.di_gid : ip->i_d.di_projid) ==
-				be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(XFS_IS_GQUOTA_ON(mp) ?
+		       gid_eq(ip->i_d.di_gid, be32_to_cpu(gdqp->q_core.d_id)):
+		       projid_eq(ip->i_d.di_projid, be32_to_cpu(gdqp->q_core.d_id)));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 4e87258..b919704 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -171,7 +171,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
+		     !projid_eq(target_dp->i_d.di_projid, src_ip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 1a9ee2c..dab0ab3 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1305,7 +1305,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (tdp->i_d.di_projid != sip->i_d.di_projid))) {
+		     !projid_eq(tdp->i_d.di_projid, sip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
