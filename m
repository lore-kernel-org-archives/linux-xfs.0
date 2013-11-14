Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0C837F54
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 14:02:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA0638F8050
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:01:57 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id URB7pGyCHuozpz42 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 12:01:56 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAEK1ti1029350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:01:56 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAEK1rR3001338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:01:54 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAEK1ruR012554 for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:01:53 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
Subject: [PATCH v2] xfsprogs: properly check size arguments for growfs
Date: Thu, 14 Nov 2013 12:01:30 -0800
Message-Id: <1384459290-16291-1-git-send-email-guangyu.sun@oracle.com>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, Guangyu Sun <guangyu.sun@oracle.com>

xfs_growfs has lowercase options to grow a filesystem as big as possible
(e.g. the -d option) and uppercase options to grow a filesystem to a
specified size, expressed in blocks. (e.g. the "-D size" option)

If the size parameter is not numerical, the parameter is either trimmed or
ignored. In the latter case, the filesystem is grown as big as possible. This
may happen when users accidentally specify the size in a format similar to
mkfs.xfs (e.g. "-D 100m" or "-D size=16384")

In both cases, xfs_growfs should return an error instead of resizing the
filesystem.

To reproduce:
  # mkfs.xfs -f -d size=20m -L koenfs /dev/dm-3
  # mount /dev/dm-3 //mnt
  # xfs_growfs -D 10000andmorethan10invalidcharacters /mnt
  (...)
  data blocks changed from 5120 to 10000
  # xfs_growfs -D invalidargument20000containingnumbers /mnt
  (...)
  data blocks changed from 10000 to 19659543

Reported-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 growfs/xfs_growfs.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2df68fb..bcadd84 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -123,6 +123,7 @@ main(int argc, char **argv)
 	int			projid32bit;
 	int			crcs_enabled;
 	int			ftype_enabled = 0;
+	char			*endptr;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -137,7 +138,12 @@ main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) != EOF) {
 		switch (c) {
 		case 'D':
-			dsize = strtoll(optarg, NULL, 10);
+			dsize = strtoll(optarg, &endptr, 10);
+			if (*endptr) {
+				fprintf(stderr, _("%s: %s is not a valid "
+					"number\n"), progname, optarg);
+				return 1;
+			}
 			/* fall through */
 		case 'd':
 			dflag = 1;
@@ -150,7 +156,12 @@ main(int argc, char **argv)
 			lflag = iflag = 1;
 			break;
 		case 'L':
-			lsize = strtoll(optarg, NULL, 10);
+			lsize = strtoll(optarg, &endptr, 10);
+			if (*endptr) {
+				fprintf(stderr, _("%s: %s is not a valid "
+					"number\n"), progname, optarg);
+				return 1;
+			}
 			/* fall through */
 		case 'l':
 			lflag = 1;
@@ -166,7 +177,12 @@ main(int argc, char **argv)
 			progname = optarg;
 			break;
 		case 'R':
-			rsize = strtoll(optarg, NULL, 10);
+			rsize = strtoll(optarg, &endptr, 10);
+			if (*endptr) {
+				fprintf(stderr, _("%s: %s is not a valid "
+					"number\n"), progname, optarg);
+				return 1;
+			}
 			/* fall through */
 		case 'r':
 			rflag = 1;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
