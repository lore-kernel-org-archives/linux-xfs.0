Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B72AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A432606A5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIOXIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXIF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C27F600D4;
        Wed, 15 Sep 2021 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747206;
        bh=fhMKfQR0w/iOzdOuz2Edc1i0i6yRSPzb3TkriaKtr5g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bAD+q0ePBqgCz2ze0IPF6GSAOs71x+tO2iaLpAf+eKtxXnLyYTni8kPwNPIpDygkc
         /U4DEBtRWsZd0w7vkNFRtxpOEb//nFNFeM/6564KPrIrajlAXdkXV36Y6vjml0AJYs
         aEtrF/MxKHbjFDoirhTQgBSzY5yIo1VR86zJ+73gC9122y1g9L+ZD0Mk27PQQsh/NZ
         3YoQyaaafrLyvHp8NCQbcm0/lki5SUS7yKzz3zhAAiCQzg5DXr/tlB5RGGfGrT+CqZ
         1vQmB8rzMbq9A6yW6KWaDuodR4z6xYwk2+l4pZcmkUz5+jD44V5SWE3dqiRLDGyb0m
         2KBlWS2lBJ5Jg==
Subject: [PATCH 02/61] libfrog: move topology.[ch] to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:06:45 -0700
Message-ID: <163174720579.350433.12686413907945599656.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The topology code depends on a few libxfs structures and is only needed
by mkfs and xfs_repair.  Move this code to libxfs to reduce the size of
libfrog and to avoid build failures caused by "xfs: move perag structure
and setup to libxfs/xfs_ag.[ch]".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h   |    1 +
 libfrog/Makefile   |    2 --
 libxfs/Makefile    |   10 ++++++----
 libxfs/topology.c  |    5 ++---
 libxfs/topology.h  |    6 +++---
 mkfs/xfs_mkfs.c    |    1 -
 repair/sb.c        |    1 -
 7 files changed, 12 insertions(+), 14 deletions(-)
 rename libfrog/topology.c => libxfs/topology.c (99%)
 rename libfrog/topology.h => libxfs/topology.h (88%)


diff --git a/include/libxfs.h b/include/libxfs.h
index bc07655e..36ae86cc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -213,5 +213,6 @@ int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 
 #include "xfs_attr.h"
+#include "topology.h"
 
 #endif	/* __LIBXFS_H__ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 395ce308..01107082 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -27,7 +27,6 @@ projects.c \
 ptvar.c \
 radix-tree.c \
 scrub.c \
-topology.c \
 util.c \
 workqueue.c
 
@@ -47,7 +46,6 @@ projects.h \
 ptvar.h \
 radix-tree.h \
 scrub.h \
-topology.h \
 workqueue.h
 
 LSRCFILES += gen_crc32table.c
diff --git a/libxfs/Makefile b/libxfs/Makefile
index de595b7c..3e3c4bd0 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -20,6 +20,11 @@ PKGHFILES = xfs_fs.h \
 	xfs_log_format.h
 
 HFILES = \
+	libxfs_io.h \
+	libxfs_api_defs.h \
+	init.h \
+	libxfs_priv.h \
+	topology.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
@@ -48,10 +53,6 @@ HFILES = \
 	xfs_shared.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
-	libxfs_io.h \
-	libxfs_api_defs.h \
-	init.h \
-	libxfs_priv.h \
 	xfs_dir2_priv.h
 
 CFILES = cache.c \
@@ -60,6 +61,7 @@ CFILES = cache.c \
 	kmem.c \
 	logitem.c \
 	rdwr.c \
+	topology.c \
 	trans.c \
 	util.c \
 	xfs_ag.c \
diff --git a/libfrog/topology.c b/libxfs/topology.c
similarity index 99%
rename from libfrog/topology.c
rename to libxfs/topology.c
index b1b470c9..a17c1969 100644
--- a/libfrog/topology.c
+++ b/libxfs/topology.c
@@ -4,14 +4,13 @@
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
+#include "libxfs_priv.h"
 #include "libxcmd.h"
 #ifdef ENABLE_BLKID
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
-#include "topology.h"
-#include "platform.h"
+#include "libfrog/platform.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/libfrog/topology.h b/libxfs/topology.h
similarity index 88%
rename from libfrog/topology.h
rename to libxfs/topology.h
index 6fde868a..1a0fe24c 100644
--- a/libfrog/topology.h
+++ b/libxfs/topology.h
@@ -4,8 +4,8 @@
  * All Rights Reserved.
  */
 
-#ifndef __LIBFROG_TOPOLOGY_H__
-#define __LIBFROG_TOPOLOGY_H__
+#ifndef __LIBXFS_TOPOLOGY_H__
+#define __LIBXFS_TOPOLOGY_H__
 
 /*
  * Device topology information.
@@ -36,4 +36,4 @@ extern int
 check_overwrite(
 	const char	*device);
 
-#endif	/* __LIBFROG_TOPOLOGY_H__ */
+#endif	/* __LIBXFS_TOPOLOGY_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 16e347e5..53904677 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,6 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
-#include "libfrog/topology.h"
 #include "libfrog/convert.h"
 #include "proto.h"
 #include <ini.h>
diff --git a/repair/sb.c b/repair/sb.c
index 17ce43cc..90f32e74 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,7 +12,6 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
-#include "libfrog/topology.h"
 
 #define BSIZE	(1024 * 1024)
 

