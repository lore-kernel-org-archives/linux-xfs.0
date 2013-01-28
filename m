Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 483BA7F56
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 10:52:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34212304048
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:51:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DOc9eQhCgA0XnBnF for
	<xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:51:59 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0SGpwuu023249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 11:51:58 -0500
Received: from andromeda.usersys.redhat.com.com (ovpn-113-142.phx2.redhat.com
	[10.3.113.142])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r0SGpvZq028955
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 11:51:58 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: re-organize XFS_ILOCK asserts in xfs_itruncate_extents()
	[V2]
Date: Mon, 28 Jan 2013 11:51:50 -0500
Message-Id: <1359391910-4227-1-git-send-email-cmaiolino@redhat.com>
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

An logically OR'red assert for check an inode locked in XFS_ILOCK_EXCL and
XFS_IOLOCK_EXCL looks better than the old way, avoiding possible mistakes while
readin the code

V2: Fix a doubled assert in i_count left in V1

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 66282dc..b05c361 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1395,9 +1395,9 @@ xfs_itruncate_extents(
 	int			error = 0;
 	int			done = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL) ||
 	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
 	ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
-- 
1.8.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
