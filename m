Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbeARAHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 19:07:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I07OWM165970
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:32 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2fjcsch4ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07VuJ013451
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:31 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0I07VOE003289
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2018 00:07:31 GMT
Subject: [PATCH 3/5] xfs: fix agfl wrapping on v5 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Jan 2018 16:07:30 -0800
Message-ID: <151623404992.4727.16316307175461448723.stgit@magnolia>
In-Reply-To: <151623403113.4727.2418454911805718650.stgit@magnolia>
References: <151623403113.4727.2418454911805718650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce helper functions to scan and fix the AGFLs at mount time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |  147 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h  |    3 +
 fs/xfs/libxfs/xfs_format.h |    5 +
 fs/xfs/xfs_mount.c         |   10 +++
 fs/xfs/xfs_super.c         |   10 +++
 5 files changed, 175 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f3f17a1..9564e34 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -70,6 +70,153 @@ xfs_agfl_size(
 	return size / sizeof(xfs_agblock_t);
 }
 
+/*
+ * Detect and fixup a screwup in the struct xfs_agfl definition that results in
+ * different free list sizes depending on the compiler padding added to the
+ * xfs_agfl. This will only matter on v5 filesystems that have the freelist
+ * wrapping around the end of the AGFL.  If we fix the problem, we log the new
+ * AGF immediately; if the caller fixes all the AGFLs, then it should set the
+ * superblock flag to say we've fixed everything.
+ */
+int
+xfs_agf_fixup_freelist_count(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agfbp,
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf;
+	struct xfs_buf		*agflbp;
+	__be32			*agfl_bno;
+	xfs_agnumber_t		agno;
+	uint32_t		agfl_size;
+	uint32_t		flfirst;
+	uint32_t		fllast;
+	int32_t			active;
+	int			offset;
+	int			error;
+
+	/* v4 or fixed-agfl fs doesn't need fixing */
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    xfs_sb_version_hasfixedagfl(&mp->m_sb))
+		return 0;
+
+	agfl_size = xfs_agfl_size(mp);
+
+	agf = XFS_BUF_TO_AGF(agfbp);
+	agno = be32_to_cpu(agf->agf_seqno);
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/*
+	 * In the original v5 code, we had a structure padding error in struct
+	 * xfs_agfl such that XFS_AGFL_SIZE thought the structure size was 36
+	 * on 32-bit and 40 on 64-bit.  On a 512b sector fs this lead to
+	 * ((512 - 36) / 4) = 119 agfl entries on 32bit, whereas on 64-bit
+	 * ((512 - 40) / 4) = 118 agfl entries.  This could lead to problems
+	 * if you migrated filesystems between 32bit and 64bit machines.
+	 *
+	 * In Linux 4.5 we fixed the padding problem such that the structure
+	 * size is always 36 bytes (119 entries in the above example), but
+	 * this still leads to verifier problems because flfirst/fllast have
+	 * to match flcount even if they wrap around the end.  This was also
+	 * problematic because there were v5 filesystems already deployed, and
+	 * some of them have the 40-byte padding (i.e. 118 entries).
+	 *
+	 * Now we're introducing a FIXED_AGFL feature that means that we've
+	 * fixed any wrapping problems and we'll never do that again.  Better
+	 * yet, old kernels won't be touching the AGFL because it's a rocompat
+	 * feature.  We retain the 36-byte padding.
+	 */
+	active = fllast - flfirst + 1;
+	if (active <= 0)
+		active += agfl_size;
+	if (active == pag->pagf_flcount)
+		return 0;
+	else if (active != pag->pagf_flcount + 1)
+		return -EFSCORRUPTED;
+
+	/* Would this have even passed muster on an old system? */
+	if (flfirst >= agfl_size - 1 || fllast >= agfl_size - 1 ||
+	    pag->pagf_flcount > agfl_size - 1)
+		return -EFSCORRUPTED;
+
+	/*
+	 * Convert a 40-byte-padded agfl into a 36-byte-padded AGFL.
+	 * Therefore, we need to move the AGFL blocks
+	 * bno[flfirst..agfl_size - 2] to bno[flfirst + 1...agfl_size - 1].
+	 *
+	 * Reusing the example above, if we had flfirst == 116, we need
+	 * to move bno[116] and bno[117] into bno[117] and bno[118],
+	 * respectively, and then increment flfirst.
+	 */
+	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
+	if (error)
+		return error;
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	memmove(&agfl_bno[flfirst + 1], &agfl_bno[flfirst],
+			(agfl_size - flfirst - 1) * sizeof(xfs_agblock_t));
+	agfl_bno[flfirst] = cpu_to_be32(NULLAGBLOCK);
+	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
+	offset = (char *)&agfl_bno[flfirst] - (char *)agflbp->b_addr;
+	xfs_trans_log_buf(tp, agflbp, offset, BBTOB(agflbp->b_length) - 1);
+	xfs_trans_brelse(tp, agflbp);
+	agflbp = NULL;
+
+	be32_add_cpu(&agf->agf_flfirst, 1);
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST);
+
+	return 0;
+}
+
+/* Fix all the AGFL counters. */
+int
+xfs_agf_fixup_freelist_counts(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agfbp;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    xfs_sb_version_hasfixedagfl(&mp->m_sb))
+		return 0;
+
+	/* Need to be able to log all AGFs + primary super */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	/* Make sure all the AGFLs do not go off the end of the array. */
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agfbp);
+		if (error)
+			goto cancel;
+		if (!agfbp) {
+			error = -ENOMEM;
+			goto cancel;
+		}
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_agf_fixup_freelist_count(tp, agfbp, pag);
+		xfs_perag_put(pag);
+		xfs_trans_brelse(tp, agfbp);
+		if (error)
+			goto cancel;
+	}
+
+	/* Add the feature flag so we don't have to do this again. */
+	xfs_sb_version_addfixedagfl(&mp->m_sb);
+	xfs_log_sb(tp);
+
+	return xfs_trans_commit(tp);
+
+cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 unsigned int
 xfs_refc_block(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a311a24..2c79ea4e 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -27,6 +27,9 @@ struct xfs_trans;
 extern struct workqueue_struct *xfs_alloc_wq;
 
 unsigned int xfs_agfl_size(struct xfs_mount *mp);
+int xfs_agf_fixup_freelist_count(struct xfs_trans *tp, struct xfs_buf *agfbp,
+		struct xfs_perag *pag);
+int xfs_agf_fixup_freelist_counts(struct xfs_mount *mp);
 
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3befc92f..e3fdc66 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -573,6 +573,11 @@ static inline bool xfs_sb_version_hasfixedagfl(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL);
 }
 
+static inline void xfs_sb_version_addfixedagfl(struct xfs_sb *sbp)
+{
+	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FIXED_AGFL;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7f66b96..38d19db 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -874,6 +874,16 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Make sure our AGFL counters do not wrap the end of the block in a
+	 * troublesome manner.  Don't bother if we're readonly.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		error = xfs_agf_fixup_freelist_counts(mp);
+		if (error)
+			goto out_log_dealloc;
+	}
+
+	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee75d93..57a0cb1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1345,6 +1345,16 @@ xfs_fs_remount(
 		}
 
 		/*
+		 * Make sure our AGFL counters do not wrap the end of the block
+		 * in a troublesome manner.
+		 */
+		error = xfs_agf_fixup_freelist_counts(mp);
+		if (error) {
+			xfs_warn(mp, "failed to set FIXED_AGFL feature");
+			return error;
+		}
+
+		/*
 		 * Fill out the reserve pool if it is empty. Use the stashed
 		 * value if it is non-zero, otherwise go with the default.
 		 */

