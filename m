Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BDB17FBB
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 01:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9AC73AC00D
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 23:05:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	c8E9it9lllMmJ60o for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 23:05:33 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Us5KR-0008HO-Qf
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Us5KR-00028X-NC
	for xfs@oss.sgi.com; Thu, 27 Jun 2013 16:05:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/15] xfs: Inode create item recovery
Date: Thu, 27 Jun 2013 16:04:55 +1000
Message-Id: <1372313099-8121-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1372313099-8121-1-git-send-email-david@fromorbit.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

When we find a icreate transaction, we need to get and initialise
the buffers in the range that has been passed. Extract and verify
the information in the item record, then loop over the range
initialising and issuing the buffer writes delayed.

Support an arbitrary size range to initialise so that in
future when we allocate inodes in much larger chunks all kernels
that understand this transaction can still recover them.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_ialloc.c      |   37 +++++++++++----
 fs/xfs/xfs_ialloc.h      |    8 ++++
 fs/xfs/xfs_log_recover.c |  114 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 145 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c8f5ae1..d5ef81a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -150,12 +150,16 @@ xfs_check_agi_freecount(
 #endif
 
 /*
- * Initialise a new set of inodes.
+ * Initialise a new set of inodes. When called without a transaction context
+ * (e.g. from recovery) we initiate a delayed write of the inode buffers rather
+ * than logging them (which in a transaction context puts them into the AIL
+ * for writeback rather than the xfsbufd queue).
  */
 STATIC int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct list_head	*buffer_list,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		length,
@@ -247,18 +251,33 @@ xfs_ialloc_inode_init(
 				ino++;
 				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
 				xfs_dinode_calc_crc(mp, free);
-			} else {
+			} else if (tp) {
 				/* just log the inode core */
 				xfs_trans_log_buf(tp, fbuf, ioffset,
 						  ioffset + isize - 1);
 			}
 		}
-		if (version == 3) {
-			/* need to log the entire buffer */
-			xfs_trans_log_buf(tp, fbuf, 0,
-					  BBTOB(fbuf->b_length) - 1);
+
+		if (tp) {
+			/*
+			 * Mark the buffer as an inode allocation buffer so it
+			 * sticks in AIL at the point of this allocation
+			 * transaction. This ensures the they are on disk before
+			 * the tail of the log can be moved past this
+			 * transaction (i.e. by preventing relogging from moving
+			 * it forward in the log).
+			 */
+			xfs_trans_inode_alloc_buf(tp, fbuf);
+			if (version == 3) {
+				/* need to log the entire buffer */
+				xfs_trans_log_buf(tp, fbuf, 0,
+						  BBTOB(fbuf->b_length) - 1);
+			}
+		} else {
+			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_delwri_queue(fbuf, buffer_list);
+			xfs_buf_relse(fbuf);
 		}
-		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
 	return 0;
 }
@@ -303,7 +322,7 @@ xfs_ialloc_ag_alloc(
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
 	 * an entire stripe unit with inodes.
- 	 */
+	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
@@ -402,7 +421,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, agno, args.agbno,
 			args.len, prandom_u32());
 
 	if (error)
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index c8da3df..68c0732 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -150,6 +150,14 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
 
+/*
+ * Inode chunk initialisation routine
+ */
+int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
+			  struct list_head *buffer_list,
+			  xfs_agnumber_t agno, xfs_agblock_t agbno,
+			  xfs_agblock_t length, unsigned int gen);
+
 extern const struct xfs_buf_ops xfs_agi_buf_ops;
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7cf5e4e..6fcc910a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,6 +45,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_icreate_item.h"
 
 /* Need all the magic numbers and buffer ops structures from these headers */
 #include "xfs_symlink.h"
