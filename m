Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38458 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2W3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:29:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMTSxJ059071
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2spu7dn1dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMT0Wa168686
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sr31vh96v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMSNH7022804
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:23 GMT
Subject: [PATCH 8/9] xfs: specify AG in bulk req
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 May 2019 15:28:22 -0700
Message-ID: <155916890260.758159.16766868880768864542.stgit@magnolia>
In-Reply-To: <155916885106.758159.3471602893858635007.stgit@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new xfs_bulk_ireq flag to constrain the iteration to a single AG.
If the passed-in startino value is zero then we start with the first
inode in the AG that the user passes in; otherwise, we iterate only
within the same AG as the passed-in inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   10 ++++++++--
 fs/xfs/xfs_ioctl.c     |   25 ++++++++++++++++++++++---
 fs/xfs/xfs_itable.c    |    6 +++---
 fs/xfs/xfs_itable.h    |    4 ++++
 fs/xfs/xfs_iwalk.c     |   12 ++++++++++++
 fs/xfs/xfs_iwalk.h     |   22 +++++++++++++++++-----
 fs/xfs/xfs_qm.c        |    3 ++-
 7 files changed, 68 insertions(+), 14 deletions(-)


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
index 294039c2ea75..cf48a2bad325 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -14,6 +14,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_alloc.h"
 #include "xfs_rtalloc.h"
+#include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_attr.h"
@@ -846,18 +847,36 @@ xfs_bulk_ireq_setup(
 	struct xfs_ibulk	*breq,
 	void __user		*ubuffer)
 {
-	if (hdr->icount == 0 ||
-	    (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
-	    hdr->reserved32 ||
+	if (hdr->icount == 0 || (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
 	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
 		return -EINVAL;
 
+	/*
+	 * The IREQ_AGNO flag means that we only want results from a given AG.
+	 * If @hdr->ino is zero, we start iterating in that AG.  If @hdr->ino is
+	 * beyond the specified AG then we return no results.
+	 */
+	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
+		if (hdr->agno >= mp->m_sb.sb_agcount)
+			return -EINVAL;
+
+		if (hdr->ino == 0)
+			hdr->ino = XFS_AGINO_TO_INO(mp, hdr->agno, 0);
+		else if (XFS_INO_TO_AGNO(mp, hdr->ino) < hdr->agno)
+			return -EINVAL;
+		else if (XFS_INO_TO_AGNO(mp, hdr->ino) > hdr->agno)
+			goto no_results;
+	} else if (hdr->agno)
+		return -EINVAL;
+
 	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
 		goto no_results;
 
 	breq->ubuffer = ubuffer;
 	breq->icount = hdr->icount;
 	breq->startino = hdr->ino;
+	if (hdr->flags & XFS_BULK_IREQ_AGNO)
+		breq->flags |= XFS_IBULK_SAME_AG;
 	return 0;
 no_results:
 	hdr->ocount = 0;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8701596976bb..08a8a827d204 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -241,8 +241,8 @@ xfs_bulkstat(
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_iwalk(breq->mp, NULL, breq->startino, xfs_bulkstat_iwalk,
-			breq->icount, &bc);
+	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
+			xfs_bulkstat_iwalk, breq->icount, &bc);
 
 	/*
 	 * We found some inodes, so clear the error status and return them.
@@ -362,7 +362,7 @@ xfs_inumbers(
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_inobt_walk(breq->mp, NULL, breq->startino,
+	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 
 	/*
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 2987f3eb335f..ae8e9cfca8ad 100644
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
index afa4b22ffb3d..d21537e0bfbb 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -479,6 +479,7 @@ xfs_iwalk(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
 	void			*data)
@@ -495,6 +496,7 @@ xfs_iwalk(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
 	error = xfs_iwalk_allocbuf(&iwag);
@@ -506,6 +508,8 @@ xfs_iwalk(
 		if (error)
 			break;
 		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	xfs_iwalk_freebuf(&iwag);
@@ -541,6 +545,7 @@ int
 xfs_iwalk_threaded(
 	struct xfs_mount	*mp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
 	bool			polled,
@@ -552,6 +557,7 @@ xfs_iwalk_threaded(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
 	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
 	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
@@ -572,6 +578,8 @@ xfs_iwalk_threaded(
 		xfs_iwalk_set_prefetch(iwag, max_prefetch);
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	if (polled)
@@ -672,6 +680,7 @@ xfs_inobt_walk(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		startino,
+	unsigned int		flags,
 	xfs_inobt_walk_fn	inobt_walk_fn,
 	unsigned int		max_prefetch,
 	void			*data)
@@ -688,6 +697,7 @@ xfs_inobt_walk(
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
+	ASSERT(!(flags & ~XFS_INOBT_WALK_FLAGS_ALL));
 
 	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);
 	error = xfs_iwalk_allocbuf(&iwag);
@@ -699,6 +709,8 @@ xfs_inobt_walk(
 		if (error)
 			break;
 		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		if (flags & XFS_INOBT_WALK_SAME_AG)
+			break;
 	}
 
 	xfs_iwalk_freebuf(&iwag);
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 20bee93d4676..a0a1bae44362 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -13,10 +13,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 #define XFS_IWALK_ABORT	(1)
 
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
@@ -27,7 +33,13 @@ typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
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
index de6a623ada02..3540238b6130 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1305,7 +1305,8 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
+	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
+			NULL);
 	if (error)
 		goto error_return;
 
