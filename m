Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JHrAqF074499 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 12:53:11 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF70F129FDEC
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 10:53:36 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id LgbX1WsRlHn4cGTY for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2009 10:53:36 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/3] Skip _check_test_fs unless a test is actually run
Date: Fri, 19 Jun 2009 13:53:31 -0400
Message-Id: <1245434013-9433-1-git-send-email-tytso@mit.edu>
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
Cc: tytso@mit.edu

Running _check_test_fs can take a non-trivial amount of time, and if a
test has been skipped because it doesn't work on Linux, or it doesn't
work of for ext4, it's pointless to re-run _check_test_fs.  So move
the call to _check_test_fs so it is only run if a test is actually run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 check |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/check b/check
index 545c010..1aae528 100755
--- a/check
+++ b/check
@@ -308,10 +308,10 @@ do
     then
 	try="$try $seq"
 	n_try=`expr $n_try + 1`
+        _check_test_fs
     fi
     
     seq="after_$seq"
-    _check_test_fs
 done
 
 interrupt=false
-- 
1.6.3.2.1.gb9f7d.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
