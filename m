Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC08D7F4C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:24:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B07D1304071
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:24:36 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:04 -0700
Message-Id: <1363213395-10988-3-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 03/14] xfs: Store projectid as a single variable.
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

xfs_get_projid is torturous to read and when you don't have the
justification of maintaining an on-disk ABI there is really no point.
So merge di_projid_lo and di_projid_hi in xfs_inode into di_projid.
That is cheaper to read and cheaper to write and can handle future
needs.  Update all callers of xfs_get_projid and xfs_set_projid to use
i_d.di_projid instead.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c   |    2 +-
 fs/xfs/xfs_inode.c    |   18 +++++++++---------
 fs/xfs/xfs_inode.h    |   22 +---------------------
 fs/xfs/xfs_ioctl.c    |    8 ++++----
 fs/xfs/xfs_iops.c     |    2 +-
 fs/xfs/xfs_itable.c   |    4 ++--
 fs/xfs/xfs_qm.c       |   10 +++++-----
 fs/xfs/xfs_qm_bhv.c   |    2 +-
 fs/xfs/xfs_rename.c   |    2 +-
 fs/xfs/xfs_vnodeops.c |    6 +++---
 10 files changed, 28 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1213f07..1f62227 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1210,7 +1210,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
-	    xfs_get_projid(ip) != eofb->eof_prid)
+	    ip->i_d.di_projid != eofb->eof_prid)
 		return 0;
 
 	return 1;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 469b9b3..f6c9652 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -842,8 +842,8 @@ static void xfs_inode_from_disk(struct xfs_inode *to, struct xfs_dinode *from)
 	to->i_d.di_uid		= be32_to_cpu(from->di_uid);
 	to->i_d.di_gid		= be32_to_cpu(from->di_gid);
 	to->i_d.di_nlink	= be32_to_cpu(from->di_nlink);
-	to->i_d.di_projid_lo	= be16_to_cpu(from->di_projid_lo);
-	to->i_d.di_projid_hi	= be16_to_cpu(from->di_projid_hi);
+	to->i_d.di_projid 		= (((u32)be16_to_cpu(from->di_projid_hi)) << 16) |
+					 be16_to_cpu(from->di_projid_lo);
 	memcpy(to->i_d.di_pad, from->di_pad, sizeof(to->i_d.di_pad));
 	to->i_d.di_flushiter	= be16_to_cpu(from->di_flushiter);
 	to->i_d.di_atime.t_sec	= be32_to_cpu(from->di_atime.t_sec);
@@ -875,8 +875,8 @@ static void xfs_inode_to_disk(struct xfs_dinode *to, struct xfs_inode *from)
 	to->di_uid		= cpu_to_be32(from->i_d.di_uid);
 	to->di_gid		= cpu_to_be32(from->i_d.di_gid);
 	to->di_nlink		= cpu_to_be32(from->i_d.di_nlink);
-	to->di_projid_lo	= cpu_to_be16(from->i_d.di_projid_lo);
-	to->di_projid_hi	= cpu_to_be16(from->i_d.di_projid_hi);
+	to->di_projid_lo	= cpu_to_be16(from->i_d.di_projid & 0xffff);
+	to->di_projid_hi	= cpu_to_be16(from->i_d.di_projid >> 16);
 	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
 	to->di_flushiter	= cpu_to_be16(from->i_d.di_flushiter);
 	to->di_atime.t_sec	= cpu_to_be32(from->i_d.di_atime.t_sec);
@@ -909,8 +909,8 @@ void xfs_inode_to_log(struct xfs_icdinode *to, struct xfs_inode *from)
 	to->di_uid		= from->i_d.di_uid;
 	to->di_gid		= from->i_d.di_gid;
 	to->di_nlink		= from->i_d.di_nlink;
-	to->di_projid_lo	= from->i_d.di_projid_lo;
-	to->di_projid_hi	= from->i_d.di_projid_hi;
+	to->di_projid_lo	= from->i_d.di_projid & 0xffff;
+	to->di_projid_hi	= from->i_d.di_projid >> 16;
 	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
 	to->di_flushiter	= from->i_d.di_flushiter;
 	to->di_atime.t_sec	= from->i_d.di_atime.t_sec;
@@ -1112,7 +1112,7 @@ xfs_iread(
 	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
-		xfs_set_projid(ip, 0);
+		ip->i_d.di_projid = 0;
 	}
 
 	ip->i_delayed_blks = 0;
