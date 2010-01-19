Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J92LAh178229 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:02:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8084F1C5DD3E
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:03:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	GQqrJf40yFHIw2hx for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 01:03:19 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11529669-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:33:18 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9zZ-0003gH-IR
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:17 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9zY-00083z-PT
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfsqa: xfs_check can see stale cached blocks
Date: Tue, 19 Jan 2010 20:03:12 +1100
Message-Id: <1263891792-30952-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891792-30952-1-git-send-email-david@fromorbit.com>
References: <1263891792-30952-1-git-send-email-david@fromorbit.com>
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

Test 017 is consistently failing now because the xfs_check uses
buffered IO to read the block device and 017 runs xfs_check ona
remount,ro filesystem. Hence the block device cache is never
invalidated (the unmount path does this) and so xfs_check can see
stale blocks from previous invocations instead of what is really on
disk at the time it is run.

Manually trash the page cache before running xfs_check to ensure
that the blockdev cache is clean and we don't get false errors
from stale blocks.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 common.rc |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 6424871..896e38d 100644
--- a/common.rc
+++ b/common.rc
@@ -318,6 +318,7 @@ _scratch_xfs_check()
     SCRATCH_OPTIONS=""
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
+    [ "$HOSTOS" = "Linux" ] && echo 1 > /proc/sys/vm/drop_caches
     $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
@@ -931,6 +932,7 @@ _check_xfs_filesystem()
         ok=0
     fi
 
+    [ "$HOSTOS" = "Linux" ] && echo 1 > /proc/sys/vm/drop_caches
     $XFS_CHECK_PROG $testoption $extra_log_options $device 2>&1 |\
 	 _fix_malloc >$tmp.fs_check
     if [ -s $tmp.fs_check ]
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
