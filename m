Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53C6o134977 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SCAP3D774eUkR4PM for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaA-0003G7-Hm
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003dT-EC
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 028/102] xfs: make i_flags an unsigned long
Date: Thu, 23 Aug 2012 15:01:46 +1000
Message-Id: <1345698180-13612-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 49e4c70e52a2bc2090e5a4e003e2888af21d6a2b

To be used for bit wakeup i_flags needs to be an unsigned long or we'll
run into trouble on big endian systems.  Because of the 1-byte i_update
field right after it this actually causes a fairly large size increase
on its own (4 or 8 bytes), but that increase will be more than offset
by the next two patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_inode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 28b3596..8a0979a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -250,7 +250,7 @@ typedef struct xfs_inode {
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
-	unsigned short		i_flags;	/* see defined flags below */
+	unsigned long		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
