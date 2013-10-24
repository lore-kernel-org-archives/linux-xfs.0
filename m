Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89D377F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 07:10:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79D7330407A
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 05:10:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id d6o6Sup6J94FD51a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 05:10:48 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9OCAkjP018888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 12:10:47 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OCAjr1020529
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 12:10:46 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OCAjTi011853 for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 12:10:45 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH V2] xfstests: src/feature.c: print a number of online CPUs
Date: Thu, 24 Oct 2013 16:10:40 +0400
Message-Id: <1382616640-23894-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <20131024104042.GT2797@dastard>
References: <20131024104042.GT2797@dastard>
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
Cc: vasily.isaenko@oracle.com

For this purpose we use sysconf() as it is the
preferred platform neutral interface for getting this
sort of information.

Based on Dave Chinner proposal.

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 src/feature.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/src/feature.c b/src/feature.c
index 2619ca5..a3ce9b8 100644
--- a/src/feature.c
+++ b/src/feature.c
@@ -30,6 +30,7 @@
  * Return code: 0 is true, anything else is error/not supported
  *
  * Test for machine features
+ *   -o  report a number of online cpus
  *   -s  report pagesize
  *   -w  report bits per long
  */
@@ -39,6 +40,7 @@
 #include <sys/quota.h>
 #include <sys/resource.h>
 #include <signal.h>
+#include <unistd.h>
 
 #ifdef HAVE_XFS_XQM_H
 #include <xfs/xqm.h>
@@ -64,7 +66,7 @@ usage(void)
 	fprintf(stderr, "Usage: feature [-v] -<q|u|g|p|U|G|P> <filesystem>\n");
 	fprintf(stderr, "       feature [-v] -c <file>\n");
 	fprintf(stderr, "       feature [-v] -t <file>\n");
-	fprintf(stderr, "       feature -s | -w\n");
+	fprintf(stderr, "       feature -o | -s | -w\n");
 	exit(1);
 }
 
@@ -212,9 +214,10 @@ main(int argc, char **argv)
 	int	uflag = 0;
 	int	Uflag = 0;
 	int	wflag = 0;
+	int	oflag = 0;
 	char	*fs = NULL;
 
-	while ((c = getopt(argc, argv, "ctgGpPqsuUvw")) != EOF) {
+	while ((c = getopt(argc, argv, "ctgGopPqsuUvw")) != EOF) {
 		switch (c) {
 		case 'c':
 			cflag++;
@@ -228,6 +231,9 @@ main(int argc, char **argv)
 		case 'G':
 			Gflag++;
 			break;
+		case 'o':
+			oflag++;
+			break;
 		case 'p':
 			pflag++;
 			break;
@@ -262,7 +268,7 @@ main(int argc, char **argv)
 		if (optind != argc-1)	/* need a device */
 			usage();
 		fs = argv[argc-1];
-	} else if (wflag || sflag) {
+	} else if (wflag || sflag || oflag) {
 		if (optind != argc)
 			usage();
 	} else 
@@ -306,6 +312,25 @@ bozo!
 #endif
 		exit(0);
 	}
+	if (oflag) {
+		long ncpus;
+
+#if defined(_SC_NPROCESSORS_ONLN)
+		/* Linux */
+		ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+#elif defined(_SC_NPROC_ONLN)
+		/* IRIX */
+		ncpus = sysconf(_SC_NPROC_ONLN);
+#else
+		ncpus = 1;
+#endif
+		if (ncpus == -1)
+			ncpus = 1;
+
+		printf("%ld\n", ncpus);
+
+		exit(0);
+	}
 
 	fprintf(stderr, "feature: dunno what you're after.\n");
 	return(1);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
