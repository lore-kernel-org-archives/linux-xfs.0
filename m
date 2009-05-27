Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrMAO204149 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9E721A2DC46
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:35 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id TFuOwMbv3dOLhtQb for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:35 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 6/9] Detect FS type to test based on TEST_DEV
Date: Wed, 27 May 2009 13:53:30 -0500
Message-Id: <1243450413-12681-7-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

This helps support generic / non-xfs fileystems.

Rather than defaulting to xfs or expecting a fs
type passed in, just look at what is on TEST_DEV
and use that for FSTYP by default.

We may wish to add a generic way to override this later.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 common |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/common b/common
index 92ec9e2..b5ca5d0 100644
--- a/common
+++ b/common
@@ -30,7 +30,13 @@ have_test_arg=false
 randomize=false
 rm -f $tmp.list $tmp.tmp $tmp.sed
 
-export FSTYP=xfs
+# Autodetect fs type based on what's on $TEST_DEV
+if [ "$HOSTOS" == "Linux" ]
+then
+    export FSTYP=`blkid -s TYPE -o value $TEST_DEV`
+else
+    export FSTYP=xfs
+fi
 
 for r
 do
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
