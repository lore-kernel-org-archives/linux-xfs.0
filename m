Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56244 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeF0Cs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:56 -0400
Subject: [PATCH 08/10] xfs_scrub: only retry non-permanent repair failures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:48:41 -0700
Message-ID: <153006772140.20121.17551661183487526760.stgit@magnolia>
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

If a repair fails, we want to retry the repair if the error was a
transient one, such as ENOMEM.  For "permanent" ones (shutdown fs,
repair not supported by kernel, readonly fs) there's no point to
retrying them so just error out immediately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2ac146a9..b20c1cbe 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -758,13 +758,6 @@ xfs_repair_metadata(
 		str_info(ctx, buf, _("Attempting optimization."));
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
-	/*
-	 * If the caller doesn't want us to complain, tell the caller to
-	 * requeue the repair for later and don't say a thing.
-	 */
-	if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED) &&
-	    (error || needs_repair(&meta)))
-		return CHECK_RETRY;
 	if (error) {
 		switch (errno) {
 		case EDEADLOCK:
@@ -781,6 +774,16 @@ _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case ENOTTY:
 		case EOPNOTSUPP:
+			/*
+			 * If we're in no-complain mode, requeue the check for
+			 * later.  It's possible that an error in another
+			 * component caused us to flag an error in this
+			 * component.  Even if the kernel didn't think it
+			 * could fix this, it's at least worth trying the scan
+			 * again to see if another repair fixed it.
+			 */
+			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+				return CHECK_RETRY;
 			/*
 			 * If we forced repairs or this is a preen, don't
 			 * error out if the kernel doesn't know how to fix.
@@ -810,7 +813,14 @@ _("Read-only filesystem; cannot make changes."));
 				return CHECK_DONE;
 			/* fall through */
 		default:
-			/* Operational error. */
+			/*
+			 * Operational error.  If the caller doesn't want us
+			 * to complain about repair failures, tell the caller
+			 * to requeue the repair for later and don't say a
+			 * thing.  Otherwise, print error and bail out.
+			 */
+			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+				return CHECK_RETRY;
 			str_errno(ctx, buf);
 			return CHECK_DONE;
 		}
@@ -818,9 +828,14 @@ _("Read-only filesystem; cannot make changes."));
 	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
 		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
 	if (needs_repair(&meta)) {
-		/* Still broken, try again or fix offline. */
-		if ((repair_flags & XRM_COMPLAIN_IF_UNFIXED) || debug)
-			str_error(ctx, buf,
+		/*
+		 * Still broken; if we've been told not to complain then we
+		 * just requeue this and try again later.  Otherwise we
+		 * log the error loudly and don't try again.
+		 */
+		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
+			return CHECK_RETRY;
+		str_error(ctx, buf,
 _("Repair unsuccessful; offline repair required."));
 	} else {
 		/* Clean metadata, no corruption remains. */

