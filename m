Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C15F29DFB
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 01:01:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C870EAC008
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 23:01:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZI4CUEBFUyXLKyPP for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 23:01:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VOLgU-0007K7-Vu
	for xfs@oss.sgi.com; Tue, 24 Sep 2013 16:01:19 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VOLgU-0004uo-VA
	for xfs@oss.sgi.com; Tue, 24 Sep 2013 16:01:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
Date: Tue, 24 Sep 2013 16:01:15 +1000
Message-Id: <1380002476-18839-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1380002476-18839-1-git-send-email-david@fromorbit.com>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
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

It uses a kernel internal structure in it's definition rather than
the user visible structure that is passed to the ioctl.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 1edb5cc..18272c7 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -515,7 +515,7 @@ typedef struct xfs_swapext
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
-#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
