Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AF357F6B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C050AC002
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WdT0JL8wCS9xERtl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 5523735999A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig49K019886
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 21/28] repair: process sparse inode records correctly
Date: Tue,  2 Jun 2015 14:41:54 -0400
Message-Id: <1433270521-62026-22-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

The inode processing phases of xfs_repair (3 and 4) validate the actual
inodes referred to by the previously scanned inode btrees. The physical
inodes are read from disk and internally validated in various ways. The
inode block state is also verified and corrected if necessary.

Sparse inodes are not physically allocated and the associated blocks may
be allocated to any other area of the fs (file data, internal use,
etc.). Attempts to validate these blocks as inode blocks produce noisy
corruption errors.

Update the inode processing mechanism to handle sparse inode records
correctly. Since sparse inodes do not exist, the general approach here
is to simply skip validation of sparse inodes. Update
process_inode_chunk() to skip reads of sparse clusters and set the buf
pointer of associated clusters to NULL. Update the rest of the function
to only verify non-NULL cluster buffers. Also, skip the inode block
state checks for blocks in sparse inode clusters.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/dino_chunks.c | 162 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 98 insertions(+), 64 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index a1ce9e7..9b7d017 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -615,6 +615,7 @@ process_inode_chunk(
 	 * set up first irec
 	 */
 	ino_rec = first_irec;
+	irec_offset = 0;
 
 	bplist = malloc(cluster_count * sizeof(xfs_buf_t *));
 	if (bplist == NULL)
@@ -622,6 +623,18 @@ process_inode_chunk(
 			cluster_count * sizeof(xfs_buf_t *));
 
 	for (bp_index = 0; bp_index < cluster_count; bp_index++) {
+		/*
+		 * Skip the cluster buffer if the first inode is sparse. The
+		 * remaining inodes in the cluster share the same state as
+		 * sparse inodes occur at cluster granularity.
+		 */
+		if (is_inode_sparse(ino_rec, irec_offset)) {
+			pftrace("skip sparse inode, startnum 0x%x idx %d",
+				ino_rec->ino_startnum, irec_offset);
+			bplist[bp_index] = NULL;
+			goto next_readbuf;
+		}
+
 		pftrace("about to read off %llu in AG %d",
 			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
 
@@ -641,12 +654,16 @@ process_inode_chunk(
 			free(bplist);
 			return(1);
 		}
-		agbno += blks_per_cluster;
-		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
 
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
 			(long long)XFS_BUF_ADDR(bplist[bp_index]),
 			XFS_BUF_COUNT(bplist[bp_index]), agno);
+
+		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
+
+next_readbuf:
+		irec_offset += mp->m_sb.sb_inopblock * blks_per_cluster;
+		agbno += blks_per_cluster;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, first_irec->ino_startnum);
 
@@ -665,24 +682,27 @@ process_inode_chunk(
 	 */
 	if (ino_discovery)  {
 		for (;;)  {
-			/*
-			 * make inode pointer
-			 */
-			dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 			agino = irec_offset + ino_rec->ino_startnum;
 
-			/*
-			 * we always think that the root and realtime
-			 * inodes are verified even though we may have
-			 * to reset them later to keep from losing the
-			 * chunk that they're in
-			 */
-			if (verify_dinode(mp, dino, agno, agino) == 0 ||
-					(agno == 0 &&
-					(mp->m_sb.sb_rootino == agino ||
-					 mp->m_sb.sb_rsumino == agino ||
-					 mp->m_sb.sb_rbmino == agino)))
-				status++;
+			/* no buffers for sparse clusters */
+			if (bplist[bp_index]) {
+				/* make inode pointer */
+				dino = xfs_make_iptr(mp, bplist[bp_index],
+						     cluster_offset);
+
+				/*
+				 * we always think that the root and realtime
+				 * inodes are verified even though we may have
+				 * to reset them later to keep from losing the
+				 * chunk that they're in
+				 */
+				if (verify_dinode(mp, dino, agno, agino) == 0 ||
+						(agno == 0 &&
+						(mp->m_sb.sb_rootino == agino ||
+						 mp->m_sb.sb_rsumino == agino ||
+						 mp->m_sb.sb_rbmino == agino)))
+					status++;
+			}
 
 			irec_offset++;
 			icnt++;
@@ -716,7 +736,8 @@ process_inode_chunk(
 		if (!status)  {
 			*bogus = 1;
 			for (bp_index = 0; bp_index < cluster_count; bp_index++)
-				libxfs_putbuf(bplist[bp_index]);
+				if (bplist[bp_index])
+					libxfs_putbuf(bplist[bp_index]);
 			free(bplist);
 			return(0);
 		}
@@ -736,35 +757,41 @@ process_inode_chunk(
 	/*
 	 * mark block as an inode block in the incore bitmap
 	 */
-	pthread_mutex_lock(&ag_locks[agno].lock);
-	state = get_bmap(agno, agbno);
-	switch (state) {
-	case XR_E_INO:	/* already marked */
-		break;
-	case XR_E_UNKNOWN:
-	case XR_E_FREE:
-	case XR_E_FREE1:
-		set_bmap(agno, agbno, XR_E_INO);
-		break;
-	case XR_E_BAD_STATE:
-		do_error(_("bad state in block map %d\n"), state);
-		break;
-	default:
-		set_bmap(agno, agbno, XR_E_MULT);
-		do_warn(_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
-			XFS_AGB_TO_FSB(mp, agno, agbno), state);
-		break;
+	if (!is_inode_sparse(ino_rec, irec_offset)) {
+		pthread_mutex_lock(&ag_locks[agno].lock);
+		state = get_bmap(agno, agbno);
+		switch (state) {
+		case XR_E_INO:	/* already marked */
+			break;
+		case XR_E_UNKNOWN:
+		case XR_E_FREE:
+		case XR_E_FREE1:
+			set_bmap(agno, agbno, XR_E_INO);
+			break;
+		case XR_E_BAD_STATE:
+			do_error(_("bad state in block map %d\n"), state);
+			break;
+		default:
+			set_bmap(agno, agbno, XR_E_MULT);
+			do_warn(
+		_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
+				XFS_AGB_TO_FSB(mp, agno, agbno), state);
+			break;
+		}
+		pthread_mutex_unlock(&ag_locks[agno].lock);
 	}
-	pthread_mutex_unlock(&ag_locks[agno].lock);
 
 	for (;;) {
-		/*
-		 * make inode pointer
-		 */
-		dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 		agino = irec_offset + ino_rec->ino_startnum;
 		ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
+		if (is_inode_sparse(ino_rec, irec_offset))
+			goto process_next;
+
+		/* make inode pointer */
+		dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
+
+
 		is_used = 3;
 		ino_dirty = 0;
 		parent = 0;
@@ -895,6 +922,7 @@ process_inode_chunk(
 			}
 		}
 
+process_next:
 		irec_offset++;
 		ibuf_offset++;
 		icnt++;
@@ -906,6 +934,9 @@ process_inode_chunk(
 			 * done! - finished up irec and block simultaneously
 			 */
 			for (bp_index = 0; bp_index < cluster_count; bp_index++) {
+				if (!bplist[bp_index])
+					continue;
+
 				pftrace("put/writebuf %p (%llu) in AG %d",
 					bplist[bp_index], (long long)
 					XFS_BUF_ADDR(bplist[bp_index]), agno);
@@ -925,29 +956,32 @@ process_inode_chunk(
 			ibuf_offset = 0;
 			agbno++;
 
-			pthread_mutex_lock(&ag_locks[agno].lock);
-			state = get_bmap(agno, agbno);
-			switch (state) {
-			case XR_E_INO:	/* already marked */
-				break;
-			case XR_E_UNKNOWN:
-			case XR_E_FREE:
-			case XR_E_FREE1:
-				set_bmap(agno, agbno, XR_E_INO);
-				break;
-			case XR_E_BAD_STATE:
-				do_error(_("bad state in block map %d\n"),
-					state);
-				break;
-			default:
-				set_bmap(agno, agbno, XR_E_MULT);
-				do_warn(
-	_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
-					XFS_AGB_TO_FSB(mp, agno, agbno), state);
-				break;
+			if (!is_inode_sparse(ino_rec, irec_offset)) {
+				pthread_mutex_lock(&ag_locks[agno].lock);
+				state = get_bmap(agno, agbno);
+				switch (state) {
+				case XR_E_INO:	/* already marked */
+					break;
+				case XR_E_UNKNOWN:
+				case XR_E_FREE:
+				case XR_E_FREE1:
+					set_bmap(agno, agbno, XR_E_INO);
+					break;
+				case XR_E_BAD_STATE:
+					do_error(
+					_("bad state in block map %d\n"),
+						state);
+					break;
+				default:
+					set_bmap(agno, agbno, XR_E_MULT);
+					do_warn(
+		_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
+						XFS_AGB_TO_FSB(mp, agno, agbno),
+						state);
+					break;
+				}
+				pthread_mutex_unlock(&ag_locks[agno].lock);
 			}
-			pthread_mutex_unlock(&ag_locks[agno].lock);
-
 		} else if (irec_offset == XFS_INODES_PER_CHUNK)  {
 			/*
 			 * get new irec (multiple chunks per block fs)
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
