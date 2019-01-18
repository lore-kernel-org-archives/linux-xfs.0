Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfARLKm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jan 2019 06:10:42 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CD03C056796
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jan 2019 11:10:42 +0000 (UTC)
From: Marco Benatto <mbenatto@redhat.com>
Subject: [PATCH] xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask
Date: Fri, 18 Jan 2019 06:10:37 -0500
Message-Id: <1547809837-8147-1-git-send-email-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, mbenatto@redhat.com
Cc: sandeen@redhat.com

Currently we have a few PTAGs in place allowing us
to transform a filesystem error in a BUG() call. However
we still none of them could perform such task during
XFS buffer verifier error, this patche introduces the
XFS_PTAG_VERIFIER_ERROR with value 0x00000100. When
fs.xfs.panic_mask sysctl knob is set to XFS_PTAG_VERIFIER_ERROR
XFS will convert any error detected by buffer verifiers into a
kernel panic.

Signed-off-by: Marco Benatto <mbenatto@redhat.com>
---
 Documentation/filesystems/xfs.txt | 3 ++-
 fs/xfs/xfs_error.c                | 2 +-
 fs/xfs/xfs_error.h                | 1 +
 fs/xfs/xfs_globals.c              | 2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 9ccfd1b..a5cbb5e 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -272,7 +272,7 @@ The following sysctls are available for the XFS filesystem:
 		XFS_ERRLEVEL_LOW:       1
 		XFS_ERRLEVEL_HIGH:      5
 
-  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 255)
+  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
 	Causes certain error conditions to call BUG(). Value is a bitmask;
 	OR together the tags which represent errors which should cause panics:
 
@@ -285,6 +285,7 @@ The following sysctls are available for the XFS filesystem:
 		XFS_PTAG_SHUTDOWN_IOERROR       0x00000020
 		XFS_PTAG_SHUTDOWN_LOGERROR      0x00000040
 		XFS_PTAG_FSBLOCK_ZERO           0x00000080
+		XFS_PTAG_VERIFIER_ERROR         0x00000100
 
 	This option is intended for debugging only.
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f54..e2ef710 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -357,7 +357,7 @@ struct xfs_errortag_attr {
 	fa = failaddr ? failaddr : __return_address;
 	__xfs_buf_ioerror(bp, error, fa);
 
-	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx %s",
+	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR, "Metadata %s detected at %pS, %s block 0x%llx %s",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  fa, bp->b_ops->name, bp->b_bn, name);
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 246d3e9..602aa7d 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -98,5 +98,6 @@ extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
 #define		XFS_PTAG_SHUTDOWN_IOERROR	0x00000020
 #define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
 #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
+#define		XFS_PTAG_VERIFIER_ERROR		0x00000100
 
 #endif	/* __XFS_ERROR_H__ */
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 5169e84..d0d3773 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -16,7 +16,7 @@
 			  /*	MIN		DFLT		MAX	*/
 	.sgid_inherit	= {	0,		0,		1	},
 	.symlink_mode	= {	0,		0,		1	},
-	.panic_mask	= {	0,		0,		255	},
+	.panic_mask	= {	0,		0,		256	},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
 	.stats_clear	= {	0,		0,		1	},
-- 
1.8.3.1
