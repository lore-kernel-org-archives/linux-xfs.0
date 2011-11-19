Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFjPo072054 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:45 -0600
Message-Id: <20111119181543.361506649@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/9] [PATCH 1/9] "xfs: fix error handling for synchronous
	writes"
References: <20111119181336.964593075@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-xfs-fix-error-handling-for-synchronous-writes-revisi.patch
	revisited
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
Cc: Alex Elder <aelder@sgi.com>, Ajeet Yadav <ajeet.yadav.77@gmail.com>, xfs@oss.sgi.com

xfs: fix for hang during synchronous buffer write error

If removed storage while synchronous buffer write underway,
"xfslogd" hangs.

Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html

Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
"xfs: fix error handling for synchronous writes"

Given that xfs_bwrite actually does the shutdown already after
waiting for the b_iodone completion and given that we actually
found that calling xfs_force_shutdown from inside
xfs_buf_iodone_callbacks was a major contributor the problem
it better to drop this call.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_buf_item.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a7342e8..7888a75 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1023,7 +1023,6 @@ xfs_buf_iodone_callbacks(
 	XFS_BUF_UNDELAYWRITE(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 
 do_callbacks:
 	xfs_buf_do_callbacks(bp);
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
