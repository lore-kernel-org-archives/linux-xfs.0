Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CED947F91
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:01:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C837B8F8039
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:01:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VHE68HhcKqet7l7B for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 12:01:35 -0700 (PDT)
Received: from Liberator-2.local (unknown [187.157.176.2])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7B42D61ACB6C
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:01:33 -0500 (CDT)
Message-ID: <533DB01C.8020300@sandeen.net>
Date: Thu, 03 Apr 2014 13:01:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix RESULT_BASE typo in check script
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

RESULT_BASE is what's set & tested, but RESULTS_BASE was
being used in an error message.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/check b/check
index 268417c..a384cb2 100755
--- a/check
+++ b/check
@@ -358,7 +358,7 @@ trap "_wrapup; exit \$status" 0 1 2 3 15
 
 mkdir -p $RESULT_BASE
 if [ ! -d $RESULT_BASE ]; then
-	echo "failed to create results directory $RESULTS_BASE"
+	echo "failed to create results directory $RESULT_BASE"
 	exit 1;
 fi
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
