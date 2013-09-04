Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 246607F52
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 01:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF8E68F8040
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 23:37:26 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 0rfoIuVTNKpGKadA for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 23:37:25 -0700 (PDT)
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/4] userns: ioctl: convert project id between user and kernel
	space
Date: Wed, 4 Sep 2013 14:38:35 +0800
Message-Id: <1378276717-9663-3-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, Gao feng <gaofeng@cn.fujitsu.com>

User namespace use /proc/<pid>/projid_map to map the project ids
in user namespace to the global project ids.

This patch adds the conversion of xfs proj_t to the global project
id struct kprojid_t, and adds the validating check.

User in un-init user namespace can only change file's project id
to the specified ids which are configured in projid_map of userns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bdebc21..8db622f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -855,7 +855,7 @@ xfs_ioc_fsgetxattr(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = xfs_get_projid(ip);
+	fa.fsx_projid = xfs_convert_to_user_projid(xfs_get_projid(ip));
 
 	if (attr) {
 		if (ip->i_afp) {
@@ -965,6 +965,7 @@ xfs_ioctl_setattr(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
+	prid_t			projid = 0;
 
 	trace_xfs_ioctl_setattr(ip);
 
@@ -976,9 +977,12 @@ xfs_ioctl_setattr(
 	/*
 	 * Disallow 32bit project ids when projid32bit feature is not enabled.
 	 */
-	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
-			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return XFS_ERROR(EINVAL);
+	if ((mask & FSX_PROJID)) {
+		if ((xfs_convert_to_kernel_projid(fa->fsx_projid, &projid) < 0) ||
+		    ((projid > (__uint16_t)-1) &&
+		     !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb)))
+			return XFS_ERROR(EINVAL);
+	}
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -990,7 +994,7 @@ xfs_ioctl_setattr(
 	 */
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
 		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
+					 ip->i_d.di_gid, projid,
 					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
@@ -1033,7 +1037,7 @@ xfs_ioctl_setattr(
 
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    xfs_get_projid(ip) != fa->fsx_projid) {
+		    xfs_get_projid(ip) != projid) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
 						pdqp, capable(CAP_FOWNER) ?
@@ -1151,12 +1155,12 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (xfs_get_projid(ip) != fa->fsx_projid) {
+		if (xfs_get_projid(ip) != projid) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_pdquot, pdqp);
 			}
-			xfs_set_projid(ip, fa->fsx_projid);
+			xfs_set_projid(ip, projid);
 
 			/*
 			 * We may have to rev the inode as well as
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
