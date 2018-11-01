Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:25:04 -0400
Subject: [PATCH 8/8] xfs: filter out mount options that don't work on v4
 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:52 -0700
Message-ID: <154111439271.6577.9895278106106014415.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A few tests require v4 filesystems and enforce this by disabling crc's
in the _scratch_mkfs call.  However, if the user specified MOUNT_OPTIONS
that only work with v5 filesystems, these tests fail.  If we detect a
test creating a v4 scratch filesystem, filter out incompatible mount
options that don't work on v4, such as simultaneous group/project quota.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/common/xfs b/common/xfs
index 80340b0d..484e6ab6 100644
--- a/common/xfs
+++ b/common/xfs
@@ -89,6 +89,7 @@ _scratch_mkfs_xfs()
 	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
 	mkfs_status=$?
 
+	grep -q crc=0 $tmp.mkfsstd && _force_xfsv4_mount_options
 
 	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
 		# manually parse the mkfs output to get the fs size in bytes
@@ -779,3 +780,26 @@ _scratch_get_bmx_prefix() {
 	_scratch_xfs_db -c "inode ${ino}" -c 'p' >> $seqres.full
 	return 1
 }
+
+#
+# Ensures that we don't pass any mount options incompatible with XFS v4
+#
+_force_xfsv4_mount_options()
+{
+	local gquota=0
+	local pquota=0
+
+	# Can't have group and project quotas in XFS v4
+	echo "$MOUNT_OPTIONS" | egrep -q "(gquota|grpquota|grpjquota=|gqnoenforce)" && gquota=1
+	echo "$MOUNT_OPTIONS" | egrep -q "(\bpquota|prjquota|pqnoenforce)" && pquota=1
+
+	if [ $gquota -gt 0 ] && [ $pquota -gt 0 ]; then
+		export MOUNT_OPTIONS=$(echo $MOUNT_OPTIONS \
+			| sed   -e 's/gquota/QUOTA/g'      \
+				-e 's/grpquota/QUOTA/g'    \
+				-e 's/grpjquota=[^, ]/QUOTA/g' \
+				-e 's/gqnoenforce/QUOTA/g' \
+				-e "s/QUOTA/defaults/g")
+	fi
+	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
+}
