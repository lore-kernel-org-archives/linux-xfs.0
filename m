Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2N6Cmrg074538 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 01:12:54 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BED314A99EB
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 23:15:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zTl8BBULbes0OTPU for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 23:15:37 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: xfs_trans_read_buf() should return an error on
	failure
Date: Wed, 23 Mar 2011 17:14:28 +1100
Message-Id: <1300860870-15471-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1300860870-15471-1-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
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
Cc: aelder@sgi.com

From: Dave Chinner <dchinner@redhat.com>

When inside a transaction and we fail to read a buffer,
xfs_trans_read_buf returns a null buffer pointer and no error.
xfs_do_da_buf() checks the error return, but not the buffer, and as
a result this read failure condition causes a panic when it attempts
to dereference the non-existant buffer.

Make xfs_trans_read_buf() return the same error for this situation
regardless of whether it is in a transaction or not. This means
every caller does not need to check both the error return and the
buffer before proceeding to use the buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_buf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 3bea661..03b3b7f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -383,7 +383,8 @@ xfs_trans_read_buf(
 	bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
 	if (bp == NULL) {
 		*bpp = NULL;
-		return 0;
+		return (flags & XBF_TRYLOCK) ?
+					0 : XFS_ERROR(ENOMEM);
 	}
 	if (XFS_BUF_GETERROR(bp) != 0) {
 	    XFS_BUF_SUPER_STALE(bp);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
