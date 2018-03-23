Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCWQye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 12:54:34 -0400
Subject: [PATCH 1/4] common/xfs: don't call xfs_scrub on a block device
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 23 Mar 2018 09:54:28 -0700
Message-ID: <152182406876.14523.11145092318388572094.stgit@magnolia>
In-Reply-To: <152182406249.14523.2186010254497227366.stgit@magnolia>
References: <152182406249.14523.2186010254497227366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@linux.alibaba.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_scrub takes an xfs mountpoint as its argument, not a block device.
Therefore, fix _check_xfs_filesystem to call it correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index 5dbd81e..1d98ba1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -358,7 +358,7 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
-		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device > $tmp.scrub 2>&1
+		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
 			echo "*** xfs_scrub $scrubflag -v -d -n output ***" >> $seqres.full

