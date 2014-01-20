Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44F8F7F57
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39885304043
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lkcFUYL0v7jTSMyn for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Ko-Lx
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004U9-L9
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs/073, 208: remove .full output before starting the test
Date: Mon, 20 Jan 2014 17:22:34 +1100
Message-Id: <1390198957-17184-5-git-send-email-david@fromorbit.com>
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

Otherwise we end up with an ever-growing file for every test that is
run and that makes it hard to isolate failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/208 | 2 ++
 tests/xfs/073     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tests/generic/208 b/tests/generic/208
index badd522..58d1d08 100755
--- a/tests/generic/208
+++ b/tests/generic/208
@@ -45,6 +45,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+rm -f $seqres.full
+
 _run_aiodio aio-dio-invalidate-failure
 
 exit $status
diff --git a/tests/xfs/073 b/tests/xfs/073
index 4280fa9..ca553ae 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -133,6 +133,8 @@ _supported_os Linux
 _require_scratch
 _require_loop
 
+rm -f $seqres.full
+
 _scratch_mkfs_xfs -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
