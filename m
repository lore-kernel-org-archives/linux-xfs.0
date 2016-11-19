Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34089 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbcKSNRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Nov 2016 08:17:07 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] fs: xfs: xfs_icreate_item: constify xfs_item_ops structure
Date: Sat, 19 Nov 2016 18:46:51 +0530
Message-Id: <1479561411-27987-1-git-send-email-bhumirks@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: julia.lawall@lip6.fr, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>

Declare the structure xfs_item_ops as const as it is only passed as an
argument to the function xfs_log_item_init. As this argument is of type
const struct xfs_item_ops *, so xfs_item_ops structures having this
property can be declared as const.
Done using Coccinelle:

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct xfs_item_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
expression e1,e2,e3;
@@
xfs_log_item_init(e1,e2,e3,&i@p)

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
struct xfs_item_ops i={...};

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct xfs_item_ops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
    737	     64	      8	    809	    329	fs/xfs/xfs_icreate_item.o

File size after:
   text	   data	    bss	    dec	    hex	filename
    801	      0	      8	    809	    329	fs/xfs/xfs_icreate_item.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 fs/xfs/xfs_icreate_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index d45ca72..865ad13 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -133,7 +133,7 @@ static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
 /*
  * This is the ops vector shared by all buf log items.
  */
-static struct xfs_item_ops xfs_icreate_item_ops = {
+static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
 	.iop_pin	= xfs_icreate_item_pin,
-- 
1.9.1

