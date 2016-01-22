Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECAF67F3F
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 12:25:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D560F30405F
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 10:25:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id i1YrIYG3se9GtKAb for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 10:25:40 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/7] xfs: get quota inode from mp & flags rather than dqp
Date: Fri, 22 Jan 2016 12:25:34 -0600
Message-Id: <1453487136-12681-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

Allow us to get the appropriate quota inode from any
mp & quota flags, not necessarily associated with a
particular dqp.  Needed for when we are searching for
the next active ID with quotas and we want to examine
the quota inode.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_dquot.c |    3 ++-
 fs/xfs/xfs_qm.h    |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c9c7c2d..5dbde0d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -464,12 +464,13 @@ xfs_qm_dqtobp(
 	struct xfs_bmbt_irec	map;
 	int			nmaps = 1, error;
 	struct xfs_buf		*bp;
-	struct xfs_inode	*quotip = xfs_dq_to_quota_inode(dqp);
+	struct xfs_inode	*quotip;
 	struct xfs_mount	*mp = dqp->q_mount;
 	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
 	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
 	uint			lock_mode;
 
+	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
 	lock_mode = xfs_ilock_data_map_shared(quotip);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 996a040..8901a01 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -104,15 +104,15 @@ xfs_dquot_tree(
 }
 
 static inline struct xfs_inode *
-xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
+xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
 {
-	switch (dqp->dq_flags & XFS_DQ_ALLTYPES) {
+	switch (dq_flags & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
-		return dqp->q_mount->m_quotainfo->qi_uquotaip;
+		return mp->m_quotainfo->qi_uquotaip;
 	case XFS_DQ_GROUP:
-		return dqp->q_mount->m_quotainfo->qi_gquotaip;
+		return mp->m_quotainfo->qi_gquotaip;
 	case XFS_DQ_PROJ:
-		return dqp->q_mount->m_quotainfo->qi_pquotaip;
+		return mp->m_quotainfo->qi_pquotaip;
 	default:
 		ASSERT(0);
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
