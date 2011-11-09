Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA98bVQs212980 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 02:37:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7964B1CF85C9
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 00:37:30 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SoObHc10bxyvMf2O for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 00:37:30 -0800 (PST)
Date: Wed, 9 Nov 2011 03:37:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH repair: do not walk the unlinked inode list
Message-ID: <20111109083729.GA23169@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stefan Pfetzing <stefan.pfetzing@1und1.de>

Stefan Pfetzing reported a bug where xfs_repair got stuck eating 100% CPU in
phase3.  We track it down to a loop in the unlinked inode list, apparently
caused by memory corruption on an iSCSI target.

I looked into tracking if we already saw a given unlinked inode, but given
that we keep walking even for inodes where we can't find an allocation btree
record that seems infeasible.  On the other hand these inodes had their
final unlink and thus were dead even before the system went down.  There
really is no point in adding them to the uncertain list and looking for
references to them later.

So the simplest fix seems to be to simply remove the unlinked inode list
walk and just clear it - when we rebuild the inode allocation btrees these
will simply be marked free.

Reported-by: Stefan Pfetzing <stefan.pfetzing@1und1.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/phase3.c
===================================================================
--- xfsprogs-dev.orig/repair/phase3.c	2011-11-09 08:59:35.313604606 +0100
+++ xfsprogs-dev/repair/phase3.c	2011-11-09 09:03:44.800605237 +0100
@@ -28,80 +28,15 @@
 #include "progress.h"
 #include "prefetch.h"
 
-/*
- * walks an unlinked list, returns 1 on an error (bogus pointer) or
- * I/O error
- */
-int
-walk_unlinked_list(xfs_mount_t *mp, xfs_agnumber_t agno, xfs_agino_t start_ino)
-{
-	xfs_buf_t *bp;
-	xfs_dinode_t *dip;
-	xfs_agino_t current_ino = start_ino;
-	xfs_agblock_t agbno;
-	int state;
-
-	while (current_ino != NULLAGINO)  {
-		if (verify_aginum(mp, agno, current_ino))
-			return(1);
-		if ((bp = get_agino_buf(mp, agno, current_ino, &dip)) == NULL)
-			return(1);
-		/*
-		 * if this looks like a decent inode, then continue
-		 * following the unlinked pointers.  If not, bail.
-		 */
-		if (verify_dinode(mp, dip, agno, current_ino) == 0)  {
-			/*
-			 * check if the unlinked list points to an unknown
-			 * inode.  if so, put it on the uncertain inode list
-			 * and set block map appropriately.
-			 */
-			if (find_inode_rec(mp, agno, current_ino) == NULL)  {
-				add_aginode_uncertain(agno, current_ino, 1);
-				agbno = XFS_AGINO_TO_AGBNO(mp, current_ino);
-
-				pthread_mutex_lock(&ag_locks[agno]);
-				state = get_bmap(agno, agbno);
-				switch (state) {
-				case XR_E_BAD_STATE:
-					do_error(_(
-						"bad state in block map %d\n"),
-						state);
-					break;
-				default:
-					/*
-					 * the block looks like inodes
-					 * so be conservative and try
-					 * to scavenge what's in there.
-					 * if what's there is completely
-					 * bogus, it'll show up later
-					 * and the inode will be trashed
-					 * anyway, hopefully without
-					 * losing too much other data
-					 */
-					set_bmap(agno, agbno, XR_E_INO);
-					break;
-				}
-				pthread_mutex_unlock(&ag_locks[agno]);
-			}
-			current_ino = be32_to_cpu(dip->di_next_unlinked);
-		} else  {
-			current_ino = NULLAGINO;;
-		}
-		libxfs_putbuf(bp);
-	}
-
-	return(0);
-}
-
-void
-process_agi_unlinked(xfs_mount_t *mp, xfs_agnumber_t agno)
+static void
+process_agi_unlinked(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
-	xfs_agnumber_t i;
-	xfs_buf_t *bp;
-	xfs_agi_t *agip;
-	int err = 0;
-	int agi_dirty = 0;
+	struct xfs_buf		*bp;
+	struct xfs_agi		*agip;
+	xfs_agnumber_t		i;
+	int			agi_dirty = 0;
 
 	bp = libxfs_readbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
@@ -112,28 +47,16 @@ process_agi_unlinked(xfs_mount_t *mp, xf
 
 	agip = XFS_BUF_TO_AGI(bp);
 
-	ASSERT(no_modify || be32_to_cpu(agip->agi_seqno) == agno);
+	ASSERT(be32_to_cpu(agip->agi_seqno) == agno);
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)  {
-		if (be32_to_cpu(agip->agi_unlinked[i]) != NULLAGINO)  {
-			err += walk_unlinked_list(mp, agno,
-					be32_to_cpu(agip->agi_unlinked[i]));
-			/*
-			 * clear the list
-			 */
-			if (!no_modify)  {
-				agip->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
-				agi_dirty = 1;
-			}
+		if (agip->agi_unlinked[i] != cpu_to_be32(NULLAGINO)) {
+			agip->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
+			agi_dirty = 1;
 		}
 	}
 
-	if (err)
-		do_warn(_("error following ag %d unlinked list\n"), agno);
-
-	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
-
-	if (agi_dirty && !no_modify)
+	if (agi_dirty)
 		libxfs_writebuf(bp, 0);
 	else
 		libxfs_putbuf(bp);
@@ -209,14 +132,14 @@ phase3(xfs_mount_t *mp)
 
 	set_progress_msg(PROG_FMT_AGI_UNLINKED, (__uint64_t) glob_agcount);
 
-	/*
-	 * first, let's look at the possibly bogus inodes
-	 */
+	/* first clear the agi unlinked AGI list */
+	if (!no_modify) {
+		for (i = 0; i < mp->m_sb.sb_agcount; i++)
+			process_agi_unlinked(mp, i);
+	}
+
+	/* now look at possibly bogus inodes */
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		/*
-		 * walk unlinked list to add more potential inodes to list
-		 */
-		process_agi_unlinked(mp, i);
 		check_uncertain_aginodes(mp, i);
 		PROG_RPT_INC(prog_rpt_done[i], 1);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
