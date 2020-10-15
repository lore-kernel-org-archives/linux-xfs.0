Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04523C43467
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49492224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgJOHWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60053 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728460AbgJOHWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:01 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 17F153AB132
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hv6-C6
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLO-40
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/27] xfsprogs: remove unused buffer tracing code
Date:   Thu, 15 Oct 2020 18:21:29 +1100
Message-Id: <20201015072155.1631135-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=iJ_Q7p5AKDy2pedFAgYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This isn't particularly useful for finding issues, it's rarely used
and complicates the conversion to the kernel buffer cache code. THe
kernel code also carries it's own trace hooks that could be
implemented if tracing is needed, so remove this code to make the
conversion simpler.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/libxfs_io.h |  49 ---------------
 libxfs/rdwr.c      | 149 ---------------------------------------------
 2 files changed, 198 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index e7ec754f6b86..9e65f4a63bfb 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -80,12 +80,6 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
 	struct list_head	b_list;
-#ifdef XFS_BUF_TRACING
-	struct list_head	b_lock_list;
-	const char		*b_func;
-	const char		*b_file;
-	int			b_line;
-#endif
 } xfs_buf_t;
 
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
@@ -129,47 +123,6 @@ extern struct cache_operations	libxfs_bcache_operations;
 /* Return the buffer even if the verifiers fail. */
 #define LIBXFS_READBUF_SALVAGE		(1 << 1)
 
-#ifdef XFS_BUF_TRACING
-
-#define libxfs_buf_read(dev, daddr, len, flags, bpp, ops) \
-	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags), (bpp), (ops))
-#define libxfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
-	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps), (flags), (bpp), (ops))
-#define libxfs_buf_mark_dirty(buf) \
-	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
-			      (buf))
-#define libxfs_buf_get(dev, daddr, len, bpp) \
-	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (bpp))
-#define libxfs_buf_get_map(dev, map, nmaps, flags, bpp) \
-	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps), (flags), (bpp))
-#define libxfs_buf_relse(buf) \
-	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
-
-int libxfs_trace_readbuf(const char *func, const char *file, int line,
-			struct xfs_buftarg *btp, xfs_daddr_t daddr, size_t len,
-			int flags, const struct xfs_buf_ops *ops,
-			struct xfs_buf **bpp);
-int libxfs_trace_readbuf_map(const char *func, const char *file, int line,
-			struct xfs_buftarg *btp, struct xfs_buf_map *maps,
-			int nmaps, int flags, struct xfs_buf **bpp,
-			const struct xfs_buf_ops *ops);
-void libxfs_trace_dirtybuf(const char *func, const char *file, int line,
-			struct xfs_buf *bp);
-int libxfs_trace_getbuf(const char *func, const char *file, int line,
-			struct xfs_buftarg *btp, xfs_daddr_t daddr,
-			size_t len, struct xfs_buf **bpp);
-int libxfs_trace_getbuf_map(const char *func, const char *file, int line,
-			struct xfs_buftarg *btp, struct xfs_buf_map *map,
-			int nmaps, int flags, struct xfs_buf **bpp);
-extern void	libxfs_trace_putbuf (const char *, const char *, int,
-			xfs_buf_t *);
-
-#else
-
 int libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
 			int nmaps, int flags, struct xfs_buf **bpp,
 			const struct xfs_buf_ops *ops);
@@ -204,8 +157,6 @@ libxfs_buf_read(
 	return libxfs_buf_read_map(target, &map, 1, flags, bpp, ops);
 }
 
-#endif /* XFS_BUF_TRACING */
-
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 79c1029b1109..51494f71fcfa 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -147,133 +147,6 @@ static char *next(
 	return ptr + offset;
 }
 
