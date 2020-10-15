Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E0FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9D332224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgJOHWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:43 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35826 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728392AbgJOHWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:43 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0700858C570
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-000hwI-Cp
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaH-006qMZ-20
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/27] libxfs: switch buffer cache implementations
Date:   Thu, 15 Oct 2020 18:21:53 +1100
Message-Id: <20201015072155.1631135-26-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=wIcCdzY_pmorTOpEkQgA:9
        a=v3FHa_nPBJHDIGtQ:21 a=AMmKO-6J1qPD4baX:21 a=EKxlx_PzuCv-lRdM:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now the kernel buffer cache code is present, switch to using it.
This kills off most of the old read/write code, and the cache
implementation used to support it.

This requires changes to xfs_repair to handle cache usage reporting
changes, along with how it sets up the cache sizes as we are moving
from a single global cache to per-ag caches and so needs different
logic. Cache size is controlled purely by manual purging - it will
not respond to memory pressure or size limits yet.

XXX: xfs_buf_ioerror_alert() causes LTO linking failures in
xfs_copy (and only xfs_copy, so a real WTF), so it's
single caller in xfs_buf.c is commented out.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c          |   8 +-
 db/io.c                  |   4 +-
 include/Makefile         |   1 -
 include/cache.h          | 133 ------
 include/libxfs.h         |  23 +-
 include/xfs_inode.h      |   1 -
 include/xfs_mount.h      |   7 +
 libxfs/Makefile          |   2 -
 libxfs/buftarg.c         | 150 ++-----
 libxfs/cache.c           | 724 --------------------------------
 libxfs/init.c            |  74 ++--
 libxfs/libxfs_api_defs.h |   4 +
 libxfs/libxfs_priv.h     |  13 -
 libxfs/rdwr.c            | 869 +--------------------------------------
 libxfs/trans.c           |   1 -
 libxfs/util.c            |   1 -
 libxfs/xfs_buf.c         |  97 +++--
 libxfs/xfs_buf.h         |  51 ++-
 libxfs/xfs_buftarg.h     |  75 ++--
 mkfs/xfs_mkfs.c          |  19 +-
 repair/attr_repair.c     |   6 +-
 repair/da_util.c         |   2 +-
 repair/dino_chunks.c     |   4 +-
 repair/dinode.c          |   4 +-
 repair/phase3.c          |   7 +-
 repair/phase4.c          |   5 +-
 repair/prefetch.c        |  65 +--
 repair/progress.c        |  12 +-
 repair/progress.h        |   4 +-
 repair/scan.c            |   6 +-
 repair/xfs_repair.c      | 190 +++++----
 31 files changed, 400 insertions(+), 2162 deletions(-)
 delete mode 100644 include/cache.h
 delete mode 100644 libxfs/cache.c

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 5d72e6451650..6caf95a6c8ce 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -17,7 +17,7 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+//extern int	platform_check_ismounted(char *, char *, struct stat *, int);
 
 static char 		*logfile_name;
 static FILE		*logerr;
@@ -49,8 +49,6 @@ static pthread_mutex_t	mainwait;
 #define ACTIVE		1
 #define INACTIVE	2
 
-xfs_off_t	write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
-xfs_off_t	write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
 static int	format_logs(struct xfs_mount *);
 
 /* general purpose message reporting routine */
@@ -1261,7 +1259,7 @@ next_log_chunk(char *p, int offset, void *private)
  *
  * Returns the next buffer-length-aligned disk address.
  */
-xfs_off_t
+static xfs_off_t
 write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
 {
 	char		*p = buf->data;
@@ -1293,7 +1291,7 @@ write_log_header(int fd, wbuf *buf, xfs_mount_t *mp)
  * the start of that buffer).  Returns the disk address at the
  * end of last aligned buffer in the log.
  */
-xfs_off_t
+static xfs_off_t
 write_log_trailer(int fd, wbuf *buf, xfs_mount_t *mp)
 {
 	xfs_off_t	logend;
diff --git a/db/io.c b/db/io.c
index 6ba2540d89ef..65bc6ec4001b 100644
--- a/db/io.c
+++ b/db/io.c
@@ -525,11 +525,11 @@ set_cur(
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
 		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
-				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
+				bbmap->nmaps, XBF_SALVAGE, &bp,
 				ops);
 	} else {
 		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
-				LIBXFS_READBUF_SALVAGE, &bp, ops);
+				XBF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
 
diff --git a/include/Makefile b/include/Makefile
index 0bd529545dfc..b6f12a801a26 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -11,7 +11,6 @@ LIBHFILES = libxfs.h \
 	libxcmd.h \
 	atomic.h \
 	bitops.h \
-	cache.h \
 	completion.h \
 	hlist.h \
 	kmem.h \
diff --git a/include/cache.h b/include/cache.h
deleted file mode 100644
index 334ad26309e2..000000000000
--- a/include/cache.h
+++ /dev/null
@@ -1,133 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __CACHE_H__
-#define __CACHE_H__
-
-/*
- * initialisation flags
- */
-/*
- * xfs_db always writes changes immediately, and so we need to purge buffers
- * when we get a buffer lookup mismatch due to reading the same block with a
- * different buffer configuration.
- */
-#define CACHE_MISCOMPARE_PURGE	(1 << 0)
-
-/*
- * cache object campare return values
- */
-enum {
-	CACHE_HIT,
-	CACHE_MISS,
-	CACHE_PURGE,
-};
-
-#define	HASH_CACHE_RATIO	8
-
-/*
- * Cache priorities range from BASE to MAX.
- *
- * For prefetch support, the top half of the range starts at
- * CACHE_PREFETCH_PRIORITY and everytime the buffer is fetched and is at or
- * above this priority level, it is reduced to below this level (refer to
- * libxfs_buf_get).
- *
- * If we have dirty nodes, we can't recycle them until they've been cleaned. To
- * keep these out of the reclaimable lists (as there can be lots of them) give
- * them their own priority that the shaker doesn't attempt to walk.
- */
-
-#define CACHE_BASE_PRIORITY	0
-#define CACHE_PREFETCH_PRIORITY	8
-#define CACHE_MAX_PRIORITY	15
-#define CACHE_DIRTY_PRIORITY	(CACHE_MAX_PRIORITY + 1)
-#define CACHE_NR_PRIORITIES	CACHE_DIRTY_PRIORITY
-
-/*
- * Simple, generic implementation of a cache (arbitrary data).
- * Provides a hash table with a capped number of cache entries.
- */
-
-struct cache;
-struct cache_node;
-
-typedef void *cache_key_t;
-
-typedef void (*cache_walk_t)(struct cache_node *);
-typedef struct cache_node * (*cache_node_alloc_t)(cache_key_t);
-typedef int (*cache_node_flush_t)(struct cache_node *);
-typedef void (*cache_node_relse_t)(struct cache_node *);
-typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int,
-					  unsigned int);
-typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
-typedef unsigned int (*cache_bulk_relse_t)(struct cache *, struct list_head *);
-
-struct cache_operations {
-	cache_node_hash_t	hash;
-	cache_node_alloc_t	alloc;
-	cache_node_flush_t	flush;
-	cache_node_relse_t	relse;
-	cache_node_compare_t	compare;
-	cache_bulk_relse_t	bulkrelse;	/* optional */
-};
-
-struct cache_hash {
-	struct list_head	ch_list;	/* hash chain head */
-	unsigned int		ch_count;	/* hash chain length */
-	pthread_mutex_t		ch_mutex;	/* hash chain mutex */
-};
-
-struct cache_mru {
-	struct list_head	cm_list;	/* MRU head */
-	unsigned int		cm_count;	/* MRU length */
-	pthread_mutex_t		cm_mutex;	/* MRU lock */
-};
-
-struct cache_node {
-	struct list_head	cn_hash;	/* hash chain */
-	struct list_head	cn_mru;		/* MRU chain */
-	unsigned int		cn_count;	/* reference count */
-	unsigned int		cn_hashidx;	/* hash chain index */
-	int			cn_priority;	/* priority, -1 = free list */
-	int			cn_old_priority;/* saved pre-dirty prio */
-	pthread_mutex_t		cn_mutex;	/* node mutex */
-};
-
-struct cache {
-	int			c_flags;	/* behavioural flags */
-	unsigned int		c_maxcount;	/* max cache nodes */
-	unsigned int		c_count;	/* count of nodes */
-	pthread_mutex_t		c_mutex;	/* node count mutex */
-	cache_node_hash_t	hash;		/* node hash function */
-	cache_node_alloc_t	alloc;		/* allocation function */
-	cache_node_flush_t	flush;		/* flush dirty data function */
-	cache_node_relse_t	relse;		/* memory free function */
-	cache_node_compare_t	compare;	/* comparison routine */
-	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
-	unsigned int		c_hashsize;	/* hash bucket count */
-	unsigned int		c_hashshift;	/* hash key shift */
-	struct cache_hash	*c_hash;	/* hash table buckets */
-	struct cache_mru	c_mrus[CACHE_DIRTY_PRIORITY + 1];
-	unsigned long long	c_misses;	/* cache misses */
-	unsigned long long	c_hits;		/* cache hits */
-	unsigned int 		c_max;		/* max nodes ever used */
-};
-
-struct cache *cache_init(int, unsigned int, struct cache_operations *);
-void cache_destroy(struct cache *);
-void cache_walk(struct cache *, cache_walk_t);
-void cache_purge(struct cache *);
-void cache_flush(struct cache *);
-
-int cache_node_get(struct cache *, cache_key_t, struct cache_node **);
-void cache_node_put(struct cache *, struct cache_node *);
-void cache_node_set_priority(struct cache *, struct cache_node *, int);
-int cache_node_get_priority(struct cache_node *);
-int cache_node_purge(struct cache *, cache_key_t, struct cache_node *);
-void cache_report(FILE *fp, const char *, struct cache *);
-int cache_overflowed(struct cache *);
-
-#endif	/* __CACHE_H__ */
diff --git a/include/libxfs.h b/include/libxfs.h
index d49f921a4429..ebef94fa2c45 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -13,7 +13,6 @@
 
 #include "list.h"
 #include "hlist.h"
-#include "cache.h"
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
@@ -53,7 +52,6 @@ struct iomap;
  */
 #include "xfs_buftarg.h"
 #include "xfs_buf.h"
-#include "libxfs_io.h"
 
 #include "xfs_bit.h"
 #include "xfs_sb.h"
@@ -138,15 +136,20 @@ typedef struct libxfs_xinit {
 #define LIBXFS_EXCLUSIVELY	0x0010	/* disallow other accesses (O_EXCL) */
 #define LIBXFS_DIRECT		0x0020	/* can use direct I/O, not buffered */
 
-extern char	*progname;
+extern char *progname;
 extern xfs_lsn_t libxfs_max_lsn;
-extern int	libxfs_init (libxfs_init_t *);
-void		libxfs_destroy(struct libxfs_xinit *li);
-extern int	libxfs_device_to_fd (dev_t);
-extern dev_t	libxfs_device_open (char *, int, int, int);
-extern void	libxfs_device_close (dev_t);
-extern int	libxfs_device_alignment (void);
-extern void	libxfs_report(FILE *);
+extern int libxfs_bhash_size;
+
+int libxfs_init (libxfs_init_t *);
+void libxfs_destroy(struct libxfs_xinit *li);
+int libxfs_device_to_fd (dev_t);
+dev_t libxfs_device_open (char *, int, int, int);
+void libxfs_open_devices(struct xfs_mount *mp, dev_t ddev, dev_t logdev,
+			dev_t rtdev);
+void libxfs_device_close (dev_t);
+int libxfs_device_alignment (void);
+int libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len);
+void libxfs_report(FILE *);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index f30ce8792fba..501a2607b46e 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -63,7 +63,6 @@ static inline void i_gid_write(struct inode *inode, uint32_t gid)
 }
 
 typedef struct xfs_inode {
-	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index d72c011b46e6..c447f3aadaeb 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -176,6 +176,11 @@ xfs_perag_resv(
 	}
 }
 
+#define xfs_daddr_to_agno(mp,d) \
+	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
+#define xfs_daddr_to_agbno(mp,d) \
+	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
+
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
@@ -190,4 +195,6 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
+struct xfs_buf * libxfs_getsb(struct xfs_mount *mp);
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1f142fb36208..7000aaec56a1 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -50,14 +50,12 @@ HFILES = \
 	xfs_shared.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
-	libxfs_io.h \
 	libxfs_api_defs.h \
 	init.h \
 	libxfs_priv.h \
 	xfs_dir2_priv.h
 
 CFILES = buftarg.c \
-	cache.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index 8332bf3341b6..df968c66c205 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -277,6 +277,9 @@ void
 xfs_buftarg_free(
 	struct xfs_buftarg	*btp)
 {
+	if (!btp)
+		return;
+
 	btp->bt_exiting = true;
 	if (btp->bt_psi_tid)
 		pthread_join(btp->bt_psi_tid, NULL);
@@ -324,22 +327,6 @@ xfs_buf_allocate_memory(
 /*
  * Low level IO routines
  */
-static void
-xfs_buf_complete_io(
-	struct xfs_buf	*bp,
-	int		status)
-{
-
-	/*
-	 * don't overwrite existing errors - otherwise we can lose errors on
-	 * buffers that require multiple bios to complete.
-	 */
-	if (status)
-		cmpxchg(&bp->b_io_error, 0, status);
-
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend(bp);
-}
 
 /*
  * XXX: this will be replaced by an AIO submission engine in future. In the mean
@@ -366,7 +353,14 @@ submit_io(
 		ret = -EIO;
 	else
 		ret = 0;
-	xfs_buf_complete_io(bp, ret);
+	/*
+	 * This is a bit of a hack until we get AIO that runs completions.
+	 * Success is treated as a completion here, but IO errors are handled as
+	 * a submission error and are handled by the caller. AIO will clean this
+	 * up.
+	 */
+	if (!ret)
+		xfs_buf_ioend(bp);
 	return ret;
 }
 
@@ -463,8 +457,6 @@ xfs_buftarg_submit_io(
 		}
 	}
 
-	atomic_set(&bp->b_io_remaining, 1);
-
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
@@ -480,104 +472,6 @@ xfs_buftarg_submit_io(
 		if (size <= 0)
 			break;	/* all done */
 	}
