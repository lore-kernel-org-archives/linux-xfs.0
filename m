Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C6CA7F69
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAB2EAC007
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:35 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id C4HTYfnrRIEF6CvY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:34 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:34 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 5C8E51FF001E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:20:14 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPQOZ120224 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPPIt018544
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:26 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 03/11] xfs: Replace macro XFS_DQ_TO_QIP with a function
Date: Thu, 27 Jun 2013 17:25:06 -0500
Message-Id: <1372371914-11370-4-git-send-email-sekharan@us.ibm.com>
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
 fs/xfs/xfs_dquot.h |    4 ----
 fs/xfs/xfs_qm.h    |   16 ++++++++++++++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 09af322..7d184de 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -573,7 +573,7 @@ xfs_qm_dqtobp(
 	xfs_bmbt_irec_t map;
 	int		nmaps = 1, error;
 	xfs_buf_t	*bp;
-	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
+	struct xfs_inode	*quotip = xfs_dq_to_quota_inode(dqp);
 	xfs_mount_t	*mp = dqp->q_mount;
 	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
 	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4f0ebfc..b596626 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -143,10 +143,6 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
-#define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
-#define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
-				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
-				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 96568c2..051e43a 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -85,6 +85,22 @@ xfs_dquot_tree(
 	}
 	return NULL;
 }
+
+static inline struct xfs_inode *
+xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
+{
+	switch (dqp->dq_flags & XFS_DQ_ALLTYPES) {
+	case XFS_DQ_USER:
+		return dqp->q_mount->m_quotainfo->qi_uquotaip;
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+		return dqp->q_mount->m_quotainfo->qi_gquotaip;
+	default:
+		ASSERT(0);
+	}
+	return NULL;
+}
+
 extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
 					     unsigned int nbblks);
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
