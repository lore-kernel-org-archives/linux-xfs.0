Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C777529E97
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63EAEAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rr54S1o2nwu8q1O2 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAO0-00030q-UI
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:48 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANg-000079-7f
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 45/60] xfs: xfs_filestreams.h doesn't need __KERNEL__
Date: Wed, 19 Jun 2013 14:50:53 +1000
Message-Id: <1371617468-32559-46-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_filestream.h |    4 ----
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
