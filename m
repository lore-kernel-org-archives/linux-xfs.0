Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85E667F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 13:29:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D747AC005
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 11:29:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AXWyfeaXZ6xltIYB for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 11:28:51 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs/013: allow non-write fsstress operations in background
	workload
Date: Tue,  3 Jun 2014 14:28:49 -0400
Message-Id: <1401820129-6543-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

It has been reported that test xfs/013 probably uses more space than
necessary, exhausting space if run against a several GB sized ramdisk.
xfs/013 primarily creates, links and removes inodes. Most of the space
consumption occurs via the background fsstress workload.

Remove the fsstress -w option that suppresses non-write operations. This
slightly reduces the storage footprint while still providing a
background workload for the test.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Dave,

I was able to squeeze an xfs/013 run into a 3GB ramdisk on my VM with
this tweak. Let me know if this works for you. If not, we could probably
start turning off some of the heavier allocating fsstress ops so long as
the cost isn't too much. I'm measuring the effectiveness of this test
via the fibt stats exported to /proc.

Brian

 tests/xfs/013 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/013 b/tests/xfs/013
index e95d027..d47bf53 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -121,7 +121,7 @@ _create $SCRATCH_MNT/dir1 $COUNT
 _cleaner $SCRATCH_MNT $LOOPS $MINDIRS &
 
 # start a background stress workload on the fs
-$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -w -n 9999999 -p 2 -S t \
+$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 9999999 -p 2 -S t \
 	>> $seqres.full 2>&1 &
 
 # Each cycle clones the current directory and makes a random file replacement
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
