Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6F3neSK183641 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 22:49:40 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9BCF6FA17
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 20:49:39 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id G8tABfgainXkj8cR for
	<xfs@oss.sgi.com>; Thu, 14 Jul 2011 20:49:39 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6F3KqCN003297
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 23:20:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6F3nc1b165128 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 23:49:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6F3ncuF006868 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 23:49:38 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1] XFS TESTS: Correct extent flag parsing for punch hole
	tests
Date: Thu, 14 Jul 2011 20:52:13 -0700
Message-Id: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
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
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

The fiemap filters used in the punch hole tests parse the
extent flags in the fiemap to determine the extent type.
They are currently parsing them as decimal values, but
they should be parsing hex values.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100755 0083963... 0083963... M	255
:100644 100644 a48b7ae... 7337298... M	common.punch
 common.punch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/255 b/255
old mode 100644
new mode 100755
diff --git a/common.punch b/common.punch
index a48b7ae..7337298 100644
--- a/common.punch
+++ b/common.punch
@@ -208,11 +208,11 @@ _filter_fiemap()
 			print $1, $2, $3;
 			next;
 		}
-		$5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ {
+		$5 ~ /0x[[:xdigit:]]*8[[:xdigit:]]{2}/ {
 			print $1, $2, "unwritten";
 			next;
 		}
-		$5 ~ /0x[[:digit:]]+/ {
+		$5 ~ /0x[[:xdigit:]]+/ {
 			print $1, $2, "data";
 		}' |
 	_coalesce_extents
@@ -228,7 +228,7 @@ _filter_hole_fiemap()
 			print $1, $2, $3; 
 			next;
 		}   
-		$5 ~ /0x[[:digit:]]+/ {
+		$5 ~ /0x[[:xdigit:]]+/ {
 			print $1, $2, "extent";
 		}' |
 	_coalesce_extents
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
