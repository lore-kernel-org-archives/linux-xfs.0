Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E645C7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 06:04:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5842DB4397
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 04:04:22 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id oGTV12xkC1Opdaww (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 04:04:19 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfstests: ltp/fsstress add verifiable logging mode
Date: Tue, 25 Feb 2014 16:04:11 +0400
Message-Id: <1393329851-10138-1-git-send-email-dmonakhov@openvz.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>

- It would be useful to have verifiable logging mode which will contain
  only deterministic information which allow to compare two logs files
  generated from two runs with same seed.
- Also add missed help for '-o logfile' option

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c56f168..7f91c04 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -246,6 +246,7 @@ int		rtpct;
 unsigned long	seed = 0;
 ino_t		top_ino;
 int		verbose = 0;
+int		verifiable_log = 0;
 sig_atomic_t	should_stop = 0;
 char		*execute_cmd = NULL;
 int		execute_freq = 1;
@@ -315,7 +316,7 @@ int main(int argc, char **argv)
 	int             nousage = 0;
 	xfs_error_injection_t	        err_inj;
 	struct sigaction action;
-	const char	*allopts = "d:e:f:i:m:M:n:o:p:rs:S:vwx:X:zH";
+	const char	*allopts = "d:e:f:i:m:M:n:o:p:rs:S:vVwx:X:zH";
 
 	errrange = errtag = 0;
 	umask(0);
@@ -396,6 +397,10 @@ int main(int argc, char **argv)
 			printf("\n");
                         nousage=1;
 			break;
+		case 'V':
+			verifiable_log = 1;
+			break;
+
 		case 'X':
 			execute_freq = strtoul(optarg, NULL, 0);
 			break;
@@ -1498,6 +1503,7 @@ usage(void)
 	printf("   -i filenum       get verbose output for this nth file object\n");
 	printf("   -m modulo        uid/gid modulo for chown/chgrp (default 32)\n");
 	printf("   -n nops          specifies the no. of operations per process (default 1)\n");
+	printf("   -o logfile       specifies logfile name\n");
 	printf("   -p nproc         specifies the no. of processes (default 1)\n");
 	printf("   -r               specifies random name padding\n");
 	printf("   -s seed          specifies the seed for the random generator (default random)\n");
@@ -1506,6 +1512,7 @@ usage(void)
 	printf("   -x cmd           execute command in the middle of operations\n");
 	printf("   -z               zeros frequencies of all operations\n");
 	printf("   -S [c,t]         prints the list of operations (omitting zero frequency) in command line or table style\n");
+	printf("   -V               specifies verifiable logging mode (omitting inode numbers)\n");
 	printf("   -X ncmd          number of calls to the -x command (default 1)\n");
 	printf("   -H               prints usage and exits\n");
 }
@@ -1533,7 +1540,8 @@ zero_freq(void)
 void inode_info(char *str, size_t sz, struct stat64 *s, int verbose)
 {
 	if (verbose)
-		snprintf(str, sz, "[%ld %ld %d %d %lld %lld]", (long)s->st_ino,
+		snprintf(str, sz, "[%ld %ld %d %d %lld %lld]",
+			 verifiable_log ? -1: (long)s->st_ino,
 			 (long)s->st_nlink,  s->st_uid, s->st_gid,
 			 (long long) s->st_blocks, (long long) s->st_size);
 }
@@ -1773,11 +1781,11 @@ bulkstat1_f(int opno, long r)
         bsr.icount=1;
         bsr.ubuffer=&t;
         bsr.ocount=NULL;
-        
 	e = xfsctl(".", fd, XFS_IOC_FSBULKSTAT_SINGLE, &bsr) < 0 ? errno : 0;
 	if (v)
 		printf("%d/%d: bulkstat1 %s ino %lld %d\n", 
-                    procid, opno, good?"real":"random", (long long)ino, e);
+		       procid, opno, good?"real":"random",
+		       verifiable_log ? -1LL : (long long)ino, e);
 	close(fd);
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
