Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P4RhE5094307 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 23:27:43 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id C03FAHZUVcDHFlRu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 21:29:28 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q9P4TRP6017473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 04:29:28 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q9P4TQ4Q023393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 04:29:27 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q9P4TQ3p027363 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 23:29:26 -0500
Message-ID: <5088BFD5.8060906@oracle.com>
Date: Thu, 25 Oct 2012 12:28:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove redundant return error from xfs_difree()
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If we can not fetch the related a.g. info when freeing a disk inode, it mostly like a
fatal issue was occurred and with ASSERT(0) is fine, however, return XFS_ERROR(EINVAL)
does not make sense here.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_ialloc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 445bf1a..b7ea965 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1065,7 +1065,6 @@ xfs_difree(
 		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
 			__func__, agno, mp->m_sb.sb_agcount);
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
 	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
@@ -1073,14 +1072,12 @@ xfs_difree(
 			__func__, (unsigned long long)inode,
 			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (agbno >= mp->m_sb.sb_agblocks)  {
 		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
 			__func__, agbno, mp->m_sb.sb_agblocks);
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
 	}
 	/*
 	 * Get the allocation group header.
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
