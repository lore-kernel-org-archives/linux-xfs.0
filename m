Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56180 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752235AbeF0Cst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:49 -0400
Subject: [PATCH 07/10] xfs_scrub: rename NOFIX_COMPLAIN to be less confusing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:48:35 -0700
Message-ID: <153006771523.20121.7089644598888393327.stgit@magnolia>
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

Rename NOFIX_COMPLAIN to COMPLAIN_IF_UNFIXED so that the symbolic name
is less confusing as to what the flag is supposed to mean.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase4.c |    2 +-
 scrub/repair.h |    2 +-
 scrub/scrub.c  |    6 +++---
 scrub/scrub.h  |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 01a073bc..7ae6b7cf 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -69,7 +69,7 @@ xfs_repair_ag(
 		return;
 
 	/* Try once more, but this time complain if we can't fix things. */
-	flags |= ALP_NOFIX_COMPLAIN;
+	flags |= ALP_COMPLAIN_IF_UNFIXED;
 	moveon = xfs_action_list_process(ctx, ctx->mnt_fd, alist, flags);
 	if (!moveon)
 		*pmoveon = false;
diff --git a/scrub/repair.h b/scrub/repair.h
index 4be950e7..c8693ccf 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -29,7 +29,7 @@ void xfs_action_list_find_mustfix(struct xfs_action_list *actions,
 
 /* Passed through to xfs_repair_metadata() */
 #define ALP_REPAIR_ONLY		(XRM_REPAIR_ONLY)
-#define ALP_NOFIX_COMPLAIN	(XRM_NOFIX_COMPLAIN)
+#define ALP_COMPLAIN_IF_UNFIXED	(XRM_COMPLAIN_IF_UNFIXED)
 #define ALP_NOPROGRESS		(1U << 31)
 
 bool xfs_action_list_process(struct scrub_ctx *ctx, int fd,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index fe4e880f..2ac146a9 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -762,7 +762,7 @@ xfs_repair_metadata(
 	 * If the caller doesn't want us to complain, tell the caller to
 	 * requeue the repair for later and don't say a thing.
 	 */
-	if (!(repair_flags & XRM_NOFIX_COMPLAIN) &&
+	if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED) &&
 	    (error || needs_repair(&meta)))
 		return CHECK_RETRY;
 	if (error) {
@@ -815,11 +815,11 @@ _("Read-only filesystem; cannot make changes."));
 			return CHECK_DONE;
 		}
 	}
-	if (repair_flags & XRM_NOFIX_COMPLAIN)
+	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
 		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
 	if (needs_repair(&meta)) {
 		/* Still broken, try again or fix offline. */
-		if ((repair_flags & XRM_NOFIX_COMPLAIN) || debug)
+		if ((repair_flags & XRM_COMPLAIN_IF_UNFIXED) || debug)
 			str_error(ctx, buf,
 _("Repair unsuccessful; offline repair required."));
 	} else {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index fdcbd40d..701a01ae 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -86,7 +86,7 @@ struct action_item {
 #define XRM_REPAIR_ONLY		(1U << 0)
 
 /* Complain if still broken even after fix. */
-#define XRM_NOFIX_COMPLAIN	(1U << 1)
+#define XRM_COMPLAIN_IF_UNFIXED	(1U << 1)
 
 enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
 		struct action_item *aitem, unsigned int repair_flags);

