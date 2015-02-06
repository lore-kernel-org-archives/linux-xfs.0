Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D7DA7F7D
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 22:47:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 385B9AC001
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 20:47:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SJaAWVfhoviGLwWX for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 20:47:02 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: only trace buffer items if they exist
Date: Fri,  6 Feb 2015 15:46:48 +1100
Message-Id: <1423198008-30748-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: y@disappointment.disaster

From: Dave Chinner <dchinner@redhat.com>

The commit 2d3d0c5 ("xfs: lobotomise xfs_trans_read_buf_map()") left
a landmine in the tracing code: trace_xfs_trans_buf_read() is now
call on all buffers that are read through this interface rather than
just buffers in transactions. For buffers outside transaction
context, bp->b_fspriv is null, and so the buf log item tracing
functions cannot be called. This causes a NULL pointer dereference
in the trace_xfs_trans_buf_read() function when tracing is turned
on.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_buf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 0a4d4ab..7579841 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -327,9 +327,10 @@ xfs_trans_read_buf_map(
 		return -EIO;
 	}
 
-	if (tp)
+	if (tp) {
 		_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_read_buf(bp->b_fspriv);
+		trace_xfs_trans_read_buf(bp->b_fspriv);
+	}
 	*bpp = bp;
 	return 0;
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
