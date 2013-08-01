Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C3CA29E13
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 10:30:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B79D8F8037
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 08:30:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ciEg8D61JNkMsbZ5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 08:30:21 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r71FUJ2s001688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:30:19 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r71FUIDg005447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:30:19 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r71FUI2c005955 for <xfs@oss.sgi.com>; Thu, 1 Aug 2013 15:30:18 GMT
Date: Thu, 1 Aug 2013 11:30:06 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 3/7] xfs: ioctl check for capabilities in the current
	user namespace
Message-ID: <20130801113006.13370058@oracle.com>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Use inode_capable() to check if SUID|SGID bits should be cleared to match
similar check in inode_change_ok().

The check for CAP_LINUX_IMMUTABLE was not modified since all other file
systems also check against init_user_ns rather than current_user_ns.

Only allow changing of projid from init_user_ns.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_ioctl.c  | 11 +++++++++--
 kernel/capability.c |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6e2bca5..7b42192 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -981,15 +981,22 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+	if (!inode_owner_or_capable(VFS_I(ip))) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
 
 	/*
 	 * Do a quota reservation only if projid is actually going to change.
+	 * Only allow changing of projid from init_user_ns since it is a
+	 * non user namespace aware identifier.
 	 */
 	if (mask & FSX_PROJID) {
+		if (current_user_ns() != &init_user_ns) {
+			code = XFS_ERROR(EINVAL);
+			goto error_return;
+		}
+
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
 		    xfs_get_projid(ip) != fa->fsx_projid) {
@@ -1103,7 +1110,7 @@ xfs_ioctl_setattr(
 		 * cleared upon successful return from chown()
 		 */
 		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
+		    !inode_capable(VFS_I(ip), CAP_FSETID))
 			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
 
 		/*
diff --git a/kernel/capability.c b/kernel/capability.c
index f6c2ce5..a4b6744 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -464,3 +464,4 @@ bool inode_capable(const struct inode *inode, int cap)
 
 	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid);
 }
+EXPORT_SYMBOL(inode_capable);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
