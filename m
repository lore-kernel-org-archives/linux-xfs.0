Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274os3O020692 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:54 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	m1eU2QVdLCdI8V9P for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:53 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pw-0001oP-3m
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:52 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pb-0007Ur-SY
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/10] xfs: fallback to vmalloc for large buffers in
	xfs_getbmap
Date: Wed,  7 Mar 2012 15:50:22 +1100
Message-Id: <1331095828-28742-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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

xfs_getbmap uses for a large buffer for extents, which is kmalloc'd.
This can fail after the system has been running for some time as it
is a high order allocation. Add a fallback to vmalloc so that it
doesn't require contiguous memory and so won't randomly fail on
files with large extent lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 188ef2f..3548c6f 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5536,8 +5536,12 @@ xfs_getbmap(
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
@@ -5661,7 +5665,10 @@ xfs_getbmap(
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
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
