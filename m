Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NCAHU5128722 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 07:10:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71918178E0
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 05:10:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	X7LaMet5H4YJvIxz for <xfs@oss.sgi.com>;
	Mon, 23 Aug 2010 05:10:49 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	36266652-1927428
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 21:40:48 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OnVrS-0004Cd-Jm
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 22:10:46 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OnVrJ-0003cM-PQ
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 22:10:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: handle negative wbc->nr_to_write during sync writeback
Date: Mon, 23 Aug 2010 22:10:37 +1000
Message-Id: <1282565437-13880-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

During data integrity (WB_SYNC_ALL) writeback, wbc->nr_to_write will
go negative on inodes with more than 1024 dirty pages due to
implementation details of write_cache_pages(). Currently XFS will
abort page clustering in writeback once nr_to_write drops below
zero, and so for data integrity writeback we will do very
inefficient page at a time allocation and IO submission for inodes
with large numbers of dirty pages.

Fix this by only aborting the page clustering code when
wbc->nr_to_write is negative and the sync mode is WB_SYNC_NONE.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 15412fe..528be1b 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -852,8 +852,8 @@ xfs_convert_page(
 		SetPageUptodate(page);
 
 	if (count) {
-		wbc->nr_to_write--;
-		if (wbc->nr_to_write <= 0)
+		if (--wbc->nr_to_write <= 0 &&
+		    wbc->sync_mode == WB_SYNC_NONE)
 			done = 1;
 	}
 	xfs_start_page_writeback(page, !page_dirty, count);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
