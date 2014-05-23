Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AF3F7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 22:44:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42FEA8F8049
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 20:44:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7PV0FzACfZ2qJQoJ for
	<xfs@oss.sgi.com>; Thu, 22 May 2014 20:43:57 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfs/005: filter _scratch_mount output to match golden image
Date: Fri, 23 May 2014 11:43:23 +0800
Message-Id: <1400816603-2263-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Failure message of mount has been changed since util-linux v2.21, to
something like:

mount: mount /dev/sda5 on /mnt/scratch failed: Structure needs cleaning

Filter the output to match the golden image for newer mount binary so
that both old and new version of mount work correctly.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2: filter the mount error message instead of changing the golden image

 tests/xfs/005 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/005 b/tests/xfs/005
index 94157c4..509ac61 100755
--- a/tests/xfs/005
+++ b/tests/xfs/005
@@ -40,6 +40,11 @@ _cleanup()
     rm -f $tmp.*
 }
 
+filter_mount()
+{
+	sed -e "s/mount .* failed: //"
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -59,7 +64,7 @@ _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
 $XFS_IO_PROG -c "pwrite 224 4" $SCRATCH_DEV | _filter_xfs_io
 
 # should FAIL, the crc is bad; golden output contains mount failure
-_scratch_mount
+_scratch_mount 2>&1 | filter_mount
 
 # success, all done
 status=0
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
