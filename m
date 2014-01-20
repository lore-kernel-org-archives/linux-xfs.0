Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED04F7F57
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1D4A8F8040
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bbSwHqfTbDqBRnJw for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:47 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Ku-No
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004UO-Mv
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] generic/204: use fixed log size for XFS
Date: Mon, 20 Jan 2014 17:22:37 +1100
Message-Id: <1390198957-17184-8-git-send-email-david@fromorbit.com>
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

In changing the default log sizes in mkfs, the freespace
calculations in generic/204 are no longer valid and so it fails with
ENOSPC before ti has finished creating the necessary files.. Make
the test use a fixed log size of 5MB for XFS so that freespace
calculations remain valid and the test passes regardless of whether
we have a new or old mkfs binary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/204 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/generic/204 b/tests/generic/204
index 598b805..13a762a 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -51,6 +51,10 @@ rm -f $seqres.full
 _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 . $tmp.mkfs
 
+# For xfs, we need to handle the different default log sizes that different
+# versions of mkfs create. All should be valid with a 5MB log, so use that.
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=5m"
+
 SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
 		| _filter_mkfs 2> $tmp.mkfs > /dev/null
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
