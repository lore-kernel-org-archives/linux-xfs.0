Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22JFnDv122429 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:15:50 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TCFZEWZZKz693sww for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 11:15:48 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [xfstests patch] 113: add testing for O_DIRECT + O_SYNC
Date: Fri, 02 Mar 2012 14:15:46 -0500
Message-ID: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Hi,

This patch adds a couple more aio-stress runs to test 113.  The first
simply adds -S, to test out AIO+DIO+O_SYNC.  The second adds -S and -o
2, which directs aio-stress to only perform the random write test.
These two tests helped identify several bugs in ext4.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/113 b/113
index 23676e0..b2ec510 100755
--- a/113
+++ b/113
@@ -100,4 +100,10 @@ _do_test 2 "-s 10m" $count $procs
 # as above, but now using direct IO
 _do_test 3 "-s 10m -O" $count $procs
 
+# dio with O_SYNC and unwritten extent conversion
+_do_test 4 "-s 10m -O -S" $count $procs
+
+# random dio writes with O_SYNC and unwritten extent conversion
+_do_test 5 "-s 10m -O -S -o 2" $count $procs
+
 exit
diff --git a/113.out b/113.out
index 1f3b866..aa856a6 100644
--- a/113.out
+++ b/113.out
@@ -12,3 +12,11 @@ aio-stress.2 : -t 20 -s 10m
 -----------------------------------------------
 aio-stress.3 : -t 20 -s 10m -O
 -----------------------------------------------
+
+-----------------------------------------------
+aio-stress.4 : -t 20 -s 10m -O -S
+-----------------------------------------------
+
+-----------------------------------------------
+aio-stress.5 : -t 20 -s 10m -O -S -o 2
+-----------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
