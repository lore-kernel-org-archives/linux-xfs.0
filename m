Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E72C433EB
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52ED4206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgHLJ0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:09 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60387 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727858AbgHLJ0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:08 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D662B760CF3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003QW-4S
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-00Alsu-QA
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] xfs: add unlink list pointers to xfs_inode
Date:   Wed, 12 Aug 2020 19:25:48 +1000
Message-Id: <20200812092556.2567285-6-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=InVZWV_gqGCsK9yfbhcA:9
        a=WmKpBGBqIDIG9tgC:21 a=VXZMSOiFbSp7OkDt:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To move away from using the on disk inode buffers to track and log
unlinked inodes, we need pointers to track them in memory. Because
we have arbitrary remove order from the list, it needs to be a
double linked list.

We start by noting that inodes are always in memory when they are
active on the unlinked list, and hence we can track these inodes
without needing to take references to the inodes or store them in
the list. We cannot, however, use inode locks to protect the inodes
on the list - the list needs an external lock to serialise all
inserts and removals. We can use the existing AGI buffer lock for
this right now as that already serialises all unlinked list
traversals and modifications.

Hence we can convert the in-memory unlinked list to a simple
list_head list in the perag. We can use list_empty() to detect an
empty unlinked list, likewise we can detect the end of the list when
the inode next pointer points back to the perag list_head. This
makes insert, remove and traversal.

