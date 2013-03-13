Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5457B7F4E
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:25:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD966AC001
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:25:27 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:06 -0700
Message-Id: <1363213395-10988-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 05/14] xfs: Update xfs_ioctl_setattr to handle projids in any
	user namespace
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
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Convert the userspace value in fa->fsx_projid into a kprojid and
  store it in the variable projid.
- Verify that xfs can store the projid after it is converted into
  xfs's user namespace.
- Replace uses of fa->fsx_projid with projid throughout
  xfs_ioctl_setattr.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1dd72d9..9aeecfb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -925,6 +925,7 @@ xfs_ioctl_setattr(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
+	kprojid_t		projid = INVALID_PROJID;
 
 	trace_xfs_ioctl_setattr(ip);
 
@@ -934,11 +935,20 @@ xfs_ioctl_setattr(
 		return XFS_ERROR(EIO);
 
 	/*
-	 * Disallow 32bit project ids when projid32bit feature is not enabled.
+	 * Verify the specifid project id is valid.
 	 */
-	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
-			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return XFS_ERROR(EINVAL);
+	if (mask & FSX_PROJID) {
+		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
+		if (!projid_valid(projid))
+			return XFS_ERROR(EINVAL);
+
+		/*
+		 * Disallow 32bit project ids when projid32bit feature is not enabled.
+		 */
+		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
+		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+			return XFS_ERROR(EINVAL);
+	}
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -950,7 +960,7 @@ xfs_ioctl_setattr(
 	 */
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
 		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
+					 ip->i_d.di_gid, projid,
 					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
 		if (code)
 			return code;
@@ -986,7 +996,7 @@ xfs_ioctl_setattr(
 	if (mask & FSX_PROJID) {
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-		    !projid_eq(ip->i_d.di_projid, fa->fsx_projid)) {
+		    !projid_eq(ip->i_d.di_projid, projid)) {
 			ASSERT(tp);
 			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
 						capable(CAP_FOWNER) ?
@@ -1104,12 +1114,12 @@ xfs_ioctl_setattr(
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
 		 */
-		if (!projid_eq(ip->i_d.di_projid, fa->fsx_projid)) {
+		if (!projid_eq(ip->i_d.di_projid, projid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_projid = fa->fsx_projid;
+			ip->i_d.di_projid = projid;
 
 			/*
 			 * We may have to rev the inode as well as
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
