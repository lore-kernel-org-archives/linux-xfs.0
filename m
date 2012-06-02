Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q52EXFH1258353 for <xfs@oss.sgi.com>; Sat, 2 Jun 2012 09:33:15 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id LMjPaR9zQCG6crhH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Jun 2012 07:33:14 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q52EXDcB012965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2012 14:33:13 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q52EXCmx018988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2012 14:33:13 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q52EXCjk005810 for <xfs@oss.sgi.com>; Sat, 2 Jun 2012 09:33:12 -0500
Message-ID: <4FCA2422.90804@oracle.com>
Date: Sat, 02 Jun 2012 22:33:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix a compile warning at seek_sanity_test.c
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

Compiler report warning at seek_sanity_test.c:
seek_sanity_test.c:46:3: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'int'

Below patch can fix it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 src/seek_sanity_test.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index a185e54..34f5508 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -42,8 +42,10 @@ static void get_file_system(int fd)
 {
 	struct statfs buf;
 
-	if (!fstatfs(fd, &buf))
-		fprintf(stdout, "File system magic#: 0x%lx\n", buf.f_type);
+	if (!fstatfs(fd, &buf)) {
+		fprintf(stdout, "File system magic#: 0x%lx\n",
+				(unsigned long int)buf.f_type);
+	}
 }
 
 static int get_io_sizes(int fd)
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
