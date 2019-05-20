Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57858 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfETWdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:33:12 -0400
Subject: [PATCH 2/3] generic/530,
 xfs/501: pass fs shutdown handle to t_open_tmpfiles
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 15:31:04 -0700
Message-ID: <155839146420.62682.1995545484813176181.stgit@magnolia>
In-Reply-To: <155839145160.62682.10916303376882370723.stgit@magnolia>
References: <155839145160.62682.10916303376882370723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com, amir73il@gmail.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

So it turns out that overlayfs can't pass FS_IOC_SHUTDOWN to the lower
filesystems and so xfstests works around this by creating shutdown
helpers for the scratch fs to direct the shutdown ioctl to wherever it
needs to go to shut down the filesystem -- SCRATCH_MNT on normal
filesystems and OVL_BASE_SCRATCH_MNT when -overlay is enabled.  This
means that t_open_tmpfiles cannot simply use one of the open tempfiles
to shut down the filesystem.

Commit f8f57747222 tried to "fix" this by ripping the shutdown code out,
but this made the tests useless.  Fix this instead by creating a
xfstests helper to return a path that can be used to shut down the
filesystem and then pass that path to t_open_tmpfiles so that we can
shut down the filesystem when overlayfs is enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |   11 +++++++++++
 src/t_open_tmpfiles.c |   20 +++++++++++++-------
 tests/generic/530     |    2 +-
 tests/xfs/501         |    2 +-
 4 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/common/rc b/common/rc
index 27c8bb7a..f577e5e3 100644
--- a/common/rc
+++ b/common/rc
@@ -393,6 +393,17 @@ _scratch_shutdown()
 	fi
 }
 
+# Return a file path that can be used to shut down the scratch filesystem.
+# Caller should _require_scratch_shutdown before using this.
+_scratch_shutdown_handle()
+{
+	if [ $FSTYP = "overlay" ]; then
+		echo $OVL_BASE_SCRATCH_MNT
+	else
+		echo $SCRATCH_MNT
+	fi
+}
+
 _test_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
index da9390fd..258b0c95 100644
--- a/src/t_open_tmpfiles.c
+++ b/src/t_open_tmpfiles.c
@@ -24,7 +24,7 @@ static int min_fd = -1;
 static int max_fd = -1;
 static unsigned int nr_opened = 0;
 static float start_time;
-static int shutdown_fs = 0;
+static int shutdown_fd = -1;
 
 void clock_time(float *time)
 {
@@ -69,7 +69,7 @@ void die(void)
 				end_time - start_time);
 		fflush(stdout);
 
-		if (shutdown_fs) {
+		if (shutdown_fd >= 0) {
 			/*
 			 * Flush the log so that we have to process the
 			 * unlinked inodes the next time we mount.
@@ -77,7 +77,7 @@ void die(void)
 			int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 			int ret;
 
-			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
+			ret = ioctl(shutdown_fd, XFS_IOC_GOINGDOWN, &flag);
 			if (ret) {
 				perror("shutdown");
 				exit(2);
@@ -148,8 +148,9 @@ void leak_tmpfile(void)
 
 /*
  * Try to put as many files on the unlinked list and then kill them.
- * The first argument is a directory to chdir into; passing any second arg
- * will shut down the fs instead of closing files.
+ * The first argument is a directory to chdir into; the second argumennt (if
+ * provided) is a file path that will be opened and then used to shut down the
+ * fs before the program exits.
  */
 int main(int argc, char *argv[])
 {
@@ -160,8 +161,13 @@ int main(int argc, char *argv[])
 		if (ret)
 			perror(argv[1]);
 	}
-	if (argc > 2 && !strcmp(argv[2], "shutdown"))
-		shutdown_fs = 1;
+	if (argc > 2) {
+		shutdown_fd = open(argv[2], O_RDONLY);
+		if (shutdown_fd < 0) {
+			perror(argv[2]);
+			return 1;
+		}
+	}
 
 	clock_time(&start_time);
 	while (1)
diff --git a/tests/generic/530 b/tests/generic/530
index b0d188b1..cb874ace 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -49,7 +49,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
+$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full
diff --git a/tests/xfs/501 b/tests/xfs/501
index 974f3414..4be03b31 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -54,7 +54,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
+$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full
