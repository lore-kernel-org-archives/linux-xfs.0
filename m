Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47514 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeBEXWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:22:36 -0500
Subject: [PATCH 3/7] xfs_scrub: classify lack of ioctl support as a runtime
 error
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:22:33 -0800
Message-ID: <151787295310.3743.17476652120290779062.stgit@magnolia>
In-Reply-To: <151787293446.3743.11110014829952400444.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the kernel doesn't have the SCRUB_METADATA ioctl that's a runtime
error, not a fs error.  Account it as such.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index af93d0f..82c8022 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -174,14 +174,14 @@ _("Does not appear to be an XFS filesystem!"));
 	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
 	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
 	    !xfs_can_scrub_parent(ctx)) {
-		str_error(ctx, ctx->mntpoint,
+		str_info(ctx, ctx->mntpoint,
 _("Kernel metadata scrubbing facility is not available."));
 		return false;
 	}
 
 	/* Do we need kernel-assisted metadata repair? */
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
-		str_error(ctx, ctx->mntpoint,
+		str_info(ctx, ctx->mntpoint,
 _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return false;
 	}

