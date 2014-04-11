Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8C267F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 16:46:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 956F8AC003
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:46:29 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	6rsNhBB5XnfLktcw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 14:46:28 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id c9so6689886qcz.30
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:46:27 -0700 (PDT)
Date: Fri, 11 Apr 2014 17:46:23 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic: add fallocate() check to generic/311
Message-ID: <20140411214623.GD10174@wallace>
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

Generic/311 fails when run on a test filesystem that does not support
fallocate().  Its I/O load is produced by fsync-tester, which uses
fallocate() system calls to allocate blocks for some of its test cases.
This causes EOPNOTSUPP failures when the test is run on indirect
block-mapped ext4 filesystems.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for block allocation capabilities.  Also, fix a
minor error message typo.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/311 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 tests/generic/311

diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
index 6802a96..284b59d
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -57,7 +57,11 @@ _need_to_be_root
 _require_scratch
 _require_dm_flakey
 
-[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not build"
+# xfs_io is not required for this test, but it's the best way to verify
+# the test system supports fallocate() for allocation
+_require_xfs_io_falloc
+
+[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not built"
 
 rm -f $seqres.full
 SEED=1
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
