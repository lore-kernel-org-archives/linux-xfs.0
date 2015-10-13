Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 309397F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 12:48:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0057A304032
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 10:48:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FWjBLVGrXjYrDh8w (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 10:48:27 -0700 (PDT)
Date: Tue, 13 Oct 2015 10:48:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/51] libxcmd: provide a common function to report
	command runtimes
Message-ID: <20151013174827.GA31669@infradead.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:05:20PM -0700, Darrick J. Wong wrote:
> Refactor the open-coded runtime stats reporting into a library
> command, then update xfs_io commands to use it.

We need to pass the actual operation that we summarize, otherwise
various tests are very unhappy:

diff --git a/include/command.h b/include/command.h
index 51dae6a..fb86f7a 100644
--- a/include/command.h
+++ b/include/command.h
@@ -58,8 +58,8 @@ extern void		command_loop(void);
 extern int		command_usage(const cmdinfo_t *ci);
 extern int		command(const cmdinfo_t *ci, int argc, char **argv);
 
-extern void		report_io_times(struct timeval *t2, long long offset,
-				     long long count, long long total,
-				     int ops, int condensed);
+extern void		report_io_times(const char *op, struct timeval *t2,
+				long long offset, long long count,
+				long long total, int ops, int condensed);
 
 #endif	/* __COMMAND_H__ */
diff --git a/io/pread.c b/io/pread.c
index 66ea945..f16c86c 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -487,7 +487,7 @@ pread_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
+	report_io_times("read", &t2, (long long)offset, count, total, c, Cflag);
 	return 0;
 }
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 81f6abe..f354de3 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -384,7 +384,7 @@ pwrite_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
+	report_io_times("wrote", &t2, (long long)offset, count, total, c, Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/io/reflink.c b/io/reflink.c
index 3572728..20007bf 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -161,7 +161,7 @@ dedupe_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	report_io_times(&t2, (long long)doffset, count, total, ops, condensed);
+	report_io_times("linked", &t2, (long long)doffset, count, total, ops, condensed);
 done:
 	close(fd);
 	return 0;
@@ -284,7 +284,7 @@ clone_all:
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	report_io_times(&t2, (long long)doffset, count, total, ops, condensed);
+	report_io_times("linked", &t2, (long long)doffset, count, total, ops, condensed);
 done:
 	close(fd);
 	return 0;
diff --git a/io/sendfile.c b/io/sendfile.c
index ced6369..21ab444 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -151,7 +151,7 @@ sendfile_f(
 	gettimeofday(&t2, NULL);
 	t2 = tsub(t2, t1);
 
-	report_io_times(&t2, (long long)offset, count, total, c, Cflag);
+	report_io_times("sent", &t2, (long long)offset, count, total, c, Cflag);
 done:
 	if (infile)
 		close(fd);
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 5a5bb01..04f66de 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -195,6 +195,7 @@ command_loop(void)
 
 void
 report_io_times(
+	const char		*op,
 	struct timeval		*t2,
 	long long		offset,
 	long long		count,
@@ -208,8 +209,8 @@ report_io_times(
 	if (!condensed) {
 		cvtstr((double)total, s1, sizeof(s1));
 		cvtstr(tdiv((double)total, *t2), s2, sizeof(s2));
-		printf(_("linked %lld/%lld bytes at offset %lld\n"),
-			total, count, (long long)offset);
+		printf(_("%s %lld/%lld bytes at offset %lld\n"),
+			op, total, count, (long long)offset);
 		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
 			s1, ops, ts, s2, tdiv((double)ops, *t2));
 	} else {/* bytes,ops,time,bytes/sec,ops/sec */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
