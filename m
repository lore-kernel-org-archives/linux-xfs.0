Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08AAA7F55
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 19:15:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B6C6AC006
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:15:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cQLy6lNdaIATPDQW for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 17:15:02 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGeGn-0002J8-Fx
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGeGn-0001zB-FC
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfstests: generic/204 should call _check_scratch_fs
Date: Tue,  3 Sep 2013 10:14:53 +1000
Message-Id: <1378167295-7566-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378167295-7566-1-git-send-email-david@fromorbit.com>
References: <1378167295-7566-1-git-send-email-david@fromorbit.com>
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

Because if it corrupts the filesystem it currently goes undetected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/204 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/generic/204 b/tests/generic/204
index 62bd248..98cb176 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -52,6 +52,8 @@ for i in `seq 1 22500`; do
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
 done
 
+_check_scratch_fs
+
 # success, all done
 echo "*** done"
 rm -f $seqres.full
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
