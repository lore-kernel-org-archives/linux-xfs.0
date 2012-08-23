Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52ixH134640 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:45 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	905qQjSgEmb3mCjJ for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:30 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZk-0003EE-LU
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bZ-K1
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 005/102] xfs: wait for I/O completion when writing out pages
	in xfs_setattr_size
Date: Thu, 23 Aug 2012 15:01:23 +1000
Message-Id: <1345698180-13612-6-git-send-email-david@fromorbit.com>
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

Upstream commit: 2b3ffd7eb7b4392e3657c5046b055ca9f1f7cf5e

The current code relies on the xfs_ioend_wait call later on to make sure
all I/O actually has completed.  The xfs_ioend_wait call will go away soon,
so prepare for that by using the waiting filemap function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_vnodeops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 59509ae..fbdb33b 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -246,7 +246,7 @@ xfs_setattr(
 		    iattr->ia_size > ip->i_d.di_size) {
 			code = xfs_flush_pages(ip,
 					ip->i_d.di_size, iattr->ia_size,
-					XBF_ASYNC, FI_NONE);
+					0, FI_NONE);
 			if (code)
 				goto error_return;
 		}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
