Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54JOr135661 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:19 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LFE5nZqHDhuioTux for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbA-0003IY-7b
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Paz-0003gp-VP
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 068/102] xfs: avoid taking the ilock unnessecarily in
	xfs_qm_dqattach
Date: Thu, 23 Aug 2012 15:02:26 +1000
Message-Id: <1345698180-13612-69-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: b4d05e3019692fc5a8c573fbce60de2d48c5b7a1

Check if we actually need to attach a dquot before taking the ilock in
xfs_qm_dqattach.  This avoid superflous lock roundtrips for the common cases
of quota support compiled in but not activated on a filesystem and an
inode that already has the dquots attached.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/quota/xfs_qm.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index eacf7e0..fd8ddac 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -777,6 +777,23 @@ xfs_qm_dqattach_grouphint(
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
@@ -794,11 +811,7 @@ xfs_qm_dqattach_locked(
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
@@ -873,6 +886,9 @@ xfs_qm_dqattach(
 {
 	int			error;
 
+	if (!xfs_qm_need_dqattach(ip))
+		return 0;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_qm_dqattach_locked(ip, flags);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
