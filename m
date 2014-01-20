Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFDC77F5F
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 00:22:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C76608F8037
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 22:22:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4v9WBBgZqSKSZ3fM for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 22:22:47 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W58Fs-0004Kl-KM
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W58Fs-0004Tu-JG
	for xfs@oss.sgi.com; Mon, 20 Jan 2014 17:22:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: test scratch device mkfs features
Date: Mon, 20 Jan 2014 17:22:31 +1100
Message-Id: <1390198957-17184-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1390198957-17184-1-git-send-email-david@fromorbit.com>
References: <1390198957-17184-1-git-send-email-david@fromorbit.com>
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

Some filesystem features are not compatible with certain tests, and
so we need to do require tests to determine if they are supported.
Some of these incompatibilities might be a result of optional mkfs
parameters specified in MKFS_OPTIONS. In this case, we don't want
scratch_mkfs_xfs stripping MKFS_OPTIONS and saying the feature is
supported when the next _scratch_mkfs command in the test will
result in a different mkfs command line.

Hence add a "mkfs supported" function to run a non-destructive mkfs
test to determine if the feature is supported by the current test's
mkfs configuration.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc | 105 +++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 42 deletions(-)

diff --git a/common/rc b/common/rc
index 68dc9a0..7a96484 100644
--- a/common/rc
+++ b/common/rc
@@ -360,53 +360,73 @@ _setup_large_xfs_fs()
 	return 0
 }
 
+_scratch_mkfs_xfs_opts()
+{
+	mkfs_opts=$*
+
+	_scratch_options mkfs
+
+	$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
+}
+
+
+_scratch_mkfs_xfs_supported()
+{
+	mkfs_opts=$*
+
+	_scratch_options mkfs
+
+	$MKFS_XFS_PROG -N $MKFS_OPTIONS $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
+}
+
 _scratch_mkfs_xfs()
 {
-    # extra mkfs options can be added by tests
-    local extra_mkfs_options=$*
+	# extra mkfs options can be added by tests
+	local extra_mkfs_options=$*
 
-    local tmp_dir=/tmp/
+	local tmp_dir=/tmp/
 
-    _scratch_options mkfs
+	# save mkfs output in case conflict means we need to run again.
+	# only the output for the mkfs that applies should be shown
+	_scratch_mkfs_xfs_opts $MKFS_OPTIONS $extra_mkfs_options \
+		2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
+	local mkfs_status=$?
 
-    # save mkfs output in case conflict means we need to run again.
-    # only the output for the mkfs that applies should be shown
-    $MKFS_XFS_PROG $SCRATCH_OPTIONS $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
-        2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
-    local mkfs_status=$?
-
-    # a mkfs failure may be caused by conflicts between
-    # $MKFS_OPTIONS and $extra_mkfs_options
-
-    if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
-        echo "** mkfs failed with extra mkfs options added to \"$MKFS_OPTIONS\" by test $seq **" \
-            >>$seqres.full
-        echo "** attempting to mkfs using only test $seq options: $extra_mkfs_options **" \
-            >>$seqres.full
-        # running mkfs again. overwrite previous mkfs output files
-        $MKFS_XFS_PROG $SCRATCH_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
-            2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
-        mkfs_status=$?
-    fi
 
-    if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
-	# manually parse the mkfs output to get the fs size in bytes
-	local fs_size
-	fs_size=`cat $tmp_dir.mkfsstd | perl -ne '
-	    if (/^data\s+=\s+bsize=(\d+)\s+blocks=(\d+)/) {
-		my $size = $1 * $2;
-		print STDOUT "$size\n";
-	    }'`
-	_setup_large_xfs_fs $fs_size
-	mkfs_status=$?
-    fi
+	# a mkfs failure may be caused by conflicts between
+	# $MKFS_OPTIONS and $extra_mkfs_options
+	if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
+		(
+		echo -n "** mkfs failed with extra mkfs options "
+		echo "added to \"$MKFS_OPTIONS\" by test $seq **"
+		echo -n "** attempting to mkfs using only test $seq "
+		echo "options: $extra_mkfs_options **"
+		) >> $seqres.full
+
+		# running mkfs again. overwrite previous mkfs output files
+		_scratch_mkfs_xfs_opts $extra_mkfs_options \
+			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
+		local mkfs_status=$?
+	fi
+
+	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
+		# manually parse the mkfs output to get the fs size in bytes
+		local fs_size
+		fs_size=`cat $tmp_dir.mkfsstd | perl -ne '
+			if (/^data\s+=\s+bsize=(\d+)\s+blocks=(\d+)/) {
+				my $size = $1 * $2;
+				print STDOUT "$size\n";
+			}'`
+		_setup_large_xfs_fs $fs_size
+		mkfs_status=$?
+	fi
 
-    # output stored mkfs output
-    cat $tmp_dir.mkfserr >&2
-    cat $tmp_dir.mkfsstd
-    rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
+	# output stored mkfs output
+	cat $tmp_dir.mkfserr >&2
+	cat $tmp_dir.mkfsstd
+	rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
-    return $mkfs_status
+	return $mkfs_status
 }
 
 # xfs_check script is planned to be deprecated. But, we want to
@@ -1129,15 +1149,15 @@ _require_dm_flakey()
 #
 _require_projid32bit()
 {
-        _scratch_mkfs_xfs -f -i projid32bit=0 2>&1 >/dev/null \
-	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
+	_scratch_mkfs_xfs_supported -i projid32bit=0 >/dev/null 2>&1 \
+		|| _notrun "mkfs.xfs doesn't have projid32bit feature"
 }
 
 # this test requires the crc feature to be available in mkfs.xfs
 #
 _require_xfs_mkfs_crc()
 {
-	_scratch_mkfs_xfs -f -m crc=1 >/dev/null 2>&1 \
+	_scratch_mkfs_xfs_supported -m crc=1 >/dev/null 2>&1 \
 	   || _notrun "mkfs.xfs doesn't have crc feature"
 }
 
@@ -1145,6 +1165,7 @@ _require_xfs_mkfs_crc()
 #
 _require_xfs_crc()
 {
+	_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1 \
 	_scratch_mount >/dev/null 2>&1 \
 	   || _notrun "Kernel doesn't support crc feature"
 	umount $SCRATCH_MNT
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
