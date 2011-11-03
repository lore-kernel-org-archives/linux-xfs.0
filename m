Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPXsL017913 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:33 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D60F512FF48D
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:32 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 1921OvEOg0Gpjonm
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:32 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1398030bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:32 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 02/12] xfstests: add different logging option to fsstress
Date: Thu,  3 Nov 2011 18:24:51 +0400
Message-Id: <1320330301-2682-3-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

Currently the only way to log fsstress's output is to redirect it's shared
stdout to pipe which is very painfull because:

1) Pipe writers are serialized via i_mutex so we waste cpu-cores power on stupid
   sinchronization for loging purpose, instead of hunting real race conditions,
   and bugs inside file system.
2) Usually output is corrupted due to luck of sychronization on shared stdout.

Since fsstress's children operate on independend paths, let's just open didicated
log file for each child and simply avoid useless sycnhronization.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51ecda2..c7001f3 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -258,6 +258,8 @@ int main(int argc, char **argv)
 	char		buf[10];
 	int		c;
 	char		*dirname = NULL;
+	char		*logname = NULL;
+	char		rpath[PATH_MAX];
 	int		fd;
 	int		i;
 	int		j;
@@ -273,7 +275,7 @@ int main(int argc, char **argv)
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, "d:e:f:i:m:n:p:rs:vwzHS")) != -1) {
+	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:vwzHS")) != -1) {
 		switch (c) {
 		case 'd':
 			dirname = optarg;
@@ -311,6 +313,10 @@ int main(int argc, char **argv)
 		case 'n':
 			operations = atoi(optarg);
 			break;
+		case 'o':
+			logname = optarg;
+			break;
+
 		case 'p':
 			nproc = atoi(optarg);
 			break;
@@ -351,10 +357,26 @@ int main(int argc, char **argv)
         }
 
 	(void)mkdir(dirname, 0777);
+	if (logname && logname[0] != '/') {
+		if (getcwd(rpath, sizeof(rpath)) < 0){
+			perror("getcwd failed");
+			exit(1);
+		}
+	} else {
+		rpath[0] = '\0';
+	}
 	if (chdir(dirname) < 0) {
 		perror(dirname);
 		exit(1);
 	}
+	if (logname) {
+		char path[PATH_MAX];
+		snprintf(path, sizeof(path), "%s/%s", rpath, logname);
+		if (freopen(path, "a", stdout) == NULL) {
+			perror("freopen logfile failed");
+			exit(1);
+		}
+	}
 	sprintf(buf, "fss%x", (unsigned int)getpid());
 	fd = creat(buf, 0666);
 	if (lseek64(fd, (off64_t)(MAXFSIZE32 + 1ULL), SEEK_SET) < 0)
@@ -409,6 +431,15 @@ int main(int argc, char **argv)
 		close(fd);
 	for (i = 0; i < nproc; i++) {
 		if (fork() == 0) {
+			if (logname) {
+				char path[PATH_MAX];
+				snprintf(path, sizeof(path), "%s/%s.%d",
+					 rpath, logname, i);
+				if (freopen(path, "a", stdout) == NULL) {
+					perror("freopen logfile failed");
+					exit(1);
+				}
+			}
 			procid = i;
 			doproc();
 			return 0;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
