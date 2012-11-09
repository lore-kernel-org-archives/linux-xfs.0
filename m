Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9718gT083072 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 01:01:08 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tH192G6XHV2uskpE for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:03:04 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWicF-0006Ap-W8
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:03:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWicF-0003oE-SA
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 18:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs_db: flush devices before exiting
Date: Fri,  9 Nov 2012 18:02:57 +1100
Message-Id: <1352444578-14600-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1352444578-14600-1-git-send-email-david@fromorbit.com>
References: <1352444578-14600-1-git-send-email-david@fromorbit.com>
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

Test 287 uses xfs_db to change 32-bit project ID support while the
filesystem is unmounted. On a large filesystem the test was failing
due to the mount not seeing the feature bit in the superblock.

xfs_db uses a different address space to the filesystem when it is
mounte dby the kernel, so the only way to keep them coherent is to
ensure that all buffered data is written to disk before the other
entity tries to read it. xfs_db uses buffered IO, but does not close
the devices when it exits, thereby leaving changes it has written in
the block device cache rather than on disk. Hence when th ekernel
tries to mount the filesystem, it reads what is on disk and does not
see xfs_db's changes.

Fix this by ensuring that xfs_db flushes it's changes to disk before
it exits by caling libxfs_device_close(). This fsyncs the data and
flushes the caches to ensure that it is present on disk before
xfs_db exits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/db/init.c b/db/init.c
index 2a5ef2b..2a31cb8 100644
--- a/db/init.c
+++ b/db/init.c
@@ -170,7 +170,7 @@ main(
 	}
 	if (cmdline) {
 		xfree(cmdline);
-		return exitcode;
+		goto close_devices;
 	}
 
 	while (!done) {
@@ -181,5 +181,13 @@ main(
 			done = command(c, v);
 		doneline(input, v);
 	}
+
+close_devices:
+	if (x.ddev)
+		libxfs_device_close(x.ddev);
+	if (x.logdev && x.logdev != x.ddev)
+		libxfs_device_close(x.logdev);
+	if (x.rtdev)
+		libxfs_device_close(x.rtdev);
 	return exitcode;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
