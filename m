Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BC147F6D
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:30:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F65C8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:30:32 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:14 -0700
Message-Id: <1363213395-10988-13-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 13/14] xfs: Use q_id instead of q_core.d_id.
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

- Use qid_lt on q_id when compariting two quota entries for order.
- Use qid_eq or !qid_eq when comparing a quota entry for equality or inequality.
- Use is_superquota when testing for the magic quota id of 0.
- Use make_kqid_uid, make_kqid_gid, and make_kqid_projid when comparing
  a quota id against a uids, gids, or projids as appropriate.
- For tracing use from_kqid and map to the init user namespace.
  Tracers outside of the initial user namespace are not allowed.

- For generating ondisk values continue to use q_core.d_id.
- For cases where we want an index and don't care which quota
  it is continue to use be32_to_cpu(...->q_core.d_id)

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_dquot.c       |    3 +--
 fs/xfs/xfs_qm.c          |   18 +++++++++---------
 fs/xfs/xfs_trace.h       |    2 +-
 fs/xfs/xfs_trans_dquot.c |    8 ++------
 4 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 00d4b87..6b306d7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1086,8 +1086,7 @@ xfs_dqlock2(
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
-		if (be32_to_cpu(d1->q_core.d_id) >
-		    be32_to_cpu(d2->q_core.d_id)) {
+		if (qid_lt(d2->q_id, d1->q_id)) {
 			mutex_lock(&d2->q_qlock);
 			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_NESTED);
 		} else {
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 363a662..ccf2689 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -407,7 +407,7 @@ xfs_qm_dqattach_one(
 		 * hold the ilock.
 		 */
 		dqp = udqhint->q_gdquot;
-		if (dqp && qid_eq(make_kqid(&init_user_ns, id.type, be32_to_cpu(dqp->q_core.d_id)), id)) {
+		if (dqp && qid_eq(dqp->q_id, id)) {
 			ASSERT(*IO_idqpp == NULL);
 
 			*IO_idqpp = xfs_qm_dqhold(dqp);
@@ -1057,7 +1057,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_core.d_id) {
+	if (!is_superquota(dqp->q_id, &init_user_ns)) {
 		xfs_qm_adjust_dqlimits(mp, &dqp->q_core);
 		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
 	}
@@ -1804,7 +1804,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    !uid_eq(ip->i_d.di_uid, (uid_t)be32_to_cpu(udqp->q_core.d_id))) {
+	    !qid_eq(make_kqid_uid(ip->i_d.di_uid), udqp->q_id)) {
 		delblksudq = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1818,12 +1818,12 @@ xfs_qm_vop_chown_reserve(
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
 		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		    !projid_eq(ip->i_d.di_projid, be32_to_cpu(gdqp->q_core.d_id)))
+		    !qid_eq(make_kqid_projid(ip->i_d.di_projid), gdqp->q_id))
 			prjflags = XFS_QMOPT_ENOSPC;
 
 		if (prjflags ||
 		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
-		     !gid_eq(ip->i_d.di_gid, be32_to_cpu(gdqp->q_core.d_id)))) {
+		     !qid_eq(make_kqid_gid(ip->i_d.di_gid), gdqp->q_id))) {
 			delblksgdq = gdqp;
 			if (delblks) {
 				ASSERT(ip->i_gdquot);
@@ -1907,7 +1907,7 @@ xfs_qm_vop_create_dqattach(
 	if (udqp) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(XFS_IS_UQUOTA_ON(mp));
-		ASSERT(uid_eq(ip->i_d.di_uid, be32_to_cpu(udqp->q_core.d_id)));
+		ASSERT(qid_eq(make_kqid_uid(ip->i_d.di_uid), udqp->q_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
@@ -1915,9 +1915,9 @@ xfs_qm_vop_create_dqattach(
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT(XFS_IS_GQUOTA_ON(mp) ?
-		       gid_eq(ip->i_d.di_gid, be32_to_cpu(gdqp->q_core.d_id)):
-		       projid_eq(ip->i_d.di_projid, be32_to_cpu(gdqp->q_core.d_id)));
+		ASSERT(qid_eq(XFS_IS_GQUOTA_ON(mp) ?
+			      make_kqid_gid(ip->i_d.di_gid) :
+			      make_kqid_projid(ip->i_d.di_projid), gdqp->q_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 16a8129..a694663 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -713,7 +713,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 	), \
 	TP_fast_assign(
 		__entry->dev = dqp->q_mount->m_super->s_dev;
-		__entry->id = be32_to_cpu(dqp->q_core.d_id);
+		__entry->id = from_kqid(&init_user_ns, dqp->q_id);
 		__entry->flags = dqp->dq_flags;
 		__entry->nrefs = dqp->q_nrefs;
 		__entry->res_bcount = dqp->q_res_bcount;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 642c2d6..76a5761 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -578,11 +578,7 @@ xfs_quota_warn(
 	/* no warnings for project quotas - we just return ENOSPC later */
 	if (dqp->dq_flags & XFS_DQ_PROJ)
 		return;
-	quota_send_warning(make_kqid(&init_user_ns,
-				     (dqp->dq_flags & XFS_DQ_USER) ?
-				     USRQUOTA : GRPQUOTA,
-				     be32_to_cpu(dqp->q_core.d_id)),
-			   mp->m_super->s_dev, type);
+	quota_send_warning(dqp->q_id, mp->m_super->s_dev, type);
 }
 
 /*
@@ -638,7 +634,7 @@ xfs_trans_dqresv(
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
-	    dqp->q_core.d_id &&
+	    !is_superquota(dqp->q_id, &init_user_ns) &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
 	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
