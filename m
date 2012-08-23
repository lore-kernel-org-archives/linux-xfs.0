Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53wJ3135451 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IqIG1xa0uuyQAin4 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:43 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003Hg-JL
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003fu-Hm
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 057/102] xfs: fallback to vmalloc for large buffers in
	xfs_attrmulti_attr_get
Date: Thu, 23 Aug 2012 15:02:15 +1000
Message-Id: <1345698180-13612-58-git-send-email-david@fromorbit.com>
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

Upstream commit: ad650f5b27bc9858360b42aaa0d9204d16115316

xfsdump uses for a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Add a fallback to vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index acca2c5..ada7da9 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -450,9 +450,12 @@ xfs_attrmulti_attr_get(
 
 	if (*len > XATTR_SIZE_MAX)
 		return EINVAL;
-	kbuf = kmalloc(*len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
+	kbuf = kmem_zalloc(*len, KM_SLEEP | KM_MAYFAIL);
+	if (!kbuf) {
+		kbuf = kmem_zalloc_large(*len);
+		if (!kbuf)
+			return ENOMEM;
+	}
 
 	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
 	if (error)
@@ -462,7 +465,10 @@ xfs_attrmulti_attr_get(
 		error = EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	if (is_vmalloc_addr(kbuf))
+		kmem_free_large(kbuf);
+	else
+		kmem_free(kbuf);
 	return error;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
