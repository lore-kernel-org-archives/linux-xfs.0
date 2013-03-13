Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 232FD7F67
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:30:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E349C8F804B
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:30:31 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:12 -0700
Message-Id: <1363213395-10988-11-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 11/14] xfs: Modify xfs_qm_dqget to take a struct kqid.
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

- Modify xfs_qm_dqget, xfs_qm_dqattach_one, and xfs_qm_qutoacheck_dqadjust
  to take a struct kqid instead of an id and type pair.

- Modify their callers to pass them a struct kqid.

- Move xfs_qutoa_type into xfs_dquot.c where it is now used.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.c       |   24 +++++++++++++++++++-----
 fs/xfs/xfs_dquot.h       |    4 ++--
 fs/xfs/xfs_qm.c          |   42 +++++++++++++++++++-----------------------
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   20 ++------------------
 5 files changed, 43 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8025eb2..51e1c31 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -63,6 +63,19 @@ static struct kmem_zone		*xfs_qm_dqzone;
 
 static struct lock_class_key xfs_dquot_other_class;
 
+STATIC int
+xfs_quota_type(int type)
+{
+	switch (type) {
+	case USRQUOTA:
+		return XFS_DQ_USER;
+	case GRPQUOTA:
+		return XFS_DQ_GROUP;
+	default:
+		return XFS_DQ_PROJ;
+	}
+}
+
 /*
  * This is called to free all the memory associated with a dquot
  */
