Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 150DD7FBD
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 07:24:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E90648F8033
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 05:24:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Vvxqa7kFcpnLy7Ev (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 05:24:53 -0800 (PST)
From: Pratyush Anand <panand@redhat.com>
Subject: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
Date: Thu, 19 Feb 2015 18:54:33 +0530
Message-Id: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
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
To: david@fromorbit.com, xfs@oss.sgi.com
Cc: Pratyush Anand <panand@redhat.com>, jbastian@redhat.com, ddutile@redhat.com

My root file system is xfs. As soon as I enable event for
xfs_trans_read_buf `echo xfs:xfs_trans_read_buf >>
/sys/kernel/debug/tracing/set_event`, I see a kernel panic.

A little bit of debugging shows that bp->b_fspriv is NULL many a time
when trace_xfs_trans_read_buf(bp->b_fspriv) is called.

I do not have any idea about xfs filesystem. So, I am not sure, if it
is expected to have bp->b_fspriv = NULL at this location.

This patch fixes the issue, until we have a better fix.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 fs/xfs/xfs_trans_buf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 0a4d4ab6d9a9..0b67a20643bf 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -329,7 +329,8 @@ xfs_trans_read_buf_map(
 
 	if (tp)
 		_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_read_buf(bp->b_fspriv);
+	if (bp->b_fspriv)
+		trace_xfs_trans_read_buf(bp->b_fspriv);
 	*bpp = bp;
 	return 0;
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
