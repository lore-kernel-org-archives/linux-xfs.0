Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16408 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdKQT5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 14:57:03 -0500
Subject: [PATCH 3/5] xfs_io: pull xfs errortag definitions from libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 11:56:59 -0800
Message-ID: <151094861922.27182.7656317389319451444.stgit@magnolia>
In-Reply-To: <151094860143.27182.12022983202520916281.stgit@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the libxfs definitions, don't provide our own.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h |    1 +
 io/inject.c      |   35 ++---------------------------------
 2 files changed, 3 insertions(+), 33 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 6d08da4..abb01cb 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -61,6 +61,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
+#include "xfs_errortag.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
diff --git a/io/inject.c b/io/inject.c
index 964ebfe..9d0cf62 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -20,6 +20,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "xfs_errortag.h"
 
 static cmdinfo_t inject_cmd;
 
@@ -29,70 +30,38 @@ error_tag(char *name)
 	static struct {
 		int	tag;
 		char	*name;
-	} *e, eflags[] = {
-#define XFS_ERRTAG_NOERROR                              0
+	} *e, eflags[XFS_ERRTAG_MAX + 1] = {
 		{ XFS_ERRTAG_NOERROR,			"noerror" },
-#define XFS_ERRTAG_IFLUSH_1                             1
 		{ XFS_ERRTAG_IFLUSH_1,			"iflush1" },
-#define XFS_ERRTAG_IFLUSH_2                             2
 		{ XFS_ERRTAG_IFLUSH_2,			"iflush2" },
-#define XFS_ERRTAG_IFLUSH_3                             3
 		{ XFS_ERRTAG_IFLUSH_3,			"iflush3" },
-#define XFS_ERRTAG_IFLUSH_4                             4
 		{ XFS_ERRTAG_IFLUSH_4,			"iflush4" },
-#define XFS_ERRTAG_IFLUSH_5                             5
 		{ XFS_ERRTAG_IFLUSH_5,			"iflush5" },
-#define XFS_ERRTAG_IFLUSH_6                             6
 		{ XFS_ERRTAG_IFLUSH_6,			"iflush6" },
-#define XFS_ERRTAG_DA_READ_BUF                          7
 		{ XFS_ERRTAG_DA_READ_BUF,		"dareadbuf" },
-#define XFS_ERRTAG_BTREE_CHECK_LBLOCK                   8
 		{ XFS_ERRTAG_BTREE_CHECK_LBLOCK,	"btree_chk_lblk" },
-#define XFS_ERRTAG_BTREE_CHECK_SBLOCK                   9
 		{ XFS_ERRTAG_BTREE_CHECK_SBLOCK,	"btree_chk_sblk" },
-#define XFS_ERRTAG_ALLOC_READ_AGF                       10
 		{ XFS_ERRTAG_ALLOC_READ_AGF,		"readagf" },
-#define XFS_ERRTAG_IALLOC_READ_AGI                      11
 		{ XFS_ERRTAG_IALLOC_READ_AGI,		"readagi" },
-#define XFS_ERRTAG_ITOBP_INOTOBP                        12
 		{ XFS_ERRTAG_ITOBP_INOTOBP,		"itobp" },
-#define XFS_ERRTAG_IUNLINK                              13
 		{ XFS_ERRTAG_IUNLINK,			"iunlink" },
-#define XFS_ERRTAG_IUNLINK_REMOVE                       14
 		{ XFS_ERRTAG_IUNLINK_REMOVE,		"iunlinkrm" },
-#define XFS_ERRTAG_DIR_INO_VALIDATE                     15
 		{ XFS_ERRTAG_DIR_INO_VALIDATE,		"dirinovalid" },
-#define XFS_ERRTAG_BULKSTAT_READ_CHUNK                  16
 		{ XFS_ERRTAG_BULKSTAT_READ_CHUNK,	"bulkstat" },
-#define XFS_ERRTAG_IODONE_IOERR                         17
 		{ XFS_ERRTAG_IODONE_IOERR,		"logiodone" },
-#define XFS_ERRTAG_STRATREAD_IOERR                      18
 		{ XFS_ERRTAG_STRATREAD_IOERR,		"stratread" },
-#define XFS_ERRTAG_STRATCMPL_IOERR                      19
 		{ XFS_ERRTAG_STRATCMPL_IOERR,		"stratcmpl" },
-#define XFS_ERRTAG_DIOWRITE_IOERR                       20
 		{ XFS_ERRTAG_DIOWRITE_IOERR,		"diowrite" },
-#define XFS_ERRTAG_BMAPIFORMAT                          21
 		{ XFS_ERRTAG_BMAPIFORMAT,		"bmapifmt" },
-#define XFS_ERRTAG_FREE_EXTENT				22
 		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
-#define XFS_ERRTAG_RMAP_FINISH_ONE			23
 		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
-#define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
 		{ XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,	"refcount_continue_update" },
-#define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
 		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
-#define XFS_ERRTAG_BMAP_FINISH_ONE			26
 		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
-#define XFS_ERRTAG_AG_RESV_CRITICAL			27
 		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
-#define XFS_ERRTAG_DROP_WRITES				28
 		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
-#define XFS_ERRTAG_LOG_BAD_CRC				29
 		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
-#define XFS_ERRTAG_LOG_ITEM_PIN				30
 		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
-#define XFS_ERRTAG_MAX                                  31
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

