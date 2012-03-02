Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DOxJ241552 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:24 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fXLfFJiMlXi2p2jA for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:23 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrt-0006Fx-39
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:21 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000J1-IL
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: avoid memory allocation failures in xfs_getbmap
Date: Fri,  2 Mar 2012 15:11:43 +1100
Message-Id: <1330661507-1121-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1330661507-1121-1-git-send-email-david@fromorbit.com>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_getbmap uses for a large buffer for extents, which is kmalloc'd.
This can fail after the system has been running for some time as it
is a high order allocation. Add a fallback to vmalloc so that it
doesn't require contiguous memory and so won't randomly fail on
files with large extent lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 188ef2f..d1ab08d 100644
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
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
