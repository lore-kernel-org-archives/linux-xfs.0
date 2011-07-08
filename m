Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p680sD2g204531 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 19:54:13 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53510E8E8BF
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 17:54:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mh3dIlxFcU1ZDI4r for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 17:54:11 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QezKb-0003RF-Qb
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:54:09 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QezKH-0007yV-J9
	for xfs@oss.sgi.com; Fri, 08 Jul 2011 10:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfstests: add mapped write fsx operations to 091
Date: Fri,  8 Jul 2011 10:53:46 +1000
Message-Id: <1310086426-30605-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1310086426-30605-1-git-send-email-david@fromorbit.com>
References: <1310086426-30605-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The recent busted fsx updates caused fsx to execute fsx with direct
IO and mmapped reads and writes on an XFS filesystem. The result
uncovered a direct-IO write vs mmap read bug to do with EOF
sub-block zeroing on the direct IO write.

Hence whiel we do not recommend that pepole mix DIO with mmap on the
same file, we should at least have tests that exercise it as they
often show up other problems like this.


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 091     |    3 +++
 091.out |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/091 b/091
index a13d979..11b599e 100755
--- a/091
+++ b/091
@@ -88,6 +88,9 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
 #run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -W
  run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
 
+ run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+ run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+
 # Commented out calls above are less likely to pick up issues, so
 # save time by commenting them out (leave 'em for manual testing).
 
diff --git a/091.out b/091.out
index 31bd25d..27ed1e3 100644
--- a/091.out
+++ b/091.out
@@ -5,3 +5,5 @@ fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
