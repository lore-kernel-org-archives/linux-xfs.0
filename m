Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbdLHESn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 23:18:43 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 31AED615CE5
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 22:18:41 -0600 (CST)
Subject: [PATCH 5/5] mkfs: remove use-once default macros
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bf7aac6f-dc75-d00f-d6ec-23599a8b156a@sandeen.net>
Date: Thu, 7 Dec 2017 22:18:42 -0600
MIME-Version: 1.0
In-Reply-To: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

sb_feat was a weird mishmash of hardcoded defaults and macros
(which were used in only this place).

Make it consistent by removing the use-once macros, and remove
the unused XFS_DFL_LOG_SIZE while we're in here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_multidisk.h | 3 ---
 mkfs/xfs_mkfs.c         | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index e5f53b7..54913d8 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -29,10 +29,7 @@
 #define	XFS_MIN_DATA_BLOCKS	100
 #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
-#define	XFS_IFLAG_ALIGN		true		/* -i align defaults on */
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
-#define	XFS_DFL_DIR_VERSION	2		/* default directory version */
-#define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
 #define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
 						/* with max trans reservation */
 #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3f6315d..a321ff2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3850,8 +3850,8 @@ main(
 		.sb_feat = {
 			.log_version = 2,
 			.attr_version = 2,
-			.dir_version = XFS_DFL_DIR_VERSION,
-			.inode_align = XFS_IFLAG_ALIGN,
+			.dir_version = 2,
+			.inode_align = true,
 			.nci = false,
 			.lazy_sb_counters = true,
 			.projid32bit = true,
-- 
1.8.3.1

