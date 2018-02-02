Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38158 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBVgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 16:36:44 -0500
Subject: [PATCH 3/4] xfs_scrub: kill dead code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Feb 2018 13:36:39 -0800
Message-ID: <151760739949.29371.1187587453029792957.stgit@magnolia>
In-Reply-To: <151760738102.29371.13542858379823064383.stgit@magnolia>
References: <151760738102.29371.13542858379823064383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We can't reach the return mess at the bottom of __xfs_scrub_test so get
rid of it.

Fixes-coverity-id: 1428798
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0dbe11c..6abca2a 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -602,7 +602,6 @@ _("Kernel %s %s facility not detected."),
 		str_info(ctx, ctx->mntpoint, "%s", strerror(errno));
 		return true;
 	}
-	return error == 0 || (error && errno != EOPNOTSUPP && errno != ENOTTY);
 }
 
 bool

