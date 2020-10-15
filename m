Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2D6C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6B52225F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgJOHWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34270 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728691AbgJOHWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:04 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 175AB58C4EC
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvH-Hr
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLd-9T
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/27] xfsprogs: remove xfs_buf_t typedef
Date:   Thu, 15 Oct 2020 18:21:34 +1100
Message-Id: <20201015072155.1631135-7-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=CEsphzgRvvrVNFrhXkAA:9
        a=r47s6XlE7_vgbZvG:21 a=QuWLPF-RmXDyA_Sr:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prepare for kernel xfs_buf  alignment by getting rid of the
xfs_buf_t typedef from userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c           |  2 +-
 include/libxlog.h         |  6 +++---
 libxfs/init.c             |  2 +-
 libxfs/libxfs_io.h        |  7 ++++---
 libxfs/libxfs_priv.h      |  4 ++--
 libxfs/logitem.c          |  4 ++--
 libxfs/rdwr.c             | 26 +++++++++++++-------------
 libxfs/trans.c            | 18 +++++++++---------
 libxfs/util.c             |  7 +++----
 libxfs/xfs_alloc.c        | 16 ++++++++--------
 libxfs/xfs_bmap.c         |  6 +++---
 libxfs/xfs_btree.c        | 10 +++++-----
 libxfs/xfs_ialloc.c       |  4 ++--
 libxfs/xfs_rtbitmap.c     | 22 +++++++++++-----------
 libxlog/xfs_log_recover.c | 12 ++++++------
 logprint/log_print_all.c  |  2 +-
 mkfs/proto.c              |  2 +-
 mkfs/xfs_mkfs.c           |  2 +-
 repair/agheader.c         |  2 +-
 repair/attr_repair.c      |  4 ++--
 repair/da_util.h          |  2 +-
 repair/dino_chunks.c      |  8 ++++----
 repair/incore.h           |  2 +-
 repair/phase5.c           |  2 +-
 repair/phase6.c           |  4 ++--
 repair/prefetch.c         | 12 ++++++------
 repair/rt.c               |  4 ++--
 repair/scan.c             |  4 ++--
 repair/xfs_repair.c       |  2 +-
 29 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 38a20d37a015..fc7d225fe6a2 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -569,7 +569,7 @@ main(int argc, char **argv)
 	xfs_mount_t	*mp;
 	xfs_mount_t	mbuf;
 	struct xlog	xlog;
-	xfs_buf_t	*sbp;
+	struct xfs_buf	*sbp;
 	xfs_sb_t	*sb;
 	xfs_agnumber_t	num_ags, agno;
 	xfs_agblock_t	bno;
diff --git a/include/libxlog.h b/include/libxlog.h
index 89e0ed669086..adaa9963cddc 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -76,12 +76,12 @@ extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
 			 int);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
-				xfs_buf_t *bp, char **offset);
+				struct xfs_buf *bp, char **offset);
 extern int	xlog_bread_noalign(struct xlog *log, xfs_daddr_t blk_no,
-				int nbblks, xfs_buf_t *bp);
+				int nbblks, struct xfs_buf *bp);
 
 extern int	xlog_find_zeroed(struct xlog *log, xfs_daddr_t *blk_no);