@@ -1261,7 +1261,7 @@ xfs_ialloc(
 	ASSERT(ip->i_d.di_nlink == nlink);
 	ip->i_d.di_uid = current_fsuid();
 	ip->i_d.di_gid = current_fsgid();
-	xfs_set_projid(ip, prid);
+	ip->i_d.di_projid = prid;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
 	/*
@@ -2895,7 +2895,7 @@ xfs_iflush_int(
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 			memset(&(dip->di_pad[0]), 0,
 			      sizeof(dip->di_pad));
-			ASSERT(xfs_get_projid(ip) == 0);
+			ASSERT(ip->i_d.di_projid == 0);
 		}
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 977f1d8..a722f7a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -252,8 +252,7 @@ typedef struct xfs_inode {
 		u32		di_uid;		/* owner's user id */
 		u32		di_gid;		/* owner's group id */
 		u32		di_nlink;	/* number of links to file */
-		u16		di_projid_lo;	/* lower part of owner's project id */
-		u16		di_projid_hi;	/* higher part of owner's project id */
+		projid_t	di_projid;	/* owner's project id */
 		u8		di_pad[6];	/* unused, zeroed space */
 		u16		di_flushiter;	/* incremented on flush */
 		xfs_ictimestamp_t di_atime;	/* time last accessed */
@@ -382,25 +381,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 }
 
 /*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
-{
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
-{
-	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
-}
-
-/*
  * In-core inode flags.
  */
 #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d681e34..79e9b13 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -815,7 +815,7 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = xfs_get_projid(ip);
+	fa.fsx_projid = ip->i_d.di_projid;
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -986,7 +986,7 @@ xfs_ioctl_setattr(
 	if (mask & FSX_PROJID) {
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    xfs_get_projid(ip) != fa->fsx_projid) {
+		    ip->i_d.di_projid != fa->fsx_projid) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -1104,12 +1104,12 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (xfs_get_projid(ip) != fa->fsx_projid) {
+		if (ip->i_d.di_projid != fa->fsx_projid) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			xfs_set_projid(ip, fa->fsx_projid);
+			ip->i_d.di_projid = fa->fsx_projid;
 
 			/*
 			 * We may have to rev the inode as well as
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..a69ddfd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -516,7 +516,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
 					 qflags, &udqp, &gdqp);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index dfb7f71..3529f2e 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -88,8 +88,8 @@ xfs_bulkstat_one_int(
 	 * further change.
 	 */
 	buf->bs_nlink = ip->i_d.di_nlink;
-	buf->bs_projid_lo = ip->i_d.di_projid_lo;
-	buf->bs_projid_hi = ip->i_d.di_projid_hi;
+	buf->bs_projid_lo = (u16)(ip->i_d.di_projid & 0xffff);
+	buf->bs_projid_hi = (u16)(ip->i_d.di_projid >> 16);
 	buf->bs_ino = ino;
 	buf->bs_mode = ip->i_d.di_mode;
 	buf->bs_uid = ip->i_d.di_uid;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e5b5cf9..c0904fc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -530,7 +530,7 @@ xfs_qm_dqattach_locked(
 			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
 						flags & XFS_QMOPT_DQALLOC,
 						ip->i_udquot, &ip->i_gdquot) :
-			xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+			xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
 						flags & XFS_QMOPT_DQALLOC,
 						ip->i_udquot, &ip->i_gdquot);
 		/*
@@ -1172,7 +1172,7 @@ xfs_qm_dqusage_adjust(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, xfs_get_projid(ip),
+		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_projid,
 						   XFS_DQ_PROJ, nblks, rtblks);
 		if (error)
 			goto error0;
@@ -1704,7 +1704,7 @@ xfs_qm_vop_dqalloc(
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (xfs_get_projid(ip) != prid) {
+		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
@@ -1819,7 +1819,7 @@ xfs_qm_vop_chown_reserve(
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
 		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id))
+		     ip->i_d.di_projid != be32_to_cpu(gdqp->q_core.d_id))
 			prjflags = XFS_QMOPT_ENOSPC;
 
 		if (prjflags ||
@@ -1917,7 +1917,7 @@ xfs_qm_vop_create_dqattach(
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
 		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			ip->i_d.di_gid : xfs_get_projid(ip)) ==
+			ip->i_d.di_gid : ip->i_d.di_projid) ==
 				be32_to_cpu(gdqp->q_core.d_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2d02eac..7d44746 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -79,7 +79,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, NULL, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, NULL, ip->i_d.di_projid, XFS_DQ_PROJ, 0, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 30ff5f4..4e87258 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -171,7 +171,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
+		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 77ad748..1a9ee2c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -741,7 +741,7 @@ xfs_create(
 		return XFS_ERROR(EIO);
 
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
+		prid = dp->i_d.di_projid;
 	else
 		prid = XFS_PROJID_DEFAULT;
 
@@ -1305,7 +1305,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
+		     (tdp->i_d.di_projid != sip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
 		goto error_return;
 	}
@@ -1402,7 +1402,7 @@ xfs_symlink(
 
 	udqp = gdqp = NULL;
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
+		prid = dp->i_d.di_projid;
 	else
 		prid = XFS_PROJID_DEFAULT;
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
