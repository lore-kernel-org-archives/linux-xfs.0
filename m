Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F8CC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 06:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9376D21D6C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 06:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfKGGIN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 01:08:13 -0500
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:58411 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbfKGGIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 01:08:12 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2019 01:08:11 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 7288D1802E617
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 06:01:30 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id EDACC182CED28;
        Thu,  7 Nov 2019 06:01:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: oven08_470620914dc0d
X-Filterd-Recvd-Size: 7435
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu,  7 Nov 2019 06:01:27 +0000 (UTC)
Message-ID: <0ceb6a89da4424a4500789610fae4d05ba45ba86.camel@perches.com>
Subject: [PATCH] xfs: Correct comment tyops -> typos
From:   Joe Perches <joe@perches.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 06 Nov 2019 22:01:15 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just fix the typos checkpatch notices...

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/kmem.c                  | 2 +-
 fs/xfs/libxfs/xfs_alloc.c      | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  | 2 +-
 fs/xfs/libxfs/xfs_da_format.h  | 2 +-
 fs/xfs/libxfs/xfs_fs.h         | 2 +-
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 fs/xfs/xfs_buf.c               | 2 +-
 fs/xfs/xfs_log_cil.c           | 4 ++--
 fs/xfs/xfs_symlink.h           | 2 +-
 fs/xfs/xfs_trans_ail.c         | 8 ++++----
 10 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index da031b9..1da942 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -32,7 +32,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 
 
 /*
- * __vmalloc() will allocate data pages and auxillary structures (e.g.
+ * __vmalloc() will allocate data pages and auxiliary structures (e.g.
  * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
  * we need to tell memory reclaim that we are in such a context via
  * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f7a4b5..b39bd8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1488,7 +1488,7 @@ xfs_alloc_ag_vextent_near(
 	dofirst = prandom_u32() & 1;
 #endif
 
-	/* handle unitialized agbno range so caller doesn't have to */
+	/* handle uninitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
 		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
 	ASSERT(args->min_agbno <= args->max_agbno);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index dca884..8ba3ae8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -829,7 +829,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 }
 
 /*
- * Retreive the attribute value and length.
+ * Retrieve the attribute value and length.
  *
  * If ATTR_KERNOVAL is specified, only the length needs to be returned.
  * Unlike a lookup, we only return an error if the attribute does not
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ae654e0..6702a08 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -482,7 +482,7 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
 }
 
 /*
- * Free space block defintions for the node format.
+ * Free space block definitions for the node format.
  */
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e9371a..038a16a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -416,7 +416,7 @@ struct xfs_bulkstat {
 
 /*
  * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was choosen
+ * and using two 16bit values to hold new 32bit projid was chosen
  * to retain compatibility with "old" filesystems).
  */
 static inline uint32_t
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c6..8ef31d7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -432,9 +432,9 @@ static inline uint xfs_log_dinode_size(int version)
 }
 
 /*
- * Buffer Log Format defintions
+ * Buffer Log Format definitions
  *
- * These are the physical dirty bitmap defintions for the log format structure.
+ * These are the physical dirty bitmap definitions for the log format structure.
  */
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1e63dd3..2ed3c65 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -461,7 +461,7 @@ _xfs_buf_map_pages(
 		unsigned nofs_flag;
 
 		/*
-		 * vm_map_ram() will allocate auxillary structures (e.g.
+		 * vm_map_ram() will allocate auxiliary structures (e.g.
 		 * pagetables) with GFP_KERNEL, yet we are likely to be under
 		 * GFP_NOFS context here. Hence we need to tell memory reclaim
 		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a120442..48435c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -179,7 +179,7 @@ xlog_cil_alloc_shadow_bufs(
 
 			/*
 			 * We free and allocate here as a realloc would copy
-			 * unecessary data. We don't use kmem_zalloc() for the
+			 * unnecessary data. We don't use kmem_zalloc() for the
 			 * same reason - we don't need to zero the data area in
 			 * the buffer, only the log vector header and the iovec
 			 * storage.
@@ -682,7 +682,7 @@ xlog_cil_push(
 	}
 
 
-	/* check for a previously pushed seqeunce */
+	/* check for a previously pushed sequence */
 	if (push_seq < cil->xc_ctx->sequence) {
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index 9743d8c..b1fa09 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -5,7 +5,7 @@
 #ifndef __XFS_SYMLINK_H
 #define __XFS_SYMLINK_H 1
 
-/* Kernel only symlink defintions */
+/* Kernel only symlink definitions */
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index aea71e..00cc5b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -427,15 +427,15 @@ xfsaild_push(
 
 		case XFS_ITEM_FLUSHING:
 			/*
-			 * The item or its backing buffer is already beeing
+			 * The item or its backing buffer is already being
 			 * flushed.  The typical reason for that is that an
 			 * inode buffer is locked because we already pushed the
 			 * updates to it as part of inode clustering.
 			 *
 			 * We do not want to to stop flushing just because lots
-			 * of items are already beeing flushed, but we need to
+			 * of items are already being flushed, but we need to
 			 * re-try the flushing relatively soon if most of the
-			 * AIL is beeing flushed.
+			 * AIL is being flushed.
 			 */
 			XFS_STATS_INC(mp, xs_push_ail_flushing);
 			trace_xfs_ail_flushing(lip);
@@ -612,7 +612,7 @@ xfsaild(
  * The push is run asynchronously in a workqueue, which means the caller needs
  * to handle waiting on the async flush for space to become available.
  * We don't want to interrupt any push that is in progress, hence we only queue
- * work if we set the pushing bit approriately.
+ * work if we set the pushing bit appropriately.
  *
  * We do this unlocked - we only need to know whether there is anything in the
  * AIL at the time we are called. We don't need to access the contents of


