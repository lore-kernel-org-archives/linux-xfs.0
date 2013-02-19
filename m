Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 546E07F58
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 10:35:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5CF2AC004
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:34:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jKCo5wDW75pFcPFl for
	<xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:34:56 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1JGYuOV005862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:56 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1JGYtWg003692
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 4/7] xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits()
	instead of xfs_disk_dquot_t
Date: Tue, 19 Feb 2013 11:37:28 -0500
Message-Id: <1361291851-24714-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Modify xfs_qm_adjust_dqlimits() to take the xfs_dquot as a
parameter instead of just the xfs_disk_dquot_t so we can update
in-memory fields if necessary.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.c       |    3 ++-
 fs/xfs/xfs_dquot.h       |    2 +-
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_trans_dquot.c |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8025eb2..e1833b9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -86,9 +86,10 @@ xfs_qm_dqdestroy(
 void
 xfs_qm_adjust_dqlimits(
 	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_dquot	*dq)
 {
 	xfs_quotainfo_t		*q = mp->m_quotainfo;
+	xfs_disk_dquot_t	*d = &dq->q_core;
 
 	ASSERT(d->d_id);
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c694a84..69491b6 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -146,7 +146,7 @@ extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
 extern void		xfs_qm_adjust_dqlimits(xfs_mount_t *,
-					xfs_disk_dquot_t *);
+					       struct xfs_dquot *);
 extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
 					xfs_dqid_t, uint, uint, xfs_dquot_t **);
 extern void		xfs_qm_dqput(xfs_dquot_t *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e5b5cf9..d0acb4e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1057,7 +1057,7 @@ xfs_qm_quotacheck_dqadjust(
 	 * There are no timers for the default values set in the root dquot.
 	 */
 	if (dqp->q_core.d_id) {
-		xfs_qm_adjust_dqlimits(mp, &dqp->q_core);
+		xfs_qm_adjust_dqlimits(mp, dqp);
 		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
 	}
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 642c2d6..22d3da3 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -412,7 +412,7 @@ xfs_trans_apply_dquot_deltas(
 			 * Start/reset the timer(s) if needed.
 			 */
 			if (d->d_id) {
-				xfs_qm_adjust_dqlimits(tp->t_mountp, d);
+				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
 				xfs_qm_adjust_dqtimers(tp->t_mountp, d);
 			}
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
