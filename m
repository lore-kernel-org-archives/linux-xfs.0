Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19777 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933516AbdKAVqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:46:45 -0400
Subject: [PATCH 02/14] common/xfs: standardize the xfs_scrub output that
 gets recorded to $seqres.full
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:46:40 -0700
Message-ID: <150957280092.18388.482320105508128305.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make the xfs_scrub output that gets recorded to $seqres.full follow the
format of xfs_repair checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/common/xfs b/common/xfs
index de3c560..5643adf 100644
--- a/common/xfs
+++ b/common/xfs
@@ -357,11 +357,15 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
-		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full 2>&1
+		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
-			_log_err "filesystem on $device failed scrub"
+			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
+			echo "*** xfs_scrub $scrubflag -v -d -n output ***" >> $seqres.full
+			cat $tmp.scrub >> $seqres.full
+			echo "*** end xfs_scrub output" >> $serqres.full
 			ok=0
 		fi
+		rm -f $tmp.scrub
 	fi
 
 	if [ "$type" = "xfs" ]; then

