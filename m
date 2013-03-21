Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C9807F3F
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 06:00:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E3B3AC004
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 04:00:05 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.137]) by
	cuda.sgi.com with ESMTP id m98A1FmyRsAOanyh for
	<xfs@oss.sgi.com>; Thu, 21 Mar 2013 04:00:03 -0700 (PDT)
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.22 OK)
	with ESMTP id p02003p2L9FjB5 for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 12:00:02 +0100 (CET)
From: Jan Schmidt <list.xfs@jan-o-sch.net>
Subject: [PATCH] xfstests: add execution of a custom command to fsstress (-x
	and -X options)
Date: Thu, 21 Mar 2013 11:59:45 +0100
Message-Id: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
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

From: Jan Schmidt <list.btrfs@jan-o-sch.net>

This patch adds execution of a custom command in the middle of all fsstress
operations. Its intended use is the creation of snapshots in the middle of a
test run.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 ltp/fsstress.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b4cfb25..5d5611f 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -247,6 +247,8 @@ unsigned long	seed = 0;
 ino_t		top_ino;
 int		verbose = 0;
 sig_atomic_t	should_stop = 0;
+char		*execute_cmd = NULL;
+int		execute_freq = 1;
 
 void	add_to_flist(int, int, int);
 void	append_pathname(pathname_t *, char *);
@@ -313,13 +315,14 @@ int main(int argc, char **argv)
 	int             nousage = 0;
 	xfs_error_injection_t	        err_inj;
 	struct sigaction action;
+	const char	*allopts = "d:e:f:i:m:M:n:o:p:rs:S:vwx:X:zH";
 
 	errrange = errtag = 0;
 	umask(0);
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, "d:e:f:i:m:M:n:o:p:rs:S:vwzH")) != -1) {
+	while ((c = getopt(argc, argv, allopts)) != -1) {
 		switch (c) {
 		case 'd':
 			dirname = optarg;
@@ -376,6 +379,9 @@ int main(int argc, char **argv)
 		case 'w':
 			write_freq();
 			break;
+		case 'x':
+			execute_cmd = optarg;
+			break;
 		case 'z':
 			zero_freq();
 			break;
@@ -390,6 +396,9 @@ int main(int argc, char **argv)
 			printf("\n");
                         nousage=1;
 			break;
+		case 'X':
+			execute_freq = strtoul(optarg, NULL, 0);
+			break;
 		case '?':
 			fprintf(stderr, "%s - invalid parameters\n",
 				myprog);
@@ -765,7 +774,9 @@ doproc(void)
 	int		opno;
 	int		rval;
 	opdesc_t	*p;
+	int		dividend;
 
+	dividend = (operations + execute_freq) / (execute_freq + 1);
 	sprintf(buf, "p%x", procid);
 	(void)mkdir(buf, 0777);
 	if (chdir(buf) < 0 || stat64(".", &statbuf) < 0) {
@@ -779,6 +790,15 @@ doproc(void)
 	if (namerand)
 		namerand = random();
 	for (opno = 0; opno < operations; opno++) {
+		if (execute_cmd && opno && opno % dividend == 0) {
+			if (verbose)
+				printf("%d: execute command %s\n", opno,
+					execute_cmd);
+			rval = system(execute_cmd);
+			if (rval)
+				fprintf(stderr, "execute command failed with "
+					"%d\n", rval);
+		}
 		p = &ops[freq_table[random() % freq_table_size]];
 		p->func(opno, random());
 		/*
@@ -1468,7 +1488,7 @@ usage(void)
 	printf("Usage: %s -H   or\n", myprog);
 	printf("       %s [-d dir][-e errtg][-f op_name=freq][-n nops]\n",
 		myprog);
-	printf("          [-p nproc][-r len][-s seed][-v][-w][-z][-S]\n");
+	printf("          [-p nproc][-r len][-s seed][-v][-w][-x cmd][-z][-S][-X ncmd]\n");
 	printf("where\n");
 	printf("   -d dir           specifies the base directory for operations\n");
 	printf("   -e errtg         specifies error injection stuff\n");
@@ -1483,8 +1503,10 @@ usage(void)
 	printf("   -s seed          specifies the seed for the random generator (default random)\n");
 	printf("   -v               specifies verbose mode\n");
 	printf("   -w               zeros frequencies of non-write operations\n");
+	printf("   -x cmd           execute command in the middle of operations\n");
 	printf("   -z               zeros frequencies of all operations\n");
 	printf("   -S [c,t]         prints the list of operations (omitting zero frequency) in command line or table style\n");
+	printf("   -X ncmd          number of calls to the -x command (default 1)\n");
 	printf("   -H               prints usage and exits\n");
 }
 
-- 
1.7.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
