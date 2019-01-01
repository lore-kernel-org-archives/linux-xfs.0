Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:08:53 -0500
Subject: [PATCH 3/8] xfs: check inobt record alignment on big block
 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:08:45 -0800
Message-ID: <154630852589.14372.6446270754079238669.stgit@magnolia>
In-Reply-To: <154630850739.14372.14000129432637481206.stgit@magnolia>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
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
 fs/xfs/scrub/ialloc.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 5082331d6c03..5e593e4292b2 100644
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
@@ -272,6 +278,7 @@ xchk_iallocbt_rec_alignment(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	struct xfs_mount		*mp = bs->sc->mp;
+	struct xchk_iallocbt		*iabt = bs->private;
 
 	/*
 	 * finobt records have different positioning requirements than inobt
@@ -289,6 +296,27 @@ xchk_iallocbt_rec_alignment(
 		return;
 	}
 
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
 	/* inobt records must be aligned to cluster and inoalignmnt size. */
 	if (irec->ir_startino & (mp->m_cluster_align_inodes - 1)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
@@ -299,6 +327,17 @@ xchk_iallocbt_rec_alignment(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
 	}
+
+	if (mp->m_inodes_per_cluster <= XFS_INODES_PER_CHUNK)
+		return;
+
+	/*
+	 * If this is the start of an inode cluster that can be mapped by
+	 * multiple inobt records, the next inobt record must follow exactly
+	 * after this one.
+	 */
+	iabt->next_startino = irec->ir_startino + XFS_INODES_PER_CHUNK;
+	iabt->next_cluster_ino = irec->ir_startino + mp->m_inodes_per_cluster;
 }
 
 /* Scrub an inobt/finobt record. */
@@ -463,6 +502,8 @@ xchk_iallocbt(
 	struct xfs_btree_cur	*cur;
 	struct xchk_iallocbt	iabt = {
 		.inodes		= 0,
+		.next_startino	= NULLAGINO,
+		.next_cluster_ino = NULLAGINO,
 	};
 	int			error;
 
