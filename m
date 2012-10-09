Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99CFTG2028580 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 07:15:29 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2ntOcSurlOvUYfYI for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 05:16:59 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] 260: Add another corner case where length is zero
Date: Tue,  9 Oct 2012 14:16:52 +0200
Message-Id: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

This commit adds another corner case to test FITRIM argument handling.
In this case we set length to zero and we expect the number of discarded
bytes to be obviously zero, however we've had bug in both ext4 and xfs
where the internal variable would underflow. This test case will be able
to catch that in future.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 260 |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/260 b/260
index b005cd3..2ade9b3 100755
--- a/260
+++ b/260
@@ -98,6 +98,19 @@ _scratch_unmount
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
+# This should return zero
+out=$("$FSTRIM" -v -s0 -l0 $SCRATCH_MNT)
+bytes=${out%% *}
+if [ $bytes -ne 0 ]; then
+	status=1
+	echo "We requested zero bytes to be discarded, however $bytes bytes"\
+	     "were discarded instead. Length handling probably underflowed."
+fi
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
 # This is a bit fuzzy, but since the file system is fresh
 # there should be at least (fssize/2) free space to trim.
 # This is supposed to catch wrong FITRIM argument handling
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
