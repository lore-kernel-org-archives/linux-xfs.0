Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2EF27F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 00:36:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5F638F8035
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 22:36:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Qnfdmo05BCcNyzHt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 22:36:05 -0700 (PDT)
Date: Tue, 13 Oct 2015 22:35:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 01/51] libxcmd: provide a common function to report
	command runtimes
Message-ID: <20151014053557.GI10397@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050520.1504.59073.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007050520.1504.59073.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Refactor the open-coded runtime stats reporting into a library
command, then update xfs_io commands to use it.

v2: Pass the verb name along so that we can report it accurately

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/command.h |    6 ++++++
 io/pread.c        |   16 +---------------
 io/pwrite.c       |   17 ++---------------
 io/sendfile.c     |   16 +---------------
 libxcmd/command.c |   27 +++++++++++++++++++++++++++
 5 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/include/command.h b/include/command.h
index 4869edf..7b9fc28 100644
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
 
+extern void		report_io_times(const char *verb, struct timeval *t2,
+					long long offset, long long count,
+					long long total, int ops, int compact);
+
 #endif	/* __COMMAND_H__ */
diff --git a/io/pread.c b/io/pread.c
index 1c77c41..f16c86c 100644
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
+	report_io_times("read", &t2, (long long)offset, count, total, c, Cflag);
 	return 0;
 }
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 10f78e4..fd9114d 100644
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
@@ -385,20 +384,8 @@ pwrite_f(
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
+	report_io_times("wrote", &t2, (long long)offset, count, total, c,
+			Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/io/sendfile.c b/io/sendfile.c
index 5c1638f..21ab444 100644
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
+	report_io_times("sent", &t2, (long long)offset, count, total, c, Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 42a77e9..dd0034c 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -192,3 +192,30 @@ command_loop(void)
 		doneline(input, v);
 	}
 }
+
+void
+report_io_times(
+	const char		*verb,
+	struct timeval		*t2,
+	long long		offset,
+	long long		count,
+	long long		total,
+	int			ops,
+	int			compact)
+{
+	char			s1[64], s2[64], ts[64];
+
+	timestr(t2, ts, sizeof(ts), compact ? VERBOSE_FIXED_TIME : 0);
+	if (!compact) {
+		cvtstr((double)total, s1, sizeof(s1));
+		cvtstr(tdiv((double)total, *t2), s2, sizeof(s2));
+		printf(_("%s %lld/%lld bytes at offset %lld\n"),
+			verb, total, count, (long long)offset);
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
