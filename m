Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FB6C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5941207D8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jgsOxsIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404284AbgFYLb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404262AbgFYLb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:31:58 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9571C061573;
        Thu, 25 Jun 2020 04:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aZ5/VvBRxy1EdrAiC3gC+vdjhy3hMAejv9F0LfGr9Sg=; b=jgsOxsIbKipWm0r7hIyr6z1gah
        3PZ4Dz0R6SiF6+L0i4am4QAUWUwqLCTfWyluQSd8AqBXZp0r2uOE5jJnhwVc9HhJAqlr/Mfmn5042
        u40YVIeATMF7r2TplEtPv5uKrmht71dV/BnhWIvWOCJp9yoP6yzVxeif1wXToT2wnMu//AJSkJs37
        T3IMv13ZdFqwHDZkTTzMWFJD8WUxuQOQ+2GaB7lGNY2UwnkGYcDIIHu8vi8+fxeoRYizOPWG/veYs
        +xbGefGDeWYCpmVs7jz9IvHsisfZbfZiBc4iPPH2ymHAPJi7d+hKLvQpcEKTcn2UXSTVu/9x2CNVk
        r16LcG/g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6X-0001zW-0b; Thu, 25 Jun 2020 11:31:41 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3/6] xfs: Convert to memalloc_nofs_save
Date:   Thu, 25 Jun 2020 12:31:19 +0100
Message-Id: <20200625113122.7540-4-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of using custom macros to set/restore PF_MEMALLOC_NOFS, use
memalloc_nofs_save() like the rest of the kernel.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/xfs/kmem.c      |  2 +-
 fs/xfs/xfs_aops.c  |  4 ++--
 fs/xfs/xfs_buf.c   |  2 +-
 fs/xfs/xfs_linux.h |  6 ------
 fs/xfs/xfs_trans.c | 14 +++++++-------
 fs/xfs/xfs_trans.h |  2 +-
 6 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index f1366475c389..c2d237159bfc 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -35,7 +35,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
  * __vmalloc() will allocate data pages and auxiliary structures (e.g.
  * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
  * we need to tell memory reclaim that we are in such a context via
- * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
+ * memalloc_nofs to prevent memory reclaim re-entering the filesystem here
  * and potentially deadlocking.
  */
 static void *
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b35611882ff9..e3a4806e519d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	memalloc_nofs_restore(tp->t_memalloc);
 	return 0;
 }
 
@@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	tp->t_memalloc = memalloc_nofs_save();
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 20b748f7e186..b2c3d01c690b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -470,7 +470,7 @@ _xfs_buf_map_pages(
 		 * vm_map_ram() will allocate auxiliary structures (e.g.
 		 * pagetables) with GFP_KERNEL, yet we are likely to be under
 		 * GFP_NOFS context here. Hence we need to tell memory reclaim
-		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
+		 * that we are in such a context via memalloc_nofs to prevent
 		 * memory reclaim re-entering the filesystem here and
 		 * potentially deadlocking.
 		 */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9f70d2f68e05..e1daf242a53b 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -104,12 +104,6 @@ typedef __u32			xfs_nlink_t;
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
 #define current_test_flags(f)	(current->flags & (f))
-#define current_set_flags_nested(sp, f)		\
-		(*(sp) = current->flags, current->flags |= (f))
-#define current_clear_flags_nested(sp, f)	\
-		(*(sp) = current->flags, current->flags &= ~(f))
-#define current_restore_flags_nested(sp, f)	\
-		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBBY		8		/* number of bits per byte */
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..4ef1a0ff0a11 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -118,7 +118,7 @@ xfs_trans_dup(
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
-	ntp->t_pflags = tp->t_pflags;
+	ntp->t_memalloc = tp->t_memalloc;
 
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
@@ -153,7 +153,7 @@ xfs_trans_reserve(
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	tp->t_memalloc = memalloc_nofs_save();
 
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
@@ -163,7 +163,7 @@ xfs_trans_reserve(
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
 		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+			memalloc_nofs_restore(tp->t_memalloc);
 			return -ENOSPC;
 		}
 		tp->t_blk_res += blocks;
@@ -240,7 +240,7 @@ xfs_trans_reserve(
 		tp->t_blk_res = 0;
 	}
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	memalloc_nofs_restore(tp->t_memalloc);
 
 	return error;
 }
@@ -861,7 +861,7 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	memalloc_nofs_restore(tp->t_memalloc);
 	xfs_trans_free(tp);
 
 	/*
@@ -893,7 +893,7 @@ __xfs_trans_commit(
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	memalloc_nofs_restore(tp->t_memalloc);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
@@ -954,7 +954,7 @@ xfs_trans_cancel(
 	}
 
 	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	memalloc_nofs_restore(tp->t_memalloc);
 
 	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8308bf6d7e40..7aa2d5ff9245 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -118,6 +118,7 @@ typedef struct xfs_trans {
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
 	unsigned int		t_flags;	/* misc flags */
+	unsigned int		t_memalloc;	/* saved memalloc state */
 	xfs_fsblock_t		t_firstblock;	/* first block allocated */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
@@ -144,7 +145,6 @@ typedef struct xfs_trans {
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */
-	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
 /*
-- 
2.27.0

