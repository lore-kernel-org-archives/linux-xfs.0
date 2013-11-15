Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 545057F72
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:34:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAD79AC00C
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:34:34 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id g90QzApYxXYSspVr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:34:33 -0800 (PST)
Message-ID: <5285A434.2080608@oracle.com>
Date: Fri, 15 Nov 2013 12:33:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 4/6] ubifs: simplify drop_last_node() via
	list_last_entry_or_null()
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

Simplify the code in drop_last_node() via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ubifs/recovery.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 065096e..e46c394 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -603,12 +603,10 @@ static void drop_last_group(struct ubifs_scan_leb *sleb, int *offs)
  */
 static void drop_last_node(struct ubifs_scan_leb *sleb, int *offs)
 {
-	struct ubifs_scan_node *snod;
-
-	if (!list_empty(&sleb->nodes)) {
-		snod = list_entry(sleb->nodes.prev, struct ubifs_scan_node,
-				  list);
+	struct ubifs_scan_node *snod = list_last_entry_or_null(&sleb->nodes,
+				       struct ubifs_scan_node, list);
 
+	if (snod) {
 		dbg_rcvry("dropping last node at %d:%d",
 			  sleb->lnum, snod->offs);
 		*offs = snod->offs;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
