Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8eHAH001489 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:17 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MkT7WmQB8tRMk2Jb for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJc2-000141-3d
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJc1-0003v7-VP
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] xfstests: disable tests that typically fail on large
	filesystems
Date: Thu, 26 Jul 2012 18:39:48 +1000
Message-Id: <1343291989-14987-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Test 017 typically fails due to the OOM killer kicking in and
killing everything but xfs_db so panics the machine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 017 |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/017 b/017
index 0a3ede3..b3a7f9c 100755
--- a/017
+++ b/017
@@ -48,6 +48,10 @@ _supported_os Linux
 
 _require_scratch
 
+# xfs_db will OOM kill the machine if you don't have huge amounts of RAM, so
+# don't run this on large filesystems.
+_require_no_large_scratch_dev
+
 echo "*** init FS"
 
 rm -f $seq.full
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
