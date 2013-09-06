Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98FA87F52
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 15:59:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3190BAC00E
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:59:30 -0700 (PDT)
Received: from mail-yh0-f50.google.com (mail-yh0-f50.google.com
	[209.85.213.50]) by cuda.sgi.com with ESMTP id 7tQ008SvpxrlbXAx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 13:59:30 -0700 (PDT)
Received: by mail-yh0-f50.google.com with SMTP id a41so1418782yho.37
	for <xfs@oss.sgi.com>; Fri, 06 Sep 2013 13:59:29 -0700 (PDT)
Message-ID: <522A422B.2030401@gmail.com>
Date: Fri, 06 Sep 2013 16:59:23 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfstests: Add JFS _scratch_mkfs external journal support
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

Hi!  I'd like to contribute several patches for better JFS support.  
This is tested against JFS and XFS.  It's a bit of copy, paste, and 
adaptation until it worked well.  Sorry to nest the XFS code in a 
switch case:  It was the only attempt at coding it that didn't look 
silly.

Thanks!

Michael

>From 52ce69861e7a261449589fdb13c8a8f88df476fa Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Fri, 6 Sep 2013 03:04:25 -0400
Subject: [PATCH 1/2] xfstests: Add JFS _scratch_mkfs external journal support

Add _scratch_mkfs external journal support for JFS.  Try to respect the
USE_EXTERNAL and SCRATCH_LOGDEV variables like the XFS support.
---
 common/config |  1 +
 common/rc     | 52 ++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/common/config b/common/config
index db086fb..bdd1add 100644
--- a/common/config
+++ b/common/config
@@ -204,6 +204,7 @@ case "$HOSTOS" in
         ;;
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
+        export MKFS_JFS_PROG="`set_prog_path mkfs.jfs`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
         export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
diff --git a/common/rc b/common/rc
index 8a239c5..191e9e5 100644
--- a/common/rc
+++ b/common/rc
@@ -207,25 +207,33 @@ _scratch_options()
     type=$1
     SCRATCH_OPTIONS=""
 
-    if [ "$FSTYP" != "xfs" ]; then
-        return
-    fi
-
-    case $type in
-    mkfs)
-	[ "$HOSTOS" != "IRIX" ] && SCRATCH_OPTIONS="$SCRATCH_OPTIONS -f"
-	rt_opt="-r"
-        log_opt="-l"
+    case $FSTYP in
+    xfs)
+	case $type in
+	mkfs)
+	    [ "$HOSTOS" != "IRIX" ] && SCRATCH_OPTIONS="$SCRATCH_OPTIONS -f"
+	    rt_opt="-r"
+            log_opt="-l"
+	    ;;
+	mount)
+	    rt_opt="-o"
+            log_opt="-o"
+	    ;;
+	esac
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	    SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${rt_opt}rtdev=$SCRATCH_RTDEV"
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	    SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}logdev=$SCRATCH_LOGDEV"
 	;;
-    mount)
-	rt_opt="-o"
-        log_opt="-o"
+    jfs)
+	if [ "$type" == "mkfs" ]; then
+	    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -j $SCRATCH_LOGDEV"
+	fi
+	;;
+    *)
 	;;
     esac
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
-	SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${rt_opt}rtdev=$SCRATCH_RTDEV"
-    [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-	SCRATCH_OPTIONS="$SCRATCH_OPTIONS ${log_opt}logdev=$SCRATCH_LOGDEV"
 }
 
 _test_options()
@@ -526,6 +534,15 @@ _scratch_mkfs_ext4()
 	return $mkfs_status
 }
 
+_scratch_mkfs_jfs()
+{
+    _scratch_options mkfs
+
+    $MKFS_JFS_PROG $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
+
+    return $?
+}
+
 _scratch_mkfs()
 {
     case $FSTYP in
@@ -544,6 +561,9 @@ _scratch_mkfs()
     ext4)
 	_scratch_mkfs_ext4 $*
 	;;
+    jfs)
+        _scratch_mkfs_jfs $*
+	;;
     *)
 	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
-- 
1.8.3.2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
