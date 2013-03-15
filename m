Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD2F17FF1
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C1BEAC005
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6ysvCXsDmTlDuG4o for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCt-0001U3-IH
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:55 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCj-0005iM-Ex
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/13] xfstests: exclude largefs fill files from dump tests
Date: Fri, 15 Mar 2013 22:53:29 +1100
Message-Id: <1363348411-21867-12-git-send-email-david@fromorbit.com>
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

The xfsdump/restore tests will see the space filling files and may
try to backthem up and restore them, consuming huge amounts of time
to do (espcially when diffing the results). Exclude the space
filling files by setting the no dump attributes on them and ensure
that xfsdump runs with the -e flag to exclude such files.

This also needs a dump filter addition to remove the output that
files were skipped, and to decrement the count of files processed by
xfsrestore because the inventory still includes excluded files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.config |    3 ++-
 common.dump   |   34 ++++++++++++++++++++++++++--------
 common.filter |    4 +++-
 common.rc     |    1 +
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/common.config b/common.config
index 5ac58bf..ab19772 100644
--- a/common.config
+++ b/common.config
@@ -160,7 +160,8 @@ export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
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
index e89dedc..be55249 100644
--- a/common.dump
+++ b/common.dump
@@ -29,7 +29,8 @@ if [ -n "$DEBUGDUMP" ]; then
 
 	# Use dump/restore in qa directory (copy them here) for debugging
 	export PATH="$here:$PATH"
-	export XFSDUMP_PROG="`set_prog_path xfsdump`"
+	export __XFSDUMP_PROG="`set_prog_path xfsdump`"
+	export XFSDUMP_PROG="$__XFSDUMP_PROG -e"
 	export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
 	export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"
 	[ -x $here/xfsdump ]    && echo "Using xfstests' xfsdump for debug"
@@ -829,7 +830,7 @@ _dump_filter_main()
 {
   _filter_devchar |\
   sed \
-      -e "s#$XFSDUMP_PROG#xfsdump#"			\
+      -e "s#$__XFSDUMP_PROG#xfsdump#"			\
       -e "s#$XFSRESTORE_PROG#xfsrestore#"		\
       -e "s#$XFSINVUTIL_PROG#xfsinvutil#"		\
       -e "s/`hostname`/HOSTNAME/"			\
@@ -872,13 +873,29 @@ _dump_filter_main()
       -e '/xfsdump: ino map phase [5]/,1d'		\
       -e 's/id:[[:space:]]*[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}/ID: ID/'						\
       -e 's/\[y\/n\][- ]----------------------*/\[y\/n\]/'		\
+      -e '/skip attribute set/d'				\
   | perl -ne '
-      if ($_ =~ /(?:Dump|Restore) Summary/) {
-        $skip = 1;
-      } elsif ($_ =~ /(?:Dump|Restore) Status/) {
-        $skip = 0;
-      }
-      print if (! $skip);'
+	# filter out all the output between the lines "Dump Summary:"
+	# and "Dump Status:"
+	if ($_ =~ /(?:Dump|Restore) Summary/) {
+		$skip = 1;
+	} elsif ($_ =~ /(?:Dump|Restore) Status/) {
+		$skip = 0;
+	}
+	print if (! $skip);' \
+  | perl -ne '
+	# correct the file count if large scratch devices are being used
+	$skip = 0;
+	if ($_ =~ /(\S+) directories and (\S+) entries/) {
+		$foo = $2;
+		if ($ENV{'LARGE_SCRATCH_DEV'} && $foo > 0) {
+			$foo -= 1;
+		}
+		printf("xfsrestore: %u directories and %u entries processed\n",
+						$1, $foo);
+		$skip = 1;
+	}
+	print if (! $skip);'
 }
 
 _dump_filter()
@@ -916,6 +933,7 @@ _dir_filter()
     -e "s#$dump_sdir#DUMP_SUBDIR#g"   \
     -e "s#$restore_sdir#RESTORE_SUBDIR#g" \
     -e "s#$$#PID#g" \
+    -e "/Only in SCRATCH_MNT: .use_space/d" \
 
 }
 
diff --git a/common.filter b/common.filter
index c34809f..da5675f 100644
--- a/common.filter
+++ b/common.filter
@@ -223,7 +223,9 @@ _filter_test_dir()
 
 _filter_scratch()
 {
-	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
+	    -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
+	    -e "/.use_space/d"
 }
 
 # Turn any device in the scratch pool into SCRATCH_DEV
diff --git a/common.rc b/common.rc
index 690c6a3..96d5077 100644
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
