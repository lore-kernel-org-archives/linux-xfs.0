Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC3877F5D
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 683A5AC00C
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ItlD1MeG9nmgTHNR for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:59 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkW9-0003vo-Hs
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVy-0001Lt-VH
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/48] xfs_repair: always use incore header for directory
	block checks
Date: Fri,  7 Jun 2013 10:25:54 +1000
Message-Id: <1370564771-4929-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Otherwise we get failures to validate the block on CRC enabled
filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 09052cc..6976d0c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1849,7 +1849,7 @@ longform_dir2_check_leaf(
 	if (!(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
 	      leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) ||
 				leafhdr.forw || leafhdr.back ||
-				leafhdr.count < leaf->hdr.stale ||
+				leafhdr.count < leafhdr.stale ||
 				leafhdr.count >
 					xfs_dir3_max_leaf_ents(mp, leaf) ||
 				(char *)&ents[leafhdr.count] > (char *)bestsp) {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