-extern int	xlog_find_cycle_start(struct xlog *log, xfs_buf_t *bp,
+extern int	xlog_find_cycle_start(struct xlog *log, struct xfs_buf *bp,
 				xfs_daddr_t first_blk, xfs_daddr_t *last_blk,
 				uint cycle);
 extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
diff --git a/libxfs/init.c b/libxfs/init.c
index bd176b50bf63..4dab7d25727e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -30,7 +30,7 @@ char *progname = "libxfs";	/* default, changed by each tool */
 struct cache *libxfs_bcache;	/* global buffer cache */
 int libxfs_bhash_size;		/* #buckets in bcache */
 
-int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
+int	use_xfs_buf_lock;	/* global flag: use struct xfs_buf locks for MT */
 
 /*
  * dev_map - map open devices to fd.
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 1eccedfc5fe1..3bb00af9bdba 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -57,7 +57,7 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *);
 };
 
-typedef struct xfs_buf {
+struct xfs_buf {
 	struct cache_node	b_node;
 	unsigned int		b_flags;
 	xfs_daddr_t		b_bn;
@@ -78,7 +78,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
 	struct list_head	b_list;
-} xfs_buf_t;
+};
 
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
@@ -163,7 +163,8 @@ extern int	libxfs_bcache_overflowed(void);
 
 /* Buffer (Raw) Interfaces */
 int		libxfs_bwrite(struct xfs_buf *bp);
-extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
+extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t,
+				struct xfs_buf *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
 extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index bd724c32c263..b88939c04adb 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -665,10 +665,10 @@ int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
-			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 43a98f284129..4d4e8080dffc 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -27,7 +27,7 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
  * Check to see if a buffer matching the given parameters is already
  * a part of the given transaction.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_trans_buf_item_match(
 	xfs_trans_t		*tp,
 	struct xfs_buftarg	*btp,
@@ -68,7 +68,7 @@ xfs_trans_buf_item_match(
  */
 void
 xfs_buf_item_init(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_mount_t		*mp)
 {
 	xfs_log_item_t		*lip;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 345fddc63d14..174cbcac1250 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -223,7 +223,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 }
 
 static void
-__initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
+__initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
 	bp->b_flags = 0;
@@ -257,14 +257,14 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 }
 
 static void
-libxfs_initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
+libxfs_initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
 	__initbuf(bp, btp, bno, bytes);
 }
 
 static void
-libxfs_initbuf_map(xfs_buf_t *bp, struct xfs_buftarg *btp,
+libxfs_initbuf_map(struct xfs_buf *bp, struct xfs_buftarg *btp,
 		struct xfs_buf_map *map, int nmaps)
 {
 	unsigned int bytes = 0;
@@ -292,10 +292,10 @@ libxfs_initbuf_map(xfs_buf_t *bp, struct xfs_buftarg *btp,
 	bp->b_flags |= LIBXFS_B_DISCONTIG;
 }
 
-static xfs_buf_t *
+static struct xfs_buf *
 __libxfs_getbufr(int blen)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 
 	/*
 	 * first look for a buffer that can be used as-is,
@@ -313,7 +313,7 @@ __libxfs_getbufr(int blen)
 		}
 		if (&bp->b_node.cn_mru == &xfs_buf_freelist.cm_list) {
 			bp = list_entry(xfs_buf_freelist.cm_list.next,
-					xfs_buf_t, b_node.cn_mru);
+					struct xfs_buf, b_node.cn_mru);
 			list_del_init(&bp->b_node.cn_mru);
 			free(bp->b_addr);
 			bp->b_addr = NULL;
@@ -331,10 +331,10 @@ __libxfs_getbufr(int blen)
 	return bp;
 }
 
-static xfs_buf_t *
+static struct xfs_buf *
 libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		blen = BBTOB(bblen);
 
 	bp =__libxfs_getbufr(blen);
@@ -343,11 +343,11 @@ libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 	return bp;
 }
 
-static xfs_buf_t *
+static struct xfs_buf *
 libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
 		struct xfs_buf_map *map, int nmaps)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		blen = BBTOB(bblen);
 
 	if (!map || !nmaps) {
@@ -574,7 +574,7 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 }
 
 int
-libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
+libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 		int len, int flags)
 {
 	int	fd = libxfs_device_to_fd(btp->bt_bdev);
@@ -915,7 +915,7 @@ libxfs_bulkrelse(
 	struct cache		*cache,
 	struct list_head	*list)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			count = 0;
 
 	if (list_empty(list))
@@ -941,7 +941,7 @@ void
 libxfs_bcache_free(void)
 {
 	struct list_head	*cm_list;
-	xfs_buf_t		*bp, *next;
+	struct xfs_buf		*bp, *next;
 
 	cm_list = &xfs_buf_freelist.cm_list;
 	list_for_each_entry_safe(bp, next, cm_list, b_node.cn_mru) {
diff --git a/libxfs/trans.c b/libxfs/trans.c
index a9d7aa39751c..814171eddf4f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -395,7 +395,7 @@ libxfs_trans_bjoin(
 void
 libxfs_trans_bhold_release(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item *bip = bp->b_log_item;
 
@@ -461,12 +461,12 @@ libxfs_trans_get_buf_map(
 	return 0;
 }
 
-xfs_buf_t *
+struct xfs_buf *
 libxfs_trans_getsb(
 	xfs_trans_t		*tp,
 	struct xfs_mount	*mp)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			len = XFS_FSS_TO_BB(mp, 1);
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
@@ -604,7 +604,7 @@ libxfs_trans_brelse(
 void
 libxfs_trans_bhold(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -661,7 +661,7 @@ libxfs_trans_log_buf(
 void
 libxfs_trans_binval(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -695,7 +695,7 @@ libxfs_trans_binval(
 void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -799,7 +799,7 @@ static void
 inode_item_done(
 	struct xfs_inode_log_item	*iip)
 {
-	xfs_buf_t			*bp;
+	struct xfs_buf			*bp;
 	int				error;
 
 	ASSERT(iip->ili_inode != NULL);
@@ -835,7 +835,7 @@ static void
 buf_item_done(
 	xfs_buf_log_item_t	*bip)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			hold;
 	extern kmem_zone_t	*xfs_buf_item_zone;
 
@@ -879,7 +879,7 @@ static void
 buf_item_unlock(
 	xfs_buf_log_item_t	*bip)
 {
-	xfs_buf_t		*bp = bip->bli_buf;
+	struct xfs_buf		*bp = bip->bli_buf;
 	uint			hold;
 
 	/* Clear the buffer's association with this transaction. */
diff --git a/libxfs/util.c b/libxfs/util.c
index c78074a01dab..afd69e54f344 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -255,7 +255,7 @@ libxfs_ialloc(
 	xfs_dev_t	rdev,
 	struct cred	*cr,
 	struct fsxattr	*fsx,
-	xfs_buf_t	**ialloc_context,
+	struct xfs_buf	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
 	xfs_ino_t	ino;
@@ -358,7 +358,7 @@ libxfs_ialloc(
 int
 libxfs_iflush_int(
 	xfs_inode_t			*ip,
-	xfs_buf_t			*bp)
+	struct xfs_buf			*bp)
 {
 	struct xfs_inode_log_item	*iip;
 	xfs_dinode_t			*dip;
@@ -540,11 +540,10 @@ libxfs_inode_alloc(
 	struct fsxattr	*fsx,
 	xfs_inode_t	**ipp)
 {
-	xfs_buf_t	*ialloc_context;
+	struct xfs_buf	*ialloc_context = NULL;
 	xfs_inode_t	*ip;
 	int		error;
 
-	ialloc_context = (xfs_buf_t *)0;
 	error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
 			   &ialloc_context, &ip);
 	if (error) {
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 93043d5927a3..d994c63cc2c9 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -686,9 +686,9 @@ xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* buffer for the ag free block array */
+	struct xfs_buf	**bpp)		/* buffer for the ag free block array */
 {
-	xfs_buf_t	*bp;		/* return value */
+	struct xfs_buf	*bp;		/* return value */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -2642,12 +2642,12 @@ out_no_agbp:
 int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
+	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
 	struct xfs_agf	*agf = agbp->b_addr;
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
+	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
 	int		error;
@@ -2706,7 +2706,7 @@ xfs_alloc_get_freelist(
 void
 xfs_alloc_log_agf(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*bp,	/* buffer for a.g. freelist header */
+	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
 {
 	int	first;		/* first byte offset */
@@ -2752,7 +2752,7 @@ xfs_alloc_pagf_init(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags)	/* XFS_ALLOC_FLAGS_... */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
@@ -2767,8 +2767,8 @@ xfs_alloc_pagf_init(
 int					/* error */
 xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
-	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
+	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
+	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a9c1536718af..cde22b43290a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -314,7 +314,7 @@ xfs_bmap_check_leaf_extents(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
+	struct xfs_buf		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
 	int			level;	/* btree level, for checking */
@@ -585,7 +585,7 @@ xfs_bmap_btree_to_extents(
 	struct xfs_btree_block	*rblock = ifp->if_broot;
 	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
-	xfs_buf_t		*cbp;	/* child block's buffer */
+	struct xfs_buf		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_owner_info	oinfo;
@@ -823,7 +823,7 @@ xfs_bmap_local_to_extents(
 	int		flags;		/* logging flags returned */
 	struct xfs_ifork *ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
-	xfs_buf_t	*bp;		/* buffer for extent block */
+	struct xfs_buf	*bp;		/* buffer for extent block */
 	struct xfs_bmbt_irec rec;
 	struct xfs_iext_cursor icur;
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a408aa42f590..af965ceacd10 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -394,7 +394,7 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t	*cur,		/* input cursor */
 	xfs_btree_cur_t	**ncur)		/* output cursor */
 {
-	xfs_buf_t	*bp;		/* btree block's buffer pointer */
+	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
@@ -698,7 +698,7 @@ xfs_btree_firstrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -728,7 +728,7 @@ xfs_btree_lastrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -990,7 +990,7 @@ STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+	struct xfs_buf		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
@@ -1633,7 +1633,7 @@ xfs_btree_decrement(
 	int			*stat)		/* success/failure */
 {
 	struct xfs_btree_block	*block;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;		/* error return value */
 	int			lev;
 	union xfs_btree_ptr	ptr;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index ce73feed981c..466dfdaa6b5e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2448,7 +2448,7 @@ out_map:
 void
 xfs_ialloc_log_agi(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* allocation group header buffer */
+	struct xfs_buf	*bp,		/* allocation group header buffer */
 	int		fields)		/* bitmask of fields to log */
 {
 	int			first;		/* first byte number */
@@ -2668,7 +2668,7 @@ xfs_ialloc_pagi_init(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno)		/* allocation group number */
 {
-	xfs_buf_t	*bp = NULL;
+	struct xfs_buf	*bp = NULL;
 	int		error;
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 1bb5c75f888a..3dbeafea7c47 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -54,9 +54,9 @@ xfs_rtbuf_get(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
-	xfs_buf_t	**bpp)		/* output: buffer for the block */
+	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
-	xfs_buf_t	*bp;		/* block buffer, result */
+	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
@@ -99,7 +99,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
@@ -274,7 +274,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -445,11 +445,11 @@ xfs_rtmodify_summary_int(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_buf_t	*bp;		/* buffer for the summary block */
+	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fsblock_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
@@ -515,7 +515,7 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
@@ -537,7 +537,7 @@ xfs_rtmodify_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
@@ -688,7 +688,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
@@ -771,7 +771,7 @@ xfs_rtcheck_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -967,7 +967,7 @@ xfs_rtfree_extent(
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
 	mp = tp->t_mountp;
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index b02743dcf024..f566c3b54bd0 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -227,7 +227,7 @@ xlog_find_verify_cycle(
 {
 	xfs_daddr_t	i, j;
 	uint		cycle;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		bufblks;
 	char		*buf = NULL;
 	int		error = 0;
@@ -294,7 +294,7 @@ xlog_find_verify_log_record(
 	int			extra_bblks)
 {
 	xfs_daddr_t		i;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
@@ -401,7 +401,7 @@ xlog_find_head(
 	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
@@ -676,7 +676,7 @@ xlog_find_tail(
 	xlog_rec_header_t	*rhead;
 	xlog_op_header_t	*op_head;
 	char			*offset = NULL;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error, i, found;
 	xfs_daddr_t		umount_data_blk;
 	xfs_daddr_t		after_umount_blk;
@@ -882,7 +882,7 @@ xlog_find_zeroed(
 	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
@@ -1419,7 +1419,7 @@ xlog_do_recovery_pass(
 	xlog_rec_header_t	*rhead;
 	xfs_daddr_t		blk_no;
 	char			*offset;
-	xfs_buf_t		*hbp, *dbp;
+	struct xfs_buf		*hbp, *dbp;
 	int			error = 0, h_size;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1924a0af70b6..bc4319d1f77c 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -16,7 +16,7 @@ xlog_print_find_oldest(
 	struct xlog	*log,
 	xfs_daddr_t	*last_blk)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_daddr_t	first_blk;
 	uint		first_half_cycle, last_half_cycle;
 	int		error = 0;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0fa6ffb0107e..d40bf9c4f497 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -225,7 +225,7 @@ newfile(
 	char		*buf,
 	int		len)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_daddr_t	d;
 	int		error;
 	int		flags;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ffbeda16faa7..ba21b4accc97 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3737,7 +3737,7 @@ main(
 	char			**argv)
 {
 	xfs_agnumber_t		agno;
-	xfs_buf_t		*buf;
+	struct xfs_buf		*buf;
 	int			c;
 	char			*dfile = NULL;
 	char			*logfile = NULL;
diff --git a/repair/agheader.c b/repair/agheader.c
index f28d8a7bb0de..8bb99489f8e7 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -467,7 +467,7 @@ secondary_sb_whack(
  */
 
 int
-verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
+verify_set_agheader(xfs_mount_t *mp, struct xfs_buf *sbuf, xfs_sb_t *sb,
 	xfs_agf_t *agf, xfs_agi_t *agi, xfs_agnumber_t i)
 {
 	int rval = 0;
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 40cf81ee7ac3..01e39304012e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -388,7 +388,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 		xfs_dablk_t blocknum, int valuelen, char* value)
 {
 	xfs_fsblock_t	bno;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		clearit = 0, i = 0, length = 0, amountdone = 0;
 	int		hdrsize = 0;
 	int		error;
@@ -730,7 +730,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 {
 	int			repair;
 	xfs_attr_leafblock_t	*leaf;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	xfs_ino_t		ino;
 	xfs_fsblock_t		dev_bno;
 	xfs_dablk_t		da_bno;
diff --git a/repair/da_util.h b/repair/da_util.h
index 90fec00c7add..2e26178c2511 100644
--- a/repair/da_util.h
+++ b/repair/da_util.h
@@ -8,7 +8,7 @@
 #define	_XR_DA_UTIL_H
 
 struct da_level_state  {
-	xfs_buf_t	*bp;		/* block bp */
+	struct xfs_buf	*bp;		/* block bp */
 	xfs_dablk_t	bno;		/* file block number */
 	xfs_dahash_t	hashval;	/* last verified hashval */
 	int		index;		/* current index in block */
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 0c60ab431e13..c87a435d8c6a 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -30,7 +30,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	xfs_dinode_t	*dino_p;
 	int		i;
 	int		cnt = 0;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		error;
 
 	/*
@@ -597,7 +597,7 @@ process_inode_chunk(
 {
 	xfs_ino_t		parent;
 	ino_tree_node_t		*ino_rec;
-	xfs_buf_t		**bplist;
+	struct xfs_buf		**bplist;
 	xfs_dinode_t		*dino;
 	int			icnt;
 	int			status;
@@ -644,10 +644,10 @@ process_inode_chunk(
 	ino_rec = first_irec;
 	irec_offset = 0;
 
-	bplist = malloc(cluster_count * sizeof(xfs_buf_t *));
+	bplist = malloc(cluster_count * sizeof(struct xfs_buf *));
 	if (bplist == NULL)
 		do_error(_("failed to allocate %zd bytes of memory\n"),
-			cluster_count * sizeof(xfs_buf_t *));
+			cluster_count * sizeof(struct xfs_buf *));
 
 	for (bp_index = 0; bp_index < cluster_count; bp_index++) {
 		/*
diff --git a/repair/incore.h b/repair/incore.h
index 5b29d5d1efd8..7130674b1fab 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -600,7 +600,7 @@ typedef struct bm_level_state  {
 /*
 	int			level;
 	uint64_t		prev_last_key;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	xfs_bmbt_block_t	*block;
 */
 } bm_level_state_t;
diff --git a/repair/phase5.c b/repair/phase5.c
index 446f7ec0a1db..c508dbf6fb85 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -390,7 +390,7 @@ build_agf_agfl(
 static void
 sync_sb(xfs_mount_t *mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 
 	bp = libxfs_getsb(mp);
 	if (!bp)
diff --git a/repair/phase6.c b/repair/phase6.c
index 70d32089bb57..d7ac7b4e1558 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -562,7 +562,7 @@ mk_rbmino(xfs_mount_t *mp)
 static int
 fill_rbmino(xfs_mount_t *mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_rtword_t	*bmp;
@@ -630,7 +630,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 static int
 fill_rsumino(xfs_mount_t *mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_suminfo_t	*smp;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3e63b8bea484..48affa1869f8 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -34,7 +34,7 @@ static int		pf_max_fsbs;
 static int		pf_batch_bytes;
 static int		pf_batch_fsbs;
 
-static void		pf_read_inode_dirs(prefetch_args_t *, xfs_buf_t *);
+static void		pf_read_inode_dirs(prefetch_args_t *, struct xfs_buf *);
 
 /*
  * Buffer priorities for the libxfs cache
@@ -271,7 +271,7 @@ pf_scan_lbtree(
 					int			isadir,
 					prefetch_args_t		*args))
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			rc;
 	int			error;
 
@@ -399,7 +399,7 @@ pf_read_exinode(
 static void
 pf_read_inode_dirs(
 	prefetch_args_t		*args,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	xfs_dinode_t		*dino;
 	int			icnt = 0;
@@ -473,7 +473,7 @@ pf_batch_read(
 	pf_which_t		which,
 	void			*buf)
 {
-	xfs_buf_t		*bplist[MAX_BUFS];
+	struct xfs_buf		*bplist[MAX_BUFS];
 	unsigned int		num;
 	off64_t			first_off, last_off, next_off;
 	int			len, size;
@@ -592,8 +592,8 @@ pf_batch_read(
 
 		if (len > 0) {
 			/*
-			 * go through the xfs_buf_t list copying from the
-			 * read buffer into the xfs_buf_t's and release them.
+			 * go through the struct xfs_buf list copying from the
+			 * read buffer into the struct xfs_buf's and release them.
 			 */
 			for (i = 0; i < num; i++) {
 
diff --git a/repair/rt.c b/repair/rt.c
index d901e7518303..793efb8089f9 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -163,7 +163,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 	int		bmbno;
 	int		end_bmbno;
 	xfs_fsblock_t	bno;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_rtblock_t	extno;
 	int		i;
 	int		len;
@@ -243,7 +243,7 @@ process_rtsummary(xfs_mount_t	*mp,
 		blkmap_t	*blkmap)
 {
 	xfs_fsblock_t	bno;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	char		*bytes;
 	int		sumbno;
 
diff --git a/repair/scan.c b/repair/scan.c
index 42b299f75067..f962d9b71226 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -152,7 +152,7 @@ scan_lbtree(
 	uint64_t	magic,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		err;
 	int		dirty = 0;
 	bool		badcrc = false;
@@ -2195,7 +2195,7 @@ scan_freelist(
 	xfs_agf_t		*agf,
 	struct aghdr_cnts	*agcnts)
 {
-	xfs_buf_t		*agflbuf;
+	struct xfs_buf		*agflbuf;
 	xfs_agnumber_t		agno;
 	struct agfl_state	state;
 	int			error;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 5efc5586bf16..724661d848c4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -718,7 +718,7 @@ main(int argc, char **argv)
 	xfs_mount_t	*temp_mp;
 	xfs_mount_t	*mp;
 	xfs_dsb_t	*dsb;
-	xfs_buf_t	*sbp;
+	struct xfs_buf	*sbp;
 	xfs_mount_t	xfs_m;
 	struct xlog	log = {0};
 	char		*msgbuf;
-- 
2.28.0

