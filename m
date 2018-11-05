Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387420AbeKFCqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Nov 2018 21:46:31 -0500
Date: Mon, 5 Nov 2018 09:25:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] populate: fix leafn creation test for v4 filesystems
Message-ID: <20181105172547.GD4131@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

The leafn creation test doesn't work on some v4 filesystems
because the field names change.  Rearrange the code somewhat so that it
works properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 610425f9..d49fbc29 100644
--- a/common/populate
+++ b/common/populate
@@ -444,7 +444,9 @@ __populate_check_xfs_dir() {
 		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"leafn")
-		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.hdr.magic" | egrep -q '(0x3dff|0xd2ff)' || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.hdr.magic" | grep -q '0x3dff' && return
+		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.magic" | grep -q '0xd2ff' && return
+		_fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
 	"node"|"btree")
 		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 1) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
