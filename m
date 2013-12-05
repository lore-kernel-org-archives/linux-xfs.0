Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12B287F57
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F328F8F8050
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id wTRwU9WCcmBGolvC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004wI-EV
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:51 +0000
Message-Id: <20131205155951.330689967@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqtobp
References: <20131205155830.620826868@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-locking
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

We might not have read in the extent list at this point, so make sure we
take the ilock exclusively if we have to do so.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2013-11-18 14:39:01.955589999 +0100
+++ xfs/fs/xfs/xfs_dquot.c	2013-12-05 11:42:34.759679600 +0100
@@ -469,16 +469,17 @@ xfs_qm_dqtobp(
 	struct xfs_mount	*mp = dqp->q_mount;
 	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
 	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
+	uint			lock_mode;
 
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
-	xfs_ilock(quotip, XFS_ILOCK_SHARED);
+	lock_mode = xfs_ilock_map_shared(quotip);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
 		 */
-		xfs_iunlock(quotip, XFS_ILOCK_SHARED);
+		xfs_iunlock_map_shared(quotip, lock_mode);
 		return ESRCH;
 	}
 
@@ -488,7 +489,7 @@ xfs_qm_dqtobp(
 	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
 			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 
-	xfs_iunlock(quotip, XFS_ILOCK_SHARED);
+	xfs_iunlock_map_shared(quotip, lock_mode);
 	if (error)
 		return error;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