-/*
- * Simple I/O (buffer cache) interface
- */
-
-
-#ifdef XFS_BUF_TRACING
-
-#undef libxfs_buf_read_map
-#undef libxfs_writebuf
-#undef libxfs_buf_get_map
-
-int		libxfs_buf_read_map(struct xfs_buftarg *btp,
-				struct xfs_buf_map *maps, int nmaps, int flags,
-				struct xfs_buf **bpp,
-				const struct xfs_buf_ops *ops);
-int		libxfs_writebuf(xfs_buf_t *, int);
-int		libxfs_buf_get_map(struct xfs_buftarg *btp,
-				struct xfs_buf_map *maps, int nmaps, int flags,
-				struct xfs_buf **bpp);
-void		libxfs_buf_relse(struct xfs_buf *bp);
-
-#define	__add_trace(bp, func, file, line)	\
-do {						\
-	if (bp) {				\
-		(bp)->b_func = (func);		\
-		(bp)->b_file = (file);		\
-		(bp)->b_line = (line);		\
-	}					\
-} while (0)
-
-int
-libxfs_trace_readbuf(
-	const char		*func,
-	const char		*file,
-	int			line,
-	struct xfs_buftarg	*btp,
-	xfs_daddr_t		blkno,
-	size_t			len,
-	int			flags,
-	const struct xfs_buf_ops *ops,
-	struct xfs_buf		**bpp)
-{
-	int			error;
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-
-	error = libxfs_buf_read_map(btp, &map, 1, flags, bpp, ops);
-	__add_trace(*bpp, func, file, line);
-	return error;
-}
-
-int
-libxfs_trace_readbuf_map(
-	const char		*func,
-	const char		*file,
-	int			line,
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	int			flags,
-	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
-{
-	int			error;
-
-	error = libxfs_buf_read_map(btp, map, nmaps, flags, bpp, ops);
-	__add_trace(*bpp, func, file, line);
-	return error;
-}
-
-void
-libxfs_trace_dirtybuf(
-	const char		*func,
-	const char		*file,
-	int			line,
-	struct xfs_buf		*bp)
-{
-	__add_trace(bp, func, file, line);
-	libxfs_buf_mark_dirty(bp);
-}
-
-int
-libxfs_trace_getbuf(
-	const char		*func,
-	const char		*file,
-	int			line,
-	struct xfs_buftarg	*btp,
-	xfs_daddr_t		blkno,
-	size_t			len,
-	struct xfs_buf		**bpp)
-{
-	int			error;
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-
-	error = libxfs_buf_get_map(target, &map, 1, 0, bpp);
-	__add_trace(bp, func, file, line);
-	return error;
-}
-
-int
-libxfs_trace_getbuf_map(
-	const char		*func,
-	const char		*file,
-	int			line,
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	int			flags,
-	struct xfs_buf		**bpp)
-{
-	int			error;
-
-	error = libxfs_buf_get_map(btp, map, nmaps, flags, bpp);
-	__add_trace(*bpp, func, file, line);
-	return error;
-}
-
-void
-libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
-{
-	__add_trace(bp, func, file, line);
-	libxfs_buf_relse(bp);
-}
-
-
-#endif
-
-
 struct xfs_buf *
 libxfs_getsb(
 	struct xfs_mount	*mp)
@@ -369,9 +242,6 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		exit(1);
 	}
 	memset(bp->b_addr, 0, bytes);
-#ifdef XFS_BUF_TRACING
-	list_head_init(&bp->b_lock_list);
-#endif
 	pthread_mutex_init(&bp->b_lock, NULL);
 	bp->b_holder = 0;
 	bp->b_recur = 0;
@@ -513,11 +383,6 @@ libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
 	return bp;
 }
 
-#ifdef XFS_BUF_TRACING
-struct list_head	lock_buf_list = {&lock_buf_list, &lock_buf_list};
-int			lock_buf_count = 0;
-#endif
-
 static int
 __cache_lookup(
 	struct xfs_bufkey	*key,
@@ -562,12 +427,6 @@ __cache_lookup(
 
 	cache_node_set_priority(libxfs_bcache, cn,
 			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
-#ifdef XFS_BUF_TRACING
-	pthread_mutex_lock(&libxfs_bcache->c_mutex);
-	lock_buf_count++;
-	list_add(&bp->b_lock_list, &lock_buf_list);
-	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
-#endif
 #ifdef IO_DEBUG
 	printf("%lx %s: hit buffer %p for bno = 0x%llx/0x%llx\n",
 		pthread_self(), __FUNCTION__,
@@ -678,14 +537,6 @@ libxfs_buf_relse(
 	 * over to the next user.
 	 */
 	bp->b_error = 0;
-
-#ifdef XFS_BUF_TRACING
-	pthread_mutex_lock(&libxfs_bcache->c_mutex);
-	lock_buf_count--;
-	ASSERT(lock_buf_count >= 0);
-	list_del_init(&bp->b_lock_list);
-	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
-#endif
 	if (use_xfs_buf_lock) {
 		if (bp->b_recur) {
 			bp->b_recur--;
-- 
2.28.0

