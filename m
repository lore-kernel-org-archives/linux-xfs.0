Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38702 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdJRXhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:37:53 -0400
Subject: [PATCH 3/5] common/xfs: standardize the xfs_scrub output that gets
 recorded to $seqres.full
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Oct 2017 16:37:49 -0700
Message-ID: <150836986903.27213.7461698055714662108.stgit@magnolia>
In-Reply-To: <150836985024.27213.3715197937819365388.stgit@magnolia>
References: <150836985024.27213.3715197937819365388.stgit@magnolia>
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
index 7d8f275..25c2ce9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -356,11 +356,15 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
-		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full
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

