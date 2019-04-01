Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfDAQnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 12:43:24 -0400
Date: Mon, 1 Apr 2019 09:43:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 49/36] xfs_scrub: remove redundant function declarations
Message-ID: <20190401164317.GA5147@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove a redundant function declaration.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/scrub/scrub.h b/scrub/scrub.h
index 34c3dd30..e6e3f16f 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -25,8 +25,6 @@ bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
 bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
-enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx, int fd,
-		struct action_item *aitem, unsigned int flags);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
