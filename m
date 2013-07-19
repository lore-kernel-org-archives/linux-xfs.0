Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F20E97F75
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E33C08F8035
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TJinHmZY0T6NHkre for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048x-69
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001zC-4w
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 32/49] xfs: xfs_filestreams.h doesn't need __KERNEL__
Date: Fri, 19 Jul 2013 16:25:03 +1000
Message-Id: <1374215120-7271-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Because it is only used within the kernel.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 09dd9af..6d61dbe 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -18,8 +18,6 @@
 #ifndef __XFS_FILESTREAM_H__
 #define __XFS_FILESTREAM_H__
 
-#ifdef __KERNEL__
-
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_perag;
@@ -69,6 +67,4 @@ xfs_inode_is_filestream(
 		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
 }
 
-#endif /* __KERNEL__ */
-
 #endif /* __XFS_FILESTREAM_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
