Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NeeJ5067594 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:40 -0600
Message-Id: <20121203144309.451341355@sgi.com>
Date: Mon, 03 Dec 2012 17:42:15 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 07/36] xfs: fallback to vmalloc for large buffers
	in xfs_getbmap
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=058
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

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

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5457,8 +5457,12 @@ xfs_getbmap(
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
@@ -5583,7 +5587,10 @@ xfs_getbmap(
 			break;
 	}
 
-	kmem_free(out);
+	if (is_vmalloc_addr(out))
+		kmem_free_large(out);
+	else
+		kmem_free(out);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
