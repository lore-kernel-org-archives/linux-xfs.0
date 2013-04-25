Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B984D29DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:16:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 333A7AC004
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:16:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VyGb3i6bw4KDi3UO for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 08:16:35 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DD90563C59BC
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:16:34 -0500 (CDT)
Message-ID: <517948D2.7070706@sandeen.net>
Date: Thu, 25 Apr 2013 10:16:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3 V2] xfsprogs: Fix up usage() errors and omissions
References: <5175BB8F.5090604@sandeen.net> <5175BCBE.8040306@sandeen.net>
In-Reply-To: <5175BCBE.8040306@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Add missing options and remove invalid options in usage() output
strings.

* Add -V to several usage() strings
* Remove deprecated/invalid -n and -s otions from xfs_fsr's usage
* Remove invalid -I option from xfs_growfs's usage
* Add -n (O_NONBLOCK) option to xfs_io's usage
* Add -e (exit on error) option to xfs_logprint's usage
* Remove invalid -b option from xfs_mdrestore's usage
* Add -N (no-op), -K (no discard), and -f (force) to mkfs.xfs's usage
* Add -x (expert) option to xfs_quota's usage

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: address Rich's nitpicky review ;)  (i.e. fix good stuff)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index c01e0b9..7f65de3 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -301,7 +301,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-bd] [-L logfile] source target [target ...]\n"),
+		_("Usage: %s [-bdV] [-L logfile] source target [target ...]\n"),
 		progname);
 	exit(1);
 }
diff --git a/db/init.c b/db/init.c
index 2a31cb8..0e9e1a2 100644
--- a/db/init.c
+++ b/db/init.c
@@ -43,7 +43,7 @@ static void
 usage(void)
 {
 	fprintf(stderr, _(
-		"Usage: %s [-fFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
+		"Usage: %s [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
 		), progname);
 	exit(1);
 }
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 54a72e9..ddc6f62 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -78,6 +78,7 @@ usage(char *progname)
 		"\t-i logsize (internal log size)\n"
 		"\t-e logsize (external log size)\n"
 		"\t-v prints more verbose messages\n"
+		"\t-V prints version and exits\n"
 		"\t-h prints this usage message\n\n"
 	"Note:\tblocksize may have 'k' appended to indicate x1024\n"
 	"\tlogsize may also have 'm' appended to indicate (1024 x 1024)\n"),
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3d017ca..6852b3f 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -386,20 +386,19 @@ void
 usage(int ret)
 {
 	fprintf(stderr, _(
-"Usage: %s [-d] [-v] [-n] [-s] [-g] [-t time] [-p passes] [-f leftf] [-m mtab]\n"
-"       %s [-d] [-v] [-n] [-s] [-g] xfsdev | dir | file ...\n\n"
+"Usage: %s [-d] [-v] [-g] [-t time] [-p passes] [-f leftf] [-m mtab]\n"
+"       %s [-d] [-v] [-g] xfsdev | dir | file ...\n"
+"       %s -V\n\n"
 "Options:\n"
-"       -n              Do nothing, only interesting with -v. Not\n"
-"                       effective with in mtab mode.\n"
-"       -s		Print statistics only.\n"
 "       -g              Print to syslog (default if stdout not a tty).\n"
 "       -t time         How long to run in seconds.\n"
-"       -p passes	Number of passes before terminating global re-org.\n"
+"       -p passes       Number of passes before terminating global re-org.\n"
 "       -f leftoff      Use this instead of %s.\n"
 "       -m mtab         Use something other than /etc/mtab.\n"
 "       -d              Debug, print even more.\n"
-"       -v		Verbose, more -v's more verbose.\n"
-		), progname, progname, _PATH_FSRLAST);
+"       -v              Verbose, more -v's more verbose.\n"
+"       -V              Print version number and exit.\n"
+		), progname, progname, progname, _PATH_FSRLAST);
 	exit(ret);
 }
 
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index a6d298b..5d544da 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -19,14 +19,6 @@
 #include <xfs/libxfs.h>
 #include <xfs/path.h>
 
-/*
- * When growing a filesystem, this is the most significant
- * bits we'll accept in the resulting inode numbers
- * without warning the user.
- */
-
-#define XFS_MAX_INODE_SIG_BITS 32
-
 static void
 usage(void)
 {
@@ -37,7 +29,6 @@ Options:\n\
 	-l          grow log section\n\
 	-r          grow realtime section\n\
 	-n          don't change anything, just show geometry\n\
-	-I          allow inode numbers to exceed %d significant bits\n\
 	-i          convert log from external to internal format\n\
 	-t          alternate location for mount table (/etc/mtab)\n\
 	-x          convert log from internal to external format\n\
@@ -47,7 +38,7 @@ Options:\n\
 	-e size     set realtime extent size to size blks\n\
 	-m imaxpct  set inode max percent to imaxpct\n\
 	-V          print version information\n"),
-		progname, XFS_MAX_INODE_SIG_BITS);
+		progname);
 	exit(2);
 }
 
diff --git a/io/init.c b/io/init.c
index fb93082..ca3055a 100644
--- a/io/init.c
+++ b/io/init.c
@@ -32,7 +32,7 @@ void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-adfmrRstx] [-p prog] [-c cmd]... file\n"),
+		_("Usage: %s [-adfmnrRstVx] [-p prog] [-c cmd]... file\n"),
 		progname);
 	exit(1);
 }
diff --git a/io/xfs_freeze.sh b/io/xfs_freeze.sh
index 45e20d2..647aa96 100644
--- a/io/xfs_freeze.sh
+++ b/io/xfs_freeze.sh
@@ -4,7 +4,7 @@
 #
 
 OPTS=""
-USAGE="Usage: xfs_freeze -f | -u <mountpoint>"
+USAGE="Usage: xfs_freeze [-V] [-f | -u] <mountpoint>"
 DIRNAME=`dirname $0`
 VERSION=false
 FREEZE=false
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 482fd4e..0923b0a 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -44,6 +44,7 @@ Options:\n\
     -c	            try to continue if error found in log\n\
     -C <filename>   copy the log from the filesystem to filename\n\
     -d	            dump the log in log-record format\n\
+    -e	            exit when an error is found in the log\n\
     -f	            specified device is actually a file\n\
     -l <device>     filename of external log\n\
     -n	            don't try and interpret log data\n\
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 509a3ed..479e677 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -178,7 +178,7 @@ perform_restore(
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-bg] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] source target\n", progname);
 	exit(1);
 }
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c57a855..a393607 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2899,13 +2899,16 @@ usage( void )
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num),\n\
 			    sectlog=n|sectsize=num\n\
+/* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1]\n\
+/* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
 			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
 /* naming */		[-n log=n|size=num,version=2|ci]\n\
+/* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
diff --git a/quota/init.c b/quota/init.c
index 0b481f7..639e9e7 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -45,7 +45,7 @@ static void
 usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-p prog] [-c cmd]... [-d project]... [path]\n"),
+		_("Usage: %s [-V] [-x] [-p prog] [-c cmd]... [-d project]... [path]\n"),
 		progname);
 	exit(1);
 }
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index 6ea7ab9..f0b5936 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -27,7 +27,7 @@ char *progname;
 void
 usage()
 {
-	fprintf(stderr, _("%s [-e extsize] [-p] source target\n"), progname);
+	fprintf(stderr, _("%s [-e extsize] [-p] [-V] source target\n"), progname);
 	exit(2);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
