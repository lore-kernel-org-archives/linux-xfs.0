Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 674C97F87
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 09:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53416304071
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:50:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bzsl6VccRcOunUWW for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:49:59 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2IEnxXs015155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:59 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r2IEnwQL018707
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:49:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 3/6] xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits()
	instead of xfs_disk_dquot_t
Date: Mon, 18 Mar 2013 10:51:45 -0400
Message-Id: <1363618308-53594-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
References: <1363618308-53594-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dquot.c       |    7 ++++---
 fs/xfs/xfs_dquot.h       |    4 ++--
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_trans_dquot.c |   10 +++++-----
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8025eb2..9c5869e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -85,10 +85,11 @@ xfs_qm_dqdestroy(
  */
 void
 xfs_qm_adjust_dqlimits(
-	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dq)
 {
-	xfs_quotainfo_t		*q = mp->m_quotainfo;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	struct xfs_disk_dquot	*d = &dq->q_core;
 
 	ASSERT(d->d_id);
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c694a84..f77b711 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -145,8 +145,8 @@ extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
-extern void		xfs_qm_adjust_dqlimits(xfs_mount_t *,
-					xfs_disk_dquot_t *);
+extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
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
index 642c2d6..fec75d0 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -326,12 +326,12 @@ xfs_trans_dqlockedjoin(
  */
 void
 xfs_trans_apply_dquot_deltas(
-	xfs_trans_t		*tp)
+	struct xfs_trans	*tp)
 {
 	int			i, j;
-	xfs_dquot_t		*dqp;
-	xfs_dqtrx_t		*qtrx, *qa;
-	xfs_disk_dquot_t	*d;
+	struct xfs_dquot	*dqp;
+	struct xfs_dqtrx	*qtrx, *qa;
+	struct xfs_disk_dquot	*d;
 	long			totalbdelta;
 	long			totalrtbdelta;
 
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
