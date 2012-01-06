Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06Kq1Jw039885 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 14:52:02 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: fix restore of ext attrs on root directory
Date: Fri,  6 Jan 2012 14:51:56 -0600
Message-Id: <1325883116-21990-1-git-send-email-wkendall@sgi.com>
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

xfsrestore fails to restore extended attributes on the root directory
because Node2path(), which returns a pathname relative to the restore
root, returns an empty string instead of ".".

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 restore/tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index afe7042..bb5df06 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -3450,7 +3450,7 @@ static bool_t
 Node2path( nh_t nh, char *path, char *errmsg )
 {
 	intgen_t remainingcnt;
-	path[ 0 ] = 0; /* in case root node passed in */
+	strcpy(path, "."); /* in case root node passed in */
 	remainingcnt = Node2path_recurse( nh, path, MAXPATHLEN, 0 );
 	if ( remainingcnt <= 0 ) {
 		node_t *np = Node_map( nh );
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
