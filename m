Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B71CB29DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 21:27:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95FDC8F804B
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 19:27:49 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	WCdynaukFWgBN6dG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 19:27:48 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id 16so7113276iea.17
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 19:27:48 -0700 (PDT)
Message-ID: <519D7E89.8060201@gmail.com>
Date: Wed, 22 May 2013 22:27:21 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Change mount method for shared/243
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
In-Reply-To: <20130522012620.GA29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi!  This patch updates the mount method in xfstests shared/243 
without seeming to change the behavior of the test.  Should this 
patch get a NACK for not being useful, no worries!  There will be 
other opportunities.

The patch was tested with ext4, with and without external journals. 
It was also tested on XFS with an external logdev.  The MOUNT_OPTIONS 
for the ext4 tests included '-o barrier=1' and '-o barrier=0'.  The 
test results varied on ext4 with an external journal, but the 
results shown by /proc/mounts was OK.  [barrier=1 causes a failed 
test, barrier=0 succeeds, both in the original and patched test.]

>From 8762f621a5fb9556fa96ec289bceffc4fcc844f3 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Wed, 22 May 2013 20:57:56 -0400
Subject: [PATCH] xfstests: Change mount method for shared/243

Change the mount invocations in shared/243 to use the built-in
_test_mount function of xfstests.  This was done as part of a
clean-up recommendation.  Currently, only ext4 file systems are
affected by this change.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 tests/shared/243 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shared/243 b/tests/shared/243
index e0f2db2..b3eb025 100755
--- a/tests/shared/243
+++ b/tests/shared/243
@@ -108,7 +108,7 @@ _check_ext4_eof_flag()
     fi
 
     # Mount the ${TEST_DEV}
-    mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
+    _test_mount
   fi
 }
 
-- 
1.8.2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