-
-	xfs_buf_complete_io(bp, bp->b_error);
-}
-
-/*
- * Allocate an uncached buffer that points at daddr.  The refcount will be 1,
- * and the cache node hash list will be empty to indicate that it's uncached.
- */
-int
-xfs_buf_get_uncached_daddr(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		daddr,
-	size_t			bblen,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_buf	*bp;
-
-	bp = libxfs_getbufr(target, daddr, bblen);
-	if (!bp)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&bp->b_node.cn_hash);
-	bp->b_node.cn_count = 1;
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-        bp->b_maps[0].bm_bn = daddr;
-	*bpp = bp;
-	return 0;
-}
-
-/*
- * Run the IO requested on a pre-configured uncached buffer. The length of the
- * IO is capped by @bblen, so a shorter IO than the entire buffer can be done
- * easily.
- */
-static int
-xfs_buf_uncached_submit(
-	struct xfs_buftarg	*target,
-	struct xfs_buf		*bp,
-	size_t			bblen,
-	int			flags)
-{
-	ASSERT(bp->b_bn == XFS_BUF_DADDR_NULL);
-
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE);
-	bp->b_flags |= flags;
-	bp->b_length = bblen;
-	bp->b_error = 0;
-
-	xfs_buftarg_submit_io(bp);
-	return bp->b_error;
-}
-
-int
-xfs_bread(
-	struct xfs_buf		*bp,
-	size_t			bblen)
-{
-	return xfs_buf_uncached_submit(bp->b_target, bp, bblen, XBF_READ);
-}
-
-/*
- * Read a single contiguous range of a buftarg and return the buffer to the
- * caller. This buffer is not cached.
- */
-int
-xfs_buf_read_uncached(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		daddr,
-	size_t			bblen,
-	int			flags,
-	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
-{
-	struct xfs_buf		 *bp;
-	int			error;
-
-	error = xfs_buf_get_uncached(target, bblen, flags, &bp);
-	if (error)
-		return error;
-
-	ASSERT(bp->b_map_count == 1);
-	bp->b_ops = ops;
-	bp->b_maps[0].bm_bn = daddr;
-
-	error = xfs_bread(bp, bblen);
-	if (error) {
-		xfs_buf_relse(bp);
-		return error;
-	}
-	*bpp = bp;
-	return 0;
-}
-
-int
-xfs_bwrite(struct xfs_buf *bp)
-{
-	return xfs_buf_uncached_submit(bp->b_target, bp, bp->b_length,
-					XBF_WRITE);
 }
 
 /*
@@ -612,6 +506,17 @@ xfs_buf_associate_memory(
 	return 0;
 }
 
+/*
+ * XXX: slow implementation - this is an async write that wants a delwri buffer
+ * list that can be flushed at unmount.
+ */
+void
+xfs_buf_mark_dirty(
+	struct xfs_buf		*bp)
+{
+	xfs_bwrite(bp);
+}
+
 /*
  * Buffer cache hash implementation
 *
@@ -697,7 +602,7 @@ btc_report_ag(
 		return;
 
 	/* report btc summary */
-	fprintf(fp, "%8u|\t%9u\t%9u\t%8u\t%8u\t%8llu\t%8llu\t%5.2f\n",
+	fprintf(fp, "%8u| %10u %9u %8u\t| %8u %8llu %8llu %5.2f\n",
 			agno,
 			btc->maxcount,
 			btc->max,
@@ -721,6 +626,7 @@ btc_report_ag(
 		hash_bucket_lengths[index]++;
 	}
 
+#ifdef XXX
 	total = 0;
 	for (i = 0; i < HASH_REPORT + 1; i++) {
 		total += i * hash_bucket_lengths[i];
@@ -736,6 +642,7 @@ btc_report_ag(
 			i - 1, hash_bucket_lengths[i],
 			((btc->count - total) * 100) /
 					atomic_read(&btc->count));
+#endif /* XXX */
 }
 
 void
@@ -751,7 +658,7 @@ btc_report(
 
 	fprintf(fp, "%s: Per-AG summary\n", name);
 	fprintf(fp, "AG\t|\t\tEntries\t\t|\t\tHash Table\n");
-	fprintf(fp, "\t|\tSupported\tUtilised\tActive\tSize\tHits\tMisses\tRatio\n");
+	fprintf(fp, "\t| Supported\tUtilised\tActive\t| Size\tHits\tMisses\tRatio\n");
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		struct xfs_perag *pag = xfs_perag_get(mp, i);
 
@@ -807,12 +714,10 @@ btc_node_find(
 			ASSERT(bp->b_flags & XBF_STALE);
 			continue;
 		}
-		btc->hits++;
 		pthread_mutex_unlock(&hash->lock);
 		return bp;
 
 	}
-	btc->misses++;
 	pthread_mutex_unlock(&hash->lock);
 	return NULL;
 }
@@ -883,6 +788,7 @@ btc_purge_buffers(
 		spin_lock(&bp->b_lock);
 		atomic_set(&bp->b_lru_ref, 0);
 		bp->b_state |= XFS_BSTATE_DISPOSE;
+		list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
 		list_move(&bp->b_btc_list, &dispose);
 		spin_unlock(&bp->b_lock);
 	}
@@ -891,7 +797,7 @@ btc_purge_buffers(
 	while (!list_empty(&dispose)) {
 		bp = list_first_entry(&dispose, struct xfs_buf, b_btc_list);
 		list_del_init(&bp->b_btc_list);
-		libxfs_brelse(&bp->b_node);
+		xfs_buf_rele(bp);
 	}
 }
 
diff --git a/libxfs/cache.c b/libxfs/cache.c
deleted file mode 100644
index 139c7c1b9e71..000000000000
--- a/libxfs/cache.c
+++ /dev/null
@@ -1,724 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-#include <pthread.h>
-
-#include "libxfs_priv.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_bit.h"
-
-#define CACHE_DEBUG 1
-#undef CACHE_DEBUG
-#define CACHE_DEBUG 1
-#undef CACHE_ABORT
-/* #define CACHE_ABORT 1 */
-
-#define CACHE_SHAKE_COUNT	64
-
-static unsigned int cache_generic_bulkrelse(struct cache *, struct list_head *);
-
-struct cache *
-cache_init(
-	int			flags,
-	unsigned int		hashsize,
-	struct cache_operations	*cache_operations)
-{
-	struct cache *		cache;
-	unsigned int		i, maxcount;
-
-	maxcount = hashsize * HASH_CACHE_RATIO;
-
-	if (!(cache = malloc(sizeof(struct cache))))
-		return NULL;
-	if (!(cache->c_hash = calloc(hashsize, sizeof(struct cache_hash)))) {
-		free(cache);
-		return NULL;
-	}
-
-	cache->c_flags = flags;
-	cache->c_count = 0;
-	cache->c_max = 0;
-	cache->c_hits = 0;
-	cache->c_misses = 0;
-	cache->c_maxcount = maxcount;
-	cache->c_hashsize = hashsize;
-	cache->c_hashshift = libxfs_highbit32(hashsize);
-	cache->hash = cache_operations->hash;
-	cache->alloc = cache_operations->alloc;
-	cache->flush = cache_operations->flush;
-	cache->relse = cache_operations->relse;
-	cache->compare = cache_operations->compare;
-	cache->bulkrelse = cache_operations->bulkrelse ?
-		cache_operations->bulkrelse : cache_generic_bulkrelse;
-	pthread_mutex_init(&cache->c_mutex, NULL);
-
-	for (i = 0; i < hashsize; i++) {
-		list_head_init(&cache->c_hash[i].ch_list);
-		cache->c_hash[i].ch_count = 0;
-		pthread_mutex_init(&cache->c_hash[i].ch_mutex, NULL);
-	}
-
-	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++) {
-		list_head_init(&cache->c_mrus[i].cm_list);
-		cache->c_mrus[i].cm_count = 0;
-		pthread_mutex_init(&cache->c_mrus[i].cm_mutex, NULL);
-	}
-	return cache;
-}
-
-static void
-cache_expand(
-	struct cache *		cache)
-{
-	pthread_mutex_lock(&cache->c_mutex);
-#ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
-#endif
-	cache->c_maxcount *= 2;
-	pthread_mutex_unlock(&cache->c_mutex);
-}
-
-void
-cache_walk(
-	struct cache *		cache,
-	cache_walk_t		visit)
-{
-	struct cache_hash *	hash;
-	struct list_head *	head;
-	struct list_head *	pos;
-	unsigned int		i;
-
-	for (i = 0; i < cache->c_hashsize; i++) {
-		hash = &cache->c_hash[i];
-		head = &hash->ch_list;
-		pthread_mutex_lock(&hash->ch_mutex);
-		for (pos = head->next; pos != head; pos = pos->next)
-			visit((struct cache_node *)pos);
-		pthread_mutex_unlock(&hash->ch_mutex);
-	}
-}
-
-#ifdef CACHE_ABORT
-#define cache_abort()	abort()
-#else
-#define cache_abort()	do { } while (0)
-#endif
-
-#ifdef CACHE_DEBUG
-static void
-cache_zero_check(
-	struct cache_node *	node)
-{
-	if (node->cn_count > 0) {
-		fprintf(stderr, "%s: refcount is %u, not zero (node=%p)\n",
-			__FUNCTION__, node->cn_count, node);
-		cache_abort();
-	}
-}
-#define cache_destroy_check(c)	cache_walk((c), cache_zero_check)
-#else
-#define cache_destroy_check(c)	do { } while (0)
-#endif
-
-void
-cache_destroy(
-	struct cache *		cache)
-{
-	unsigned int		i;
-
-	cache_destroy_check(cache);
-	for (i = 0; i < cache->c_hashsize; i++) {
-		list_head_destroy(&cache->c_hash[i].ch_list);
-		pthread_mutex_destroy(&cache->c_hash[i].ch_mutex);
-	}
-	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++) {
-		list_head_destroy(&cache->c_mrus[i].cm_list);
-		pthread_mutex_destroy(&cache->c_mrus[i].cm_mutex);
-	}
-	pthread_mutex_destroy(&cache->c_mutex);
-	free(cache->c_hash);
-	free(cache);
-}
-
-static unsigned int
-cache_generic_bulkrelse(
-	struct cache *		cache,
-	struct list_head *	list)
-{
-	struct cache_node *	node;
-	unsigned int		count = 0;
-
-	while (!list_empty(list)) {
-		node = list_entry(list->next, struct cache_node, cn_mru);
-		pthread_mutex_destroy(&node->cn_mutex);
-		list_del_init(&node->cn_mru);
-		cache->relse(node);
-		count++;
-	}
-
-	return count;
-}
-
-/*
- * Park unflushable nodes on their own special MRU so that cache_shake() doesn't
- * end up repeatedly scanning them in the futile attempt to clean them before
- * reclaim.
- */
-static void
-cache_add_to_dirty_mru(
-	struct cache		*cache,
-	struct cache_node	*node)
-{
-	struct cache_mru	*mru = &cache->c_mrus[CACHE_DIRTY_PRIORITY];
-
-	pthread_mutex_lock(&mru->cm_mutex);
-	node->cn_old_priority = node->cn_priority;
-	node->cn_priority = CACHE_DIRTY_PRIORITY;
-	list_add(&node->cn_mru, &mru->cm_list);
-	mru->cm_count++;
-	pthread_mutex_unlock(&mru->cm_mutex);
-}
-
-/*
- * We've hit the limit on cache size, so we need to start reclaiming nodes we've
- * used. The MRU specified by the priority is shaken.  Returns new priority at
- * end of the call (in case we call again). We are not allowed to reclaim dirty
- * objects, so we have to flush them first. If flushing fails, we move them to
- * the "dirty, unreclaimable" list.
- *
- * Hence we skip priorities > CACHE_MAX_PRIORITY unless "purge" is set as we
- * park unflushable (and hence unreclaimable) buffers at these priorities.
- * Trying to shake unreclaimable buffer lists when there is memory pressure is a
- * waste of time and CPU and greatly slows down cache node recycling operations.
- * Hence we only try to free them if we are being asked to purge the cache of
- * all entries.
- */
-static unsigned int
-cache_shake(
-	struct cache *		cache,
-	unsigned int		priority,
-	bool			purge)
-{
-	struct cache_mru	*mru;
-	struct cache_hash *	hash;
-	struct list_head	temp;
-	struct list_head *	head;
-	struct list_head *	pos;
-	struct list_head *	n;
-	struct cache_node *	node;
-	unsigned int		count;
-
-	ASSERT(priority <= CACHE_DIRTY_PRIORITY);
-	if (priority > CACHE_MAX_PRIORITY && !purge)
-		priority = 0;
-
-	mru = &cache->c_mrus[priority];
-	count = 0;
-	list_head_init(&temp);
-	head = &mru->cm_list;
-
-	pthread_mutex_lock(&mru->cm_mutex);
-	for (pos = head->prev, n = pos->prev; pos != head;
-						pos = n, n = pos->prev) {
-		node = list_entry(pos, struct cache_node, cn_mru);
-
-		if (pthread_mutex_trylock(&node->cn_mutex) != 0)
-			continue;
-
-		/* memory pressure is not allowed to release dirty objects */
-		if (cache->flush(node) && !purge) {
-			list_del(&node->cn_mru);
-			mru->cm_count--;
-			node->cn_priority = -1;
-			pthread_mutex_unlock(&node->cn_mutex);
-			cache_add_to_dirty_mru(cache, node);
-			continue;
-		}
-
-		hash = cache->c_hash + node->cn_hashidx;
-		if (pthread_mutex_trylock(&hash->ch_mutex) != 0) {
-			pthread_mutex_unlock(&node->cn_mutex);
-			continue;
-		}
-		ASSERT(node->cn_count == 0);
-		ASSERT(node->cn_priority == priority);
-		node->cn_priority = -1;
-
-		list_move(&node->cn_mru, &temp);
-		list_del_init(&node->cn_hash);
-		hash->ch_count--;
-		mru->cm_count--;
-		pthread_mutex_unlock(&hash->ch_mutex);
-		pthread_mutex_unlock(&node->cn_mutex);
-
-		count++;
-		if (!purge && count == CACHE_SHAKE_COUNT)
-			break;
-	}
-	pthread_mutex_unlock(&mru->cm_mutex);
-
-	if (count > 0) {
-		cache->bulkrelse(cache, &temp);
-
-		pthread_mutex_lock(&cache->c_mutex);
-		cache->c_count -= count;
-		pthread_mutex_unlock(&cache->c_mutex);
-	}
-
-	return (count == CACHE_SHAKE_COUNT) ? priority : ++priority;
-}
-
-/*
- * Allocate a new hash node (updating atomic counter in the process),
- * unless doing so will push us over the maximum cache size.
- */
-static struct cache_node *
-cache_node_allocate(
-	struct cache *		cache,
-	cache_key_t		key)
-{
-	unsigned int		nodesfree;
-	struct cache_node *	node;
-
-	pthread_mutex_lock(&cache->c_mutex);
-	nodesfree = (cache->c_count < cache->c_maxcount);
-	if (nodesfree) {
-		cache->c_count++;
-		if (cache->c_count > cache->c_max)
-			cache->c_max = cache->c_count;
-	}
-	cache->c_misses++;
-	pthread_mutex_unlock(&cache->c_mutex);
-	if (!nodesfree)
-		return NULL;
-	node = cache->alloc(key);
-	if (node == NULL) {	/* uh-oh */
-		pthread_mutex_lock(&cache->c_mutex);
-		cache->c_count--;
-		pthread_mutex_unlock(&cache->c_mutex);
-		return NULL;
-	}
-	pthread_mutex_init(&node->cn_mutex, NULL);
-	list_head_init(&node->cn_mru);
-	node->cn_count = 1;
-	node->cn_priority = 0;
-	node->cn_old_priority = -1;
-	return node;
-}
-
-int
-cache_overflowed(
-	struct cache *		cache)
-{
-	return cache->c_maxcount == cache->c_max;
-}
-
-
-static int
-__cache_node_purge(
-	struct cache *		cache,
-	struct cache_node *	node)
-{
-	int			count;
-	struct cache_mru *	mru;
-
-	pthread_mutex_lock(&node->cn_mutex);
-	count = node->cn_count;
-	if (count != 0) {
-		pthread_mutex_unlock(&node->cn_mutex);
-		return count;
-	}
-
-	/* can't purge dirty objects */
-	if (cache->flush(node)) {
-		pthread_mutex_unlock(&node->cn_mutex);
-		return 1;
-	}
-
-	mru = &cache->c_mrus[node->cn_priority];
-	pthread_mutex_lock(&mru->cm_mutex);
-	list_del_init(&node->cn_mru);
-	mru->cm_count--;
-	pthread_mutex_unlock(&mru->cm_mutex);
-
-	pthread_mutex_unlock(&node->cn_mutex);
-	pthread_mutex_destroy(&node->cn_mutex);
-	list_del_init(&node->cn_hash);
-	cache->relse(node);
-	return 0;
-}
-
-/*
- * Lookup in the cache hash table.  With any luck we'll get a cache
- * hit, in which case this will all be over quickly and painlessly.
- * Otherwise, we allocate a new node, taking care not to expand the
- * cache beyond the requested maximum size (shrink it if it would).
- * Returns one if hit in cache, otherwise zero.  A node is _always_
- * returned, however.
- */
-int
-cache_node_get(
-	struct cache *		cache,
-	cache_key_t		key,
-	struct cache_node **	nodep)
-{
-	struct cache_node *	node = NULL;
-	struct cache_hash *	hash;
-	struct cache_mru *	mru;
-	struct list_head *	head;
-	struct list_head *	pos;
-	struct list_head *	n;
-	unsigned int		hashidx;
-	int			priority = 0;
-	int			purged = 0;
-
-	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
-	hash = cache->c_hash + hashidx;
-	head = &hash->ch_list;
-
-	for (;;) {
-		pthread_mutex_lock(&hash->ch_mutex);
-		for (pos = head->next, n = pos->next; pos != head;
-						pos = n, n = pos->next) {
-			int result;
-
-			node = list_entry(pos, struct cache_node, cn_hash);
-			result = cache->compare(node, key);
-			switch (result) {
-			case CACHE_HIT:
-				break;
-			case CACHE_PURGE:
-				if ((cache->c_flags & CACHE_MISCOMPARE_PURGE) &&
-				    !__cache_node_purge(cache, node)) {
-					purged++;
-					hash->ch_count--;
-				}
-				/* FALL THROUGH */
-			case CACHE_MISS:
-				goto next_object;
-			}
-
-			/*
-			 * node found, bump node's reference count, remove it
-			 * from its MRU list, and update stats.
-			 */
-			pthread_mutex_lock(&node->cn_mutex);
-
-			if (node->cn_count == 0) {
-				ASSERT(node->cn_priority >= 0);
-				ASSERT(!list_empty(&node->cn_mru));
-				mru = &cache->c_mrus[node->cn_priority];
-				pthread_mutex_lock(&mru->cm_mutex);
-				mru->cm_count--;
-				list_del_init(&node->cn_mru);
-				pthread_mutex_unlock(&mru->cm_mutex);
-				if (node->cn_old_priority != -1) {
-					ASSERT(node->cn_priority ==
-							CACHE_DIRTY_PRIORITY);
-					node->cn_priority = node->cn_old_priority;
-					node->cn_old_priority = -1;
-				}
-			}
-			node->cn_count++;
-
-			pthread_mutex_unlock(&node->cn_mutex);
-			pthread_mutex_unlock(&hash->ch_mutex);
-
-			pthread_mutex_lock(&cache->c_mutex);
-			cache->c_hits++;
-			pthread_mutex_unlock(&cache->c_mutex);
-
-			*nodep = node;
-			return 0;
-next_object:
-			continue;	/* what the hell, gcc? */
-		}
-		pthread_mutex_unlock(&hash->ch_mutex);
-		/*
-		 * not found, allocate a new entry
-		 */
-		node = cache_node_allocate(cache, key);
-		if (node)
-			break;
-		priority = cache_shake(cache, priority, false);
-		/*
-		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
-		 * back the same priority, if not we get back priority+1.
-		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
-		 */
-		if (priority > CACHE_MAX_PRIORITY) {
-			priority = 0;
-			cache_expand(cache);
-		}
-	}
-
-	node->cn_hashidx = hashidx;
-
-	/* add new node to appropriate hash */
-	pthread_mutex_lock(&hash->ch_mutex);
-	hash->ch_count++;
-	list_add(&node->cn_hash, &hash->ch_list);
-	pthread_mutex_unlock(&hash->ch_mutex);
-
-	if (purged) {
-		pthread_mutex_lock(&cache->c_mutex);
-		cache->c_count -= purged;
-		pthread_mutex_unlock(&cache->c_mutex);
-	}
-
-	*nodep = node;
-	return 1;
-}
-
-void
-cache_node_put(
-	struct cache *		cache,
-	struct cache_node *	node)
-{
-	struct cache_mru *	mru;
-
-	pthread_mutex_lock(&node->cn_mutex);
-#ifdef CACHE_DEBUG
-	if (node->cn_count < 1) {
-		fprintf(stderr, "%s: node put on refcount %u (node=%p)\n",
-				__FUNCTION__, node->cn_count, node);
-		cache_abort();
-	}
-	if (!list_empty(&node->cn_mru)) {
-		fprintf(stderr, "%s: node put on node (%p) in MRU list\n",
-				__FUNCTION__, node);
-		cache_abort();
-	}
-#endif
-	node->cn_count--;
-
-	if (node->cn_count == 0) {
-		/* add unreferenced node to appropriate MRU for shaker */
-		mru = &cache->c_mrus[node->cn_priority];
-		pthread_mutex_lock(&mru->cm_mutex);
-		mru->cm_count++;
-		list_add(&node->cn_mru, &mru->cm_list);
-		pthread_mutex_unlock(&mru->cm_mutex);
-	}
-
-	pthread_mutex_unlock(&node->cn_mutex);
-}
-
-void
-cache_node_set_priority(
-	struct cache *		cache,
-	struct cache_node *	node,
-	int			priority)
-{
-	if (priority < 0)
-		priority = 0;
-	else if (priority > CACHE_MAX_PRIORITY)
-		priority = CACHE_MAX_PRIORITY;
-
-	pthread_mutex_lock(&node->cn_mutex);
-	ASSERT(node->cn_count > 0);
-	node->cn_priority = priority;
-	node->cn_old_priority = -1;
-	pthread_mutex_unlock(&node->cn_mutex);
-}
-
-int
-cache_node_get_priority(
-	struct cache_node *	node)
-{
-	int			priority;
-
-	pthread_mutex_lock(&node->cn_mutex);
-	priority = node->cn_priority;
-	pthread_mutex_unlock(&node->cn_mutex);
-
-	return priority;
-}
-
-
-/*
- * Purge a specific node from the cache.  Reference count must be zero.
- */
-int
-cache_node_purge(
-	struct cache *		cache,
-	cache_key_t		key,
-	struct cache_node *	node)
-{
-	struct list_head *	head;
-	struct list_head *	pos;
-	struct list_head *	n;
-	struct cache_hash *	hash;
-	int			count = -1;
-
-	hash = cache->c_hash + cache->hash(key, cache->c_hashsize,
-					   cache->c_hashshift);
-	head = &hash->ch_list;
-	pthread_mutex_lock(&hash->ch_mutex);
-	for (pos = head->next, n = pos->next; pos != head;
-						pos = n, n = pos->next) {
-		if ((struct cache_node *)pos != node)
-			continue;
-
-		count = __cache_node_purge(cache, node);
-		if (!count)
-			hash->ch_count--;
-		break;
-	}
-	pthread_mutex_unlock(&hash->ch_mutex);
-
-	if (count == 0) {
-		pthread_mutex_lock(&cache->c_mutex);
-		cache->c_count--;
-		pthread_mutex_unlock(&cache->c_mutex);
-	}
-#ifdef CACHE_DEBUG
-	if (count >= 1) {
-		fprintf(stderr, "%s: refcount was %u, not zero (node=%p)\n",
-				__FUNCTION__, count, node);
-		cache_abort();
-	}
-	if (count == -1) {
-		fprintf(stderr, "%s: purge node not found! (node=%p)\n",
-			__FUNCTION__, node);
-		cache_abort();
-	}
-#endif
-	return count == 0;
-}
-
-/*
- * Purge all nodes from the cache.  All reference counts must be zero.
- */
-void
-cache_purge(
-	struct cache *		cache)
-{
-	int			i;
-
-	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++)
-		cache_shake(cache, i, true);
-
-#ifdef CACHE_DEBUG
-	if (cache->c_count != 0) {
-		/* flush referenced nodes to disk */
-		cache_flush(cache);
-		fprintf(stderr, "%s: shake on cache %p left %u nodes!?\n",
-				__FUNCTION__, cache, cache->c_count);
-		cache_abort();
-	}
-#endif
-}
-
-/*
- * Flush all nodes in the cache to disk.
- */
-void
-cache_flush(
-	struct cache *		cache)
-{
-	struct cache_hash *	hash;
-	struct list_head *	head;
-	struct list_head *	pos;
-	struct cache_node *	node;
-	int			i;
-
-	if (!cache->flush)
-		return;
-
-	for (i = 0; i < cache->c_hashsize; i++) {
-		hash = &cache->c_hash[i];
-
-		pthread_mutex_lock(&hash->ch_mutex);
-		head = &hash->ch_list;
-		for (pos = head->next; pos != head; pos = pos->next) {
-			node = (struct cache_node *)pos;
-			pthread_mutex_lock(&node->cn_mutex);
-			cache->flush(node);
-			pthread_mutex_unlock(&node->cn_mutex);
-		}
-		pthread_mutex_unlock(&hash->ch_mutex);
-	}
-}
-
-#define	HASH_REPORT	(3 * HASH_CACHE_RATIO)
-void
-cache_report(
-	FILE		*fp,
-	const char	*name,
-	struct cache	*cache)
-{
-	int		i;
-	unsigned long	count, index, total;
-	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
-
-	if ((cache->c_hits + cache->c_misses) == 0)
-		return;
-
-	/* report cache summary */
-	fprintf(fp, "%s: %p\n"
-			"Max supported entries = %u\n"
-			"Max utilized entries = %u\n"
-			"Active entries = %u\n"
-			"Hash table size = %u\n"
-			"Hits = %llu\n"
-			"Misses = %llu\n"
-			"Hit ratio = %5.2f\n",
-			name, cache,
-			cache->c_maxcount,
-			cache->c_max,
-			cache->c_count,
-			cache->c_hashsize,
-			cache->c_hits,
-			cache->c_misses,
-			(double)cache->c_hits * 100 /
-				(cache->c_hits + cache->c_misses)
-	);
-
-	for (i = 0; i <= CACHE_MAX_PRIORITY; i++)
-		fprintf(fp, "MRU %d entries = %6u (%3u%%)\n",
-			i, cache->c_mrus[i].cm_count,
-			cache->c_mrus[i].cm_count * 100 / cache->c_count);
-
-	i = CACHE_DIRTY_PRIORITY;
-	fprintf(fp, "Dirty MRU %d entries = %6u (%3u%%)\n",
-		i, cache->c_mrus[i].cm_count,
-		cache->c_mrus[i].cm_count * 100 / cache->c_count);
-
-	/* report hash bucket lengths */
-	bzero(hash_bucket_lengths, sizeof(hash_bucket_lengths));
-
-	for (i = 0; i < cache->c_hashsize; i++) {
-		count = cache->c_hash[i].ch_count;
-		if (count > HASH_REPORT)
-			index = HASH_REPORT + 1;
-		else
-			index = count;
-		hash_bucket_lengths[index]++;
-	}
-
-	total = 0;
-	for (i = 0; i < HASH_REPORT + 1; i++) {
-		total += i * hash_bucket_lengths[i];
-		if (hash_bucket_lengths[i] == 0)
-			continue;
-		fprintf(fp, "Hash buckets with  %2d entries %6ld (%3ld%%)\n",
-			i, hash_bucket_lengths[i],
-			(i * hash_bucket_lengths[i] * 100) / cache->c_count);
-	}
-	if (hash_bucket_lengths[i])	/* last report bucket is the overflow bucket */
-		fprintf(fp, "Hash buckets with >%2d entries %6ld (%3ld%%)\n",
-			i - 1, hash_bucket_lengths[i],
-			((cache->c_count - total) * 100) / cache->c_count);
-}
diff --git a/libxfs/init.c b/libxfs/init.c
index 59c0f9df586b..1c05a416da9e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -27,11 +27,8 @@
 
 char *progname = "libxfs";	/* default, changed by each tool */
 