The only complication here is log recovery of old filesystems that
have multiple lists. These always remove from the head of the list,
so we can easily construct just enough of the unlinked list for
recovery from any list to work correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c      |   1 +
 fs/xfs/xfs_inode.c       |  21 ++++-
 fs/xfs/xfs_inode.h       |   1 +
 fs/xfs/xfs_log_recover.c | 179 +++++++++++++++++++++++----------------
 fs/xfs/xfs_mount.c       |   1 +
 fs/xfs/xfs_mount.h       |   1 +
 6 files changed, 130 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5cdded02cdc8..0c04a66bf88d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,6 +66,7 @@ xfs_inode_alloc(
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 	ip->i_sick = 0;
 	ip->i_checked = 0;
+	INIT_LIST_HEAD(&ip->i_unlink);
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fa92bdf6e0da..dcf80ac51267 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2294,7 +2294,17 @@ xfs_iunlink(
 	if (error)
 		return error;
 
-	return xfs_iunlink_insert_inode(tp, agibp, ip);
+	/*
+	 * Insert the inode into the on disk unlinked list, and if that
+	 * succeeds, then insert it into the in memory list. We do it in this
+	 * order so that the modifications required to the on disk list are not
+	 * impacted by already having this inode in the list.
+	 */
+	error = xfs_iunlink_insert_inode(tp, agibp, ip);
+	if (!error)
+		list_add(&ip->i_unlink, &agibp->b_pag->pag_ici_unlink_list);
+
+	return error;
 }
 
 /* Return the imap, dinode pointer, and buffer for an inode. */
@@ -2516,7 +2526,14 @@ xfs_iunlink_remove(
 	if (error)
 		return error;
 
-	return xfs_iunlink_remove_inode(tp, agibp, ip);
+	/*
+	 * Remove the inode from the on-disk list and then remove it from the
+	 * in-memory list. This order of operations ensures we can look up both
+	 * next and previous inode in the on-disk list via the in-memory list.
+	 */
+	error = xfs_iunlink_remove_inode(tp, agibp, ip);
+	list_del(&ip->i_unlink);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5ea962c6cf98..73f36908a1ce 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -56,6 +56,7 @@ typedef struct xfs_inode {
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
+	struct list_head	i_unlink;
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f4..b3481f4e2f96 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2682,11 +2682,11 @@ xlog_recover_clear_agi_bucket(
 	return;
 }
 
-STATIC xfs_agino_t
-xlog_recover_process_one_iunlink(
+static struct xfs_inode *
+xlog_recover_get_one_iunlink(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
-	xfs_agino_t			agino,
+	xfs_agino_t			*agino,
 	int				bucket)
 {
 	struct xfs_buf			*ibp;
@@ -2695,48 +2695,35 @@ xlog_recover_process_one_iunlink(
 	xfs_ino_t			ino;
 	int				error;
 
-	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	ino = XFS_AGINO_TO_INO(mp, agno, *agino);
 	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
 	if (error)
-		goto fail;
+		return NULL;
 
 	/*
-	 * Get the on disk inode to find the next inode in the bucket.
+	 * Get the on disk inode to find the next inode in the bucket. Should
+	 * not fail because we just read the inode from this buffer, but if it
+	 * does then we still have to allow the caller to set up and release
+	 * the inode we just looked up. Make sure the list walk terminates here,
+	 * though.
 	 */
 	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
-	if (error)
-		goto fail_iput;
+	if (error) {
+		ASSERT(0);
+		*agino = NULLAGINO;
+		return ip;
+	}
+
 
 	xfs_iflags_clear(ip, XFS_IRECOVERY);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 
-	/* setup for the next pass */
-	agino = be32_to_cpu(dip->di_next_unlinked);
+	/* Get the next inode we will be looking up. */
+	*agino = be32_to_cpu(dip->di_next_unlinked);
 	xfs_buf_relse(ibp);
 
-	/*
-	 * Prevent any DMAPI event from being sent when the reference on
-	 * the inode is dropped.
-	 */
-	ip->i_d.di_dmevmask = 0;
-
-	xfs_irele(ip);
-	return agino;
-
- fail_iput:
-	xfs_irele(ip);
- fail:
-	/*
-	 * We can't read in the inode this bucket points to, or this inode
-	 * is messed up.  Just ditch this bucket of inodes.  We will lose
-	 * some inodes and space, but at least we won't hang.
-	 *
-	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
-	 * clear the inode pointer in the bucket.
-	 */
-	xlog_recover_clear_agi_bucket(mp, agno, bucket);
-	return NULLAGINO;
+	return ip;
 }
 
 /*
@@ -2762,58 +2749,106 @@ xlog_recover_process_one_iunlink(
  * scheduled on this CPU to ensure other scheduled work can run without undue
  * latency.
  */
-STATIC void
-xlog_recover_process_iunlinks(
-	struct xlog	*log)
+static int
+xlog_recover_iunlinks_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
-	xfs_mount_t	*mp;
-	xfs_agnumber_t	agno;
-	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
-	xfs_agino_t	agino;
-	int		bucket;
-	int		error;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	int			bucket;
+	int			error;
 
-	mp = log->l_mp;
+	/*
+	 * Find the agi for this ag.
+	 */
+	error = xfs_read_agi(mp, NULL, agno, &agibp);
+	if (error) {
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		/*
-		 * Find the agi for this ag.
+		 * AGI is b0rked. Don't process it.
+		 *
+		 * We should probably mark the filesystem as corrupt after we've
+		 * recovered all the ag's we can....
 		 */
-		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		return 0;
+	}
+
+	/*
+	 * Unlock the buffer so that it can be acquired in the normal course of
+	 * the transaction to truncate and free each inode.  Because we are not
+	 * racing with anyone else here for the AGI buffer, we don't even need
+	 * to hold it locked to read the initial unlinked bucket entries out of
+	 * the buffer. We keep buffer reference though, so that it stays pinned
+	 * in memory while we need the buffer.
+	 */
+	agi = agibp->b_addr;
+	xfs_buf_unlock(agibp);
+
+	/*
+	 * The unlinked inode list is maintained on incore inodes as a double
+	 * linked list. We don't have any of that state in memory, so we have to
+	 * create it as we go. This is simple as we are only removing from the
+	 * head of the list and that means we only need to pull the current
+	 * inode in and the next inode.  Inodes are unlinked when their
+	 * reference count goes to zero, so we can overlap the xfs_iget() and
+	 * xfs_irele() calls so we always have the first two inodes on the list
+	 * in memory. Hence we can fake up the necessary in memory state for the
+	 * unlink to "just work".
+	 */
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+		struct xfs_inode	*ip, *prev_ip = NULL;
+		xfs_agino_t		agino;
+
+		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+		while (agino != NULLAGINO) {
+			ip = xlog_recover_get_one_iunlink(mp, agno, &agino,
+							  bucket);
+			if (!ip) {
+				/*
+				 * something busted, but still got to release
+				 * prev_ip, so make it look like it's at the end
+				 * of the list before it gets released.
+				 */
+				error = -EFSCORRUPTED;
+				break;
+			}
+			list_add_tail(&ip->i_unlink,
+					&agibp->b_pag->pag_ici_unlink_list);
+			if (prev_ip)
+				xfs_irele(prev_ip);
+			prev_ip = ip;
+			cond_resched();
+		}
+		if (prev_ip)
+			xfs_irele(prev_ip);
 		if (error) {
 			/*
-			 * AGI is b0rked. Don't process it.
-			 *
-			 * We should probably mark the filesystem as corrupt
-			 * after we've recovered all the ag's we can....
+			 * We can't read an inode this bucket points to, or an
+			 * inode is messed up.  Just ditch this bucket of
+			 * inodes.  We will lose some inodes and space, but at
+			 * least we won't hang.
 			 */
-			continue;
-		}
-		/*
-		 * Unlock the buffer so that it can be acquired in the normal
-		 * course of the transaction to truncate and free each inode.
-		 * Because we are not racing with anyone else here for the AGI
-		 * buffer, we don't even need to hold it locked to read the
-		 * initial unlinked bucket entries out of the buffer. We keep
-		 * buffer reference though, so that it stays pinned in memory
-		 * while we need the buffer.
-		 */
-		agi = agibp->b_addr;
-		xfs_buf_unlock(agibp);
-
-		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
-			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
-			while (agino != NULLAGINO) {
-				agino = xlog_recover_process_one_iunlink(mp,
-							agno, agino, bucket);
-				cond_resched();
-			}
+			xlog_recover_clear_agi_bucket(mp, agno, bucket);
+			break;
 		}
-		xfs_buf_rele(agibp);
 	}
+	xfs_buf_rele(agibp);
+	return error;
 }
 
+void
+xlog_recover_process_iunlinks(
+       struct xlog             *log)
+{
+       struct xfs_mount        *mp = log->l_mp;
+       xfs_agnumber_t          agno;
+
+       for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
+               xlog_recover_iunlinks_ag(mp, agno);
+}
+
+
 STATIC void
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bbfd1d5b1c04..2def15297a5f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -200,6 +200,7 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		INIT_LIST_HEAD(&pag->pag_ici_unlink_list);
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
 		init_waitqueue_head(&pag->pagb_wait);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a72cfcaa4ad1..c35a6c463529 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -355,6 +355,7 @@ typedef struct xfs_perag {
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
+	struct list_head pag_ici_unlink_list;	/* unlinked inode list */
 
 	/* buffer cache index */
 	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-- 
2.26.2.761.g0e0b3e54be

