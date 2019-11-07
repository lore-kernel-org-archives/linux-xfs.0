Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAF3C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451B6206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X/kCOHE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfKGS0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44314 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfKGS0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qJUOno0KkWRjRFF3tK7w8TzeWeKbWmvu5memB9ckY5s=; b=X/kCOHE7N0mDbGnFOMt4CRF1vM
        o2znrABuiUX3gSwty+motcywyFyZkKLocNB+a3+PHoUTRntkq6asIfcDHlxp+AOaG89TG5YVrXUqO
        UDVW6ffVa/N7ihwkshKL8mqfutgRyQo581Cx5Xmup/Cxf75UHi/YYYAMUVH86+pRVE6o6VzSnVkJJ
        D1PNoOCK4w8qltoS6+iM3MZi4aZlKYb6CSWZPrgYPc61a+pFVI57skyfBTqrOIdFRc3lT2mRAnezZ
        s8AjXRBfWivvZD+6YdNMJNXyc+DPcJxhypVoveoPH1SBs8tW20DaV7nn/+79bIn7NW5tqgrrD9ZsX
        Cs97UHDQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTw-0004VN-4N; Thu, 07 Nov 2019 18:26:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 44/46] xfs: remove the now unused dir ops infrastructure
Date:   Thu,  7 Nov 2019 19:24:08 +0100
Message-Id: <20191107182410.12660-45-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile               |  1 -
 fs/xfs/libxfs/xfs_da_btree.h  |  1 -
 fs/xfs/libxfs/xfs_da_format.c | 46 -----------------------------------
 fs/xfs/libxfs/xfs_dir2.c      |  2 --
 fs/xfs/libxfs/xfs_dir2.h      |  9 -------
 fs/xfs/xfs_inode.h            |  3 ---
 fs/xfs/xfs_iops.c             |  1 -
 fs/xfs/xfs_mount.h            |  2 --
 8 files changed, 65 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_da_format.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 06b68b6115bc..aceca2f9a3db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -27,7 +27,6 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_bmap_btree.o \
 				   xfs_btree.o \
 				   xfs_da_btree.o \
-				   xfs_da_format.o \
 				   xfs_defer.o \
 				   xfs_dir2.o \
 				   xfs_dir2_block.o \
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 4ac2cc87c28f..5af4df71e92b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -10,7 +10,6 @@
 struct xfs_inode;
 struct xfs_trans;
 struct zone;
-struct xfs_dir_ops;
 
 /*
  * Directory/attribute geometry information. There will be one of these for each
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
deleted file mode 100644
index 498363ac193d..000000000000
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ /dev/null
@@ -1,46 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
- * Copyright (c) 2013 Red Hat, Inc.
- * All Rights Reserved.
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_inode.h"
-#include "xfs_dir2.h"
-#include "xfs_dir2_priv.h"
-
-static const struct xfs_dir_ops xfs_dir2_ops = {
-};
-
-static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
-};
-
-static const struct xfs_dir_ops xfs_dir3_ops = {
-};
-
-/*
- * Return the ops structure according to the current config.  If we are passed
- * an inode, then that overrides the default config we use which is based on
- * feature bits.
- */
-const struct xfs_dir_ops *
-xfs_dir_get_ops(
-	struct xfs_mount	*mp,
-	struct xfs_inode	*dp)
-{
-	if (dp)
-		return dp->d_ops;
-	if (mp->m_dir_inode_ops)
-		return mp->m_dir_inode_ops;
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return &xfs_dir3_ops;
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		return &xfs_dir2_ftype_ops;
-	return &xfs_dir2_ops;
-}
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index eccffe7a5ae0..624c05e77ab4 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -104,8 +104,6 @@ xfs_da_mount(
 	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
 
-	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
-
 	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
 				    KM_MAYFAIL);
 	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b44c64a20f67..a0cd423c79dd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -28,15 +28,6 @@ extern struct xfs_name	xfs_name_dotdot;
  */
 extern unsigned char xfs_mode_to_ftype(int mode);
 
-/*
- * directory operations vector for encode/decode routines
- */
-struct xfs_dir_ops {
-};
-
-extern const struct xfs_dir_ops *
-	xfs_dir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
-
 /*
  * Generic directory interface routines
  */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bcfb35a9c5ca..6516dd1fc86a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -37,9 +37,6 @@ typedef struct xfs_inode {
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
 
-	/* operations vectors */
-	const struct xfs_dir_ops *d_ops;		/* directory ops vector */
-
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 21e6d08e3e18..57e6e44123a9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1321,7 +1321,6 @@ xfs_setup_inode(
 		lockdep_set_class(&inode->i_rwsem,
 				  &inode->i_sb->s_type->i_mutex_dir_key);
 		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
-		ip->d_ops = ip->i_mount->m_dir_inode_ops;
 	} else {
 		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9719f2aa8be3..2dceb446e651 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -12,7 +12,6 @@ struct xfs_mru_cache;
 struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
-struct xfs_dir_ops;
 struct xfs_da_geometry;
 
 /* dynamic preallocation free space thresholds, 5% down to 1% */
@@ -156,7 +155,6 @@ typedef struct xfs_mount {
 	int			m_swidth;	/* stripe width */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
-	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
 	uint			m_chsize;	/* size of next field */
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
-- 
2.20.1

