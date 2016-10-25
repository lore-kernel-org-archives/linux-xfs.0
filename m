Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46647 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754700AbcJYXFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:41 -0400
Subject: [PATCH 19/39] xfs_io: support injecting the 'per-AG reservation
 critically low' error
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:37 -0700
Message-ID: <147743673772.11035.3310689539964275768.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 56642b8..5d5e4ae 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -84,7 +84,9 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
 #define XFS_ERRTAG_BMAP_FINISH_ONE			26
 		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
-#define XFS_ERRTAG_MAX                                  27
+#define XFS_ERRTAG_AG_RESV_CRITICAL			27
+		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
+#define XFS_ERRTAG_MAX                                  28
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

