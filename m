Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEEAC11F69
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6758A61D01
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhF3GRG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:17:06 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52899 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231587AbhF3GRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:17:06 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6BD31106B0F;
        Wed, 30 Jun 2021 16:14:35 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTUY-0012JN-Lg; Wed, 30 Jun 2021 16:14:34 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTUY-007LTw-E7; Wed, 30 Jun 2021 16:14:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3] xfs: replace kmem_alloc_large() with kvmalloc()
Date:   Wed, 30 Jun 2021 16:14:31 +1000
Message-Id: <20210630061431.1750745-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630061431.1750745-1-david@fromorbit.com>
References: <20210630061431.1750745-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=dSPyfIX0mPSTpOhiuKoA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is no reason for this wrapper existing anymore. All the places
that use KM_NOFS allocation are within transaction contexts and
hence covered by memalloc_nofs_save/restore contexts. Hence we don't
need any special handling of vmalloc for large IOs anymore and
so special casing this code isn't necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/kmem.c                 | 39 -----------------------------------
 fs/xfs/kmem.h                 |  1 -
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/scrub/attr.c           | 14 +++++++------
 fs/xfs/scrub/attr.h           |  3 ---
 fs/xfs/xfs_log.c              |  4 ++--
 fs/xfs/xfs_log_cil.c          | 10 ++++++++-
 fs/xfs/xfs_log_recover.c      |  2 +-
 fs/xfs/xfs_trace.h            |  1 -
 9 files changed, 21 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 3f2979fd2f2b..6f49bf39183c 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -29,42 +29,3 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
-
-
-/*
- * __vmalloc() will allocate data pages and auxiliary structures (e.g.
- * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
- * we need to tell memory reclaim that we are in such a context via
- * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
- * and potentially deadlocking.
- */
-static void *
-__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
-{
-	unsigned nofs_flag = 0;
-	void	*ptr;
-	gfp_t	lflags = kmem_flags_convert(flags);
-
-	if (flags & KM_NOFS)
-		nofs_flag = memalloc_nofs_save();
-
-	ptr = __vmalloc(size, lflags);
-
-	if (flags & KM_NOFS)
-		memalloc_nofs_restore(nofs_flag);
-
-	return ptr;
-}
-
-void *
-kmem_alloc_large(size_t size, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	trace_kmem_alloc_large(size, flags, _RET_IP_);
-
-	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
-	if (ptr)
-		return ptr;
-	return __kmem_vmalloc(size, flags);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 9ff20047f8b8..54da6d717a06 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 }
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
-extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
 	kvfree(ptr);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b910bd209949..16d64872acc0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -489,7 +489,7 @@ xfs_attr_copy_value(
 	}
 
 	if (!args->value) {
-		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
+		args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);
 		if (!args->value)
 			return -ENOMEM;
 	}
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 552af0cf8482..6c36af6dbd35 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -25,11 +25,11 @@
  * reallocating the buffer if necessary.  Buffer contents are not preserved
  * across a reallocation.
  */
-int
+static int
 xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
 	size_t			value_size,
-	xfs_km_flags_t		flags)
+	gfp_t			flags)
 {
 	size_t			sz;
 	struct xchk_xattr_buf	*ab = sc->buf;
@@ -57,7 +57,7 @@ xchk_setup_xattr_buf(
 	 * Don't zero the buffer upon allocation to avoid runtime overhead.
 	 * All users must be careful never to read uninitialized contents.
 	 */
-	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
+	ab = kvmalloc(sizeof(*ab) + sz, flags);
 	if (!ab)
 		return -ENOMEM;
 
@@ -79,7 +79,7 @@ xchk_setup_xattr(
 	 * without the inode lock held, which means we can sleep.
 	 */
 	if (sc->flags & XCHK_TRY_HARDER) {
-		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, 0);
+		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, GFP_KERNEL);
 		if (error)
 			return error;
 	}
@@ -138,7 +138,8 @@ xchk_xattr_listent(
 	 * doesn't work, we overload the seen_enough variable to convey
 	 * the error message back to the main scrub function.
 	 */
-	error = xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
+	error = xchk_setup_xattr_buf(sx->sc, valuelen,
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (error == -ENOMEM)
 		error = -EDEADLOCK;
 	if (error) {
@@ -323,7 +324,8 @@ xchk_xattr_block(
 		return 0;
 
 	/* Allocate memory for block usage checking. */
-	error = xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
+	error = xchk_setup_xattr_buf(ds->sc, 0,
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (error == -ENOMEM)
 		return -EDEADLOCK;
 	if (error)
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 13a1d2e8424d..1719e1c4da59 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -65,7 +65,4 @@ xchk_xattr_dstmap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
-int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
-		xfs_km_flags_t flags);
-
 #endif	/* __XFS_SCRUB_ATTR_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5f6fc0ee4584..71fd8c0cad92 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1462,8 +1462,8 @@ xlog_alloc_log(
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
-						KM_MAYFAIL | KM_ZERO);
+		iclog->ic_data = kvzalloc(log->l_iclog_size,
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_data)
 			goto out_free_iclog;
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b128aaa9b870..d162e8b83e90 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -185,7 +185,15 @@ xlog_cil_alloc_shadow_bufs(
 			 */
 			kmem_free(lip->li_lv_shadow);
 
-			lv = kmem_alloc_large(buf_size, KM_NOFS);
+			/*
+			 * We are in transaction context, which means this
+			 * allocation will pick up GFP_NOFS from the
+			 * memalloc_nofs_save/restore context the transaction
+			 * holds. This means we can use GFP_KERNEL here so the
+			 * generic kvmalloc() code will run vmalloc on
+			 * contiguous page allocation failure as we require.
+			 */
+			lv = kvmalloc(buf_size, GFP_KERNEL);
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
 			lv->lv_item = lip;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cc559815e08f..1a291bf50776 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -106,7 +106,7 @@ xlog_alloc_buffer(
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);
+	return kvzalloc(BBTOB(nbblks), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6865e838a71b..38f2f67303f7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3689,7 +3689,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
 	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
 	TP_ARGS(size, flags, caller_ip))
 DEFINE_KMEM_EVENT(kmem_alloc);
-DEFINE_KMEM_EVENT(kmem_alloc_large);
 
 TRACE_EVENT(xfs_check_new_dalign,
 	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
-- 
2.31.1

