Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p964vtkX165646 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 23:57:56 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EB551C6AC80
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 21:57:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GHC7KBGpjlm6Uvmj for <xfs@oss.sgi.com>;
	Wed, 05 Oct 2011 21:57:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RBg1b-0003VP-Cr
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 15:57:39 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RBg1b-0001pq-3n
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 15:57:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix unused variable warning
Date: Thu,  6 Oct 2011 15:57:39 +1100
Message-Id: <1317877059-7024-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Fix this warning:

fs/xfs/xfs_aops.c: In function 'xfs_end_io_direct_write':
fs/xfs/xfs_aops.c:1280:17: warning: unused variable 'inode' [-Wunused-variable]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 462e937..11b2aad 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1277,7 +1277,6 @@ xfs_end_io_direct_write(
 	bool			is_async)
 {
 	struct xfs_ioend	*ioend = iocb->private;
-	struct inode		*inode = ioend->io_inode;
 
 	/*
 	 * blockdev_direct_IO can return an error even after the I/O
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
