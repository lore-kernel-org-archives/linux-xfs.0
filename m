Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 934847F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 02:02:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 677A08F8039
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:02:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MS4QrtoXcOwvAe4N for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 00:02:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WAxRW-0004Oj-1n
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:02:46 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WAxRW-0001KL-0R
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:02:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_db: fix attribute leaf output for ATTR3 format
Date: Wed,  5 Feb 2014 19:02:45 +1100
Message-Id: <1391587365-5066-1-git-send-email-david@fromorbit.com>
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

attr3_leaf_entries_count() checks against the wrong magic number.
hence returns zero for an entry count when it should be returning a
value. Fixing this makes xfs/021 pass on CRC enabled filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/attr.c b/db/attr.c
index 740d564..caa154e 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -170,7 +170,7 @@ attr3_leaf_entries_count(
 	struct xfs_attr3_leafblock *leaf = obj;
 
 	ASSERT(startoff == 0);
-	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR_LEAF_MAGIC)
+	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR3_LEAF_MAGIC)
 		return 0;
 	return be16_to_cpu(leaf->hdr.count);
 }
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
