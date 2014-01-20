Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 984007F62
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B4BEAC005
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:47 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	peKX6hMLnkzQ07U0 for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:45 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Kr-NC
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004UJ-MJ
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs/104: use fixed log size
Date: Mon, 20 Jan 2014 17:22:36 +1100
Message-Id: <1390198957-17184-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

In changing the default log sizes in mkfs, the freespace
calculations in xfs/104 are no longer valid and so it fails with
ENOSPC before running any of the growfs tests. Make the test use a
fixed log size of 5MB so that freespace calculations remain valid
and the test passes regardless of whether we have a new or old mkfs
binary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/104 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/104 b/tests/xfs/104
index d31cf16..e899aca 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -84,7 +84,7 @@ nags=4
 size=`expr 120 \* 1048576`	# 120 megabytes initially
 sizeb=`expr $size / $dbsize`	# in data blocks
 echo "*** creating scratch filesystem"
-_create_scratch -dsize=${size} -dagcount=${nags}
+_create_scratch -lsize=5m -dsize=${size} -dagcount=${nags}
 
 fillsize=`expr 110 \* 1048576`	# 110 megabytes of filling
 echo "*** using some initial space on scratch filesystem"
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
