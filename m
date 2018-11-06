Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA63x2Wp023753
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:36 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nh33ttufh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA648ZEG009543
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:36 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA648Z0d010919
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:35 GMT
Subject: [PATCH 4/8] xfs: check inobt record alignment on big block
 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:31 -0800
Message-ID: <154147731114.32496.5929393143346043196.stgit@magnolia>
In-Reply-To: <154147728649.32496.4515247239602322709.stgit@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On a big block filesystem, there may be multiple inobt records covering
a single inode cluster.  These records obviously won't be aligned to
cluster alignment rules, and they must cover the entire cluster.  Teach
scrub to check for these things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index f498dfca3312..4fadea892440 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -57,6 +57,12 @@ struct xchk_iallocbt {
 
 	/* Block alignment of inode clusters. */
 	unsigned int		cluster_align;
+
+	/* Expected next startino, for big block filesystems. */
+	xfs_agino_t		next_startino;
+
+	/* Expected end of the current inode cluster. */
+	xfs_agino_t		next_cluster_ino;
 };
 
 /*
@@ -288,6 +294,27 @@ xchk_iallocbt_rec_alignment(
 	struct xchk_iallocbt		*iabt = bs->private;
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
 	imask = XFS_OFFBNO_TO_AGINO(mp, iabt->cluster_align, 0) - 1;
 	if (irec->ir_startino & imask) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
@@ -299,6 +326,17 @@ xchk_iallocbt_rec_alignment(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return;
 	}
+
+	if (iabt->inodes_per_cluster <= XFS_INODES_PER_CHUNK)
+		return;
+
+	/*
+	 * If this is the start of an inode cluster that can be mapped by
+	 * multiple inobt records, the next inobt record must follow exactly
+	 * after this one.
+	 */
+	iabt->next_startino = irec->ir_startino + XFS_INODES_PER_CHUNK;
+	iabt->next_cluster_ino = irec->ir_startino + iabt->inodes_per_cluster;
 }
 
 /* Scrub an inobt/finobt record. */
@@ -470,6 +508,8 @@ xchk_iallocbt(
 		.inodes		= 0,
 		.cluster_align	= xfs_ialloc_cluster_alignment(sc->mp),
 		.blocks_per_cluster = xfs_icluster_size_fsb(sc->mp),
+		.next_startino	= NULLAGINO,
+		.next_cluster_ino = NULLAGINO,
 	};
 	int			error;
 
