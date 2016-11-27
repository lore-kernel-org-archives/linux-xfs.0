Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36346 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbcK0Rfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 12:35:31 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] fs: xfs: libxfs: constify xfs_nameops structures
Date: Sun, 27 Nov 2016 23:05:01 +0530
Message-Id: <1480268101-30384-1-git-send-email-bhumirks@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: julia.lawall@lip6.fr, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>

Declare the structure xfs_nameops as const as it is only stored in the
m_dirnameops field of a xfs_mount structure. This field is of type
const struct xfs_nameops *, so xfs_nameops structures having this
property can be declared as const.
Done using Coccinelle:
@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct xfs_nameops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct xfs_mount mp;
@@
mp.m_dirnameops=&i@p

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
static
+const
struct xfs_nameops i={...};

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct xfs_nameops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
   5302	     85	      0	   5387	   150b	fs/xfs/libxfs/xfs_dir2.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   5318	     69	      0	   5387	   150b	fs/xfs/libxfs/xfs_dir2.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 20a96dd..c58d72c 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -93,7 +93,7 @@
 	return result;
 }
 
-static struct xfs_nameops xfs_ascii_ci_nameops = {
+static const struct xfs_nameops xfs_ascii_ci_nameops = {
 	.hashname	= xfs_ascii_ci_hashname,
 	.compname	= xfs_ascii_ci_compname,
 };
-- 
1.9.1

