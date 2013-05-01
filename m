Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 731847F76
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:32:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5143E304067
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:32:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sCF8fBItAn0qZuCm for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:32:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXSSL-000876-Jl
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXSSL-0000fh-Gj
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfstests: filter EA paths used by dump
Date: Wed,  1 May 2013 18:32:01 +1000
Message-Id: <1367397123-2530-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1367397123-2530-1-git-send-email-david@fromorbit.com>
References: <1367397123-2530-1-git-send-email-david@fromorbit.com>
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

Test 063 fails because the diff output now has entire paths to the
files in the results directory in it rather than just the file name.
Add the results directory to the directory filter used by the dump
tests to remove the path from the diff output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/dump |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/common/dump b/common/dump
index 73d0304..7fe50f6 100644
--- a/common/dump
+++ b/common/dump
@@ -927,6 +927,7 @@ _dir_filter()
     -e "s#$restore_sdir#RESTORE_SUBDIR#g" \
     -e "s#$$#PID#g" \
     -e "/Only in SCRATCH_MNT: .use_space/d" \
+    -e "s#$RESULT_DIR/##g" \
 
 }
 
@@ -1358,7 +1359,7 @@ _diff_compare_eas()
     | sed -e "s#$restore_sdir\/##" \
     | tee $seqres.ea2 \
     | _dir_filter
-    diff -s $seqres.ea1 $seqres.ea2
+    diff -s $seqres.ea1 $seqres.ea2 | _dir_filter
 }
 
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