-struct cache *libxfs_bcache;	/* global buffer cache */
 int libxfs_bhash_size;		/* #buckets in bcache */
 
-int	use_xfs_buf_lock;	/* global flag: use struct xfs_buf locks for MT */
-
 /*
  * dev_map - map open devices to fd.
  */
@@ -390,11 +387,6 @@ libxfs_init(libxfs_init_t *a)
 			progname);
 		goto done;
 	}
-	if (!libxfs_bhash_size)
-		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
-	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
-				   &libxfs_bcache_operations);
-	use_xfs_buf_lock = a->usebuflock;
 	xfs_dir_startup();
 	init_zones();
 	rval = 1;
@@ -481,7 +473,7 @@ rtmount_init(
 			progname);
 		return -1;
 	}
-	libxfs_buf_relse(bp);
+	xfs_buf_relse(bp);
 	return 0;
 }
 
@@ -519,6 +511,13 @@ libxfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 
+		spin_lock_init(&pag->pag_buf_lock);
+		if (!libxfs_bhash_size)
+			libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
+		pag->pag_buf_hash = btc_init(libxfs_bhash_size);
+		if (!pag->pag_buf_hash)
+			goto out_unwind;
+
 		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
 			error = -EEXIST;
 			goto out_unwind;
@@ -582,9 +581,11 @@ libxfs_initialize_perag(
 	return 0;
 
 out_unwind:
+	btc_destroy(pag->pag_buf_hash);
 	kmem_free(pag);
 	for (; index > first_initialised; index--) {
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		btc_destroy(pag->pag_buf_hash);
 		kmem_free(pag);
 	}
 	return error;
@@ -675,7 +676,7 @@ xfs_check_sizes(
 		xfs_warn(mp, "last sector read failed");
 		return error;
 	}
-	libxfs_buf_relse(bp);
+	xfs_buf_relse(bp);
 
 	if (mp->m_logdev_targp == mp->m_ddev_targp)
 		return 0;
@@ -692,7 +693,7 @@ xfs_check_sizes(
 		xfs_warn(mp, "log device read failed");
 		return error;
 	}
-	libxfs_buf_relse(bp);
+	xfs_buf_relse(bp);
 	return 0;
 }
 
