Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFC5F7F58
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C72048F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	a5JUHoEhjYHThqaT for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:28 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Pv-Gx
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007pD-G2
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs/217: prevent enospc failures on small test devices
Date: Mon, 24 Feb 2014 14:06:14 +1100
Message-Id: <1393211175-30016-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1393211175-30016-1-git-send-email-david@fromorbit.com>
References: <1393211175-30016-1-git-send-email-david@fromorbit.com>
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

I'm running xfstests against a ramdisk, so I'm limited in size of
the test and scratch devices. While there are large enough to hold a
filesystem image with a 2GB log, the way the log changes position in
an image file as the size of the filesystem increases means that the
aggregated disk space of xfs/217 is more than enough to run a 4GB
TEST_DEV out of space and hence fail the test.

To avoid this problem, punch out the image file between every mkfs
iteration so that it only consumes the space needed by each
individual mkfs tests, not an aggregation of them all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/217 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/xfs/217 b/tests/xfs/217
index 6c439c0..ab55a30 100755
--- a/tests/xfs/217
+++ b/tests/xfs/217
@@ -63,6 +63,10 @@ _do_mkfs()
 		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
 		umount -d $LOOP_MNT > /dev/null 2>&1
+
+		# punch out the previous blocks so that we keep the amount of
+		# disk space the test requires down to a minimum.
+		$XFS_IO_PROG -f -c "unresvsp 0 16383g" $LOOP_DEV
 	done
 }
 # make large holey file
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
