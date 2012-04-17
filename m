Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H9Pdva037638 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 04:25:39 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5BKvLuZRUNz6jGVt for
	<xfs@oss.sgi.com>; Tue, 17 Apr 2012 02:25:38 -0700 (PDT)
From: Tom Marek <tmarek@redhat.com>
Subject: [PATCH 2/3 V2] xfstests 198, 240,
	common.rc: added check for aiodio-sparse2
Date: Tue, 17 Apr 2012 11:24:46 +0200
Message-Id: <1334654687-25450-2-git-send-email-tmarek@redhat.com>
In-Reply-To: <1334654687-25450-1-git-send-email-tmarek@redhat.com>
References: <y>
 <1334654687-25450-1-git-send-email-tmarek@redhat.com>
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
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

Tests number 198 and 240 could fail when aiodio-sparse2 was not build.
_require_aiodio helper was added to common.rc file to fix this.

Cc: david@fromorbit.com
Signed-off-by: Tom Marek <tmarek@redhat.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
V2: check for aiodio-sparse2 was moved to helper function located in
    common.rc file. _require_aiodio was added to tests 198 and 240.
 198       |    2 ++
 240       |    1 +
 common.rc |    8 ++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/198 b/198
index e46ec8d..210b7bb 100755
--- a/198
+++ b/198
@@ -45,6 +45,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_aiodio
+
 echo "Silence is golden."
 
 # real QA test starts here
diff --git a/240 b/240
index 563449e..5b37bdc 100755
--- a/240
+++ b/240
@@ -52,6 +52,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
+_require_aiodio
 
 echo "Silence is golden."
 
diff --git a/common.rc b/common.rc
index cab0b64..7745df1 100644
--- a/common.rc
+++ b/common.rc
@@ -770,6 +770,14 @@ _require_scratch()
     fi
 }
 
+# this test needs aio-dio-regress to be built
+#
+_require_aiodio()
+{
+    [ -x $here/src/aio-dio-regress/aiodio_sparse2 ] || \
+        _notrun "This tests requires src/aio-dio-regress/ to be built"
+}
+
 # this test needs a logdev
 #
 _require_logdev()
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
