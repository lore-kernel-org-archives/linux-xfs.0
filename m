Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:32830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbeF0Csm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:42 -0400
Subject: [PATCH 06/10] xfs_scrub: don't error out if an optimize-only repair
 isn't supported
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:48:28 -0700
Message-ID: <153006770873.20121.6125776702823601560.stgit@magnolia>
In-Reply-To: <153006766483.20121.9285982017465570544.stgit@magnolia>
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the kernel told us a metadata object could be optimized, we ask it to
do the optimization and it spits back that it doesn't support
optimizing, don't record this as an error since the fs is still
consistent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index c893f2c9..fe4e880f 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -782,10 +782,11 @@ _("Filesystem is shut down, aborting."));
 		case ENOTTY:
 		case EOPNOTSUPP:
 			/*
-			 * If we forced repairs, don't complain if kernel
-			 * doesn't know how to fix.
+			 * If we forced repairs or this is a preen, don't
+			 * error out if the kernel doesn't know how to fix.
 			 */
-			if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			if (is_unoptimized(&oldm) ||
+			    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
 				return CHECK_DONE;
 			/* fall through */
 		case EINVAL:

