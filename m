Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbfFLGuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mfrI066049
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2t02heskb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6nI97099799
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t024utj1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6nujX019825
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:49:56 GMT
Subject: [PATCH 8/9] xfs: specify AG in bulk req
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:49:55 -0700
Message-ID: <156032219545.3774581.4885293947910469571.stgit@magnolia>
In-Reply-To: <156032214432.3774581.1304900948974476604.stgit@magnolia>
References: <156032214432.3774581.1304900948974476604.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new xfs_bulk_ireq flag to constrain the iteration to a single AG.
If the passed-in startino value is zero then we start with the first
inode in the AG that the user passes in; otherwise, we iterate only
within the same AG as the passed-in inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   10 ++++++++--
 fs/xfs/xfs_ioctl.c     |   25 ++++++++++++++++++++++++-
 fs/xfs/xfs_itable.c    |    6 +++---
 fs/xfs/xfs_itable.h    |    4 ++++
 fs/xfs/xfs_iwalk.c     |   12 ++++++++++++
 fs/xfs/xfs_iwalk.h     |   22 +++++++++++++++++-----
 fs/xfs/xfs_qm.c        |    3 ++-
 7 files changed, 70 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f9f35139d4b7..77c06850ac52 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -462,11 +462,17 @@ struct xfs_bulk_ireq {
 	uint32_t	flags;		/* I/O: operation flags		*/
 	uint32_t	icount;		/* I: count of entries in buffer */
 	uint32_t	ocount;		/* O: count of entries filled out */
-	uint32_t	reserved32;	/* must be zero			*/
+	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
 	uint64_t	reserved[5];	/* must be zero			*/
 };
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(0)
+/*
+ * Only return results from the specified @agno.  If @ino is zero, start
+ * with the first inode of @agno.
+ */
+#define XFS_BULK_IREQ_AGNO	(1 << 0)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO)
 
 /* Header for a single inode request. */
 struct xfs_ireq {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2ac5e100b147..f71341cd8340 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -853,7 +853,6 @@ xfs_bulk_ireq_setup(
 {
 	if (hdr->icount == 0 ||
 	    (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
-	    hdr->reserved32 ||
 	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
 		return -EINVAL;
 
@@ -861,6 +860,29 @@ xfs_bulk_ireq_setup(
 	breq->ubuffer = ubuffer;
 	breq->icount = hdr->icount;
 	breq->ocount = 0;
+	breq->flags = 0;
+
+	/*
+	 * The IREQ_AGNO flag means that we only want results from a given AG.
+	 * If @hdr->ino is zero, we start iterating in that AG.  If @hdr->ino is
+	 * beyond the specified AG then we return no results.
+	 */
+	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
+		if (hdr->agno >= mp->m_sb.sb_agcount)
+			return -EINVAL;
+
+		if (breq->startino == 0)
+			breq->startino = XFS_AGINO_TO_INO(mp, hdr->agno, 0);
+		else if (XFS_INO_TO_AGNO(mp, breq->startino) < hdr->agno)
+			return -EINVAL;
+
+		breq->flags |= XFS_IBULK_SAME_AG;
+
+		/* Asking for an inode past the end of the AG?  We're done! */
+		if (XFS_INO_TO_AGNO(mp, breq->startino) > hdr->agno)
+			return XFS_ITER_ABORT;
+	} else if (hdr->agno)
+		return -EINVAL;
 
 	/* Asking for an inode past the end of the FS?  We're done! */
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
@@ -945,6 +967,7 @@ xfs_ireq_setup(
 	breq->ubuffer = ubuffer;
 	breq->icount = 1;
 	breq->startino = hdr->ino;
+	breq->flags = 0;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1ff95bba971f..553167d9c647 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -249,8 +249,8 @@ xfs_bulkstat(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_iwalk(breq->mp, NULL, breq->startino, xfs_bulkstat_iwalk,
-			breq->icount, &bc);
+	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
+			xfs_bulkstat_iwalk, breq->icount, &bc);
 
 	kmem_free(bc.buf);
 
@@ -370,7 +370,7 @@ xfs_inumbers(
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_inobt_walk(breq->mp, NULL, breq->startino,
+	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 
 	/*
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index d41a0a8a326c..d66ecb45ad60 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -12,8 +12,12 @@ struct xfs_ibulk {
 	xfs_ino_t		startino; /* start with this inode */
 	unsigned int		icount;   /* number of elements in ubuffer */
 	unsigned int		ocount;   /* number of records returned */
+	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
 };
 
+/* Only iterate within the same AG as startino */
+#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
+
 /* Return value that means we want to abort the walk. */
 #define XFS_IBULK_ABORT		(XFS_IWALK_ABORT)
 
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index f10688cfb917..56e50480b496 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -506,6 +506,7 @@ xfs_iwalk(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
 	void			*data)
@@ -524,6 +525,7 @@ xfs_iwalk(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
 	error = xfs_iwalk_alloc(&iwag);
@@ -535,6 +537,8 @@ xfs_iwalk(
 		if (error)
 			break;
 		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	xfs_iwalk_free(&iwag);
@@ -573,6 +577,7 @@ int
 xfs_iwalk_threaded(
 	struct xfs_mount	*mp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
 	bool			polled,
@@ -584,6 +589,7 @@ xfs_iwalk_threaded(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
 	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
@@ -605,6 +611,8 @@ xfs_iwalk_threaded(
 		xfs_iwalk_set_prefetch(iwag, max_prefetch);
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	if (polled)
@@ -623,6 +631,7 @@ xfs_inobt_walk(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_inobt_walk_fn	inobt_walk_fn,
 	unsigned int		max_prefetch,
 	void			*data)
@@ -639,6 +648,7 @@ xfs_inobt_walk(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_INOBT_WALK_FLAGS_ALL));
 
 	/* Translate inumbers record count to inode count. */
 	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);
@@ -651,6 +661,8 @@ xfs_inobt_walk(
 		if (error)
 			break;
 		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	xfs_iwalk_free(&iwag);
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 202bca4c9c02..28e8257f9241 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -14,10 +14,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 #define XFS_IWALK_ABORT		(XFS_ITER_ABORT)
 
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
-		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+		unsigned int flags, xfs_iwalk_fn iwalk_fn,
+		unsigned int max_prefetch, void *data);
 int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
-		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
-		void *data);
+		unsigned int flags, xfs_iwalk_fn iwalk_fn,
+		unsigned int max_prefetch, bool poll, void *data);
+
+/* Only iterate inodes within the same AG as @startino. */
+#define XFS_IWALK_SAME_AG	(0x1)
+
+#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
 
 /* Walk all inode btree records in the filesystem starting from @startino. */
 typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
@@ -28,7 +34,13 @@ typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 #define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
 
 int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
-		unsigned int max_prefetch, void *data);
+		xfs_ino_t startino, unsigned int flags,
+		xfs_inobt_walk_fn inobt_walk_fn, unsigned int max_prefetch,
+		void *data);
+
+/* Only iterate inobt records within the same AG as @startino. */
+#define XFS_INOBT_WALK_SAME_AG	(XFS_IWALK_SAME_AG)
+
+#define XFS_INOBT_WALK_FLAGS_ALL (XFS_INOBT_WALK_SAME_AG)
 
 #endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8bb902125403..a526c28662ae 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1304,7 +1304,8 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
+	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
+			NULL);
 	if (error)
 		goto error_return;
 
