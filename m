Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8FxKNH150199 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 09:59:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C34116ECC78
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 07:59:18 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	muH7Cs68e1kTokYi for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 07:59:18 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RYgNS-0006pE-CD
	for xfs@oss.sgi.com; Thu, 08 Dec 2011 15:59:18 +0000
Message-Id: <20111208155918.348628833@bombadil.infradead.org>
Date: Thu, 08 Dec 2011 10:58:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/11] xfs: make i_flags an unsigned long
References: <20111208155755.323930705@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-use-i_flags
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

To be used for bit wakeup i_flags needs to be an unsigned long or we'll
run into trouble on big endian systems.  Beause of the 1-byte i_update
field right after it this actually causes a fairly large size increase
on its own (4 or 8 bytes), but that increase will be more than offset
by the next two patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_inode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 12:58:58.449770178 +0100
+++ xfs/fs/xfs/xfs_inode.h	2011-11-30 12:59:05.013067955 +0100
@@ -242,7 +242,7 @@ typedef struct xfs_inode {
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
-	unsigned short		i_flags;	/* see defined flags below */
+	unsigned long		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
