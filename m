Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33050 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbdLFQQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 11:16:19 -0500
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH 22/45] fs: xfs: remove duplicate includes
Date: Wed,  6 Dec 2017 21:46:06 +0530
Message-Id: <1512576966-4303-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pravin.shedge4linux@gmail.com

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 fs/xfs/scrub/scrub.c | 1 -
 fs/xfs/scrub/trace.c | 1 -
 fs/xfs/xfs_reflink.c | 2 --
 fs/xfs/xfs_trace.c   | 1 -
 4 files changed, 5 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9c42c4e..ab3aef2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -46,7 +46,6 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-#include "scrub/scrub.h"
 #include "scrub/btree.h"
 
 /*
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 472080e..86daed0 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -26,7 +26,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cc041a2..cf7c8f8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -49,8 +49,6 @@
 #include "xfs_alloc.h"
 #include "xfs_quota_defs.h"
 #include "xfs_quota.h"
-#include "xfs_btree.h"
-#include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
 #include "xfs_rmap_btree.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 5d95fe3..35f3546 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -24,7 +24,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_da_format.h"
-#include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
-- 
2.7.4

