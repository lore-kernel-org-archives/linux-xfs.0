Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C06F7F3F
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 12:34:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38545304062
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 10:34:36 -0700 (PDT)
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	by cuda.sgi.com with ESMTP id ZOiDfFZm7E4AUwEp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 10:34:34 -0700 (PDT)
From: Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical section
Date: Wed, 22 Apr 2015 13:33:41 -0400
Message-Id: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org

The commit f7be2d7f594cbc ("xfs: push down inactive transaction
mgmt for truncate") refactored the xfs_inactive() function
in fs/xfs/xfs_inode.c.  However, it also moved the call to
xfs_idestroy_fork() from inside the xfs_ilock() critical section to
outside. That was causing memory corruption and strange failures like
deferencing NULL pointers in some circumstances.

This patch moves the xfs_idestroy_fork() call back into an xfs_ilock()
critical section to avoid memory corruption problem.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/xfs/xfs_inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6163767..31850fb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1900,8 +1900,11 @@ xfs_inactive(
 			return;
 	}
 
-	if (ip->i_afp)
+	if (ip->i_afp) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
 
 	ASSERT(ip->i_d.di_anextents == 0);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
