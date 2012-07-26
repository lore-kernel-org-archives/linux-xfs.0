Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8eEYe001454 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:15 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lCx8eoUUhLXMBtMn for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJcB-00013y-Un
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003um-R7
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] xfstests: use command line option for setting extra
	space
Date: Thu, 26 Jul 2012 18:39:44 +1000
Message-Id: <1343291989-14987-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

Allow the extra free space to leave in large scratch filesystems to
be specified by a command line option rather than just via an
environment variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common b/common
index da86cd9..78ac654 100644
--- a/common
+++ b/common
@@ -247,6 +247,11 @@ s/ .*//p
 	    usage
 	    ;;
 
+	--extra-space=*)
+	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
+	    xpand=false
+	    ;;
+
 	*)
 	    start=$r
 	    end=$r
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
