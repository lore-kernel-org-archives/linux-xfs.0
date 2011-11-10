Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZidc127037 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:44 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 4/8] xfsprogs: mkfs.xfs: let libxfs_umount() do its thing
Date: Thu, 10 Nov 2011 14:35:14 -0600
Message-Id: <9f5a2c84d462158505a0a4fce6c9417315ab59ee.1320955676.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
In-Reply-To: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
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
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

In the mkfs.xfs main() routine (which is gargantuan, by the way),
there are a few function calls intended to do some clean up before
unmounting the filesystem.

The first function drops references that will be dropped again in
the unmnount call.  The others assume all references will go away as
a result of the purge, but the filesystem's root inode reference
will remain.

Let the unmount function take care of destroying the real-time
structures.  And instead of purging the inode and block caches, just
flush them (at least the block cache) and let the unmount code take
care of the final purge.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 mkfs/xfs_mkfs.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f527f3d..213cc74 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2674,9 +2674,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * Dump all inodes and buffers before marking us all done.
 	 * Need to drop references to inodes we still hold, first.
 	 */
-	libxfs_rtmount_destroy(mp);
-	libxfs_icache_purge();
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();
 
 	/*
 	 * Mark the filesystem ok.
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
