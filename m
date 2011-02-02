Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p12FY9bd041917 for <xfs@oss.sgi.com>; Wed, 2 Feb 2011 09:34:10 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6502D2A51AC
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 07:36:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PGKzhCIJzGLVC9Ih for
	<xfs@oss.sgi.com>; Wed, 02 Feb 2011 07:36:38 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] 089: fix error caused by weird stdout buffer handling
Date: Wed,  2 Feb 2011 16:36:06 +0100
Message-Id: <1296660966-691-1-git-send-email-lczerner@redhat.com>
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
Cc: hch@infradead.org, lczerner@redhat.com, esandeen@redhat.com

We have hit the error while running 089.

FSTYP         -- ext3
PLATFORM      -- Linux/x86_64 localhost 2.6.32-109.el6.x86_64

089 4s ... - output mismatch (see 089.out.bad)
--- 089.out     2011-02-01 13:32:13.350865206 -0500
+++ 089.out.bad 2011-02-01 15:46:50.998864578 -0500
@@ -43,7 +43,6 @@
 completed 50 iterations
 completed 50 iterations
 completed 50 iterations
-completed 50 iterations
 completed 10000 iterations
 directory entries:
 t_mtab
Ran: 089
Failures: 089
Failed 1 of 1 tests

This is not very easily reproducible, however one can hit it
eventually when running 089 in the loop. The problem is apparently, that
the output might get lost, probably due to some stdio buffer weirdness.

This commit workaround the issue by adding an optional argument to the
t_mtab to specify output file. The t_mtab output is then appended to a
file which content is then printed to the stdout as it would if no
output file is used.

With this commit applied the problem is no longer reproducible.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 089          |    9 ++++++---
 src/t_mtab.c |    8 +++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/089 b/089
index e28e099..1714bec 100755
--- a/089
+++ b/089
@@ -28,6 +28,7 @@ owner=nathans@sgi.com
 seq=`basename $0`
 echo "QA output created by $seq"
 
+mtab_output=$TEST_DIR/mtab_output
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
@@ -62,10 +63,12 @@ mount > t_mtab
 
 mtab()
 {
-	$here/src/t_mtab 50 &
-	$here/src/t_mtab 50 &
-	$here/src/t_mtab 50 &
+	rm -f $mtab_output
+	$here/src/t_mtab 50 $mtab_output &
+	$here/src/t_mtab 50 $mtab_output &
+	$here/src/t_mtab 50 $mtab_output &
 	wait
+	cat $mtab_output
 
 	$here/src/t_mtab 10000
 
diff --git a/src/t_mtab.c b/src/t_mtab.c
index 2931887..9bca954 100644
--- a/src/t_mtab.c
+++ b/src/t_mtab.c
@@ -263,6 +263,7 @@ update_mtab (void)
 int main(int argc, char **argv)
 {
 	int i, stop = 100000;
+	FILE *fout = NULL;
 
 	if (argc > 1)
 		stop = atoi(argv[1]);
@@ -270,6 +271,11 @@ int main(int argc, char **argv)
 	for (i = 0; i < stop; i++) {
 		update_mtab();
 	}
-	printf("completed %d iterations\n", stop);
+
+	if (argc > 2)
+		fout = fopen(argv[2],"a");
+	if (!fout)
+		fout = stdout;
+	fprintf(fout, "completed %d iterations\n", stop);
 	return 0;
 }
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