@@ -814,7 +815,7 @@ libxfs_mount(
 								progname);
 			sbp->sb_agcount = 1;
 		} else
-			libxfs_buf_relse(bp);
+			xfs_buf_relse(bp);
 	}
 
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
@@ -888,15 +889,6 @@ libxfs_flush_mount(
 	int			error = 0;
 	int			err2;
 
-	/*
-	 * Purge the buffer cache to write all dirty buffers to disk and free
-	 * all incore buffers.  Buffers that fail write verification will cause
-	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
-	 * cannot be written will cause the LOST_WRITE flag to be set in the
-	 * buftarg.
-	 */
-	libxfs_bcache_purge();
-
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
 		err2 = libxfs_flush_buftarg(mp->m_ddev_targp, _("data device"));
@@ -921,6 +913,7 @@ libxfs_flush_mount(
 	return error;
 }
 
+
 /*
  * Release any resource obtained during a mount.
  */
@@ -934,21 +927,28 @@ libxfs_umount(
 
 	libxfs_rtmount_destroy(mp);
 
+	/*
+	 * XXX: This device flushing stuff has changed and needs to be converted
+	 * to a buftarg API.
+	 */
 	error = libxfs_flush_mount(mp);
-
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		if (!pag)
+			continue;
+
+		btc_destroy(pag->pag_buf_hash);
 		kmem_free(pag);
 	}
 
+	xfs_buftarg_free(mp->m_ddev_targp);
+	xfs_buftarg_free(mp->m_rtdev_targp);
+	if (mp->m_logdev_targp != mp->m_ddev_targp)
+		xfs_buftarg_free(mp->m_logdev_targp);
+
 	kmem_free(mp->m_attr_geo);
 	kmem_free(mp->m_dir_geo);
 
-	kmem_free(mp->m_rtdev_targp);
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		kmem_free(mp->m_logdev_targp);
-	kmem_free(mp->m_ddev_targp);
-
 	return error;
 }
 
@@ -963,10 +963,6 @@ libxfs_destroy(
 
 	libxfs_close_devices(li);
 
-	/* Free everything from the buffer cache before freeing buffer zone */
-	libxfs_bcache_purge();
-	libxfs_bcache_free();
-	cache_destroy(libxfs_bcache);
 	leaked = destroy_zones();
 	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
@@ -979,15 +975,13 @@ libxfs_device_alignment(void)
 	return platform_align_blockdev();
 }
 
-void
-libxfs_report(FILE *fp)
+struct xfs_buf *
+libxfs_getsb(
+	struct xfs_mount	*mp)
 {
-	time_t t;
-	char *c;
-
-	cache_report(fp, "libxfs_bcache", libxfs_bcache);
+	struct xfs_buf          *bp;
 
-	t = time(NULL);
-	c = asctime(localtime(&t));
-	fprintf(fp, "%s", c);
+	libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1),
+			0, &bp, &xfs_sb_buf_ops);
+	return bp;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c45da9a2cd01..a10d9e7375ef 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -47,14 +47,18 @@
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_blkdev_issue_flush		libxfs_blkdev_issue_flush
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_map			libxfs_buf_get_map
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
+#define xfs_buf_mark_dirty		libxfs_buf_mark_dirty
 #define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_read_map		libxfs_buf_read_map
 #define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
+#define xfs_buf_reverify		libxfs_buf_reverify
+#define xfs_buftarg_purge_ag		libxfs_buftarg_purge_ag
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ac12a993d872..1ce4f8836fd3 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -43,7 +43,6 @@
 
 #include "list.h"
 #include "hlist.h"
-#include "cache.h"
 #include "bitops.h"
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
@@ -88,7 +87,6 @@ struct iomap;
  */
 #include "xfs_buftarg.h"
 #include "xfs_buf.h"
-#include "libxfs_io.h"
 
 /* for all the support code that uses progname in error messages */
 extern char    *progname;
@@ -386,17 +384,6 @@ howmany_64(uint64_t x, uint32_t y)
 	return x;
 }
 
-/* buffer management */
-#define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
-
-#define xfs_buf_oneshot(bp)		((void) 0)
-
-#define xfs_buf_zero(bp, off, len) \
-	memset((bp)->b_addr + off, 0, len);
-
-void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
-#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
-
 /* mount stuff */
 #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
 #define XFS_MOUNT_ATTR2			LIBXFS_MOUNT_ATTR2
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3bae6a813675..06e487eda1db 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -19,44 +19,13 @@
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
 
-#include "libxfs.h"
-
-/*
- * Important design/architecture note:
- *
- * The userspace code that uses the buffer cache is much less constrained than
- * the kernel code. The userspace code is pretty nasty in places, especially
- * when it comes to buffer error handling.  Very little of the userspace code
- * outside libxfs clears bp->b_error - very little code even checks it - so the
- * libxfs code is tripping on stale errors left by the userspace code.
- *
- * We can't clear errors or zero buffer contents in libxfs_buf_get-* like we do
- * in the kernel, because those functions are used by the libxfs_readbuf_*
- * functions and hence need to leave the buffers unchanged on cache hits. This
- * is actually the only way to gather a write error from a libxfs_writebuf()
- * call - you need to get the buffer again so you can check bp->b_error field -
- * assuming that the buffer is still in the cache when you check, that is.
- *
- * This is very different to the kernel code which does not release buffers on a
- * write so we can wait on IO and check errors. The kernel buffer cache also
- * guarantees a buffer of a known initial state from xfs_buf_get() even on a
- * cache hit.
- *
- * IOWs, userspace is behaving quite differently to the kernel and as a result
- * it leaks errors from reads, invalidations and writes through
- * libxfs_buf_get/libxfs_buf_read.
- *
- * The result of this is that until the userspace code outside libxfs is cleaned
- * up, functions that release buffers from userspace control (i.e
- * libxfs_writebuf/libxfs_buf_relse) need to zero bp->b_error to prevent
- * propagation of stale errors into future buffer operations.
- */
+#include "libxfs.h"		/* for libxfs_device_alignment */
 
 #define BDSTRAT_SIZE	(256 * 1024)
 
 #define IO_BCOMPARE_CHECK
 
