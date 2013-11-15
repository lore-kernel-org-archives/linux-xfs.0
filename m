Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9520B7F77
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:35:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38AB4AC00B
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:35:22 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cO5tUoPwuCPEOiyt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:35:21 -0800 (PST)
Message-ID: <5285A464.1070904@oracle.com>
Date: Fri, 15 Nov 2013 12:34:44 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 5/6] jfs: simplify lmNextPage() via list_last_entry_or_null()
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify the code in lmNextPage via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/jfs/jfs_logmgr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 360d27c..7b565d0 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -591,10 +591,7 @@ static int lmNextPage(struct jfs_log * log)
 	 *	write or queue the full page at the tail of write queue
 	 */
 	/* get the tail tblk on commit queue */
-	if (list_empty(&log->cqueue))
-		tblk = NULL;
-	else
-		tblk = list_entry(log->cqueue.prev, struct tblock, cqueue);
+	tblk = list_last_entry_or_null(&log->cqueue, struct tblock, cqueue);
 
 	/* every tblk who has COMMIT record on the current page,
 	 * and has not been committed, must be on commit queue
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
