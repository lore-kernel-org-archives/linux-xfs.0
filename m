Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbeKOQLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 11:11:18 -0500
Subject: [PATCH 4/9] xfs: check inobt record alignment on big block
 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Nov 2018 22:04:46 -0800
Message-ID: <154226188639.13280.8621133300264764877.stgit@magnolia>
In-Reply-To: <154226186169.13280.4536602352984659736.stgit@magnolia>
References: <154226186169.13280.4536602352984659736.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

On a big block filesystem, there may be multiple inobt records covering
a single inode cluster.  These records obviously won't be aligned to
cluster alignment rules, and they must cover the entire cluster.  Teach
scrub to check for these things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/ialloc.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 8f2089049ae5..5a33661e0656 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -47,6 +47,12 @@ xchk_setup_ag_iallocbt(
 struct xchk_iallocbt {
 	/* Number of inodes we see while scanning inobt. */
 	unsigned long long	inodes;
+
+	/* Expected next startino, for big block filesystems. */
+	xfs_agino_t		next_startino;
+
+	/* Expected end of the current inode cluster. */
+	xfs_agino_t		next_cluster_ino;
 };
 
 /*
@@ -271,8 +277,30 @@ xchk_iallocbt_rec_alignment(
 	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec)
 {
+	struct xchk_iallocbt		*iabt = bs->private;
 	xfs_agino_t			imask;
 
+	if (iabt->next_startino != NULLAGINO) {
+		/*
+		 * We're midway through a cluster of inodes that is mapped by
+		 * multiple inobt records.  Did we get the record for the next
+		 * irec in the sequence?
+		 */
+		if (irec->ir_startino != iabt->next_startino) {
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+			return;
+		}
+
+		iabt->next_startino += XFS_INODES_PER_CHUNK;
+
+		/* Are we done with the cluster? */
+		if (iabt->next_startino >= iabt->next_cluster_ino) {
+			iabt->next_startino = NULLAGINO;
+			iabt->next_cluster_ino = NULLAGINO;
+		}
+		return;
+	}
+
 	imask = bs->sc->mp->m_cluster_align_inodes - 1;
 	if (irec->ir_startino & imask) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
@@ -284,6 +312,18 @@ xchk_iallocbt_rec_alignment(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
 	}
+
+	if (bs->sc->mp->m_inodes_per_cluster <= XFS_INODES_PER_CHUNK)
+		return;
+
+	/*
+	 * If this is the start of an inode cluster that can be mapped by
+	 * multiple inobt records, the next inobt record must follow exactly
+	 * after this one.
+	 */
+	iabt->next_startino = irec->ir_startino + XFS_INODES_PER_CHUNK;
+	iabt->next_cluster_ino = irec->ir_startino +
+			bs->sc->mp->m_inodes_per_cluster;
 }
 
 /* Scrub an inobt/finobt record. */
@@ -448,6 +488,8 @@ xchk_iallocbt(
 	struct xfs_btree_cur	*cur;
 	struct xchk_iallocbt	iabt = {
 		.inodes		= 0,
+		.next_startino	= NULLAGINO,
+		.next_cluster_ino = NULLAGINO,
 	};
 	int			error;
 