-/* XXX: (dgc) Propagate errors, only exit if fail-on-error flag set */
+/* XXX: (dgc) Propagate errors rather than exit */
 int
 libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 {
@@ -145,749 +114,9 @@ static char *next(
 	return ptr + offset;
 }
 
-struct xfs_buf *
-libxfs_getsb(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buf		*bp;
-
-	libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1),
-			0, &bp, &xfs_sb_buf_ops);
-	return bp;
-}
-
-kmem_zone_t			*xfs_buf_zone;
-
-static struct cache_mru		xfs_buf_freelist =
-	{{&xfs_buf_freelist.cm_list, &xfs_buf_freelist.cm_list},
-	 0, PTHREAD_MUTEX_INITIALIZER };
-
-/*
- * The bufkey is used to pass the new buffer information to the cache object
- * allocation routine. Because discontiguous buffers need to pass different
- * information, we need fields to pass that information. However, because the
- * blkno and bblen is needed for the initial cache entry lookup (i.e. for
- * bcompare) the fact that the map/nmaps is non-null to switch to discontiguous
- * buffer initialisation instead of a contiguous buffer.
- */
-struct xfs_bufkey {
-	struct xfs_buftarg	*buftarg;
-	xfs_daddr_t		blkno;
-	unsigned int		bblen;
-	struct xfs_buf_map	*map;
-	int			nmaps;
-};
-
-/*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
-#define GOLDEN_RATIO_PRIME	0x9e37fffffffc0001UL
-#define CACHE_LINE_SIZE		64
-static unsigned int
-libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
-{
-	uint64_t	hashval = ((struct xfs_bufkey *)key)->blkno;
-	uint64_t	tmp;
-
-	tmp = hashval ^ (GOLDEN_RATIO_PRIME + hashval) / CACHE_LINE_SIZE;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> hashshift);
-	return tmp % hashsize;
-}
-
-static int
-libxfs_bcompare(struct cache_node *node, cache_key_t key)
-{
-	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
-						   b_node);
-	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
-
-	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
-	    bp->b_bn == bkey->blkno) {
-		if (bp->b_length == bkey->bblen)
-			return CACHE_HIT;
-#ifdef IO_BCOMPARE_CHECK
-		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
-			fprintf(stderr,
-	"%lx: Badness in key lookup (length)\n"
-	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
-				pthread_self(),
-				(unsigned long long)bp->b_bn, 
-				BBTOB(bp->b_length),
-				(unsigned long long)bkey->blkno,
-				BBTOB(bkey->bblen));
-		}
-#endif
-		return CACHE_PURGE;
-	}
-	return CACHE_MISS;
-}
-
-static void
-__initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
-		unsigned int bytes)
-{
-	bp->b_flags = 0;
-	bp->b_bn = bno;
-	bp->b_length = BTOBB(bytes);
-	bp->b_target = btp;
-	bp->b_mount = btp->bt_mount;
-	bp->b_error = 0;
-	if (!bp->b_addr)
-		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
-	if (!bp->b_addr) {
-		fprintf(stderr,
-			_("%s: %s can't memalign %u bytes: %s\n"),
-			progname, __FUNCTION__, bytes,
-			strerror(errno));
-		exit(1);
-	}
-	memset(bp->b_addr, 0, bytes);
-	pthread_mutex_init(&bp->b_lock, NULL);
-	bp->b_holder = 0;
-	bp->b_recur = 0;
-	bp->b_ops = NULL;
-	INIT_LIST_HEAD(&bp->b_li_list);
-}
-
-static void
-libxfs_initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
-		unsigned int bytes)
-{
-	bp->b_map_count = 1;
-	bp->b_maps = &bp->__b_map;
-	bp->b_maps[0].bm_bn = bno;
-	bp->b_maps[0].bm_len = bytes;
-
-	__initbuf(bp, btp, bno, bytes);
-}
-
-static void
-libxfs_initbuf_map(struct xfs_buf *bp, struct xfs_buftarg *btp,
-		struct xfs_buf_map *map, int nmaps)
-{
-	unsigned int bytes = 0;
-	int i;
-
-	if (nmaps == 1) {
-		libxfs_initbuf(bp, btp, map[0].bm_bn, map[0].bm_len);
-		return;
-	}
-
-	bytes = sizeof(struct xfs_buf_map) * nmaps;
-	bp->b_maps = malloc(bytes);
-	if (!bp->b_maps) {
-		fprintf(stderr,
-			_("%s: %s can't malloc %u bytes: %s\n"),
-			progname, __FUNCTION__, bytes,
-			strerror(errno));
-		exit(1);
-	}
-	bp->b_map_count = nmaps;
-
-	bytes = 0;
-	for ( i = 0; i < nmaps; i++) {
-		bp->b_maps[i].bm_bn = map[i].bm_bn;
-		bp->b_maps[i].bm_len = map[i].bm_len;
-		bytes += BBTOB(map[i].bm_len);
-	}
-
-	__initbuf(bp, btp, map[0].bm_bn, bytes);
-	bp->b_flags |= LIBXFS_B_DISCONTIG;
-}
-
-static struct xfs_buf *
-__libxfs_getbufr(int blen)
-{
-	struct xfs_buf	*bp;
-
-	/*
-	 * first look for a buffer that can be used as-is,
-	 * if one cannot be found, see if there is a buffer,
-	 * and if so, free its buffer and set b_addr to NULL
-	 * before calling libxfs_initbuf.
-	 */
-	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
-	if (!list_empty(&xfs_buf_freelist.cm_list)) {
-		list_for_each_entry(bp, &xfs_buf_freelist.cm_list, b_node.cn_mru) {
-			if (bp->b_length == BTOBB(blen)) {
-				list_del_init(&bp->b_node.cn_mru);
-				break;
-			}
-		}
-		if (&bp->b_node.cn_mru == &xfs_buf_freelist.cm_list) {
-			bp = list_entry(xfs_buf_freelist.cm_list.next,
-					struct xfs_buf, b_node.cn_mru);
-			list_del_init(&bp->b_node.cn_mru);
-			free(bp->b_addr);
-			bp->b_addr = NULL;
-			if (bp->b_maps != &bp->__b_map)
-				free(bp->b_maps);
-			bp->b_maps = NULL;
-		}
-	} else
-		bp = kmem_cache_zalloc(xfs_buf_zone, 0);
-	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
-	bp->b_ops = NULL;
-	if (bp->b_flags & LIBXFS_B_DIRTY)
-		fprintf(stderr, "found dirty buffer (bulk) on free list!\n");
-
-	return bp;
-}
-
-struct xfs_buf *
-libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
-{
-	struct xfs_buf	*bp;
-	int		blen = BBTOB(bblen);
-
-	bp =__libxfs_getbufr(blen);
-	if (bp)
-		libxfs_initbuf(bp, btp, blkno, blen);
-	return bp;
-}
-
-static struct xfs_buf *
-libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
-		struct xfs_buf_map *map, int nmaps)
-{
-	struct xfs_buf	*bp;
-	int		blen = BBTOB(bblen);
-
-	if (!map || !nmaps) {
-		fprintf(stderr,
-			_("%s: %s invalid map %p or nmaps %d\n"),
-			progname, __FUNCTION__, map, nmaps);
-		exit(1);
-	}
-
-	if (blkno != map[0].bm_bn) {
-		fprintf(stderr,
-			_("%s: %s map blkno 0x%llx doesn't match key 0x%llx\n"),
-			progname, __FUNCTION__, (long long)map[0].bm_bn,
-			(long long)blkno);
-		exit(1);
-	}
-
-	bp =__libxfs_getbufr(blen);
-	if (bp)
-		libxfs_initbuf_map(bp, btp, map, nmaps);
-	return bp;
-}
-
-static int
-__cache_lookup(
-	struct xfs_bufkey	*key,
-	unsigned int		flags,
-	struct xfs_buf		**bpp)
-{
-	struct cache_node	*cn = NULL;
-	struct xfs_buf		*bp;
-
-	*bpp = NULL;
-
-	cache_node_get(libxfs_bcache, key, &cn);
-	if (!cn)
-		return -ENOMEM;
-	bp = container_of(cn, struct xfs_buf, b_node);
-
-	if (use_xfs_buf_lock) {
-		int		ret;
-
-		ret = pthread_mutex_trylock(&bp->b_lock);
-		if (ret) {
-			ASSERT(ret == EAGAIN);
-			if (flags & LIBXFS_GETBUF_TRYLOCK) {
-				cache_node_put(libxfs_bcache, cn);
-				return -EAGAIN;
-			}
-
-			if (pthread_equal(bp->b_holder, pthread_self())) {
-				fprintf(stderr,
-	_("Warning: recursive buffer locking at block %" PRIu64 " detected\n"),
-					key->blkno);
-				bp->b_recur++;
-				*bpp = bp;
-				return 0;
-			} else {
-				pthread_mutex_lock(&bp->b_lock);
-			}
-		}
-
-		bp->b_holder = pthread_self();
-	}
-
-	cache_node_set_priority(libxfs_bcache, cn,
-			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
-	*bpp = bp;
-	return 0;
-}
-
-static int
-libxfs_getbuf_flags(
-	struct xfs_buftarg	*btp,
-	xfs_daddr_t		blkno,
-	int			len,
-	unsigned int		flags,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_bufkey	key = {NULL};
-	int			ret;
-
-	key.buftarg = btp;
-	key.blkno = blkno;
-	key.bblen = len;
-
-	ret = __cache_lookup(&key, flags, bpp);
-	if (ret)
-		return ret;
-
-	if (btp == btp->bt_mount->m_ddev_targp) {
-		(*bpp)->b_pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, blkno));
-	}
-
-	return 0;
-}
-
-/*
- * Clean the buffer flags for libxfs_getbuf*(), which wants to return
- * an unused buffer with clean state.  This prevents CRC errors on a
- * re-read of a corrupt block that was prefetched and freed.  This
- * can happen with a massively corrupt directory that is discarded,
- * but whose blocks are then recycled into expanding lost+found.
- *
- * Note however that if the buffer's dirty (prefetch calls getbuf)
- * we'll leave the state alone because we don't want to discard blocks
- * that have been fixed.
- */
-static void
-reset_buf_state(
-	struct xfs_buf	*bp)
-{
-	if (bp && !(bp->b_flags & LIBXFS_B_DIRTY))
-		bp->b_flags &= ~(LIBXFS_B_UNCHECKED | LIBXFS_B_STALE |
-				LIBXFS_B_UPTODATE);
-}
-
-static int
-__libxfs_buf_get_map(
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	int			flags,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_bufkey	key = {NULL};
-	int			i;
-
-	if (nmaps == 1)
-		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
-				flags, bpp);
-
-	key.buftarg = btp;
-	key.blkno = map[0].bm_bn;
-	for (i = 0; i < nmaps; i++) {
-		key.bblen += map[i].bm_len;
-	}
-	key.map = map;
-	key.nmaps = nmaps;
-
-	return __cache_lookup(&key, flags, bpp);
-}
-
-int
-libxfs_buf_get_map(
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
-{
-	int			error;
-
-	error = __libxfs_buf_get_map(btp, map, nmaps, flags, bpp);
-	if (error)
-		return error;
-
-	reset_buf_state(*bpp);
-	return 0;
-}
-
-void
-libxfs_buf_relse(
-	struct xfs_buf	*bp)
-{
-	/*
-	 * ensure that any errors on this use of the buffer don't carry
-	 * over to the next user.
-	 */
-	bp->b_error = 0;
-	if (use_xfs_buf_lock) {
-		if (bp->b_recur) {
-			bp->b_recur--;
-		} else {
-			bp->b_holder = 0;
-			pthread_mutex_unlock(&bp->b_lock);
-		}
-	}
-
-	if (!list_empty(&bp->b_node.cn_hash))
-		cache_node_put(libxfs_bcache, &bp->b_node);
-	else if (--bp->b_node.cn_count == 0) {
-		if (bp->b_flags & LIBXFS_B_DIRTY)
-			libxfs_bwrite(bp);
-		libxfs_brelse(&bp->b_node);
-	}
-}
-
-static struct cache_node *
-libxfs_balloc(
-	cache_key_t		key)
-{
-	struct xfs_bufkey	*bufkey = (struct xfs_bufkey *)key;
-	struct xfs_buf		*bp;
-
-	if (bufkey->map)
-		bp = libxfs_getbufr_map(bufkey->buftarg, bufkey->blkno,
-				bufkey->bblen, bufkey->map, bufkey->nmaps);
-	else
-		bp = libxfs_getbufr(bufkey->buftarg, bufkey->blkno,
-				bufkey->bblen);
-	return &bp->b_node;
-}
-
-
-static int
-__read_buf(int fd, void *buf, int len, off64_t offset, int flags)
-{
-	int	sts;
-
-	sts = pread(fd, buf, len, offset);
-	if (sts < 0) {
-		int error = errno;
-		fprintf(stderr, _("%s: read failed: %s\n"),
-			progname, strerror(error));
-		return -error;
-	} else if (sts != len) {
-		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
-			progname, sts, len);
-		return -EIO;
-	}
-	return 0;
-}
-
-static int
-libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
-		int len, int flags)
-{
-	int	fd = libxfs_device_to_fd(btp->bt_bdev);
-	int	bytes = BBTOB(len);
-	int	error;
-
-	ASSERT(len <= bp->b_length);
-
-	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
-	if (!error &&
-	    bp->b_target->bt_bdev == btp->bt_bdev &&
-	    bp->b_bn == blkno &&
-	    bp->b_length == len)
-		bp->b_flags |= LIBXFS_B_UPTODATE;
-	bp->b_error = error;
-	return error;
-}
-
-int
-libxfs_readbuf_verify(
-	struct xfs_buf		*bp,
-	const struct xfs_buf_ops *ops)
-{
-	if (!ops)
-		return bp->b_error;
-
-	bp->b_ops = ops;
-	bp->b_ops->verify_read(bp);
-	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
-	return bp->b_error;
-}
-
-static int
-libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
-{
-	int	fd;
-	int	error = 0;
-	void	*buf;
-	int	i;
-
-	fd = libxfs_device_to_fd(btp->bt_bdev);
-	buf = bp->b_addr;
-	for (i = 0; i < bp->b_map_count; i++) {
-		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
-		int len = BBTOB(bp->b_maps[i].bm_len);
-
-		error = __read_buf(fd, buf, len, offset, flags);
-		if (error) {
-			bp->b_error = error;
-			break;
-		}
-		buf += len;
-	}
-
-	if (!error)
-		bp->b_flags |= LIBXFS_B_UPTODATE;
-	return error;
-}
-
-int
-libxfs_buf_read_map(
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
-{
-	struct xfs_buf		*bp;
-	bool			salvage = flags & LIBXFS_READBUF_SALVAGE;
-	int			error = 0;
-
-	*bpp = NULL;
-	if (nmaps == 1)
-		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
-				0, &bp);
-	else
-		error = __libxfs_buf_get_map(btp, map, nmaps, 0, &bp);
-	if (error)
-		return error;
-
-	/*
-	 * If the buffer was prefetched, it is likely that it was not validated.
-	 * Hence if we are supplied an ops function and the buffer is marked as
-	 * unchecked, we need to validate it now.
-	 *
-	 * We do this verification even if the buffer is dirty - the
-	 * verification is almost certainly going to fail the CRC check in this
-	 * case as a dirty buffer has not had the CRC recalculated. However, we
-	 * should not be dirtying unchecked buffers and therefore failing it
-	 * here because it's dirty and unchecked indicates we've screwed up
-	 * somewhere else.
-	 *
-	 * Note that if the caller passes in LIBXFS_READBUF_SALVAGE, that means
-	 * they want the buffer even if it fails verification.
-	 */
-	bp->b_error = 0;
-	if (bp->b_flags & (LIBXFS_B_UPTODATE | LIBXFS_B_DIRTY)) {
-		if (bp->b_flags & LIBXFS_B_UNCHECKED)
-			error = libxfs_readbuf_verify(bp, ops);
-		if (error && !salvage)
-			goto err;
-		goto ok;
-	}
-
-	/*
-	 * Set the ops on a cache miss (i.e. first physical read) as the
-	 * verifier may change the ops to match the type of buffer it contains.
-	 * A cache hit might reset the verifier to the original type if we set
-	 * it again, but it won't get called again and set to match the buffer
-	 * contents. *cough* xfs_da_node_buf_ops *cough*.
-	 */
-	if (nmaps == 1)
-		error = libxfs_readbufr(btp, map[0].bm_bn, bp, map[0].bm_len,
-				flags);
-	else
-		error = libxfs_readbufr_map(btp, bp, flags);
-	if (error)
-		goto err;
-
-	error = libxfs_readbuf_verify(bp, ops);
-	if (error && !salvage)
-		goto err;
-
-ok:
-	*bpp = bp;
-	return 0;
-err:
-	libxfs_buf_relse(bp);
-	return error;
-}
-
-/*
- * Mark a buffer dirty.  The dirty data will be written out when the cache
- * is flushed (or at release time if the buffer is uncached).
- */
-void
-libxfs_buf_mark_dirty(
-	struct xfs_buf	*bp)
-{
-	/*
-	 * Clear any error hanging over from reading the buffer. This prevents
-	 * subsequent reads after this write from seeing stale errors.
-	 */
-	bp->b_error = 0;
-	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= LIBXFS_B_DIRTY;
-}
-
-/* Complain about (and remember) dropping dirty buffers. */
-static void
-libxfs_whine_dirty_buf(
-	struct xfs_buf		*bp)
-{
-	fprintf(stderr, _("%s: Releasing dirty buffer to free list!\n"),
-			progname);
-
-	if (bp->b_error == -EFSCORRUPTED)
-		bp->b_target->flags |= XFS_BUFTARG_CORRUPT_WRITE;
-	bp->b_target->flags |= XFS_BUFTARG_LOST_WRITE;
-}
-
-void
-libxfs_brelse(
-	struct cache_node	*node)
-{
-	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
-						   b_node);
-
-	if (!bp)
-		return;
-	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_whine_dirty_buf(bp);
-	if (bp->b_pag)
-		xfs_perag_put(bp->b_pag);
-	bp->b_pag = NULL;
-
-	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
-	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
-	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
-}
-
-static unsigned int
-libxfs_bulkrelse(
-	struct cache		*cache,
-	struct list_head	*list)
-{
-	struct xfs_buf		*bp;
-	int			count = 0;
-
-	if (list_empty(list))
-		return 0 ;
-
-	list_for_each_entry(bp, list, b_node.cn_mru) {
-		if (bp->b_flags & LIBXFS_B_DIRTY)
-			libxfs_whine_dirty_buf(bp);
-		count++;
-	}
-
-	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
-	list_splice(list, &xfs_buf_freelist.cm_list);
-	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
-
-	return count;
-}
-
-/*
- * Free everything from the xfs_buf_freelist MRU, used at final teardown
- */
-void
-libxfs_bcache_free(void)
-{
-	struct list_head	*cm_list;
-	struct xfs_buf		*bp, *next;
-
-	cm_list = &xfs_buf_freelist.cm_list;
-	list_for_each_entry_safe(bp, next, cm_list, b_node.cn_mru) {
-		free(bp->b_addr);
-		if (bp->b_maps != &bp->__b_map)
-			free(bp->b_maps);
-		kmem_cache_free(xfs_buf_zone, bp);
-	}
-}
-
-/*
- * When a buffer is marked dirty, the error is cleared. Hence if we are trying
- * to flush a buffer prior to cache reclaim that has an error on it it means
- * we've already tried to flush it and it failed. Prevent repeated corruption
- * errors from being reported by skipping such buffers - when the corruption is
- * fixed the buffer will be marked dirty again and we can write it again.
- */
-static int
-libxfs_bflush(
-	struct cache_node	*node)
-{
-	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
-						   b_node);
-
-	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
-		return libxfs_bwrite(bp);
-	return bp->b_error;
-}
-
-void
-libxfs_bcache_purge(void)
-{
-	cache_purge(libxfs_bcache);
-}
-
-void
-libxfs_bcache_flush(void)
-{
-	cache_flush(libxfs_bcache);
-}
-
-int
-libxfs_bcache_overflowed(void)
-{
-	return cache_overflowed(libxfs_bcache);
-}
-
-struct cache_operations libxfs_bcache_operations = {
-	.hash		= libxfs_bhash,
-	.alloc		= libxfs_balloc,
-	.flush		= libxfs_bflush,
-	.relse		= libxfs_brelse,
-	.compare	= libxfs_bcompare,
-	.bulkrelse	= libxfs_bulkrelse
-};
-
-/*
- * Verify an on-disk magic value against the magic value specified in the
- * verifier structure. The verifier magic is in disk byte order so the caller is
- * expected to pass the value directly from disk.
- */
-bool
-xfs_verify_magic(
-	struct xfs_buf		*bp,
-	__be32			dmagic)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	int			idx;
-
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
-	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
-		return false;
-	return dmagic == bp->b_ops->magic[idx];
-}
-
-/*
- * Verify an on-disk magic value against the magic value specified in the
- * verifier structure. The verifier magic is in disk byte order so the caller is
- * expected to pass the value directly from disk.
- */
-bool
-xfs_verify_magic16(
-	struct xfs_buf		*bp,
-	__be16			dmagic)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	int			idx;
-
-	idx = xfs_sb_version_hascrc(&mp->m_sb);
-	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
-		return false;
-	return dmagic == bp->b_ops->magic16[idx];
-}
-
 /*
  * Inode cache stubs.
  */
-
 kmem_zone_t		*xfs_inode_zone;
 extern kmem_zone_t	*xfs_ili_zone;
 
@@ -984,52 +213,6 @@ libxfs_blkdev_issue_flush(
 	return ret ? -errno : 0;
 }
 
-/*
- * Write out a buffer list synchronously.
- *
- * This will take the @buffer_list, write all buffers out and wait for I/O
- * completion on all of the buffers. @buffer_list is consumed by the function,
- * so callers must have some other way of tracking buffers if they require such
- * functionality.
- */
-int
-xfs_buf_delwri_submit(
-	struct list_head	*buffer_list)
-{
-	struct xfs_buf		*bp, *n;
-	int			error = 0, error2;
-
-	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
-		list_del_init(&bp->b_list);
-		error2 = libxfs_bwrite(bp);
-		if (!error)
-			error = error2;
-		libxfs_buf_relse(bp);
-	}
-
-	return error;
-}
-
-/*
- * Cancel a delayed write list.
- *
- * Remove each buffer from the list, clear the delwri queue flag and drop the
- * associated buffer reference.
- */
-void
-xfs_buf_delwri_cancel(
-	struct list_head	*list)
-{
-	struct xfs_buf		*bp;
-
-	while (!list_empty(list)) {
-		bp = list_first_entry(list, struct xfs_buf, b_list);
-
-		list_del_init(&bp->b_list);
-		libxfs_buf_relse(bp);
-	}
-}
-
 /*
  * Format the log. The caller provides either a buftarg which is used to access
  * the log via buffers or a direct pointer to a buffer that encapsulates the
@@ -1056,6 +239,7 @@ libxfs_log_clear(
 	xfs_daddr_t		end_blk;
 	char			*ptr;
 	int			error;
+	LIST_HEAD(buffer_list);
 
 	if (((btp && dptr) || (!btp && !dptr)) ||
 	    (btp && !btp->bt_bdev) || !fs_uuid)
@@ -1085,15 +269,17 @@ libxfs_log_clear(
 	/* write out the first log record */
 	ptr = dptr;
 	if (btp) {
-		error = xfs_buf_get_uncached_daddr(btp, start, len, &bp);
+		error = xfs_buf_get_uncached(btp, len, 0, &bp);
 		if (error)
 			return error;
+
+		bp->b_maps[0].bm_bn = start;
 		ptr = bp->b_addr;
 	}
 	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
 			  next, bp);
 	if (bp) {
-		libxfs_buf_mark_dirty(bp);
+		xfs_bwrite(bp);
 		libxfs_buf_relse(bp);
 	}
 
