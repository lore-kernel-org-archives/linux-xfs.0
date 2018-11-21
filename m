Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7031 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390411AbeKVJgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 04:36:38 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0003no-Gx
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0008FO-Fs
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: remove xfs_extst_t enum because tracing
Date: Thu, 22 Nov 2018 09:59:58 +1100
Message-Id: <20181121225958.30947-4-david@fromorbit.com>
In-Reply-To: <20181121225958.30947-1-david@fromorbit.com>
References: <20181121225958.30947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

__print_symbolic does crazy things and stringifies the tables
that are used to map values to strings. Hence if we use enums
for the values, it just doesn't work because XFS_UNWRITTEN != 1,
it's a string.

Convert to macros and remove the xfs_extst_t enum as it's not
useful anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |  2 +-
 fs/xfs/libxfs/xfs_bmap.h  |  2 +-
 fs/xfs/libxfs/xfs_rmap.c  |  2 +-
 fs/xfs/libxfs/xfs_rmap.h  |  2 +-
 fs/xfs/libxfs/xfs_types.h |  7 +++----
 fs/xfs/xfs_bmap_item.c    |  2 +-
 fs/xfs/xfs_rmap_item.c    |  2 +-
 fs/xfs/xfs_trace.h        | 12 ++++++------
 fs/xfs/xfs_trans.h        |  4 ++--
 fs/xfs/xfs_trans_bmap.c   |  4 ++--
 fs/xfs/xfs_trans_rmap.c   |  4 ++--
 11 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 19e921d1586f..39eaa2b86060 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6062,7 +6062,7 @@ xfs_bmap_finish_one(
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	unsigned			state)
 {
 	int				error = 0;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 488dc8860fd7..fd5c9916881d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -255,7 +255,7 @@ struct xfs_bmap_intent {
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
 		enum xfs_bmap_intent_type type, int whichfork,
 		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t *blockcount, xfs_exntst_t state);
+		xfs_filblks_t *blockcount, unsigned state);
 int	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
 int	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 245af452840e..34dc7470c14f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2165,7 +2165,7 @@ xfs_rmap_finish_one(
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
-	xfs_exntst_t			state,
+	unsigned			state,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 157dc722ad35..5b72c288ef48 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -202,7 +202,7 @@ void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		unsigned state, struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a73cd80c2439..6c1e0cbbb6fb 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -131,16 +131,15 @@ struct xfs_iext_cursor {
 	int			pos;
 };
 
-typedef enum {
-	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-} xfs_exntst_t;
+#define XFS_EXT_NORM		0
+#define XFS_EXT_UNWRITTEN	1
 
 typedef struct xfs_bmbt_irec
 {
 	xfs_fileoff_t	br_startoff;	/* starting file offset */
 	xfs_fsblock_t	br_startblock;	/* starting block number */
 	xfs_filblks_t	br_blockcount;	/* number of blocks */
-	xfs_exntst_t	br_state;	/* extent state */
+	unsigned	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
 /*
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ce45f066995e..124dc5d6e5a0 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -388,7 +388,7 @@ xfs_bui_recover(
 	struct xfs_bud_log_item		*budp;
 	enum xfs_bmap_intent_type	type;
 	int				whichfork;
-	xfs_exntst_t			state;
+	unsigned			state;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_bmbt_irec		irec;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 127dc9c32a54..6122c3a80be9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -412,7 +412,7 @@ xfs_rui_recover(
 	struct xfs_rud_log_item		*rudp;
 	enum xfs_rmap_intent_type	type;
 	int				whichfork;
-	xfs_exntst_t			state;
+	unsigned			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 145412e91a70..c11dfa709bc7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -218,7 +218,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__field(xfs_fileoff_t, startoff)
 		__field(xfs_fsblock_t, startblock)
 		__field(xfs_filblks_t, blockcount)
-		__field(xfs_exntst_t, state)
+		__field(unsigned, state)
 		__field(int, bmap_state)
 		__field(unsigned long, caller_ip)
 	),
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "offset %lld block %lld count %lld flag %d caller %pS",
+		  "offset %lld block %lld count %lld flag %u caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -2334,7 +2334,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		 int whichfork,
 		 xfs_fileoff_t offset,
 		 xfs_filblks_t len,
-		 xfs_exntst_t state),
+		 unsigned state),
 	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -2344,7 +2344,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
-		__field(xfs_exntst_t, l_state)
+		__field(unsigned, l_state)
 		__field(int, op)
 	),
 	TP_fast_assign(
@@ -2358,7 +2358,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno %u agbno %u owner %lld %s offset %llu len %llu state %d",
+	TP_printk("dev %d:%d op %d agno %u agbno %u owner %lld %s offset %llu len %llu state %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2378,7 +2378,7 @@ DEFINE_EVENT(xfs_map_extent_deferred_class, name, \
 		 int whichfork, \
 		 xfs_fileoff_t offset, \
 		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
+		 unsigned state), \
 	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 
 DEFINE_DEFER_EVENT(xfs_defer_cancel);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a0c5dbda18aa..cbb2494ce8e7 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -255,7 +255,7 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		struct xfs_rud_log_item *rudp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		unsigned state, struct xfs_btree_cur **pcur);
 
 /* refcount updates */
 enum xfs_refcount_intent_type;
@@ -279,6 +279,6 @@ int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
 		struct xfs_bud_log_item *rudp, enum xfs_bmap_intent_type type,
 		struct xfs_inode *ip, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t *blockcount,
-		xfs_exntst_t state);
+		unsigned state);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 741c558b2179..332c0b4cec61 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -49,7 +49,7 @@ xfs_trans_log_finish_bmap_update(
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	unsigned			state)
 {
 	int				error;
 
@@ -111,7 +111,7 @@ xfs_trans_set_bmap_flags(
 	struct xfs_map_extent		*bmap,
 	enum xfs_bmap_intent_type	type,
 	int				whichfork,
-	xfs_exntst_t			state)
+	unsigned			state)
 {
 	bmap->me_flags = 0;
 	switch (type) {
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 05b00e40251f..7c2e43ed7243 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -23,7 +23,7 @@ xfs_trans_set_rmap_flags(
 	struct xfs_map_extent		*rmap,
 	enum xfs_rmap_intent_type	type,
 	int				whichfork,
-	xfs_exntst_t			state)
+	unsigned			state)
 {
 	rmap->me_flags = 0;
 	if (state == XFS_EXT_UNWRITTEN)
@@ -87,7 +87,7 @@ xfs_trans_log_finish_rmap_update(
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
-	xfs_exntst_t			state,
+	unsigned			state,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
-- 
2.19.1
