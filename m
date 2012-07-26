Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8e5g9001395 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:05 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	A8H38BMP7ydriXmd for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJc2-000144-4X
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJc2-0003vB-0G
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfstests: exclude largefs fill files from dump tests
Date: Thu, 26 Jul 2012 18:39:49 +1000
Message-Id: <1343291989-14987-11-git-send-email-david@fromorbit.com>
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

The xfsdump/restore tests will see the space filling files and may
try to backthem up and restore them, consuming huge amounts of time
to do (espcially when diffing the results). Exclude the space
filling files by setting the no dump attributes on them and ensure
that xfsdump runs with the -e flag to exclude such files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.config |    3 ++-
 common.dump   |    2 +-
 common.rc     |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/common.config b/common.config
index 7bed1c5..bb9af93 100644
--- a/common.config
+++ b/common.config
@@ -146,7 +146,8 @@ export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
-export XFSDUMP_PROG="`set_prog_path xfsdump`"
+export __XFSDUMP_PROG="`set_prog_path xfsdump`"
+export XFSDUMP_PROG="$__XFSDUMP_PROG -e"
 export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
 export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"
 export DBENCH_PROG="`set_prog_path dbench`"
diff --git a/common.dump b/common.dump
index e89dedc..a33dc81 100644
--- a/common.dump
+++ b/common.dump
@@ -829,7 +829,7 @@ _dump_filter_main()
 {
   _filter_devchar |\
   sed \
-      -e "s#$XFSDUMP_PROG#xfsdump#"			\
+      -e "s#$__XFSDUMP_PROG#xfsdump#"			\
       -e "s#$XFSRESTORE_PROG#xfsrestore#"		\
       -e "s#$XFSINVUTIL_PROG#xfsinvutil#"		\
       -e "s/`hostname`/HOSTNAME/"			\
diff --git a/common.rc b/common.rc
index 1c3c605..1b23b66 100644
--- a/common.rc
+++ b/common.rc
@@ -306,6 +306,7 @@ _setup_large_xfs_fs()
 	xfs_io -F -f \
 		-c "truncate $file_size" \
 		-c "falloc -k 0 $file_size" \
+		-c "chattr +d" \
 		$SCRATCH_MNT/.use_space 2>&1 > /dev/null
 	status=$?
 	umount $SCRATCH_MNT
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
