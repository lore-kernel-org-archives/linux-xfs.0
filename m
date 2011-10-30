Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9U2QaEk230784 for <xfs@oss.sgi.com>; Sat, 29 Oct 2011 21:26:36 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80EBE20F786
	for <xfs@oss.sgi.com>; Sat, 29 Oct 2011 19:26:35 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	gtzGreTkC7Cl98wo for <xfs@oss.sgi.com>;
	Sat, 29 Oct 2011 19:26:35 -0700 (PDT)
Received: by vcbfk14 with SMTP id fk14so4783917vcb.26
	for <xfs@oss.sgi.com>; Sat, 29 Oct 2011 19:26:34 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfstests: 075 112 redirect stderr of fsx to /dev/null too
Date: Sun, 30 Oct 2011 10:25:55 +0800
Message-Id: <1319941555-4405-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>

In commit c18bf42de9d5d5fa05025754df1ff63f2147bd12 a warning message
will be printed to stderr if filesystem doesn't support fallocate(2).
The warning message will fail these tests though fsx returns SUCCESS.

	FSTYP         -- ext3
	PLATFORM      -- Linux/i686 debian-dev 3.1.0+
	MKFS_OPTIONS  -- /dev/sda3
	MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda3 /mnt/sda3

	075 12s ... - output mismatch (see 075.out.bad)
	--- 075.out     2011-10-28 21:35:41.872573530 +0800
	+++ 075.out.bad 2011-10-30 10:31:02.607058029 +0800
	@@ -4,6 +4,9 @@
	 -----------------------------------------------
	 fsx.0 : -d -N numops -S 0
	 -----------------------------------------------
	+fsx: main: filesystem does not support fallocate, disabling
	+: Operation not supported

So redirect stderr of fsx to /dev/null too.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 075 |    2 +-
 112 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/075 b/075
index 0f0a6ed..87d273f 100755
--- a/075
+++ b/075
@@ -77,7 +77,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P $here $seq.$_n >/dev/null
+    if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
     then
 	echo "    fsx ($_param) failed, $? - compare $seq.$_n.{good,bad,fsxlog}"
 	mv $out/$seq.$_n $here/$seq.$_n.full
diff --git a/112 b/112
index 557350a..763b17a 100755
--- a/112
+++ b/112
@@ -77,7 +77,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on $here (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P $here $seq.$_n >/dev/null
+    if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
     then
 	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
 	mv $seq.$_n.fsxlog $here/$seq.$_n.full
-- 
1.7.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
