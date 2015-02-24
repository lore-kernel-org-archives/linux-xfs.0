Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 316B07F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 01:12:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0EFF68F80C5
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 23:12:40 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NoYDrNVKBcP3zJXs for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 23:12:38 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YQ9fM-000333-7o
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 18:12:24 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YQ9fM-0000XP-6M
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 18:12:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: superblock buffers need to be sector sized
Date: Tue, 24 Feb 2015 18:12:24 +1100
Message-Id: <1424761944-2034-1-git-send-email-david@fromorbit.com>
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

In secondary_sb_wack() we zero the unused portion of both the
on-disk superblock and the in-memory copy that we have. When
the device sector size is 4k, this causes xfs_repair to crash like
so:

# xfs_repair /dev/ram1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
bad magic number
bad on-disk superblock 3 - bad magic number
primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
zeroing unused portion of secondary superblock (AG #3)
#

The stack trace is indicative:

#0  memset ()
#1  0x000000000040404b in secondary_sb_wack
#2  verify_set_agheader
#3  0x0000000000427b4b in scan_ag
#4  0x000000000042a2ca in worker_thread
#5  0x00007ffff77ba0a4 in start_thread
#6  0x00007ffff74efc2d in clone

Which points at memset overrunning the in memory buffer, as it is
only 512 bytes in length.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/scan.c b/repair/scan.c
index ce8d7f5..12aa782 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1485,7 +1485,7 @@ scan_ag(
 	int		status;
 	char		*objname = NULL;
 
-	sb = (struct xfs_sb *)calloc(BBSIZE, 1);
+	sb = (struct xfs_sb *)calloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), 1);
 	if (!sb) {
 		do_error(_("can't allocate memory for superblock\n"));
 		return;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
