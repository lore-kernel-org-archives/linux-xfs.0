Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGIRtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 13:49:45 -0400
Subject: [PATCH 1/3] xfs: rework min log size helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Jul 2019 10:49:41 -0700
Message-ID: <156269458116.3039184.6080699668311209553.stgit@magnolia>
In-Reply-To: <156269457497.3039184.4886490143800432410.stgit@magnolia>
References: <156269457497.3039184.4886490143800432410.stgit@magnolia>
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
 common/xfs |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index f8dafc6c..2b38e94b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -87,16 +87,35 @@ _scratch_find_xfs_min_logblocks()
 	# minimum log size.
 	local XFS_MIN_LOG_BYTES=2097152
 
-	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
+	# Try formatting the filesystem with all the options given and the
+	# minimum log size.  We hope either that this succeeds or that mkfs
+	# tells us the required minimum log size for the feature set.
+	#
+	# We cannot use _scratch_do_mkfs because it will retry /any/ failed
+	# mkfs with MKFS_OPTIONS removed even if the only "failure" was that
+	# the log was too small.
+	local extra_mkfs_options="$* -N -l size=$XFS_MIN_LOG_BYTES"
+	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
 		2>$tmp.mkfserr 1>$tmp.mkfsstd
 	local mkfs_status=$?
 
+	# If the format fails for a reason other than the log being too small,
+	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
+	# will do if we pass in the log size option.
+	if [ $mkfs_status -ne 0 ] &&
+	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
+		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
+			2>$tmp.mkfserr 1>$tmp.mkfsstd
+		mkfs_status=$?
+	fi
+
 	# mkfs suceeded, so we must pick out the log block size to do the
 	# unit conversion
 	if [ $mkfs_status -eq 0 ]; then
-		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
+		blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
 			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
 		echo $((XFS_MIN_LOG_BYTES / blksz))
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -104,6 +123,7 @@ _scratch_find_xfs_min_logblocks()
 	if grep -q 'minimum size is' $tmp.mkfserr; then
 		grep 'minimum size is' $tmp.mkfserr | \
 			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
+		rm -f $tmp.mkfsstd $tmp.mkfserr
 		return
 	fi
 
@@ -111,6 +131,7 @@ _scratch_find_xfs_min_logblocks()
 	echo "Cannot determine minimum log size" >&2
 	cat $tmp.mkfsstd >> $seqres.full
 	cat $tmp.mkfserr >> $seqres.full
+	rm -f $tmp.mkfsstd $tmp.mkfserr
 }
 
 _scratch_mkfs_xfs()
