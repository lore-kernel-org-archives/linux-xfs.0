Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C9447F69
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 22:07:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DB08304071
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:07:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id N7AHIbO4G4cJKHkC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 20:07:16 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6U37FB5029827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:15 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6U37DV4028446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:15 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6U37D9S028438 for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 03:07:13 GMT
Date: Mon, 29 Jul 2013 23:07:05 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v7 6/7] xfs: add capable check to free eofblocks ioctl
Message-ID: <20130729230705.128e4509@oracle.com>
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

Check for CAP_SYS_ADMIN since the caller can truncate preallocated
blocks from files they do not own nor have write access to. A more
fine grained access check was considered: require the caller to
specify their own uid/gid and to use inode_permission to check for
write, but this would not catch the case of an inode not reachable
via path traversal from the callers mount namespace.

Add check for read-only filesystem to free eofblocks ioctl.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6e72eff..b1990ac 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1613,6 +1613,12 @@ xfs_file_ioctl(
 		struct xfs_fs_eofblocks eofb;
 		struct xfs_eofblocks keofb;
 
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (IS_RDONLY(inode))
+			return -XFS_ERROR(EROFS);
+
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
