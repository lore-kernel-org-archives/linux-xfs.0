Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31476EB8FA5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Sep 2023 07:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjIFHdb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Sep 2023 03:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjIFHdb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2023 03:33:31 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712CDCA
        for <linux-xfs@vger.kernel.org>; Wed,  6 Sep 2023 00:33:24 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id BD977587042A6; Wed,  6 Sep 2023 09:33:19 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 6BF0E5870428A;
        Wed,  6 Sep 2023 09:33:19 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [PATCH] xfs: compact repeated Kconfig expression "depends on XFS_FS"
Date:   Wed,  6 Sep 2023 09:33:19 +0200
Message-ID: <20230906073319.10239-1-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make issues like v5.9-rc4-90-g894645546bb1 not happen by enclosing
the entirety of XFS options in an if..endif block, which is equivalent
to having "depends on XFS_FS" spelled out everywhere, but shorter.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 fs/xfs/Kconfig | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index c9d653168ad0..2f5ae62eb528 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -22,9 +22,10 @@ config XFS_FS
 	  system of your root partition is compiled as a module, you'll need
 	  to use an initial ramdisk (initrd) to boot.
 
+if XFS_FS
+
 config XFS_SUPPORT_V4
 	bool "Support deprecated V4 (crc=0) format"
-	depends on XFS_FS
 	default y
 	help
 	  The V4 filesystem format lacks certain features that are supported
@@ -49,7 +50,6 @@ config XFS_SUPPORT_V4
 
 config XFS_SUPPORT_ASCII_CI
 	bool "Support deprecated case-insensitive ascii (ascii-ci=1) format"
-	depends on XFS_FS
 	default y
 	help
 	  The ASCII case insensitivity filesystem feature only works correctly
@@ -76,7 +76,6 @@ config XFS_SUPPORT_ASCII_CI
 
 config XFS_QUOTA
 	bool "XFS Quota support"
-	depends on XFS_FS
 	select QUOTACTL
 	help
 	  If you say Y here, you will be able to set limits for disk usage on
@@ -94,7 +93,6 @@ config XFS_QUOTA
 
 config XFS_POSIX_ACL
 	bool "XFS POSIX ACL support"
-	depends on XFS_FS
 	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
@@ -104,7 +102,6 @@ config XFS_POSIX_ACL
 
 config XFS_RT
 	bool "XFS Realtime subvolume support"
-	depends on XFS_FS
 	help
 	  If you say Y here you will be able to mount and use XFS filesystems
 	  which contain a realtime subvolume.  The realtime subvolume is a
@@ -127,7 +124,6 @@ config XFS_DRAIN_INTENTS
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
-	depends on XFS_FS
 	depends on TMPFS && SHMEM
 	select XFS_DRAIN_INTENTS
 	help
@@ -163,7 +159,7 @@ config XFS_ONLINE_SCRUB_STATS
 config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
-	depends on XFS_FS && XFS_ONLINE_SCRUB
+	depends on XFS_ONLINE_SCRUB
 	help
 	  If you say Y here you will be able to repair metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
@@ -180,7 +176,7 @@ config XFS_ONLINE_REPAIR
 
 config XFS_WARN
 	bool "XFS Verbose Warnings"
-	depends on XFS_FS && !XFS_DEBUG
+	depends on !XFS_DEBUG
 	help
 	  Say Y here to get an XFS build with many additional warnings.
 	  It converts ASSERT checks to WARN, so will log any out-of-bounds
@@ -193,7 +189,6 @@ config XFS_WARN
 
 config XFS_DEBUG
 	bool "XFS Debugging support"
-	depends on XFS_FS
 	help
 	  Say Y here to get an XFS build with many debugging features,
 	  including ASSERT checks, function wrappers around macros,
@@ -207,7 +202,7 @@ config XFS_DEBUG
 config XFS_ASSERT_FATAL
 	bool "XFS fatal asserts"
 	default y
-	depends on XFS_FS && XFS_DEBUG
+	depends on XFS_DEBUG
 	help
 	  Set the default DEBUG mode ASSERT failure behavior.
 
@@ -216,3 +211,5 @@ config XFS_ASSERT_FATAL
 	  result in warnings.
 
 	  This behavior can be modified at runtime via sysfs.
+
+endif # XFS_FS
-- 
2.42.0

