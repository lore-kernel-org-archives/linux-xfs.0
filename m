Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJOXtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 19:49:39 -0400
Date: Mon, 15 Oct 2018 09:03:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_scrub: lack of kernel support is not a service failure
Message-ID: <20181015160344.GJ28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't treat a lack of kernel support for scrubbing as an automated
service failure because we have not actually determined that there's
anything wrong with the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 33b83a5f..6a0304d2 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -779,9 +779,15 @@ main(
 	 * for capturing all the log messages if the scrub fails, because the
 	 * fail service uses the service name to gather log messages for the
 	 * error report.
+	 *
+	 * Note: We don't count a lack of kernel support as a service failure
+	 * because we haven't determined that there's anything wrong with the
+	 * filesystem.
 	 */
 	if (is_service) {
 		sleep(2);
+		if (!ctx.scrub_setup_succeeded)
+			return 0;
 		if (ret != SCRUB_RET_SUCCESS)
 			return 1;
 	}
