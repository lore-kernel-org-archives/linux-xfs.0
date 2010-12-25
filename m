Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBPKMdQB125009 for <xfs@oss.sgi.com>; Sat, 25 Dec 2010 14:22:39 -0600
Date: Sat, 25 Dec 2010 21:14:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] XFS: Compare, don't assign in ASSERT() in
	xfs_trans_unreserve_and_mod_sb()
Message-ID: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

Hi,

In fs/xfs/xfs_trans.c::xfs_trans_unreserve_and_mod_sb() at the out: label 
we have this:
	ASSERT(error = 0);
I believe a comparison was intended, not an assignment. If I'm right, the 
patch below fixes that up.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xfs_trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only.

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f6d956b..0e312b9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1137,7 +1137,7 @@ out_undo_fdblocks:
 	if (blkdelta)
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
 out:
-	ASSERT(error = 0);
+	ASSERT(error == 0);
 	return;
 }
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
