Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C10EC7F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 19:53:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 943238F8050
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 17:53:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nO1HszpgDKOKNRg8 for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 17:53:25 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WArfs-0003ml-2y
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 12:53:12 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WArfs-0006pO-1n
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 12:53:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs/296: fix golden output
Date: Wed,  5 Feb 2014 12:53:12 +1100
Message-Id: <1391565192-26213-1-git-send-email-david@fromorbit.com>
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

This test never passed, so the golden output was never properly
verified as correct. Now that the bug is fixed, fix the golden
output to match the actual test output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/296.out | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/296.out b/tests/xfs/296.out
index 1fb1b69..c279465 100644
--- a/tests/xfs/296.out
+++ b/tests/xfs/296.out
@@ -50,6 +50,7 @@ Checking for xattr on restored file
 user.name
 
 Checking for capability on restored file
-RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
+RESTORE_DIR/DUMP_SUBDIR/testfile = cap_setgid,cap_setuid+ep
 # file: RESTORE_DIR/DUMP_SUBDIR/testfile
 security.capability
+
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
