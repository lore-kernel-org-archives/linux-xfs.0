Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegE2067679 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144311.580325568@sgi.com>
Date: Mon, 03 Dec 2012 17:42:38 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 30/36] xfs: fix allocbt cursor leak in
	xfs_alloc_ag_vextent_near
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=097
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

Upstream commit: 76d095388b040229ea1aad7dea45be0cfa20f589

When we fail to find an matching extent near the requested extent
specification during a left-right distance search in
xfs_alloc_ag_vextent_near, we fail to free the original cursor that
we used to look up the XFS_BTNUM_CNT tree and hence leak it.

Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_alloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1086,6 +1086,7 @@ restart:
 			goto restart;
 		}
 
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
