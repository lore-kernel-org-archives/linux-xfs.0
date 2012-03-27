Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REcRKq093883 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:38:27 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	nXmOwYCpycnPsseG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:38:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCXXW-0004Ip-A7
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 14:38:26 +0000
Message-Id: <20120327143826.255746245@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 10:34:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: avoid taking the ilock unnessecarily in
	xfs_qm_dqattach
References: <20120327143445.196524266@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-dqattach-locking
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Check if we actually need to attach a dquot before taking the ilock in
xfs_qm_dqattach.  This avoid superflous lock roundtrips for the common cases
of quota support compiled in but not activated on a filesystem and an
inode that already has the dquots attached.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_qm.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-03-26 21:11:12.000000000 +0200
+++ xfs/fs/xfs/xfs_qm.c	2012-03-27 08:04:51.765661301 +0200
@@ -476,6 +476,23 @@ done:
 	xfs_dqunlock(udq);
 }
 
+static bool
+xfs_qm_need_dqattach(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return false;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return false;
+	if (!XFS_NOT_DQATTACHED(mp, ip))
+		return false;
+	if (ip->i_ino == mp->m_sb.sb_uquotino ||
+	    ip->i_ino == mp->m_sb.sb_gquotino)
+		return false;
+	return true;
+}
 
 /*
  * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
@@ -493,11 +510,7 @@ xfs_qm_dqattach_locked(
 	uint		nquotas = 0;
 	int		error = 0;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) ||
-	    !XFS_IS_QUOTA_ON(mp) ||
-	    !XFS_NOT_DQATTACHED(mp, ip) ||
-	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	if (!xfs_qm_need_dqattach(ip))
 		return 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -568,6 +581,9 @@ xfs_qm_dqattach(
 {
 	int			error;
 
+	if (!xfs_qm_need_dqattach(ip))
+		return 0;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_qm_dqattach_locked(ip, flags);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