@@ -1135,9 +321,10 @@ libxfs_log_clear(
 
 		ptr = dptr;
 		if (btp) {
-			error = xfs_buf_get_uncached_daddr(btp, blk, len, &bp);
+			error = xfs_buf_get_uncached(btp, len, 0, &bp);
 			if (error)
 				return error;
+			bp->b_maps[0].bm_bn = blk;
 			ptr = bp->b_addr;
 		}
 		/*
@@ -1147,7 +334,7 @@ libxfs_log_clear(
 		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
 				  tail_lsn, next, bp);
 		if (bp) {
-			libxfs_buf_mark_dirty(bp);
+			xfs_bwrite(bp);
 			libxfs_buf_relse(bp);
 		}
 
@@ -1271,39 +458,3 @@ libxfs_log_header(
 	return BBTOB(len);
 }
 
-void
-libxfs_buf_set_priority(
-	struct xfs_buf	*bp,
-	int		priority)
-{
-	cache_node_set_priority(libxfs_bcache, &bp->b_node, priority);
-}
-
-int
-libxfs_buf_priority(
-	struct xfs_buf	*bp)
-{
-	return cache_node_get_priority(&bp->b_node);
-}
-
-/*
- * Log a message about and stale a buffer that a caller has decided is corrupt.
- *
- * This function should be called for the kinds of metadata corruption that
- * cannot be detect from a verifier, such as incorrect inter-block relationship
- * data.  Do /not/ call this function from a verifier function.
- *
- * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
- * be marked stale, but b_error will not be set.  The caller is responsible for
- * releasing the buffer or fixing it.
- */
-void
-__xfs_buf_mark_corrupt(
-	struct xfs_buf		*bp,
-	xfs_failaddr_t		fa)
-{
-	ASSERT(bp->b_flags & XBF_DONE);
-
-	xfs_buf_corruption_error(bp, fa);
-	xfs_buf_stale(bp);
-}
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 814171eddf4f..573b5ad217e3 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -672,7 +672,6 @@ libxfs_trans_binval(
 
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
-	XFS_BUF_UNDELAYWRITE(bp);
 	xfs_buf_stale(bp);
 
 	bip->bli_flags |= XFS_BLI_STALE;
diff --git a/libxfs/util.c b/libxfs/util.c
index afd69e54f344..d16cf7e6efce 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -6,7 +6,6 @@
 
 #include "libxfs_priv.h"
 #include "libxfs.h"
-#include "libxfs_io.h"
 #include "init.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
diff --git a/libxfs/xfs_buf.c b/libxfs/xfs_buf.c
index a6752e45ab25..f8bedbdbc386 100644
--- a/libxfs/xfs_buf.c
+++ b/libxfs/xfs_buf.c
@@ -18,11 +18,7 @@
 #include "xfs_errortag.h"
 #include "xfs_errortag.h"
 
-#include <libaio.h>
-
-#include "libxfs.h"	/* libxfs_device_to_fd */
-
-//struct kmem_zone *xfs_buf_zone;
+struct kmem_zone *xfs_buf_zone;
 
 /*
  * Locking orders
@@ -41,14 +37,6 @@
  *	b_lock
  *	  pag_buf_lock
  *	    lru_lock
- *
- * xfs_buftarg_wait_rele
- *	lru_lock
- *	  b_lock (trylock due to inversion)
- *
- * xfs_buftarg_isolate
- *	lru_lock
- *	  b_lock (trylock due to inversion)
  */
 
 /*
@@ -144,7 +132,6 @@ xfs_buf_stale(
 	spin_unlock(&bp->b_lock);
 }
 
-#ifdef NOT_YET
 static int
 xfs_buf_get_maps(
 	struct xfs_buf		*bp,
@@ -164,7 +151,6 @@ xfs_buf_get_maps(
 		return -ENOMEM;
 	return 0;
 }
-#endif /* not yet */
 
 static void
 xfs_buf_free_maps(
@@ -176,7 +162,6 @@ xfs_buf_free_maps(
 	}
 }
 
-#ifdef NOT_YET
 static int
 _xfs_buf_alloc(
 	struct xfs_buftarg	*target,
@@ -190,7 +175,7 @@ _xfs_buf_alloc(
 	int			i;
 
 	*bpp = NULL;
-	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
+	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS | __GFP_NOFAIL);
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
@@ -236,7 +221,6 @@ _xfs_buf_alloc(
 	*bpp = bp;
 	return 0;
 }
-#endif /* not yet */
 
 /*
  * Releases the specified buffer.
@@ -318,6 +302,7 @@ xfs_buf_find(
 	spin_lock(&pag->pag_buf_lock);
 	bp = btc_node_find(pag->pag_buf_hash, &cmap);
 	if (bp) {
+		pag->pag_buf_hash->hits++;
 		atomic_inc(&bp->b_hold);
 		goto found;
 	}
@@ -325,6 +310,7 @@ xfs_buf_find(
 	/* No match found */
 	if (!new_bp) {
 		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
+		pag->pag_buf_hash->misses++;
 		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
 		return -ENOENT;
@@ -391,7 +377,6 @@ xfs_buf_incore(
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
  * more hits than misses.
  */
-#ifdef NOT_YET
 int
 xfs_buf_get_map(
 	struct xfs_buftarg	*target,
@@ -457,7 +442,6 @@ _xfs_buf_read(
 
 	return xfs_buf_submit(bp);
 }
-#endif /* not yet */
 
 /*
  * Reverify a buffer found in cache without an attached ->b_ops.
@@ -494,7 +478,6 @@ xfs_buf_reverify(
 	return bp->b_error;
 }
 
-#ifdef NOT_YET
 int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
@@ -506,7 +489,9 @@ xfs_buf_read_map(
 {
 	struct xfs_buf		*bp;
 	int			error;
+	bool			salvage = flags & XBF_SALVAGE;
 
+	flags &= ~XBF_SALVAGE;
 	flags |= XBF_READ;
 	*bpp = NULL;
 
@@ -549,9 +534,12 @@ xfs_buf_read_map(
 	 * future cache lookups will also treat it as an empty, uninitialised
 	 * buffer.
 	 */
-	if (error) {
+	if (error && !salvage) {
+		/*
+		 * XXX: This breaks LTO for some unknown reason!
 		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
 			xfs_buf_ioerror_alert(bp, __this_address);
+		 */
 
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
@@ -566,7 +554,6 @@ xfs_buf_read_map(
 	*bpp = bp;
 	return 0;
 }
-#endif /* not yet */
 
 /*
  *	If we are not low on memory then do the readahead in a deadlock
@@ -599,7 +586,6 @@ xfs_buf_hold(
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 	atomic_inc(&bp->b_hold);
-	bp->b_node.cn_count++;
 }
 
 /*
@@ -655,8 +641,7 @@ xfs_buf_rele(
 
 	/* the last reference has been dropped ... */
 	__xfs_buf_ioacct_dec(bp);
-	//if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
-	if (0) {
+	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU take a new reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
@@ -813,15 +798,36 @@ __xfs_buf_ioerror(
 void
 xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
-	const char		*func)
+	xfs_failaddr_t		failaddr)
 {
 	xfs_alert(bp->b_target->bt_mount,
-"metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
-			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
+"metadata I/O error at %p at daddr 0x%llx len %d error %d",
+			failaddr, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
 			-bp->b_error);
 }
 
-#ifdef NOT_YET
+/*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_flags & XBF_DONE);
+
+	xfs_buf_corruption_error(bp, fa);
+	xfs_buf_stale(bp);
+}
+
 int
 xfs_bread(
 	struct xfs_buf		*bp,
@@ -862,7 +868,6 @@ xfs_bwrite(
 	}
 	return error;
 }
-#endif /* not yet */
 
 /*
  * Wait for I/O completion of a sync buffer and return the I/O error code.
@@ -960,7 +965,6 @@ __xfs_buf_submit(
  * Remove each buffer from the list, clear the delwri queue flag and drop the
  * associated buffer reference.
  */
-#ifdef NOT_YET
 void
 xfs_buf_delwri_cancel(
 	struct list_head	*list)
@@ -1226,7 +1230,6 @@ xfs_buf_delwri_pushbuf(
 
 	return error;
 }
-#endif /* not yet */
 
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {
@@ -1242,7 +1245,6 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 	atomic_set(&bp->b_lru_ref, lru_ref);
 }
 
-#ifdef NOT_YET
 /*
  * Verify an on-disk magic value against the magic value specified in the
  * verifier structure. The verifier magic is in disk byte order so the caller is
@@ -1295,12 +1297,13 @@ xfs_buf_read_uncached(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	*bpp = NULL;
 
-	bp = xfs_buf_get_uncached(target, numblks, flags);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_uncached(target, numblks, flags, &bp);
+	if (error)
+		return error;
 
 	/* set up the buffer for a read IO */
 	ASSERT(bp->b_map_count == 1);
@@ -1311,7 +1314,7 @@ xfs_buf_read_uncached(
 
 	xfs_buf_submit(bp);
 	if (bp->b_error) {
-		int	error = bp->b_error;
+		error = bp->b_error;
 		xfs_buf_relse(bp);
 		return error;
 	}
@@ -1320,31 +1323,35 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
-struct xfs_buf *
+int
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
 	size_t			numblks,
-	int			flags)
+	int			flags,
+	struct xfs_buf		**bpp)
 {
 	int			error;
 	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
+	*bpp = NULL;
+
 	/* flags might contain irrelevant bits, pass only what we care about */
-	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
-	if (unlikely(bp == NULL))
+	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
+	if (error)
 		goto fail;
 
 	error = xfs_buf_allocate_memory(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
+
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 
  fail_free_buf:
 	kmem_cache_free(xfs_buf_zone, bp);
  fail:
-	return NULL;
+	return error;
 }
-#endif
diff --git a/libxfs/xfs_buf.h b/libxfs/xfs_buf.h
index 0ed1f9793e15..4b6dff885165 100644
--- a/libxfs/xfs_buf.h
+++ b/libxfs/xfs_buf.h
@@ -49,8 +49,7 @@ typedef void (*xfs_buf_iodone_t)(struct xfs_buf *bp);
  * clean up soon and should be identical between kernel and userspace..
  */
 struct xfs_buf {
-	struct cache_node	b_node;
-	struct list_head	b_hash;	/* will replace b_node */
+	struct list_head	b_hash;
 	xfs_daddr_t		b_bn;
 	unsigned int		b_length;
 	unsigned int		b_flags;
@@ -72,6 +71,7 @@ struct xfs_buf {
 	int			b_io_error;
 	struct list_head	b_list;
 	struct list_head	b_li_list;	/* Log items list head */
+	int			b_prio;		/* XXX: repair prefetch */
 
 	struct list_head	b_btc_list;
 	unsigned int		b_state;
@@ -138,6 +138,25 @@ int xfs_bread(struct xfs_buf *bp, size_t bblen);
 
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
 
+static inline void
+xfs_buf_zero(struct xfs_buf *bp, uint boff, int len)
+{
+	memset(bp->b_addr + boff, 0, len);
+}
+
+int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
+				int flags, struct xfs_buf **bpp);
+int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
+			  size_t numblks, int flags, struct xfs_buf **bpp,
+			  const struct xfs_buf_ops *ops);
+
+/* Delayed Write Buffer Routines */
+void xfs_buf_delwri_cancel(struct list_head *);
+bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
+int xfs_buf_delwri_submit(struct list_head *);
+int xfs_buf_delwri_submit_nowait(struct list_head *);
+int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
+
 /* Locking and Unlocking Buffers */
 int xfs_buf_trylock(struct xfs_buf *bp);
 void xfs_buf_lock(struct xfs_buf *bp);
@@ -146,13 +165,11 @@ void xfs_buf_unlock(struct xfs_buf *bp);
 /* Releasing Buffers */
 void xfs_buf_hold(struct xfs_buf *bp);
 void xfs_buf_rele(struct xfs_buf *bp);
-/*
 static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
 	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
 }
-*/
 void xfs_buf_free(struct xfs_buf *bp);
 
 
@@ -164,14 +181,16 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
 	return __xfs_buf_submit(bp, wait);
 }
 
+int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 void xfs_buf_stale(struct xfs_buf *bp);
 void xfs_buf_ioend(struct xfs_buf *bp);
-void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
-		xfs_failaddr_t failaddr);
-void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
-
+void __xfs_buf_ioerror(struct xfs_buf *bp, int error, xfs_failaddr_t fa);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 
+void xfs_buf_ioerror_alert(struct xfs_buf *, xfs_failaddr_t fa);
+
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /*
  * These macros use the IO block map rather than b_bn. b_bn is now really
@@ -191,13 +210,27 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref);
  * If the buffer is already on the LRU, do nothing. Otherwise set the buffer
  * up with a reference count of 0 so it will be tossed from the cache when
  * released.
+ */
 static inline void xfs_buf_oneshot(struct xfs_buf *bp)
 {
 	if (!list_empty(&bp->b_lru) || atomic_read(&bp->b_lru_ref) > 1)
 		return;
 	atomic_set(&bp->b_lru_ref, 0);
 }
- */
+
+static inline int
+xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				cksum_offset);
+}
+
+static inline void
+xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
+{
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 cksum_offset);
+}
 
  #endif	/* __LIBXFS_IO_H__ */
 
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index d2ce47e22545..61c4a3164d23 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -17,6 +17,10 @@ struct xfs_buf;
 struct xfs_buf_map;
 struct xfs_mount;
 
+/* this needs to die */
+#define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
+
+
 /*
  * The xfs_buftarg contains 2 notions of "sector size" -
  *
@@ -63,12 +67,18 @@ struct xfs_buftarg {
  */
 struct xfs_buftarg *xfs_buftarg_alloc(struct xfs_mount *mp, dev_t bdev);
 void xfs_buftarg_free(struct xfs_buftarg *target);
-void xfs_buftarg_wait(struct xfs_buftarg *target);
 int xfs_buftarg_setsize(struct xfs_buftarg *target, unsigned int size);
 void xfs_buftarg_purge_ag(struct xfs_buftarg *btp, xfs_agnumber_t agno);
+int xfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 
+/* XXX: flags used by libxfs - these need to go */
+#define LIBXFS_B_EXIT          (1 << 31)       /* exit on failure */
+#define LIBXFS_B_UNCHECKED     (1 << 30)       /* needs verification */
+#define LIBXFS_B_DIRTY         (1 << 29)       /* needs writeback - REMOVE ME*/
+#define LIBXFS_B_INODEBUF      (1 << 28)       /* repair prefetch state */
+
 /*
  * Low level buftarg IO routines.
  *
@@ -77,24 +87,8 @@ void xfs_buftarg_purge_ag(struct xfs_buftarg *btp, xfs_agnumber_t agno);
  */
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
 int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
-
-int xfs_buf_get_uncached_daddr(struct xfs_buftarg *target, xfs_daddr_t daddr,
-				size_t bblen, struct xfs_buf **bpp);
-static inline int
-xfs_buf_get_uncached(
-	struct xfs_buftarg	*target,
-	size_t			bblen,
-	int			flags,
-	struct xfs_buf		**bpp)
-{
-	return xfs_buf_get_uncached_daddr(target, XFS_BUF_DADDR_NULL, bblen, bpp);
-}
-
-int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
-			  size_t bblen, int flags, struct xfs_buf **bpp,
-			  const struct xfs_buf_ops *ops);
-
 void xfs_buftarg_submit_io(struct xfs_buf *bp);
+void xfs_buf_mark_dirty(struct xfs_buf *bp);
 
 /*
  * Cached buffer memory manangement
@@ -102,40 +96,27 @@ void xfs_buftarg_submit_io(struct xfs_buf *bp);
 int xfs_buf_allocate_memory(struct xfs_buf *bp, uint flags);
 void xfs_buf_free_memory(struct xfs_buf *bp);
 
-/*
- * Temporary: these need to be the same as the LIBXFS_B_* flags until we change
- * over to the kernel structures. For those that aren't the same or don't yet
- * exist, start the numbering from the top down.
- */
-#define XBF_READ	(1 << 31)
-#define XBF_WRITE	(1 << 30)
-#define XBF_DONE	(1 << 3)	// LIBXFS_B_UPTODATE	0x0008
-#define XBF_STALE	(1 << 2)	// LIBXFS_B_STALE	0x0004
-
-#define XBF_READ_AHEAD	(1 << 30) /* asynchronous read-ahead */
-#define XBF_NO_IOACCT	(1 << 29) /* bypass I/O accounting (non-LRU bufs) */
-#define XBF_ASYNC	(1 << 28) /* initiator will not wait for completion */
-#define XBF_WRITE_FAIL	(0)	  /* unused in userspace */
+#define XBF_READ	(1 << 0) /* buffer intended for reading from device */
+#define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
+#define XBF_NO_IOACCT	(1 << 3) /* bypass I/O accounting (non-LRU bufs) */
+#define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
+#define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
+#define XBF_STALE	(1 << 6) /* buffer has been staled, do not find it */
+#define XBF_WRITE_FAIL	(1 << 7) /* async writes have failed on this buffer */
 
 /* buffer type flags for write callbacks */
-#define _XBF_INODES	(0)/* inode buffer */
-#define _XBF_DQUOTS	(0)/* dquot buffer */
-#define _XBF_LOGRECOVERY (0)/* log recovery buffer */
-
-/* flags used only as arguments to access routines */
-#define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	 (0)	  /* unused in userspace */
+#define _XBF_INODES	(1 << 10)/* inode buffer */
+#define _XBF_DQUOTS	(1 << 11)/* dquot buffer */
+#define _XBF_LOGRECOVERY (1 << 12)/* log recovery buffer */
 
 /* flags used only internally */
-#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
+#define _XBF_DELWRI_Q	(1 << 16)/* buffer on a delwri queue */
 
-/*
- * Raw buffer access functions. These exist as temporary bridges for uncached IO
- * that uses direct access to the buffers to submit IO. These will go away with
- * the new buffer cache IO engine.
- */
-struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno,
-			int bblen);
+/* flags used only as arguments to access routines */
+#define XBF_TRYLOCK	(1 << 20)/* lock requested, but do not wait */
+#define XBF_UNMAPPED	(1 << 21)/* do not map the buffer */
+#define XBF_SALVAGE	(1 << 22) /* caller will attempt to salvage buffer */
 
 /* temporary, just for compile for the moment */
 #define xfs_buf_ioend_async(bp)		xfs_buf_ioend(bp)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 87e1881e3152..ad96b9274c92 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3497,10 +3497,10 @@ prepare_devices(
 	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
 	 * swath to be sure)
 	 */