@@ -696,20 +709,21 @@ int
 xfs_qm_dqget(
 	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,	  /* locked inode (optional) */
-	xfs_dqid_t	id,	  /* uid/projid/gid depending on type */
-	uint		type,	  /* XFS_DQ_USER/XFS_DQ_PROJ/XFS_DQ_GROUP */
+	struct kqid     qid,	  /* uid/projid/gid depending on type */
 	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	uint			id = from_kqid(&init_user_ns, qid);
+	uint			type = xfs_quota_type(qid.type);
 	struct radix_tree_root *tree = XFS_DQUOT_TREE(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-	if ((! XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
-	    (! XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
-	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
+	if ((! XFS_IS_UQUOTA_ON(mp) && qid.type == USRQUOTA) ||
+	    (! XFS_IS_PQUOTA_ON(mp) && qid.type == PRJQUOTA) ||
+	    (! XFS_IS_GQUOTA_ON(mp) && qid.type == GRPQUOTA)) {
 		return (ESRCH);
 	}
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 2c197da..3566548 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -147,8 +147,8 @@ extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
 extern void		xfs_qm_adjust_dqlimits(xfs_mount_t *,
 					xfs_disk_dquot_t *);
-extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
-					xfs_dqid_t, uint, uint, xfs_dquot_t **);
+extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *, struct kqid,
+					uint, xfs_dquot_t **);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 308592e..31711ed 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -367,8 +367,7 @@ xfs_qm_unmount_quotas(
 STATIC int
 xfs_qm_dqattach_one(
 	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
+	struct kqid	id,
 	uint		doalloc,
 	xfs_dquot_t	*udqhint, /* hint */
 	xfs_dquot_t	**IO_idqpp)
@@ -397,7 +396,7 @@ xfs_qm_dqattach_one(
 	 * the user dquot.
 	 */
 	if (udqhint) {
-		ASSERT(type == XFS_DQ_GROUP || type == XFS_DQ_PROJ);
+		ASSERT(id.type == GRPQUOTA || id.type == PRJQUOTA);
 		xfs_dqlock(udqhint);
 
 		/*
@@ -408,7 +407,7 @@ xfs_qm_dqattach_one(
 		 * hold the ilock.
 		 */
 		dqp = udqhint->q_gdquot;
-		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
+		if (dqp && qid_eq(make_kqid(&init_user_ns, id.type, be32_to_cpu(dqp->q_core.d_id)), id)) {
 			ASSERT(*IO_idqpp == NULL);
 
 			*IO_idqpp = xfs_qm_dqhold(dqp);
@@ -432,7 +431,7 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
+	error = xfs_qm_dqget(ip->i_mount, ip, id,
 			     doalloc | XFS_QMOPT_DOWARN, &dqp);
 	if (error)
 		return error;
@@ -516,7 +515,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
+		error = xfs_qm_dqattach_one(ip, make_kqid_uid(ip->i_d.di_uid),
 						flags & XFS_QMOPT_DQALLOC,
 						NULL, &ip->i_udquot);
 		if (error)
@@ -527,10 +526,10 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (XFS_IS_OQUOTA_ON(mp)) {
 		error = XFS_IS_GQUOTA_ON(mp) ?
-			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
+			xfs_qm_dqattach_one(ip, make_kqid_gid(ip->i_d.di_gid),
 						flags & XFS_QMOPT_DQALLOC,
 						ip->i_udquot, &ip->i_gdquot) :
-			xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
+			xfs_qm_dqattach_one(ip, make_kqid_projid(ip->i_d.di_projid),
 						flags & XFS_QMOPT_DQALLOC,
 						ip->i_udquot, &ip->i_gdquot);
 		/*
@@ -1016,8 +1015,7 @@ out:
 STATIC int
 xfs_qm_quotacheck_dqadjust(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		id,
-	uint			type,
+	struct kqid		id,
 	xfs_qcnt_t		nblks,
 	xfs_qcnt_t		rtblks)
 {
@@ -1025,7 +1023,7 @@ xfs_qm_quotacheck_dqadjust(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	error = xfs_qm_dqget(mp, ip, id, type,
+	error = xfs_qm_dqget(mp, ip, id,
 			     XFS_QMOPT_DQALLOC | XFS_QMOPT_DOWARN, &dqp);
 	if (error) {
 		/*
@@ -1160,22 +1158,22 @@ xfs_qm_dqusage_adjust(
 	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_uid,
-						   XFS_DQ_USER, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, make_kqid_uid(ip->i_d.di_uid),
+						   nblks, rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_gid,
-						   XFS_DQ_GROUP, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, make_kqid_gid(ip->i_d.di_gid),
+						   nblks, rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_projid,
-						   XFS_DQ_PROJ, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, make_kqid_projid(ip->i_d.di_projid),
+						   nblks, rtblks);
 		if (error)
 			goto error0;
 	}
@@ -1662,8 +1660,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
-						 XFS_DQ_USER,
+			if ((error = xfs_qm_dqget(mp, NULL, make_kqid_uid(uid),
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
 						 &uq))) {
@@ -1688,8 +1685,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (!gid_eq(ip->i_d.di_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
-						 XFS_DQ_GROUP,
+			if ((error = xfs_qm_dqget(mp, NULL, make_kqid_gid(gid),
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
 						 &gq))) {
@@ -1708,8 +1704,8 @@ xfs_qm_vop_dqalloc(
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (!projid_eq(ip->i_d.di_projid, prid)) {
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
-						 XFS_DQ_PROJ,
+			if ((error = xfs_qm_dqget(mp, NULL,
+						 make_kqid_projid(prid),
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
 						 &gq))) {
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 7d44746..dda0f7a 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -79,7 +79,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, NULL, ip->i_d.di_projid, XFS_DQ_PROJ, 0, &dqp)) {
+	if (!xfs_qm_dqget(mp, NULL, make_kqid_projid(ip->i_d.di_projid), 0, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8ad5488..03876dc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -48,19 +48,6 @@ STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
 STATIC uint	xfs_qm_export_flags(uint);
 STATIC uint	xfs_qm_export_qtype_flags(uint);
 
-STATIC int
-xfs_quota_type(int type)
-{
-	switch (type) {
-	case USRQUOTA:
-		return XFS_DQ_USER;
-	case GRPQUOTA:
-		return XFS_DQ_GROUP;
-	default:
-		return XFS_DQ_PROJ;
-	}
-}
-
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
  * gdquots. Called only at unmount time.
@@ -525,9 +512,7 @@ xfs_qm_scall_setqlim(
 	 * Get the dquot (locked), and join it to the transaction.
 	 * Allocate the dquot if this doesn't exist.
 	 */
-	if ((error = xfs_qm_dqget(mp, NULL, from_kqid(&init_user_ns, id),
-				  xfs_quota_type(id.type),
-				  XFS_QMOPT_DQALLOC, &dqp))) {
+	if ((error = xfs_qm_dqget(mp, NULL, id, XFS_QMOPT_DQALLOC, &dqp))) {
 		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 		ASSERT(error != ENOENT);
 		goto out_unlock;
@@ -744,8 +729,7 @@ xfs_qm_scall_getquota(
 	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
 	 * exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, NULL, from_kqid(&init_user_ns, id),
-			     xfs_quota_type(id.type), 0, &dqp);
+	error = xfs_qm_dqget(mp, NULL, id, 0, &dqp);
 	if (error)
 		return error;
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
