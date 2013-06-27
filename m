Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6DBC7F5A
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7782B304053
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:27 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id 7J5TLPaFeJ6oaDYE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:26 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:25 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 4828E19D8041
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:13 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPMTP137478 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPMgv018381
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:22 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 01/11] xfs: Define a new function xfs_is_quota_inode()
Date: Thu, 27 Jun 2013 17:25:04 -0500
Message-Id: <1372371914-11370-2-git-send-email-sekharan@us.ibm.com>
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

In preparation for combined pquota/gquota support, define
a new function to check if the fiven inode is a quota inode.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_itable.c      |    2 +-
 fs/xfs/xfs_qm.c          |    8 +++-----
 fs/xfs/xfs_sb.h          |    6 ++++++
 fs/xfs/xfs_trans_dquot.c |    6 ++----
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2ea7d40..9cbf9e0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -43,7 +43,7 @@ xfs_internal_inum(
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
+		 xfs_is_quota_inode(&mp->m_sb, ino)));
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b75c9bb..28a5e8a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -489,8 +489,7 @@ xfs_qm_need_dqattach(
 		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
-	if (ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return false;
 	return true;
 }
@@ -606,8 +605,7 @@ xfs_qm_dqdetach(
 
 	trace_xfs_dquot_dqdetach(ip);
 
-	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_uquotino);
-	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_gquotino);
+	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, ip->i_ino));
 	if (ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
@@ -1152,7 +1150,7 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
+	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
 		*res = BULKSTAT_RV_NOTHING;
 		return XFS_ERROR(EINVAL);
 	}
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 2de58a8..78f9e70 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -618,6 +618,12 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline bool
+xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+{
+	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index fec75d0..3fa369c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -157,8 +157,7 @@ xfs_trans_mod_dquot_byino(
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) ||
 	    !XFS_IS_QUOTA_ON(mp) ||
-	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
 	if (tp->t_dqinfo == NULL)
@@ -816,8 +815,7 @@ xfs_trans_reserve_quota_nblks(
 	if (XFS_IS_PQUOTA_ON(mp))
 		flags |= XFS_QMOPT_ENOSPC;
 
-	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
-	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
+	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
