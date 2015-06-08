Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E0E97F51
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 06:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E8CC8F8037
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 04:29:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mYugcHC44m8YTFnU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 04:29:26 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D8AF3BACB7
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 11:29:25 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t58BTPMu027127
	for <xfs@oss.sgi.com>; Mon, 8 Jun 2015 07:29:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] repair: helper to transition inode blocks to inode state
Date: Mon,  8 Jun 2015 07:29:24 -0400
Message-Id: <1433762964-11502-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
References: <1433762964-11502-1-git-send-email-bfoster@redhat.com>
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

The state of each block in an inode chunk transitions from free state to
inode state as we process physical inodes on disk. We take care to
detect invalid transitions and warn the user if multiply claimed blocks
are detected.

This block of code is a largish switch statement that is executed twice
due to the implementation details of the inode processing loop. Factor
it into a new helper.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/dino_chunks.c | 91 ++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 52 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 9b7d017..834227b 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -550,7 +550,42 @@ verify_aginode_chunk_irec(xfs_mount_t	*mp,
 	return(irec);
 }
 
+/*
+ * Set the state of an inode block during inode chunk processing. The block is
+ * expected to be in the free or inode state. If free, it transitions to the
+ * inode state. Warn if the block is in neither expected state as this indicates
+ * multiply claimed blocks.
+ */
+static void
+process_inode_agbno_state(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno)
+{
+	int state;
 
+	pthread_mutex_lock(&ag_locks[agno].lock);
+	state = get_bmap(agno, agbno);
+	switch (state) {
+	case XR_E_INO:	/* already marked */
+		break;
+	case XR_E_UNKNOWN:
+	case XR_E_FREE:
+	case XR_E_FREE1:
+		set_bmap(agno, agbno, XR_E_INO);
+		break;
+	case XR_E_BAD_STATE:
+		do_error(_("bad state in block map %d\n"), state);
+		break;
+	default:
+		set_bmap(agno, agbno, XR_E_MULT);
+		do_warn(
+	_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
+			XFS_AGB_TO_FSB(mp, agno, agbno), state);
+		break;
+	}
+	pthread_mutex_unlock(&ag_locks[agno].lock);
+}
 
 /*
  * processes an inode allocation chunk/block, returns 1 on I/O errors,
@@ -558,8 +593,6 @@ verify_aginode_chunk_irec(xfs_mount_t	*mp,
  *
  * *bogus is set to 1 if the entire set of inodes is bad.
  */
-
-/* ARGSUSED */
 static int
 process_inode_chunk(
 	xfs_mount_t 		*mp,
@@ -578,7 +611,6 @@ process_inode_chunk(
 	int			icnt;
 	int			status;
 	int			is_used;
-	int			state;
 	int			ino_dirty;
 	int			irec_offset;
 	int			ibuf_offset;
@@ -757,29 +789,8 @@ next_readbuf:
 	/*
 	 * mark block as an inode block in the incore bitmap
 	 */
-	if (!is_inode_sparse(ino_rec, irec_offset)) {
-		pthread_mutex_lock(&ag_locks[agno].lock);
-		state = get_bmap(agno, agbno);
-		switch (state) {
-		case XR_E_INO:	/* already marked */
-			break;
-		case XR_E_UNKNOWN:
-		case XR_E_FREE:
-		case XR_E_FREE1:
-			set_bmap(agno, agbno, XR_E_INO);
-			break;
-		case XR_E_BAD_STATE:
-			do_error(_("bad state in block map %d\n"), state);
-			break;
-		default:
-			set_bmap(agno, agbno, XR_E_MULT);
-			do_warn(
-		_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
-				XFS_AGB_TO_FSB(mp, agno, agbno), state);
-			break;
-		}
-		pthread_mutex_unlock(&ag_locks[agno].lock);
-	}
+	if (!is_inode_sparse(ino_rec, irec_offset))
+		process_inode_agbno_state(mp, agno, agbno);
 
 	for (;;) {
 		agino = irec_offset + ino_rec->ino_startnum;
@@ -956,32 +967,8 @@ process_next:
 			ibuf_offset = 0;
 			agbno++;
 
-			if (!is_inode_sparse(ino_rec, irec_offset)) {
-				pthread_mutex_lock(&ag_locks[agno].lock);
-				state = get_bmap(agno, agbno);
-				switch (state) {
-				case XR_E_INO:	/* already marked */
-					break;
-				case XR_E_UNKNOWN:
-				case XR_E_FREE:
-				case XR_E_FREE1:
-					set_bmap(agno, agbno, XR_E_INO);
-					break;
-				case XR_E_BAD_STATE:
-					do_error(
-					_("bad state in block map %d\n"),
-						state);
-					break;
-				default:
-					set_bmap(agno, agbno, XR_E_MULT);
-					do_warn(
-		_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
-						XFS_AGB_TO_FSB(mp, agno, agbno),
-						state);
-					break;
-				}
-				pthread_mutex_unlock(&ag_locks[agno].lock);
-			}
+			if (!is_inode_sparse(ino_rec, irec_offset))
+				process_inode_agbno_state(mp, agno, agbno);
 		} else if (irec_offset == XFS_INODES_PER_CHUNK)  {
 			/*
 			 * get new irec (multiple chunks per block fs)
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