-	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp,
-				(xi->dsize - whack_blks), whack_blks, &buf);
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, whack_blks, 0, &buf);
 	if (error)
 		goto out_error;
+	buf->b_maps[0].bm_bn = xi->dsize - whack_blks;
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
@@ -3511,19 +3511,21 @@ prepare_devices(
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp, 0, whack_blks, &buf);
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, whack_blks, 0, &buf);
 	if (error)
 		goto out_error;
+	buf->b_maps[0].bm_bn = 0;
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
 	/* OK, now write the superblock... */
-	error = xfs_buf_get_uncached_daddr(mp->m_ddev_targp, XFS_SB_DADDR,
-			XFS_FSS_TO_BB(mp, 1), &buf);
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, XFS_FSS_TO_BB(mp, 1), 0,
+					&buf);
 	if (error)
 		goto out_error;
 	buf->b_ops = &xfs_sb_buf_ops;
+	buf->b_maps[0].bm_bn = XFS_SB_DADDR;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
 	libxfs_buf_mark_dirty(buf);
@@ -3543,11 +3545,11 @@ prepare_devices(
 	/* finally, check we can write the last block in the realtime area */
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev &&
 	    cfg->rtblocks > 0) {
-		error = xfs_buf_get_uncached_daddr(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
-				BTOBB(cfg->blocksize), &buf);
+		error = xfs_buf_get_uncached(mp->m_rtdev_targp,
+					BTOBB(cfg->blocksize), 0, &buf);
 		if (error)
 			goto out_error;
+		buf->b_maps[0].bm_bn = XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL);
 		memset(buf->b_addr, 0, cfg->blocksize);
 		libxfs_buf_mark_dirty(buf);
 		libxfs_buf_relse(buf);
