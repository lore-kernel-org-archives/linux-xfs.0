Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbfFRVHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:23 -0400
Subject: [PATCH 2/4] xfs: rework min log size helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jun 2019 14:07:15 -0700
Message-ID: <156089203509.345809.3448903728041546348.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The recent _scratch_find_xfs_min_logblocks helper has a major thinko in
it -- it relies on feeding a too-small size to _scratch_do_mkfs so that
mkfs will tell us the minimum log size.  Unfortunately, _scratch_do_mkfs
will see that first failure and retry the mkfs without MKFS_OPTIONS,
which means that we return the minimum log size for the default mkfs
settings without MKFS_OPTIONS.

This is a problem if someone's running fstests with a set of
MKFS_OPTIONS that affects the minimum log size.  To fix this, open-code
the _scratch_do_mkfs retry behavior so that we only do the "retry
without MKFS_OPTIONS" behavior if the mkfs failed for a reason other
than the minimum log size check.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc  |   13 ++++++++++---
 common/xfs |   23 +++++++++++++++++++++--
 2 files changed, 31 insertions(+), 5 deletions(-)


diff --git a/common/rc b/common/rc
index 25203bb4..a38b7f02 100644
--- a/common/rc
+++ b/common/rc
@@ -438,6 +438,14 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+# Format the scratch device directly.  First argument is the mkfs command.
+# Second argument are all the parameters.  stdout goes to $tmp.mkfsstd and
+# stderr goes to $tmp.mkfserr.
+__scratch_do_mkfs()
+{
+	eval "$1 $2 $SCRATCH_DEV" 2>$tmp.mkfserr 1>$tmp.mkfsstd
+}
+
 # Do the actual mkfs work on SCRATCH_DEV. Firstly mkfs with both MKFS_OPTIONS
 # and user specified mkfs options, if that fails (due to conflicts between mkfs
 # options), do a second mkfs with only user provided mkfs options.
@@ -456,8 +464,7 @@ _scratch_do_mkfs()
 
 	# save mkfs output in case conflict means we need to run again.
 	# only the output for the mkfs that applies should be shown
-	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
-		2>$tmp.mkfserr 1>$tmp.mkfsstd
+	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
 	mkfs_status=$?
 
 	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
@@ -471,7 +478,7 @@ _scratch_do_mkfs()
 		) >> $seqres.full
 
 		# running mkfs again. overwrite previous mkfs output files
-		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
+		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options" \
 			2>$tmp.mkfserr 1>$tmp.mkfsstd
 		mkfs_status=$?
 	fi
diff --git a/common/xfs b/common/xfs
index f8dafc6c..8733e2ae 100644
--- a/common/xfs
+++ b/common/xfs
@@ -87,16 +87,33 @@ _scratch_find_xfs_min_logblocks()
 	# minimum log size.
 	local XFS_MIN_LOG_BYTES=2097152
 
-	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
-		2>$tmp.mkfserr 1>$tmp.mkfsstd
+	# Try formatting the filesystem with all the options given and the
+	# minimum log size.  We hope either that this succeeds or that mkfs
+	# tells us the required minimum log size for the feature set.
+	#
+	# We cannot use _scratch_do_mkfs because it will retry /any/ failed
+	# mkfs with MKFS_OPTIONS removed even if the only "failure" was that
+	# the log was too small.
+	local extra_mkfs_options="$* -N -l size=$XFS_MIN_LOG_BYTES"
+	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
 	local mkfs_status=$?
 
+	# If the format fails for a reason other than the log being too small,
+	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
+	# will do if we pass in the log size option.
+	if [ $mkfs_status -ne 0 ] &&
+	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
+		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options"
+		local mkfs_status=$?
+	fi
+
 	# mkfs suceeded, so we must pick out the log block size to do the
 	# unit conversion
 	if [ $mkfs_status -eq 0 ]; then
 		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
 			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
 		echo $((XFS_MIN_LOG_BYTES / blksz))
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -104,6 +121,7 @@ _scratch_find_xfs_min_logblocks()
 	if grep -q 'minimum size is' $tmp.mkfserr; then
 		grep 'minimum size is' $tmp.mkfserr | \
 			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -111,6 +129,7 @@ _scratch_find_xfs_min_logblocks()
 	echo "Cannot determine minimum log size" >&2
 	cat $tmp.mkfsstd >> $seqres.full
 	cat $tmp.mkfserr >> $seqres.full
+	rm -f $tmp.mkfsstd $tmp.mkfserr
 }
 
 _scratch_mkfs_xfs()
