Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43924 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeJEFXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 01:23:09 -0400
Date: Thu, 4 Oct 2018 15:27:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/8] xfs_io: dedupe command should only complain if we don't
 dedupe anything
Message-ID: <20181004222733.GM19324@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The dedupe command should only complain about non-matching extents if
the kernel hasn't managed to dedupe /any/ of the input range.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io/reflink.c b/io/reflink.c
index 26eb2e32..72dfe32d 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -70,7 +70,8 @@ dedupe_ioctl(
 					_(strerror(-info->status)));
 			goto done;
 		}
-		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
+		if (deduped == 0 &&
+		    info->status == XFS_EXTENT_DATA_DIFFERS) {
 			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
 					_("Extents did not match."));
 			goto done;
