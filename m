Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DC5C29DFB
	for <xfs@oss.sgi.com>; Sat, 21 Sep 2013 17:02:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4BA8C8F804B
	for <xfs@oss.sgi.com>; Sat, 21 Sep 2013 15:02:56 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	DNX6HLRAzW7wddO1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Sep 2013 15:02:51 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id x19so1126082qcw.2
	for <xfs@oss.sgi.com>; Sat, 21 Sep 2013 15:02:50 -0700 (PDT)
Date: Sat, 21 Sep 2013 18:02:47 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH V2] xfstests: only run generic/300 on filesystems supporting
	fallocate()
Message-ID: <20130921220247.GE7855@wallace>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

Generic/300 fails when run on a test filesystem that does not support
fallocate(), as in the case of an ext4 filesystem created without the
extent feature or with the bigalloc feature.  It uses fio's falloc
ioengine to generate part of its I/O load, and both fallocates blocks
and punches holes.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for both block allocation and hole punching
capabilities.  We need to use both _require_xfs_io_falloc and
_require_xfs_io_falloc_punch because the latter does not currently
test for block allocation support.  Also, delete any pre-existing test
output to avoid confusion with old results.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..1bb2837 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -44,6 +44,17 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
+# For this test, the test system's glibc and kernel and the test file system
+# must support both fallocating and hole punching.  We don't need xfs_io to
+# perform the test, but we can use it to verify these preconditions.  For now,
+# this allows us to avoid duplicating the following functions for fio or other
+# applications that might be used to generate I/O at the cost of picking up a
+# minor dependency on xfsprogs.
+_require_xfs_io_falloc
+_require_xfs_io_falloc_punch
+
+rm -f $seqres.full
+
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
-- 
1.8.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
