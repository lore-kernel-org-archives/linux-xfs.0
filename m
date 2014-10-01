Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D38C7F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:18:16 -0500 (CDT)
Received: from dhcp-128-162-232-226.americas.sgi.com
	(dhcp-128-162-232-226.americas.sgi.com [128.162.232.226])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0509AC001
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:18:15 -0700 (PDT)
Received: from dhcp-128-162-232-226.americas.sgi.com (localhost [127.0.0.1])
	by dhcp-128-162-232-226.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s91LIIGS003059
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 16:18:18 -0500 (CDT)
	(envelope-from tinguely@dhcp-128-162-232-226.americas.sgi.com)
Message-Id: <20141001191803.153063401@sgi.com>
Date: Wed, 01 Oct 2014 16:18:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix the xfs_iflush_done callback search
Content-Disposition: inline;
	filename=xfs-fix-xfs_iflush_done-callback-search.patch
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

Commit "xfs: remove all the inodes on a buffer from the AIL in bulk"
made the xfs inode flush callback more efficient by combining all
the inode writes on the buffer and the deletions of the inode log
item from AIL.

The initial loop in this patch should be looping through all
the log items on the buffer to see which items have
xfs_iflush_done as their callback function. But currently,
only the log item passed to the function has its callback
compared to xfs_iflush_done. If the log item pointer passed to
the function does have the xfs_iflush_done callback function,
then all the log items on the buffer are removed from the
li_bio_list on the buffer b_fspriv and could be removed from
the AIL eventhough they may have not been written yet.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_inode_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_inode_item.c
===================================================================
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -615,7 +615,7 @@ xfs_iflush_done(
 	blip = bp->b_fspriv;
 	prev = NULL;
 	while (blip != NULL) {
-		if (lip->li_cb != xfs_iflush_done) {
+		if (blip->li_cb != xfs_iflush_done) {
 			prev = blip;
 			blip = blip->li_bio_list;
 			continue;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
