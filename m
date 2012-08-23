Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53xI2135461 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:00 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	66MYM36WqptWFMan for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:45 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003Hi-LH
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003fz-Iq
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 058/102] xfs: fallback to vmalloc for large buffers in
	xfs_getbmap
Date: Thu, 23 Aug 2012 15:02:16 +1000
Message-Id: <1345698180-13612-59-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: f074211f6041305b645669464343d504f4e6a290

xfs_getbmap uses for a large buffer for extents, which is kmalloc'd.
This can fail after the system has been running for some time as it
is a high order allocation. Add a fallback to vmalloc so that it
doesn't require contiguous memory and so won't randomly fail on
files with large extent lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_bmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 51b3489..2af58c4 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5455,8 +5455,12 @@ xfs_getbmap(
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
 		return XFS_ERROR(ENOMEM);
 	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out)
-		return XFS_ERROR(ENOMEM);
+	if (!out) {
+		out = kmem_zalloc_large(bmv->bmv_count *
+					sizeof(struct getbmapx));
+		if (!out)
+			return XFS_ERROR(ENOMEM);
+	}
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
@@ -5581,7 +5585,10 @@ xfs_getbmap(
 			break;
 	}
 
-	kmem_free(out);
+	if (is_vmalloc_addr(out))
+		kmem_free_large(out);
+	else
+		kmem_free(out);
 	return error;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
