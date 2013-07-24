Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 934437F69
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 23:52:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 733A2304064
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 21:52:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vZMwnmlMW8RXtAxB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 21:52:31 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6O4qUpM007012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6O4qTQm026157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:30 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6O4qT92026151 for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 04:52:29 GMT
Date: Wed, 24 Jul 2013 00:52:43 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v5 3/7] xfs: ioctl check for capabilities in the current
	user namespace
Message-ID: <20130724005243.325a9a88@oracle.com>
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

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_ioctl.c  | 4 ++--
 kernel/capability.c | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6e2bca5..8edc780 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -981,7 +981,7 @@ xfs_ioctl_setattr(
 	 * to the file owner ID, except in cases where the
 	 * CAP_FSETID capability is applicable.
 	 */
-	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
+	if (!inode_owner_or_capable(VFS_I(ip))) {
 		code = XFS_ERROR(EPERM);
 		goto error_return;
 	}
@@ -1103,7 +1103,7 @@ xfs_ioctl_setattr(
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
