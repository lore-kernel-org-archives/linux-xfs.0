Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 903807F58
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29EA5AC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DcZ9OdoEiA0ZX97Q for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bm-9t
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007sC-8u
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] repair: use a listhead for the dotdot list
Date: Thu, 27 Feb 2014 20:51:10 +1100
Message-Id: <1393494675-30194-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494675-30194-1-git-send-email-david@fromorbit.com>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Cleanup suggested by Christoph Hellwig - removes another open coded
list implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index cdbf4db..7be68b3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -43,13 +43,13 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
  * entries are updated. These must be rebuilt after the initial pass
  */
 typedef struct dotdot_update {
-	struct dotdot_update	*next;
+	struct list_head	list;
 	ino_tree_node_t		*irec;
 	xfs_agnumber_t		agno;
 	int			ino_offset;
 } dotdot_update_t;
 
-static dotdot_update_t		*dotdot_update_list;
+static LIST_HEAD(dotdot_update_list);
 static int			dotdot_update;
 
 static void
@@ -64,12 +64,12 @@ add_dotdot_update(
 		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
 			sizeof(dotdot_update_t));
 
-	dir->next = dotdot_update_list;
+	INIT_LIST_HEAD(&dir->list);
 	dir->irec = irec;
 	dir->agno = agno;
 	dir->ino_offset = ino_offset;
 
-	dotdot_update_list = dir;
+	list_add(&dir->list, &dotdot_update_list);
 }
 
 /*
@@ -3021,9 +3021,10 @@ update_missing_dotdot_entries(
 	 * set dotdot_update flag so processing routines do not count links
 	 */
 	dotdot_update = 1;
-	while (dotdot_update_list) {
-		dir = dotdot_update_list;
-		dotdot_update_list = dir->next;
+	while (!list_empty(&dotdot_update_list)) {
+		dir = list_entry(dotdot_update_list.prev, struct dotdot_update,
+				 list);
+		list_del(&dir->list);
 		process_dir_inode(mp, dir->agno, dir->irec, dir->ino_offset);
 		free(dir);
 	}
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