@@ -4070,7 +4072,6 @@ main(
 	 * Need to drop references to inodes we still hold, first.
 	 */
 	libxfs_rtmount_destroy(mp);
-	libxfs_bcache_purge();
 
 	/*
 	 * Mark the filesystem ok.
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 01e39304012e..5f994d78902b 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -407,7 +407,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			break;
 		}
 		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
+				XFS_FSB_TO_BB(mp, 1), XBF_SALVAGE,
 				&bp, &xfs_attr3_rmt_buf_ops);
 		if (error) {
 			do_warn(
@@ -767,7 +767,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 
 		error = -libxfs_buf_read(mp->m_dev,
 				XFS_FSB_TO_DADDR(mp, dev_bno),
-				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
+				XFS_FSB_TO_BB(mp, 1), XBF_SALVAGE,
 				&bp, &xfs_attr3_leaf_buf_ops);
 		if (error) {
 			do_warn(
@@ -1099,7 +1099,7 @@ process_longform_attr(
 	}
 
 	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			XFS_FSB_TO_BB(mp, 1), XBF_SALVAGE, &bp,
 			&xfs_da3_node_buf_ops);
 	if (error) {
 		do_warn(
diff --git a/repair/da_util.c b/repair/da_util.c
index 7239c2e2c64f..a91a2c0fee9c 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -64,7 +64,7 @@ da_read_buf(
 		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
 		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
-	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
+	libxfs_buf_read_map(mp->m_dev, map, nex, XBF_SALVAGE,
 			&bp, ops);
 	if (map != map_array)
 		free(map);
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index c87a435d8c6a..84db42fcdd44 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -41,7 +41,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	 * so no one else will overlap them.
 	 */
 	error = -libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			XFS_FSB_TO_BB(mp, 1), XBF_SALVAGE, &bp,
 			NULL);
 	if (error) {
 		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
@@ -669,7 +669,7 @@ process_inode_chunk(
 				XFS_AGB_TO_DADDR(mp, agno, agbno),
 				XFS_FSB_TO_BB(mp,
 					M_IGEO(mp)->blocks_per_cluster),
-				LIBXFS_READBUF_SALVAGE, &bplist[bp_index],
+				XBF_SALVAGE, &bplist[bp_index],
 				&xfs_inode_buf_ops);
 		if (error) {
 			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
diff --git a/repair/dinode.c b/repair/dinode.c
index c89f21e08373..38ac2e7136ca 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1106,7 +1106,7 @@ process_quota_inode(
 
 		error = -libxfs_buf_read(mp->m_dev,
 				XFS_FSB_TO_DADDR(mp, fsbno), dqchunklen,
-				LIBXFS_READBUF_SALVAGE, &bp,
+				XBF_SALVAGE, &bp,
 				&xfs_dquot_buf_ops);
 		if (error) {
 			do_warn(
@@ -1218,7 +1218,7 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
 
 		error = -libxfs_buf_read(mp->m_dev,
 				XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(byte_cnt),
-				LIBXFS_READBUF_SALVAGE, &bp,
+				XBF_SALVAGE, &bp,
 				&xfs_symlink_buf_ops);
 		if (error) {
 			do_warn(
diff --git a/repair/phase3.c b/repair/phase3.c
index ca4dbee47434..fdd3b391d26b 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -31,7 +31,7 @@ process_agi_unlinked(
 
 	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			mp->m_sb.sb_sectsize / BBSIZE, LIBXFS_READBUF_SALVAGE,
+			mp->m_sb.sb_sectsize / BBSIZE, XBF_SALVAGE,
 			&bp, &xfs_agi_buf_ops);
 	if (error)
 		do_error(_("cannot read agi block %" PRId64 " for ag %u\n"),
@@ -62,15 +62,18 @@ process_ag_func(
 	xfs_agnumber_t 		agno,
 	void			*arg)
 {
+	struct xfs_mount	*mp = wq->wq_ctx;
+
 	/*
 	 * turn on directory processing (inode discovery) and
 	 * attribute processing (extra_attr_check)
 	 */
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
-	process_aginodes(wq->wq_ctx, arg, agno, 1, 0, 1);
+	process_aginodes(mp, arg, agno, 1, 0, 1);
 	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
+	libxfs_buftarg_purge_ag(mp->m_ddev_targp, agno);
 }
 
 static void
diff --git a/repair/phase4.c b/repair/phase4.c
index 191b484262af..3d66d030a67a 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -126,11 +126,14 @@ process_ag_func(
 	xfs_agnumber_t 		agno,
 	void			*arg)
 {
+	struct xfs_mount	*mp = wq->wq_ctx;
+
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
-	process_aginodes(wq->wq_ctx, arg, agno, 0, 1, 0);
+	process_aginodes(mp, arg, agno, 0, 1, 0);
 	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
+	libxfs_buftarg_purge_ag(mp->m_ddev_targp, agno);
 
 	/*
 	 * now recycle the per-AG duplicate extent records
diff --git a/repair/prefetch.c b/repair/prefetch.c
index aacb96cec0da..4c74255066b8 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -42,6 +42,7 @@ static void		pf_read_inode_dirs(prefetch_args_t *, struct xfs_buf *);
  * Directory metadata is ranked higher than other metadata as it's used
  * in phases 3, 4 and 6, while other metadata is only used in 3 & 4.
  */
+#define CACHE_PREFETCH_PRIORITY 8
 
 /* intermediate directory btree nodes - can't be queued */
 #define B_DIR_BMAP	CACHE_PREFETCH_PRIORITY + 7
@@ -60,6 +61,21 @@ static void		pf_read_inode_dirs(prefetch_args_t *, struct xfs_buf *);
 /* inode clusters without any directory entries */
 #define B_INODE		CACHE_PREFETCH_PRIORITY
 
+static void
+buf_set_priority(
+	struct xfs_buf	*bp,
+	int		priority)
+{
+	bp->b_prio = priority;
+}
+
+static int
+buf_priority(
+	struct xfs_buf	*bp)
+{
+	return bp->b_prio;
+}
+
 /*
  * Test if bit 0 or 2 is set in the "priority tag" of the buffer to see if
  * the buffer is for an inode or other metadata.
@@ -122,19 +138,19 @@ pf_queue_io(
 	 * completely overwriting it this behaviour is perfectly fine.
 	 */
 	error = -libxfs_buf_get_map(mp->m_dev, map, nmaps,
-			LIBXFS_GETBUF_TRYLOCK, &bp);
+			XBF_TRYLOCK, &bp);
 	if (error)
 		return;
 
-	if (bp->b_flags & LIBXFS_B_UPTODATE) {
+	if (bp->b_flags & XBF_DONE) {
 		if (B_IS_INODE(flag))
 			pf_read_inode_dirs(args, bp);
-		libxfs_buf_set_priority(bp, libxfs_buf_priority(bp) +
+		buf_set_priority(bp, buf_priority(bp) +
 						CACHE_PREFETCH_PRIORITY);
 		libxfs_buf_relse(bp);
 		return;
 	}
-	libxfs_buf_set_priority(bp, flag);
+	buf_set_priority(bp, flag);
 
 	pthread_mutex_lock(&args->lock);
 
@@ -148,7 +164,7 @@ pf_queue_io(
 		}
 	} else {
 		ASSERT(!B_IS_INODE(flag));
-		libxfs_buf_set_priority(bp, B_DIR_META_2);
+		buf_set_priority(bp, B_DIR_META_2);
 	}
 
 	pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to queue"
@@ -276,12 +292,12 @@ pf_scan_lbtree(
 	int			error;
 
 	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
-			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			XFS_FSB_TO_BB(mp, 1), XBF_SALVAGE, &bp,
 			&xfs_bmbt_buf_ops);
 	if (error)
 		return 0;
 
-	libxfs_buf_set_priority(bp, isadir ? B_DIR_BMAP : B_BMAP);
+	buf_set_priority(bp, isadir ? B_DIR_BMAP : B_BMAP);
 
 	/*
 	 * If the verifier flagged a problem with the buffer, we can't trust
@@ -407,7 +423,8 @@ pf_read_inode_dirs(
 	int			isadir;
 	int			error;
 
-	error = -libxfs_readbuf_verify(bp, &xfs_inode_buf_ops);
+	error = -libxfs_buf_reverify(bp, &xfs_inode_buf_ops);
+	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 	if (error)
 		return;
 
@@ -461,7 +478,7 @@ pf_read_inode_dirs(
 		}
 	}
 	if (hasdir)
-		libxfs_buf_set_priority(bp, B_DIR_INODE);
+		buf_set_priority(bp, B_DIR_INODE);
 }
 
 /*
@@ -504,13 +521,13 @@ pf_batch_read(
 			 * list and seeking back over ranges we've already done
 			 * optimised reads for.
 			 */
-			if ((bplist[num]->b_flags & LIBXFS_B_DISCONTIG)) {
+			if (bplist[num]->b_map_count > 1) {
 				num++;
 				break;
 			}
 
 			if (which != PF_META_ONLY ||
-				  !B_IS_INODE(libxfs_buf_priority(bplist[num])))
+				  !B_IS_INODE(buf_priority(bplist[num])))
 				num++;
 			if (num == MAX_BUFS)
 				break;
@@ -560,7 +577,7 @@ pf_batch_read(
 
 		if (which == PF_PRIMARY) {
 			for (inode_bufs = 0, i = 0; i < num; i++) {
-				if (B_IS_INODE(libxfs_buf_priority(bplist[i])))
+				if (B_IS_INODE(buf_priority(bplist[i])))
 					inode_bufs++;
 			}
 			args->inode_bufs_queued -= inode_bufs;
@@ -588,7 +605,7 @@ pf_batch_read(
 		 * guarantees that only the last buffer in the list will be a
 		 * discontiguous buffer.
 		 */
-		if (lbp->b_flags & LIBXFS_B_DISCONTIG) {
+		if (lbp->b_map_count > 1) {
 			libxfs_bread(lbp, lbp->b_length);
 			lbp->b_flags |= LIBXFS_B_UNCHECKED;
 			libxfs_buf_relse(lbp);
@@ -608,22 +625,22 @@ pf_batch_read(
 				if (len < size)
 					break;
 				memcpy(bplist[i]->b_addr, pbuf, size);
-				bplist[i]->b_flags |= (LIBXFS_B_UPTODATE |
+				bplist[i]->b_flags |= (XBF_DONE |
 						       LIBXFS_B_UNCHECKED);
 				len -= size;
-				if (B_IS_INODE(libxfs_buf_priority(bplist[i])))
+				if (B_IS_INODE(buf_priority(bplist[i])))
 					pf_read_inode_dirs(args, bplist[i]);
 				else if (which == PF_META_ONLY)
-					libxfs_buf_set_priority(bplist[i],
+					buf_set_priority(bplist[i],
 								B_DIR_META_H);
 				else if (which == PF_PRIMARY && num == 1)
-					libxfs_buf_set_priority(bplist[i],
+					buf_set_priority(bplist[i],
 								B_DIR_META_S);
 			}
 		}
 		for (i = 0; i < num; i++) {
 			pftrace("putbuf %c %p (%llu) in AG %d",
-				B_IS_INODE(libxfs_buf_priority(bplist[i])) ?
+				B_IS_INODE(buf_priority(bplist[i])) ?
 								      'I' : 'M',
 				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
 				args->agno);
@@ -916,11 +933,11 @@ start_inode_prefetch(
 	args->dirs_only = dirs_only;
 
 	/*
-	 * use only 1/8 of the libxfs cache as we are only counting inodes
-	 * and not any other associated metadata like directories
+	 * Cache  is now per-ag, so we can use most of it here as we are only
+	 * counting inodes and not any other associated metadata like
+	 * directories
 	 */
-
-	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
+	max_queue = min(libxfs_bhash_size * 4, 1024);
 	if (igeo->inode_cluster_size > mp->m_sb.sb_blocksize)
 		max_queue = max_queue * igeo->blocks_per_cluster /
 				igeo->ialloc_blks;
@@ -1028,11 +1045,12 @@ do_inode_prefetch(
 	int			queues_started = 0;
 
 	/*
+	 * XXX
+	 *
 	 * If the previous phases of repair have not overflowed the buffer
 	 * cache, then we don't need to re-read any of the metadata in the
 	 * filesystem - it's all in the cache. In that case, run a thread per
 	 * CPU to maximise parallelism of the queue to be processed.
-	 */
 	if (check_cache && !libxfs_bcache_overflowed()) {
 		queue.wq_ctx = mp;
 		create_work_queue(&queue, mp, platform_nproc());
@@ -1041,6 +1059,7 @@ do_inode_prefetch(
 		destroy_work_queue(&queue);
 		return;
 	}
+	 */
 
 	/*
 	 * single threaded behaviour - single prefetch thread, processed
diff --git a/repair/progress.c b/repair/progress.c
index f6c4d988444e..6252e19e9c67 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -383,14 +383,18 @@ timediff(int phase)
 **  array.
 */
 char *
-timestamp(int end, int phase, char *buf)
+timestamp(
+	struct xfs_mount *mp,
+	int		end,
+	int		phase,
+	char		*buf)
 {
 
-	time_t    now;
-	struct tm *tmp;
+	time_t		now;
+	struct tm	*tmp;
 
 	if (verbose > 1)
-		cache_report(stderr, "libxfs_bcache", libxfs_bcache);
+		btc_report(stderr, "Buffer Cache", mp);
 
 	now = time(NULL);
 
diff --git a/repair/progress.h b/repair/progress.h
index 2c1690db1b17..7d5009568462 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -3,6 +3,8 @@
 #ifndef	_XFS_REPAIR_PROGRESS_RPT_H_
 #define	_XFS_REPAIR_PROGRESS_RPT_H_
 
+struct xfs_mount;
+
 #define PROG_RPT_DEFAULT	(15*60)	 /* default 15 minute report interval */
 #define	PHASE_START		0
 #define	PHASE_END		1
@@ -37,7 +39,7 @@ extern void stop_progress_rpt(void);
 extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
-extern char *timestamp(int end, int phase, char *buf);
+extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
 extern char *duration(int val, char *buf);
 extern int do_parallel;
 
diff --git a/repair/scan.c b/repair/scan.c
index f962d9b71226..9e3ec2354a9d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -42,7 +42,10 @@ struct aghdr_cnts {
 void
 set_mp(xfs_mount_t *mpp)
 {
+	/*
+	 * XXX: whyfor this do?
 	libxfs_bcache_purge();
+	 */
 	mp = mpp;
 }
 
@@ -60,8 +63,7 @@ salvage_buffer(
 {
 	int			error;
 
-	error = -libxfs_buf_read(target, blkno, numblks,
-			LIBXFS_READBUF_SALVAGE, bpp, ops);
+	error = -libxfs_buf_read(target, blkno, numblks, XBF_SALVAGE, bpp, ops);
 	if (error != EIO)
 		return error;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 724661d848c4..33652853ef7a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -724,7 +724,6 @@ main(int argc, char **argv)
 	char		*msgbuf;
 	struct xfs_sb	psb;
 	int		rval;
-	struct xfs_ino_geometry	*igeo;
 	int		error;
 
 	progname = basename(argv[0]);
@@ -741,8 +740,8 @@ main(int argc, char **argv)
 
 	msgbuf = malloc(DURATION_BUF_SIZE);
 
-	timestamp(PHASE_START, 0, NULL);
-	timestamp(PHASE_END, 0, NULL);
+	timestamp(NULL, PHASE_START, 0, NULL);
+	timestamp(NULL, PHASE_END, 0, NULL);
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
@@ -765,7 +764,7 @@ main(int argc, char **argv)
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
-	timestamp(PHASE_END, 1, NULL);
+	timestamp(NULL, PHASE_END, 1, NULL);
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -788,6 +787,87 @@ main(int argc, char **argv)
 	if (isa_file)
 		check_fs_vs_host_sectsize(&psb);
 
+	/*
+	 * Adjust per-ag buffer cache sizes based on system memory,
+	 * filesystem size, inode count and the number of AGs.
+	 *
+	 * We'll set the cache size based on 3/4s the memory minus
+	 * space used by the inode AVL tree and block usage map.
+	 *
+	 * Inode AVL tree space is approximately 4 bytes per inode,
+	 * block usage map is currently 1 byte for 2 blocks.
+	 *
+	 * We assume most blocks will be inode clusters.
+	 *
+	 * Calculations are done in kilobyte units.
+	 */
+
+	if (!bhash_option_used || max_mem_specified) {
+		unsigned long	mem_used;
+		unsigned long	max_mem;
+		struct rlimit	rlim;
+
+
+		mem_used = (psb.sb_icount >> (10 - 2)) +
+					(psb.sb_dblocks >> (10 + 1)) +
+					50000;	/* rough estimate of 50MB overhead */
+		max_mem = max_mem_specified ? max_mem_specified * 1024 :
+						platform_physmem() * 3 / 4;
+
+		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
+					rlim.rlim_cur != RLIM_INFINITY) {
+			rlim.rlim_cur = rlim.rlim_max;
+			setrlimit(RLIMIT_AS, &rlim);
+			/* use approximately 80% of rlimit to avoid overrun */
+			max_mem = min(max_mem, rlim.rlim_cur / 1280);
+		} else
+			max_mem = min(max_mem, (LONG_MAX >> 10) + 1);
+
+		if (verbose > 1)
+			do_log(
+	_("        - max_mem = %lu, icount = %" PRIu64 ", imem = %" PRIu64 ", dblock = %" PRIu64 ", dmem = %" PRIu64 "\n"),
+				max_mem, psb.sb_icount,
+				psb.sb_icount >> (10 - 2),
+				psb.sb_dblocks,
+				psb.sb_dblocks >> (10 + 1));
+
+		if (max_mem <= mem_used) {
+			if (max_mem_specified) {
+				do_abort(
+	_("Required memory for repair is greater that the maximum specified\n"
+	  "with the -m option. Please increase it to at least %lu.\n"),
+					mem_used / 1024);
+			}
+			do_log(
+	_("Memory available for repair (%luMB) may not be sufficient.\n"
+	  "At least %luMB is needed to repair this filesystem efficiently\n"
+	  "If repair fails due to lack of memory, please\n"),
+				max_mem / 1024, mem_used / 1024);
+			if (do_prefetch)
+				do_log(
+	_("turn prefetching off (-P) to reduce the memory footprint.\n"));
+			else
+				do_log(
+	_("increase system RAM and/or swap space to at least %luMB.\n"),
+			mem_used * 2 / 1024);
+
+			max_mem = mem_used;
+		}
+
+		max_mem -= mem_used;
+		if (max_mem >= (1 << 30))
+			max_mem = 1 << 30;
+		libxfs_bhash_size = max_mem / (HASH_CACHE_RATIO *
+				((32 * psb.sb_inodesize) >> 10));
+		libxfs_bhash_size /= psb.sb_agcount;
+		if (libxfs_bhash_size < 128)
+			libxfs_bhash_size = 128;
+
+		if (verbose)
+			do_log(_("        - block cache size set to %d entries\n"),
+				libxfs_bhash_size * HASH_CACHE_RATIO);
+	}
+
 	/*
 	 * Prepare the mount structure. Point the log reference to our local
 	 * copy so it's available to the various phases. The log bits are
@@ -803,7 +883,6 @@ main(int argc, char **argv)
 		exit(1);
 	}
 	mp->m_log = &log;
-	igeo = M_IGEO(mp);
 
 	/* Spit out function & line on these corruption macros */
 	if (verbose > 2)
@@ -878,91 +957,6 @@ main(int argc, char **argv)
 		}
 	}
 
-	/*
-	 * Adjust libxfs cache sizes based on system memory,
-	 * filesystem size and inode count.
-	 *
-	 * We'll set the cache size based on 3/4s the memory minus
-	 * space used by the inode AVL tree and block usage map.
-	 *
-	 * Inode AVL tree space is approximately 4 bytes per inode,
-	 * block usage map is currently 1 byte for 2 blocks.
-	 *
-	 * We assume most blocks will be inode clusters.
-	 *
-	 * Calculations are done in kilobyte units.
-	 */
-
-	if (!bhash_option_used || max_mem_specified) {
-		unsigned long 	mem_used;
-		unsigned long	max_mem;
-		struct rlimit	rlim;
-
-		libxfs_bcache_purge();
-		cache_destroy(libxfs_bcache);
-
-		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
-					(mp->m_sb.sb_dblocks >> (10 + 1)) +
-					50000;	/* rough estimate of 50MB overhead */
-		max_mem = max_mem_specified ? max_mem_specified * 1024 :
-					      platform_physmem() * 3 / 4;
-
-		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
-					rlim.rlim_cur != RLIM_INFINITY) {
-			rlim.rlim_cur = rlim.rlim_max;
-			setrlimit(RLIMIT_AS, &rlim);
-			/* use approximately 80% of rlimit to avoid overrun */
-			max_mem = min(max_mem, rlim.rlim_cur / 1280);
-		} else
-			max_mem = min(max_mem, (LONG_MAX >> 10) + 1);
-
-		if (verbose > 1)
-			do_log(
-	_("        - max_mem = %lu, icount = %" PRIu64 ", imem = %" PRIu64 ", dblock = %" PRIu64 ", dmem = %" PRIu64 "\n"),
-				max_mem, mp->m_sb.sb_icount,
-				mp->m_sb.sb_icount >> (10 - 2),
-				mp->m_sb.sb_dblocks,
-				mp->m_sb.sb_dblocks >> (10 + 1));
-
-		if (max_mem <= mem_used) {
-			if (max_mem_specified) {
-				do_abort(
-	_("Required memory for repair is greater that the maximum specified\n"
-	  "with the -m option. Please increase it to at least %lu.\n"),
-					mem_used / 1024);
-			}
-			do_log(
-	_("Memory available for repair (%luMB) may not be sufficient.\n"
-	  "At least %luMB is needed to repair this filesystem efficiently\n"
-	  "If repair fails due to lack of memory, please\n"),
-				max_mem / 1024, mem_used / 1024);
-			if (do_prefetch)
-				do_log(
-	_("turn prefetching off (-P) to reduce the memory footprint.\n"));
-			else
-				do_log(
-	_("increase system RAM and/or swap space to at least %luMB.\n"),
-			mem_used * 2 / 1024);
-
-			max_mem = mem_used;
-		}
-
-		max_mem -= mem_used;
-		if (max_mem >= (1 << 30))
-			max_mem = 1 << 30;
-		libxfs_bhash_size = max_mem / (HASH_CACHE_RATIO *
-				(igeo->inode_cluster_size >> 10));
-		if (libxfs_bhash_size < 512)
-			libxfs_bhash_size = 512;
-
-		if (verbose)
-			do_log(_("        - block cache size set to %d entries\n"),
-				libxfs_bhash_size * HASH_CACHE_RATIO);
-
-		libxfs_bcache = cache_init(0, libxfs_bhash_size,
-						&libxfs_bcache_operations);
-	}
-
 	/*
 	 * calculate what mkfs would do to this filesystem
 	 */
@@ -987,23 +981,23 @@ main(int argc, char **argv)
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
 	phase2(mp, phase2_threads);
-	timestamp(PHASE_END, 2, NULL);
+	timestamp(mp, PHASE_END, 2, NULL);
 
 	if (do_prefetch)
 		init_prefetch(mp);
 
 	phase3(mp, phase2_threads);
-	timestamp(PHASE_END, 3, NULL);
+	timestamp(mp, PHASE_END, 3, NULL);
 
 	phase4(mp);
-	timestamp(PHASE_END, 4, NULL);
+	timestamp(mp, PHASE_END, 4, NULL);
 
 	if (no_modify)
 		printf(_("No modify flag set, skipping phase 5\n"));
 	else {
 		phase5(mp);
 	}
-	timestamp(PHASE_END, 5, NULL);
+	timestamp(mp, PHASE_END, 5, NULL);
 
 	/*
 	 * Done with the block usage maps, toss them...
@@ -1013,10 +1007,10 @@ main(int argc, char **argv)
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
-		timestamp(PHASE_END, 6, NULL);
+		timestamp(mp, PHASE_END, 6, NULL);
 
 		phase7(mp, phase2_threads);
-		timestamp(PHASE_END, 7, NULL);
+		timestamp(mp, PHASE_END, 7, NULL);
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
@@ -1125,11 +1119,13 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_buf_relse(sbp);
 
 	/*
+	 * XXX: delwri flush.
+	 *
 	 * Done. Flush all cached buffers and inodes first to ensure all
 	 * verifiers are run (where we discover the max metadata LSN), reformat
 	 * the log if necessary and unmount.
-	 */
 	libxfs_bcache_flush();
+	 */
 	format_log_max_lsn(mp);
 
 	/* Report failure if anything failed to get written to our fs. */
-- 
2.28.0

