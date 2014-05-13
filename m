Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 739787F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:24:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AC0A3042B2
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:24:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pXTcMeFAIAFlXPUQ for
	<xfs@oss.sgi.com>; Tue, 13 May 2014 05:24:36 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4DCOZmu012349
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 13 May 2014 08:24:35 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4DCOZ5G012714
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 08:24:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: use killall -9 and wait in _cleanup() in xfs/013
Date: Tue, 13 May 2014 08:24:34 -0400
Message-Id: <1399983874-58985-1-git-send-email-bfoster@redhat.com>
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

Kill any lingering fsstress processes and wait properly should we abort
the test. This prevents the workload from inadvertently affecting
subsequent tests.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Dave,

Sorry, this probably should have been posted sooner. I was half
expecting to have more changes to the test. Looks like you fixed up the
groups already (thanks), so here's a small one to fix up the exit
path... Obviously it's not the end of the world if this waits for the
next natural xfstests update. :)

Brian

 tests/xfs/013 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/013 b/tests/xfs/013
index 049f0dc..e95d027 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -40,7 +40,8 @@ status=1	# failure is the default!
 
 _cleanup()
 {
-	killall fsstress 2>/dev/null
+	killall -9 fsstress 2>/dev/null
+	wait
 	cd /
 	umount $SCRATCH_MNT 2>/dev/null
 	rm -f $tmp.*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
