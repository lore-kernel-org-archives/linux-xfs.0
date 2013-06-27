Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B5E87F52
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 382BCAC001
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:28 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id AiOV8dTvTbdCqK0Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:27 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:26 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id D9B401FF001D
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:20:08 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPO7P160768 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPOtN018490
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:24 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 02/11] xfs: Replace macro XFS_DQUOT_TREE with a function
Date: Thu, 27 Jun 2013 17:25:05 -0500
Message-Id: <1372371914-11370-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

In preparation for combined pquota/gquota support, for the sake
of readability, change the macro to an inline function.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c |    2 +-
 fs/xfs/xfs_qm.c    |    6 +++---
 fs/xfs/xfs_qm.h    |   22 ++++++++++++++++------
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 044e97a..09af322 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -804,7 +804,7 @@ xfs_qm_dqget(
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root *tree = XFS_DQUOT_TREE(qi, type);
+	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28a5e8a..8e707d3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -70,7 +70,7 @@ xfs_qm_dquot_walk(
 	void			*data)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	uint32_t		next_index;
 	int			last_error = 0;
 	int			skipped;
@@ -189,7 +189,7 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 	qi->qi_dquots--;
 
@@ -1471,7 +1471,7 @@ xfs_qm_dqfree_one(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 
 	qi->qi_dquots--;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5d16a6e..96568c2 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -69,12 +69,22 @@ typedef struct xfs_quotainfo {
 	struct shrinker  qi_shrinker;
 } xfs_quotainfo_t;
 
-#define XFS_DQUOT_TREE(qi, type) \
-	((type & XFS_DQ_USER) ? \
-	 &((qi)->qi_uquota_tree) : \
-	 &((qi)->qi_gquota_tree))
-
-
+static inline struct radix_tree_root *
+xfs_dquot_tree(
+	struct xfs_quotainfo	*qi,
+	int			type)
+{
+	switch (type) {
+	case XFS_DQ_USER:
+		return &qi->qi_uquota_tree;
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+		return &qi->qi_gquota_tree;
+	default:
+		ASSERT(0);
+	}
+	return NULL;
+}
 extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
 					     unsigned int nbblks);
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
