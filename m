Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28685 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdJSBZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 21:25:10 -0400
Subject: [PATCH 3/3] xfs_io: add new error injection knobs to inject command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Oct 2017 18:25:06 -0700
Message-ID: <150837630628.31583.12537115048470504642.stgit@magnolia>
In-Reply-To: <150837629129.31583.8002405051612025341.stgit@magnolia>
References: <150837629129.31583.8002405051612025341.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Bring xfs_io's inject command up to date with the newest knobs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 25c7021..964ebfe 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -86,7 +86,13 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
 #define XFS_ERRTAG_AG_RESV_CRITICAL			27
 		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
-#define XFS_ERRTAG_MAX                                  28
+#define XFS_ERRTAG_DROP_WRITES				28
+		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
+#define XFS_ERRTAG_LOG_BAD_CRC				29
+		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
+#define XFS_ERRTAG_LOG_ITEM_PIN				30
+		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
+#define XFS_ERRTAG_MAX                                  31
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

