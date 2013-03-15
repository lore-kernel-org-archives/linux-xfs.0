Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0251D7FD8
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB729304043
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Fv13FwhxnjjCF355 for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:39 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCZ-0001Tb-DD
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCZ-0005i2-AX
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/13] xfstest: enable xfs_repair for large filesystem testing
Date: Fri, 15 Mar 2013 22:53:25 +1100
Message-Id: <1363348411-21867-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that large filesystem testing does not play free space games to
fill the space without IO, we can enable xfs_repair when running in
this mode. xfs_repair has had it's scalability problems solved, too,
so this is a safe thing to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 common.rc |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/common.rc b/common.rc
index d221be1..ee4f522 100644
--- a/common.rc
+++ b/common.rc
@@ -1273,19 +1273,17 @@ _check_xfs_filesystem()
     extra_mount_options=""
     device=$1
     if [ "$2" != "none" ]; then
-       	extra_log_options="-l$2"
+	extra_log_options="-l$2"
         extra_mount_options="-ologdev=$2"
     fi
 
     if [ "$3" != "none" ]; then
-       	extra_rt_options="-r$3"
+	extra_rt_options="-r$3"
         extra_mount_options=$extra_mount_options" -ortdev=$3"
     fi
     extra_mount_options=$extra_mount_options" $MOUNT_OPTIONS"
 
     [ "$FSTYP" != xfs ] && return 0
-    testoption=""
-    [ "$LARGE_SCRATCH_DEV" = yes ] && testoption=-t
 
     type=`_fs_type $device`
     ok=1
@@ -1310,8 +1308,13 @@ _check_xfs_filesystem()
         ok=0
     fi
 
-    $XFS_CHECK_PROG $testoption $extra_log_options $device 2>&1 |\
-	 _fix_malloc >$tmp.fs_check
+    # xfs_check runs out of memory on large files, so even providing the test
+    # option (-t) to avoid indexing the free space trees doesn't make it pass on
+    # large filesystems. Avoid it.
+    if [ "$LARGE_SCRATCH_DEV" != yes ]; then
+	    $XFS_CHECK_PROG $extra_log_options $device 2>&1 |\
+		 _fix_malloc >$tmp.fs_check
+    fi
     if [ -s $tmp.fs_check ]
     then
         echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $seq.full)"
@@ -1323,8 +1326,7 @@ _check_xfs_filesystem()
 
         ok=0
     fi
-    # repair doesn't scale massively at this stage, optionally skip it for now
-    [ "$LARGE_SCRATCH_DEV" = yes ] || \
+
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
