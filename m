Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17167 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162935AbdDWRry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Apr 2017 13:47:54 -0400
Date: Sun, 23 Apr 2017 10:46:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix getfsmap userspace memory corruption while setting
 OF_LAST
Message-ID: <20170423174653.GO23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

At the end of a getfsmap call, we will set FMR_OF_LAST in the last
struct fsmap that was handed in by userspace if we've truly run out of
space mapping record (as opposed to simply running out of space in the
user array).  Unfortunately, fmh_entries is the wrong check for whether
or not we've filled out anything in the user array because the ioctl
provides that fmh_count==0 sets fmh_entries without filling out the fsmap
array.  Therefore we end up writing things into user memory areas that we
weren't given, and kaboom.

Since Christoph amended the getfsmap structure to track the number of
fsmap entries we've actually filled out, use that as part of deciding if
we have to set the OF_LAST flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index eee8b0f..6190697 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1674,7 +1674,7 @@ xfs_ioc_getfsmap(
 		return error;
 
 	/* If we didn't abort, set the "last" flag in the last fmx */
-	if (!aborted && xhead.fmh_entries) {
+	if (!aborted && info.idx) {
 		info.last_flags |= FMR_OF_LAST;
 		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
 				&info.last_flags, sizeof(info.last_flags)))
