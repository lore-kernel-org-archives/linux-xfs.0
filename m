Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDA7F7F9B
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9EB37304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eGuIuiAMYESuDHbF for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:54 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YW-Am
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-000631-9w
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 32/50] xfs: xfs_filestreams.h
	doesn't need __KERNEL__
Date: Mon, 12 Aug 2013 20:49:53 +1000
Message-Id: <1376304611-22994-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
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
