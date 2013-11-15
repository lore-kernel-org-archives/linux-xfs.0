Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D3287F81
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:35:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5893B8F8052
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:35:56 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ECAWLcI7nDQaSaQ2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:35:55 -0800 (PST)
Message-ID: <5285A483.3040009@oracle.com>
Date: Fri, 15 Nov 2013 12:35:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 6/6] jfs: simplify lmLogSync() via list_last_entry_or_null()
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

Simplify the code in lmLogSync() via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/jfs/jfs_logmgr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 7b565d0..2f90779 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -963,13 +963,9 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
 
 	if (log->sync == log->syncpt) {
 		LOGSYNC_LOCK(log, flags);
-		if (list_empty(&log->synclist))
-			log->sync = log->lsn;
-		else {
-			lp = list_entry(log->synclist.next,
-					struct logsyncblk, synclist);
-			log->sync = lp->lsn;
-		}
+		lp = list_last_entry_or_null(&log->synclist, struct logsyncblk,
+					     synclist);
+		log->sync = lp ? lp->lsn : log->lsn;
 		LOGSYNC_UNLOCK(log, flags);
 
 	}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
