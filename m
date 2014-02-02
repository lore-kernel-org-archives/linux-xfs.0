Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C4487F61
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:56:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2DC8AC001
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:56:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	onZHD4cGqQtAtOsO for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:56:15 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WA6tU-0005p4-SE
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WA6tU-0003N3-RA
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs/199: enforce v4 superblock format for test
Date: Mon,  3 Feb 2014 10:56:02 +1100
Message-Id: <1391385365-12790-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1391385365-12790-1-git-send-email-david@fromorbit.com>
References: <1391385365-12790-1-git-send-email-david@fromorbit.com>
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

This test relies of the contents of the sb_features2 field being
known. Make sure ot clear allt eh MKFS_OPTIONS and ensure that we
direct mkfs to create only the simplest of featuresets to test this
functionality.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/199 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/199 b/tests/xfs/199
index 1d64e02..c1b5962 100755
--- a/tests/xfs/199
+++ b/tests/xfs/199
@@ -49,7 +49,10 @@ _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs -l lazy-count=1 >/dev/null 2>&1
+# clear any mkfs options so taht we can directly specify the options we need to
+# be able to test the features bitmask behaviour correctly.
+MKFS_OPTIONS=
+_scratch_mkfs_xfs -l lazy-count=1 -i projid32bit=0 >/dev/null 2>&1
 
 #
 # Print the current flags.  Just a dummy so that the test breaks
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
