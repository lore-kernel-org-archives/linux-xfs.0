Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F32FB7F61
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:30:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67130AC001
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:30:30 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:13 -0700
Message-Id: <1363213395-10988-12-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 12/14] xfs: Remember the kqid for a quota
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

- Add q_id to struct xfs_quota
- Modify xfs_qm_dqread to take a struct kqid, allowing xfs_qm_dqread to
  set q_id on fresh quota structures.
- Modify xfs_qm_dqget and xfs_qm_init_quota_info to pass a kqid
  to xfs_qm_dqread

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.c |   12 ++++++------
 fs/xfs/xfs_dquot.h |    3 ++-
 fs/xfs/xfs_qm.c    |    9 +++++----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 51e1c31..00d4b87 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -581,8 +581,7 @@ xfs_qm_dqtobp(
 int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
-	xfs_dqid_t		id,
-	uint			type,
+	struct kqid		id,
 	uint			flags,
 	struct xfs_dquot	**O_dqpp)
 {
@@ -596,8 +595,9 @@ xfs_qm_dqread(
 
 	dqp = kmem_zone_zalloc(xfs_qm_dqzone, KM_SLEEP);
 
-	dqp->dq_flags = type;
-	dqp->q_core.d_id = cpu_to_be32(id);
+	dqp->q_id = id;
+	dqp->dq_flags = xfs_quota_type(id.type);
+	dqp->q_core.d_id = cpu_to_be32(from_kqid(&init_user_ns, id));
 	dqp->q_mount = mp;
 	INIT_LIST_HEAD(&dqp->q_lru);
 	mutex_init(&dqp->q_qlock);
@@ -615,7 +615,7 @@ xfs_qm_dqread(
 	 * Make sure group quotas have a different lock class than user
 	 * quotas.
 	 */
-	if (!(type & XFS_DQ_USER))
+	if (id.type != USRQUOTA)
 		lockdep_set_class(&dqp->q_qlock, &xfs_dquot_other_class);
 
 	XFS_STATS_INC(xs_qm_dquot);
@@ -779,7 +779,7 @@ restart:
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
+	error = xfs_qm_dqread(mp, qid, flags, &dqp);
 
 	if (ip)
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 3566548..0b6020e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -36,6 +36,7 @@ struct xfs_trans;
  * The incore dquot structure
  */
 typedef struct xfs_dquot {
+	struct kqid      q_id;		/* quota identifier */
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
@@ -138,7 +139,7 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
 				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
-extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
+extern int		xfs_qm_dqread(struct xfs_mount *, struct kqid,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 31711ed..363a662 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -673,10 +673,11 @@ xfs_qm_init_quotainfo(
 	 * Since we may not have done a quotacheck by this point, just read
 	 * the dquot without attaching it to any hashtables or lists.
 	 */
-	error = xfs_qm_dqread(mp, 0,
-			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
-			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
-			  XFS_DQ_PROJ),
+	error = xfs_qm_dqread(mp,
+			make_kqid(&init_user_ns,
+				  XFS_IS_UQUOTA_RUNNING(mp) ? USRQUOTA :
+				  (XFS_IS_GQUOTA_RUNNING(mp) ? GRPQUOTA :
+				   PRJQUOTA), 0),
 			XFS_QMOPT_DOWARN, &dqp);
 	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
