Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46610 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:35 -0400
Subject: [PATCH 18/39] xfs_io: add refcount+bmap error injection types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:29 -0700
Message-ID: <147743672943.11035.2953776445747317319.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Add refcount and bmap deferred finish to the types of errors we can
inject.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 16ac925..56642b8 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -78,7 +78,13 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
 #define XFS_ERRTAG_RMAP_FINISH_ONE			23
 		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
-#define XFS_ERRTAG_MAX                                  24
+#define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
+		{ XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,	"refcount_continue_update" },
+#define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
+		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
+#define XFS_ERRTAG_BMAP_FINISH_ONE			26
+		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
+#define XFS_ERRTAG_MAX                                  27
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

