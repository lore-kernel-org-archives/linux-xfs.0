Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9081F7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:53:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13E22AC003
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 23:53:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tW6GB4GwmhbAj6fR for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 23:53:11 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeJxz-0006qs-Jz
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:07 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeJxz-0006Vj-G7
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs_repair: always use incore header for directory block
	checks
Date: Mon, 20 May 2013 16:52:58 +1000
Message-Id: <1369032783-24973-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1369032783-24973-1-git-send-email-david@fromorbit.com>
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
