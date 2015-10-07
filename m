Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CAB329E4E
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:05:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C73C304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:05:26 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KEhuBLIubf1NdDIB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:05:24 -0700 (PDT)
Subject: [PATCH 01/51] libxcmd: provide a common function to report command
	runtimes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:05:20 -0700
Message-ID: <20151007050520.1504.59073.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Refactor the open-coded runtime stats reporting into a library
command, then update xfs_io commands to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/command.h |    6 ++++++
 io/pread.c        |   16 +---------------
 io/pwrite.c       |   16 +---------------
 io/sendfile.c     |   16 +---------------
 libxcmd/command.c |   26 ++++++++++++++++++++++++++
 5 files changed, 35 insertions(+), 45 deletions(-)


diff --git a/include/command.h b/include/command.h
index 4869edf..51dae6a 100644
--- a/include/command.h
+++ b/include/command.h
@@ -18,6 +18,8 @@
 #ifndef __COMMAND_H__
 #define __COMMAND_H__
 
+#include <sys/time.h>
+
 #define CMD_FLAG_GLOBAL	((int)0x80000000)	/* don't iterate "args" */
 
 typedef int (*cfunc_t)(int argc, char **argv);
@@ -56,4 +58,8 @@ extern void		command_loop(void);
 extern int		command_usage(const cmdinfo_t *ci);
 extern int		command(const cmdinfo_t *ci, int argc, char **argv);
 
+extern void		report_io_times(struct timeval *t2, long long offset,
+				     long long count, long long total,
+				     int ops, int condensed);
+
 #endif	/* __COMMAND_H__ */
diff --git a/io/pread.c b/io/pread.c
index 1c77c41..66ea945 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -379,7 +379,6 @@ pread_f(
 	long long	count, total, tmp;
 	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
-	char		s1[64], s2[64], ts[64];
 	char		*sp;
 	int		Cflag, qflag, uflag, vflag;
 	int		eof = 0, direction = IO_FORWARD;
@@ -488,20 +487,7 @@ pread_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	/* Finally, report back -- -C gives a parsable format */
-	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
-	if (!Cflag) {
-		cvtstr((double)total, s1, sizeof(s1));
-		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
-		printf(_("read %lld/%lld bytes at offset %lld\n"),
-			total, count, (long long)offset);
-		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
-			s1, c, ts, s2, tdiv((double)c, t2));
-	} else {/* bytes,ops,time,bytes/sec,ops/sec */
-		printf("%lld,%d,%s,%.3f,%.3f\n",
-			total, c, ts,
-			tdiv((double)total, t2), tdiv((double)c, t2));
-	}
+	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
 	return 0;
 }
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 10f78e4..81f6abe 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -250,7 +250,6 @@ pwrite_f(
 	unsigned int	zeed = 0, seed = 0xcdcdcdcd;
 	size_t		fsblocksize, fssectsize;
 	struct timeval	t1, t2;
-	char		s1[64], s2[64], ts[64];
 	char		*sp, *infile = NULL;
 	int		Cflag, qflag, uflag, dflag, wflag, Wflag;
 	int		direction = IO_FORWARD;
@@ -385,20 +384,7 @@ pwrite_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	/* Finally, report back -- -C gives a parsable format */
-	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
-	if (!Cflag) {
-		cvtstr((double)total, s1, sizeof(s1));
-		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
-		printf(_("wrote %lld/%lld bytes at offset %lld\n"),
-			total, count, (long long)offset);
-		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
-			s1, c, ts, s2, tdiv((double)c, t2));
-	} else {/* bytes,ops,time,bytes/sec,ops/sec */
-		printf("%lld,%d,%s,%.3f,%.3f\n",
-			total, c, ts,
-			tdiv((double)total, t2), tdiv((double)c, t2));
-	}
+	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/io/sendfile.c b/io/sendfile.c
index 5c1638f..ced6369 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -81,7 +81,6 @@ sendfile_f(
 	long long	count, total;
 	size_t		blocksize, sectsize;
 	struct timeval	t1, t2;
-	char		s1[64], s2[64], ts[64];
 	char		*infile = NULL;
 	int		Cflag, qflag;
 	int		c, fd = -1;
@@ -152,20 +151,7 @@ sendfile_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	/* Finally, report back -- -C gives a parsable format */
-	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
-	if (!Cflag) {
-		cvtstr((double)total, s1, sizeof(s1));
-		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
-		printf(_("sent %lld/%lld bytes from offset %lld\n"),
-			total, count, (long long)offset);
-		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
-			s1, c, ts, s2, tdiv((double)c, t2));
-	} else {/* bytes,ops,time,bytes/sec,ops/sec */
-		printf("%lld,%d,%s,%.3f,%.3f\n",
-			total, c, ts,
-			tdiv((double)total, t2), tdiv((double)c, t2));
-	}
+	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 42a77e9..5a5bb01 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -192,3 +192,29 @@ command_loop(void)
 		doneline(input, v);
 	}
 }
+
+void
+report_io_times(
+	struct timeval		*t2,
+	long long		offset,
+	long long		count,
+	long long		total,
+	int			ops,
+	int			condensed)
+{
+	char			s1[64], s2[64], ts[64];
+
+	timestr(t2, ts, sizeof(ts), condensed ? VERBOSE_FIXED_TIME : 0);
+	if (!condensed) {
+		cvtstr((double)total, s1, sizeof(s1));
+		cvtstr(tdiv((double)total, *t2), s2, sizeof(s2));
+		printf(_("linked %lld/%lld bytes at offset %lld\n"),
+			total, count, (long long)offset);
+		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
+			s1, ops, ts, s2, tdiv((double)ops, *t2));
+	} else {/* bytes,ops,time,bytes/sec,ops/sec */
+		printf("%lld,%d,%s,%.3f,%.3f\n",
+			total, ops, ts,
+			tdiv((double)total, *t2), tdiv((double)ops, *t2));
+	}
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
