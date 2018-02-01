Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50760 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755014AbeBAUdb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Feb 2018 15:33:31 -0500
Subject: [PATCH 31/29] xfs_scrub: handle scrub-only kernels more helpfully
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
 <20180131173016.GD4849@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <313224b9-67b0-cd94-fca5-a862761b2b02@sandeen.net>
Date: Thu, 1 Feb 2018 14:33:30 -0600
MIME-Version: 1.0
In-Reply-To: <20180131173016.GD4849@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

If xfs_scrub is run today against a 4.15 kernel, it fails with

EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Error: /home: Kernel metadata optimization facility is required.
Info: /home: Scrub aborted after phase 1.
/home: 2 errors found.

Be a bit kinder to the user and suggest a path forward.  By the
time we fail for missing preen or repair functionality, we do
know that scrub is available, so suggest it.

Further, rather than stating what is required, state what was not
found ... we're failing, so state what was missing, vs. what is
required - seems a bit more definitive.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/scrub/phase1.c b/scrub/phase1.c
index 547767b..e78ac7d 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -175,7 +175,7 @@ _("Does not appear to be an XFS filesystem!"));
 	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
 	    !xfs_can_scrub_parent(ctx)) {
 		str_error(ctx, ctx->mntpoint,
-_("Kernel metadata scrubbing facility is required."));
+_("Kernel metadata scrubbing facility not available."));
 		return false;
 	}
 
@@ -183,10 +183,10 @@ _("Kernel metadata scrubbing facility is required."));
 	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
 		if (ctx->mode == SCRUB_MODE_PREEN)
 			str_error(ctx, ctx->mntpoint,
-_("Kernel metadata optimization facility is required."));
+_("Kernel metadata optimization facility not available.  Please use -n."));
 		else
 			str_error(ctx, ctx->mntpoint,
-_("Kernel metadata repair facility is required."));
+_("Kernel metadata repair facility not not available. Please use -n."));
 		return false;
 	}
 