@@ -1617,7 +1618,10 @@ xlog_recover_add_to_trans(
  *	   form the cancelled buffer table. Hence they have tobe done last.
  *
  *	3. Inode allocation buffers must be replayed before inode items that
- *	   read the buffer and replay changes into it.
+ *	   read the buffer and replay changes into it. For filesystems using the
+ *	   ICREATE transactions, this means XFS_LI_ICREATE objects need to get
+ *	   treated the same as inode allocation buffers as they create and
+ *	   initialise the buffers directly.
  *
  *	4. Inode unlink buffers must be replayed after inode items are replayed.
  *	   This ensures that inodes are completely flushed to the inode buffer
@@ -1632,10 +1636,17 @@ xlog_recover_add_to_trans(
  * from all the other buffers and move them to last.
  *
  * Hence, 4 lists, in order from head to tail:
- * 	- buffer_list for all buffers except cancelled/inode unlink buffers
- * 	- item_list for all non-buffer items
- * 	- inode_buffer_list for inode unlink buffers
- * 	- cancel_list for the cancelled buffers
+ *	- buffer_list for all buffers except cancelled/inode unlink buffers
+ *	- item_list for all non-buffer items
+ *	- inode_buffer_list for inode unlink buffers
+ *	- cancel_list for the cancelled buffers
+ *
+ * Note that we add objects to the tail of the lists so that first-to-last
+ * ordering is preserved within the lists. Adding objects to the head of the
+ * list means when we traverse from the head we walk them in last-to-first
+ * order. For cancelled buffers and inode unlink buffers this doesn't matter,
+ * but for all other items there may be specific ordering that we need to
+ * preserve.
  */
 STATIC int
 xlog_recover_reorder_trans(
@@ -1655,6 +1666,9 @@ xlog_recover_reorder_trans(
 		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 
 		switch (ITEM_TYPE(item)) {
+		case XFS_LI_ICREATE:
+			list_move_tail(&item->ri_list, &buffer_list);
+			break;
 		case XFS_LI_BUF:
 			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
 				trace_xfs_log_recover_item_reorder_head(log,
@@ -2982,6 +2996,93 @@ xlog_recover_efd_pass2(
 }
 
 /*
+ * This routine is called when an inode create format structure is found in a
+ * committed transaction in the log.  It's purpose is to initialise the inodes
+ * being allocated on disk. This requires us to get inode cluster buffers that
+ * match the range to be intialised, stamped with inode templates and written
+ * by delayed write so that subsequent modifications will hit the cached buffer
+ * and only need writing out at the end of recovery.
+ */
+STATIC int
+xlog_recover_do_icreate_pass2(
+	struct xlog		*log,
+	struct list_head	*buffer_list,
+	xlog_recover_item_t	*item)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_icreate_log	*icl;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	unsigned int		count;
+	unsigned int		isize;
+	xfs_agblock_t		length;
+
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+	if (icl->icl_type != XFS_LI_ICREATE) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
+		return EINVAL;
+	}
+
+	if (icl->icl_size != 1) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
+		return EINVAL;
+	}
+
+	agno = be32_to_cpu(icl->icl_ag);
+	if (agno >= mp->m_sb.sb_agcount) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
+		return EINVAL;
+	}
+	agbno = be32_to_cpu(icl->icl_agbno);
+	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
+		return EINVAL;
+	}
+	isize = be32_to_cpu(icl->icl_isize);
+	if (isize != mp->m_sb.sb_inodesize) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
+		return EINVAL;
+	}
+	count = be32_to_cpu(icl->icl_count);
+	if (!count) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
+		return EINVAL;
+	}
+	length = be32_to_cpu(icl->icl_length);
+	if (!length || length >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
+		return EINVAL;
+	}
+
+	/* existing allocation is fixed value */
+	ASSERT(count == XFS_IALLOC_INODES(mp));
+	ASSERT(length == XFS_IALLOC_BLOCKS(mp));
+	if (count != XFS_IALLOC_INODES(mp) ||
+	     length != XFS_IALLOC_BLOCKS(mp)) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
+		return EINVAL;
+	}
+
+	/*
+	 * Inode buffers can be freed. Do not replay the inode initialisation as
+	 * we could be overwriting something written after this inode buffer was
+	 * cancelled.
+	 *
+	 * XXX: we need to iterate all buffers and only init those that are not
+	 * cancelled. I think that a more fine grained factoring of
+	 * xfs_ialloc_inode_init may be appropriate here to enable this to be
+	 * done easily.
+	 */
+	if (xlog_check_buffer_cancelled(log,
+			XFS_AGB_TO_DADDR(mp, agno, agbno), length, 0))
+		return 0;
+
+	xfs_ialloc_inode_init(mp, NULL, buffer_list, agno, agbno, length,
+					be32_to_cpu(icl->icl_gen));
+	return 0;
+}
+
+/*
  * Free up any resources allocated by the transaction
  *
  * Remember that EFIs, EFDs, and IUNLINKs are handled later.
@@ -3023,6 +3124,7 @@ xlog_recover_commit_pass1(
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
 	case XFS_LI_DQUOT:
+	case XFS_LI_ICREATE:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -3053,6 +3155,8 @@ xlog_recover_commit_pass2(
 		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_DQUOT:
 		return xlog_recover_dquot_pass2(log, buffer_list, item);
+	case XFS_LI_ICREATE:
+		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:
 		/* nothing to do in pass2 */
 		return 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
