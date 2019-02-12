Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 21:17:42 -0500
Subject: [PATCH 2/3] common: fix _require_btime for lazy filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 11 Feb 2019 18:17:32 -0800
Message-ID: <154993785290.1948.9192893627999402298.stgit@magnolia>
In-Reply-To: <154993784038.1948.7502664832930298472.stgit@magnolia>
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Filesystems are not required to try to fill the statx btime field unless
the caller actually sets STATX_BTIME.  They're allowed to volunteer that
information "if it's cheap", but XFS doesn't volunteer and there may be
filesystems that support btime but not cheaply.

Either way, we want to test btime on any filesystem that supports it,
cheaply or otherwise, so set STATX_BTIME when we're trying to detect
support for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index ab468adf..6fb71e60 100644
--- a/common/rc
+++ b/common/rc
@@ -3849,7 +3849,11 @@ _dmsetup_create()
 
 _require_btime()
 {
-	$XFS_IO_PROG -f $TEST_DIR/test_creation_time -c "statx -v" \
+	# Note: filesystems are not required to report btime (creation time)
+	# if the caller doesn't ask for it, so we define STATX_BTIME here and
+	# pass it in to the statx command.
+	export STATX_BTIME=0x800
+	$XFS_IO_PROG -f $TEST_DIR/test_creation_time -c "statx -m $STATX_BTIME -v" \
 		| grep btime >>$seqres.full 2>&1 || \
 		_notrun "inode creation time not supported by this filesystem"
 	rm -f $TEST_DIR/test_creation_time
