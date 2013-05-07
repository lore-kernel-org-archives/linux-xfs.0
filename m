Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A52629E07
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:04:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23D708F8033
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:04:58 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fBmy69O866Kj0G95 for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:04:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006ZD-GM
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rg-C4
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: Inode create item recovery
Date: Tue,  7 May 2013 18:04:36 +1000
Message-Id: <1367913876-30086-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_ialloc.c      |   24 ++++++++----
 fs/xfs/xfs_ialloc.h      |    5 ++-
 fs/xfs/xfs_log_recover.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 9126b59..51473ee 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -151,12 +151,16 @@ xfs_check_agi_freecount(
 #endif
 
 /*
- * Initialise a new set of inodes.
+ * Initialise a new set of inodes. When called without a transaction context
+ * (e.g. from recovery) we initiate a delayed write of the inode buffers rather
+ * than logging them (which in a transaction context puts them into the AIL
+ * for writeback rather than the xfsbufd queue).
  */
 int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct list_head	*buffer_list,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		length,
@@ -218,8 +222,9 @@ xfs_ialloc_inode_init(
 		 * Hence we only need to log the buffers as "ordered" buffers so
 		 * they track in the AIL as if they were physically logged.
 		 */
-		xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
-				mp->m_sb.sb_inodesize, length, gen);
+		if (tp)
+			xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+					mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
@@ -254,14 +259,14 @@ xfs_ialloc_inode_init(
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
+		if (version == 3 && tp) {
 			/*
 			 * Mark the buffer as ordered so that it is not logged
 			 * in the transaction but still tracked in the AIL as
@@ -279,7 +284,10 @@ xfs_ialloc_inode_init(
 		 * past this transaction (i.e. by preventing relogging from
 		 * moving it forward in the log).
 		 */
-		xfs_trans_inode_alloc_buf(tp, fbuf);
+		if (tp)
+			xfs_trans_inode_alloc_buf(tp, fbuf);
+		else
+			xfs_buf_delwri_queue(fbuf, buffer_list);
 	}
 	return 0;
 }
@@ -324,7 +332,7 @@ xfs_ialloc_ag_alloc(
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
 	 * an entire stripe unit with inodes.
- 	 */
+	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
@@ -423,7 +431,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, agno, args.agbno,
 			args.len, prandom_u32());
 
 	if (error)
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index ec1cc48..ce6980b 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -156,7 +156,8 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
  * Inode buffer initialisation routine
  */
 int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
-		 xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_agblock_t length, unsigned int gen);
+			  struct list_head *buffer_list,
+			  xfs_agnumber_t agno, xfs_agblock_t agbno,
+			  xfs_agblock_t length, unsigned int gen);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 93f03ec..6d608ce 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,6 +45,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_icreate_item.h"
 
 /* Need all the magic numbers and buffer ops structures from these headers */
 #include "xfs_symlink.h"
@@ -1618,6 +1619,9 @@ xlog_recover_reorder_trans(
 		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 
 		switch (ITEM_TYPE(item)) {
+		case XFS_LI_ICREATE:
+			list_move(&item->ri_list, &trans->r_itemq);
+			break;
 		case XFS_LI_BUF:
 			if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
 				trace_xfs_log_recover_item_reorder_head(log,
@@ -2886,6 +2890,93 @@ xlog_recover_efd_pass2(
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
@@ -2927,6 +3018,7 @@ xlog_recover_commit_pass1(
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
 	case XFS_LI_DQUOT:
+	case XFS_LI_ICREATE:
 		/* nothing to do in pass 1 */
 		return 0;
 	default:
@@ -2957,6 +3049,8 @@ xlog_recover_commit_pass2(
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
