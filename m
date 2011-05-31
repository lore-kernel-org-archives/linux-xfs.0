Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VELK1h048900 for <xfs@oss.sgi.com>; Tue, 31 May 2011 09:21:21 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D998490A44
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 07:21:19 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id KZ6D6pvVxzCWEJFM
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 07:21:19 -0700 (PDT)
Received: by wyi11 with SMTP id 11so3918298wyi.26
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 07:21:19 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 May 2011 17:21:19 +0300
Message-ID: <BANLkTimjBe5gmgObaG9j8SiD3mj9RxaSaw@mail.gmail.com>
Subject: [PATCH] fix hardcoded reference to /mnt/test in common.attr
From: Amir Goldstein <amir73il@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS <xfs@oss.sgi.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, sergey ivanov <sergey57@gmail.com>, Christoph Hellwig <hch@lst.de>

From: Amir Goldstein <amir73il@users.sf.net>

When trying to run test 70, we encountered several problems.
Sergey has strace'd some of the problems to attempts to
set xattr on the wrong test dir (/mnt/test/), which appears to be
hardcoded in common.attr.

Reported-by: Sergey Ivanov <sergey57@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 common.attr |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common.attr b/common.attr
index 343edfc..37d0927 100644
--- a/common.attr
+++ b/common.attr
@@ -163,7 +163,7 @@ _require_attrs()
     # stored on disk.
     #
     touch $TEST_DIR/syscalltest
-    attr -s "user.xfstests" -V "attr" /mnt/test/ >
$TEST_DIR/syscalltest.out 2>&1
+    attr -s "user.xfstests" -V "attr" $TEST_DIR >
$TEST_DIR/syscalltest.out 2>&1
     cat $TEST_DIR/syscalltest.out >> $here/$seq.full

     if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
