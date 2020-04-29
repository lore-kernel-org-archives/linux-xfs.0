Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE19CC83006
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8897420737
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l4LorHdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgD2Cqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 22:46:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgD2Cqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 22:46:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2hqAJ121547
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Yy8tg4cwz8b6M3veE6865DMoT7+B0htPwmEEMxvWGM8=;
 b=l4LorHdCLmukqi+BpaeI2rMnwPRqnTpY6MskQl8804Sy5Bm3EGETFm0LCe6d7CW9vD1F
 FLlmIMOpwdrXRsxZ0gd8+RYD/SNPpwTyDvBDfRisojG8cq9nGInwUx6/B8vzXyFQUELd
 pL6pwSEgb4ymkf3cy7zK/cXjiiwKVtq1V7ekCdppg887gQbcVgHdX5xU6+46eMXKkgmT
 O2rn+wY20EDIcZ6kiF7ROptb0nT4ZLR3qfuM8ScZcrZ4ryj4zobD2YgWBay+yXSyZUSY
 vOLk7G2fG6TZ6Vrqh0fWUFIJTqLv53JlWosQgY9DXfpY7uaDxFQeU/Iy1feQp2oJg1l+ 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p08p53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2ftoW096170
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30pvcytexa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03T2kegn004232
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 19:46:40 -0700
Subject: [PATCH 4/5] xfs: use atomic extent swapping to repair extended
 attributes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Apr 2020 19:46:39 -0700
Message-ID: <158812839930.169849.13885520868450722707.stgit@magnolia>
In-Reply-To: <158812837421.169849.625434931406278072.stgit@magnolia>
References: <158812837421.169849.625434931406278072.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When repairing extended attributes online, stage the new xattr contents
in a temporary file and use the atomic extent swapping mechanism to
commit the results in bulk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |    6 -
 fs/xfs/libxfs/xfs_swapext.c    |   53 +++++
 fs/xfs/libxfs/xfs_swapext.h    |    1 
 fs/xfs/scrub/attr.c            |   12 +
 fs/xfs/scrub/attr_repair.c     |  453 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/bitmap.c          |   22 ++
 fs/xfs/scrub/bitmap.h          |    1 
 fs/xfs/xfs_bmap_util.c         |    2 
 fs/xfs/xfs_bmap_util.h         |    3 
 fs/xfs/xfs_trace.h             |    3 
 10 files changed, 525 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ceb67213df64..5fc1a11572da 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -813,8 +813,12 @@ struct xfs_swap_extent {
 /* Set the file sizes when finished. */
 #define XFS_SWAP_EXTENT_SET_SIZES	(1ULL << 1)
 
+/* Try to convert inode2 from block to short format at the end, if possible. */
+#define XFS_SWAP_EXTENT_TO_SHORTFORM2	(1ULL << 2)
+
 #define XFS_SWAP_EXTENT_FLAGS		(XFS_SWAP_EXTENT_ATTR_FORK | \
-					 XFS_SWAP_EXTENT_SET_SIZES)
+					 XFS_SWAP_EXTENT_SET_SIZES | \
+					 XFS_SWAP_EXTENT_TO_SHORTFORM2)
 
 /* This is the structure used to lay out an sxi log item in the log. */
 struct xfs_sxi_log_format {
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 64083d48fb7d..f16f7d9a0b66 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -20,6 +20,9 @@
 #include "xfs_trace.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_leaf.h"
 
 /* Information to help us reset reflink flag / CoW fork state after a swap. */
 
@@ -200,12 +203,45 @@ xfs_swapext_update_size(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+/* Convert inode2's leaf attr fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_attr_to_shortform2(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->si_ip2,
+		.geo		= tp->t_mountp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.trans		= tp,
+	};
+	struct xfs_buf		*bp;
+	int			forkoff;
+	int			error;
+
+	if (!xfs_bmap_one_block(sxi->si_ip2, XFS_ATTR_FORK))
+		return 0;
+
+	error = xfs_attr3_leaf_read(tp, sxi->si_ip2, 0, &bp);
+	if (error)
+		return error;
+
+	forkoff = xfs_attr_shortform_allfit(bp, sxi->si_ip2);
+	if (forkoff == 0)
+		return 0;
+
+	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
+}
+
+#define XFS_SWAP_EXTENT_POST_PROCESSING (XFS_SWAP_EXTENT_TO_SHORTFORM2)
+
 /* Do we have more work to do to finish this operation? */
 bool
 xfs_swapext_has_more_work(
 	struct xfs_swapext_intent	*sxi)
 {
-	return sxi->si_blockcount > 0;
+	return sxi->si_blockcount > 0 ||
+		(sxi->si_flags & XFS_SWAP_EXTENT_POST_PROCESSING);
 }
 
 /* Finish one extent swap, possibly log more. */
@@ -218,12 +254,23 @@ xfs_swapext_finish_one(
 	int				whichfork;
 	int				nimaps;
 	int				bmap_flags;
-	int				error;
+	int				error = 0;
 
 	whichfork = (sxi->si_flags & XFS_SWAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bmap_flags = xfs_bmapi_aflag(whichfork);
 
+	/* Do any post-processing work that we requires a transaction roll. */
+	if (sxi->si_blockcount == 0) {
+		if (sxi->si_flags & XFS_SWAP_EXTENT_TO_SHORTFORM2) {
+			if (sxi->si_flags & XFS_SWAP_EXTENT_ATTR_FORK)
+				error = xfs_swapext_attr_to_shortform2(tp, sxi);
+			sxi->si_flags &= ~XFS_SWAP_EXTENT_TO_SHORTFORM2;
+			return error;
+		}
+		return 0;
+	}
+
 	while (sxi->si_blockcount > 0) {
 		int64_t		ip1_delta = 0, ip2_delta = 0;
 
@@ -385,6 +432,8 @@ xfs_swapext_init_intent(
 		sxi->si_isize1 = ip2->i_d.di_size;
 		sxi->si_isize2 = ip1->i_d.di_size;
 	}
+	if (flags & XFS_SWAPEXT_TO_SHORTFORM2)
+		sxi->si_flags |= XFS_SWAP_EXTENT_TO_SHORTFORM2;
 	sxi->si_ip1 = ip1;
 	sxi->si_ip2 = ip2;
 	sxi->si_startoff1 = startoff1;
diff --git a/fs/xfs/libxfs/xfs_swapext.h b/fs/xfs/libxfs/xfs_swapext.h
index f4146f55a4c9..2ac08a25f0d9 100644
--- a/fs/xfs/libxfs/xfs_swapext.h
+++ b/fs/xfs/libxfs/xfs_swapext.h
@@ -49,6 +49,7 @@ int xfs_swapext_finish_one(struct xfs_trans *tp,
 		struct xfs_swapext_intent *sxi_state);
 
 #define XFS_SWAPEXT_SET_SIZES		(1U << 0)
+#define XFS_SWAPEXT_TO_SHORTFORM2	(1U << 1)
 int xfs_swapext_atomic(struct xfs_trans **tpp, struct xfs_inode *ip1,
 		struct xfs_inode *ip2, int whichfork, xfs_fileoff_t startoff1,
 		xfs_fileoff_t startoff2, xfs_filblks_t blockcount,
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index faacdb9f9f1e..b2cde8cd8244 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -19,6 +19,7 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/attr.h"
+#include "scrub/repair.h"
 
 /*
  * Allocate enough memory to hold an attr value and attr block bitmaps,
@@ -80,6 +81,17 @@ xchk_setup_xattr(
 {
 	int			error;
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		if (!xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
+			return -EOPNOTSUPP;
+
+		error = xrep_create_tempfile(sc, S_IFREG);
+		if (error)
+			return error;
+	}
+#endif
+
 	/*
 	 * We failed to get memory while checking attrs, so this time try to
 	 * get all the memory we're ever going to need.  Allocate the buffer
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index f1d7b1808498..d2563dd6c2d2 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -24,6 +24,8 @@
 #include "xfs_attr_sf.h"
 #include "xfs_attr_remote.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_swapext.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -445,14 +447,15 @@ xrep_attr_walk_blind(
 				len--;
 			}
 
-			if (flags & XREP_ATTR_WALK_INCORE)
-				continue;
-
 			/*
-			 * If we didn't find a buffer, read 1 block from disk.
-			 * We don't attach any buffer ops.
+			 * If we didn't find an incore buffer, reset len to 1
+			 * so that we can make forward progress.
 			 */
 			len = 1;
+
+			if (flags & XREP_ATTR_WALK_INCORE)
+				continue;
+
 			error = xfs_buf_read(mp->m_ddev_targp, daddr,
 					XFS_FSB_TO_BB(mp, len),
 					XBF_TRYLOCK, &bp, NULL);
@@ -699,7 +702,8 @@ xrep_xattr_insert_rec(
 	 */
 	name[XATTR_NAME_MAX] = 0;
 
-	error = xblob_get(rx->xattr_blobs, key->name_cookie, name, key->namelen);
+	error = xblob_get(rx->xattr_blobs, key->name_cookie, name,
+			key->namelen);
 	if (error)
 		return error;
 
@@ -718,10 +722,10 @@ xrep_xattr_insert_rec(
 
 	name[key->namelen] = 0;
 
-	trace_xrep_xattr_insert_rec(rx->sc->ip, key->flags, name, key->namelen,
-			key->valuelen);
+	trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags, name,
+			key->namelen, key->valuelen);
 
-	args.dp = rx->sc->ip;
+	args.dp = rx->sc->tempip;
 	args.attr_filter = key->flags;
 	args.name = name;
 	args.namelen = key->namelen;
@@ -731,20 +735,407 @@ xrep_xattr_insert_rec(
 }
 
 /*
- * Insert all the attributes that we collected.
+ * Prepare both inodes' attribute forks for extent swapping.  Promote the
+ * tempfile from short format to leaf format, and if the file being repaired
+ * has a short format attr fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_xattr_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the tempfile's attributes are in shortform format, convert that
+	 * to a single leaf extent so that we can use the atomic extent swap.
+	 */
+	if (temp_local) {
+		struct xfs_buf		*leaf_bp = NULL;
+		struct xfs_da_args	args = {
+			.dp		= sc->tempip,
+			.geo		= sc->mp->m_attr_geo,
+			.whichfork	= XFS_ATTR_FORK,
+			.trans		= sc->tp,
+			.total		= 1,
+		};
+
+		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
+		if (error)
+			return error;
+
+		/*
+		 * Roll the deferred log items to get us back to a clean
+		 * transaction.  Hold on to the leaf buffer across this roll
+		 * so that the AIL cannot grab our half-baked block.
+		 */
+		xfs_trans_bhold(sc->tp, leaf_bp);
+		error = xfs_defer_finish(&sc->tp);
+		xfs_trans_bhold_release(sc->tp, leaf_bp);
+	}
+
+	/*
+	 * If the file being repaired had a shortform attribute fork, convert
+	 * that to an empty extent list in preparation for the atomic extent
+	 * swap.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		sc->ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+		sc->ip->i_d.di_anextents = 0;
+
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+		xfs_ifork_reset(ifp);
+		ifp->if_bytes = 0;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+		ifp->if_flags |= XFS_IFEXTENTS;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+	}
+
+	return 0;
+}
+
+/* State we need to track while rewriting attr block owners. */
+struct xrep_xattr_swap_owner {
+	struct xfs_attr_list_context	ctx;
+	struct xbitmap			rmt_blocks;
+	struct xfs_scrub		*sc;
+};
+
+/*
+ * Change the owner field of a remote attribute value block to match the file
+ * that's being repaired.  In-core buffers for these values span a single
+ * extent and are never logged, so we must be careful to mask off the
+ * corresponding range so that the leaf/node pass will skip these parts of the
+ * attr fork mappings.
+ */
+static void
+xrep_xattr_swap_rmt_owner(
+	struct xfs_attr_list_context	*context,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	int				valuelen)
+{
+	struct xfs_da_args		args = {
+		.op_flags		= XFS_DA_OP_NOTIME,
+		.attr_filter		= flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.geo			= context->dp->i_mount->m_attr_geo,
+		.whichfork		= XFS_ATTR_FORK,
+		.dp			= context->dp,
+		.name			= name,
+		.namelen		= namelen,
+		.hashval		= xfs_da_hashname(name, namelen),
+		.trans			= context->tp,
+		.value			= NULL,
+		.valuelen		= 0,
+	};
+	LIST_HEAD(buffer_list);
+	struct xfs_bmbt_irec		map;
+	struct xrep_xattr_swap_owner	*xso;
+	struct xfs_mount		*mp = context->dp->i_mount;
+	struct xfs_attr3_rmt_hdr	*rmt;
+	struct xfs_buf			*bp;
+	void				*p;
+	xfs_daddr_t			dblkno;
+	int				dblkcnt;
+	int				nmap;
+	int				error;
+
+	xso = container_of(context, struct xrep_xattr_swap_owner, ctx);
+
+	if (flags & (XFS_ATTR_LOCAL | XFS_ATTR_INCOMPLETE))
+		return;
+
+	error = xfs_attr_get_ilocked(&args);
+	if (error)
+		goto fail;
+
+	/*
+	 * Mark this region of the attr fork so that the leaf/node scan will
+	 * skip this part.
+	 */
+	error = xbitmap_set(&xso->rmt_blocks, args.rmtblkno, args.rmtblkcnt);
+	if (error)
+		goto fail;
+
+	while (args.rmtblkcnt > 0) {
+		nmap = 1;
+		error = xfs_bmapi_read(args.dp, args.rmtblkno, args.rmtblkcnt,
+				&map, &nmap, XFS_BMAPI_ATTRFORK);
+		if (error || nmap != 1)
+			goto fail;
+
+		if (!xfs_bmap_is_real_extent(&map))
+			goto fail;
+
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
+		error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0, &bp,
+				&xfs_attr3_rmt_buf_ops);
+		if (error)
+			goto fail;
+
+		/*
+		 * Each rmt block within the buffer gets its own header, so
+		 * update the owner for each header.
+		 */
+		for (p = bp->b_addr;
+		     p < bp->b_addr + BBTOB(bp->b_length);
+		     p += mp->m_attr_geo->blksize) {
+			rmt = p;
+			rmt->rm_owner = cpu_to_be64(xso->sc->ip->i_ino);
+		}
+
+		xfs_buf_delwri_queue(bp, &buffer_list);
+		xfs_buf_relse(bp);
+
+		/* roll attribute extent map forwards */
+		args.rmtblkno += map.br_blockcount;
+		args.rmtblkcnt -= map.br_blockcount;
+	}
+
+	/* Write the entire remote value to disk. */
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error)
+		goto fail;
+
+	return;
+fail:
+	xfs_buf_delwri_cancel(&buffer_list);
+	context->seen_enough = 1;
+}
+
+/*
+ * Change the owner field of every block in the attribute fork to match the
+ * file being repaired.  First we fix the remote value blocks (which have
+ * particular incore geometries) and then change the rest one block at a time.
+ */
+STATIC int
+xrep_xattr_swap_leaf_owner(
+	struct xrep_xattr_swap_owner	*xso)
+{
+	struct xfs_bmbt_irec		map;
+	struct xfs_da_geometry		*geo = xso->sc->mp->m_attr_geo;
+	struct xfs_scrub		*sc = xso->sc;
+	struct xfs_da3_blkinfo		*info;
+	struct xfs_buf			*bp;
+	xfs_fileoff_t			offset = 0;
+	xfs_fileoff_t			end = -1U;
+	xfs_dablk_t			dabno;
+	int				nmap;
+	int				error;
+
+	for (offset = 0;
+	     offset < end;
+	     offset = map.br_startoff + map.br_blockcount) {
+		nmap = 1;
+		error = xfs_bmapi_read(sc->tempip, offset, end - offset,
+				&map, &nmap, XFS_BMAPI_ATTRFORK);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -EFSCORRUPTED;
+		if (!xfs_bmap_is_real_extent(&map)) {
+			continue;
+		}
+
+		if (xbitmap_test(&xso->rmt_blocks, map.br_startoff,
+				 &map.br_blockcount)) {
+			continue;
+		}
+
+		for (dabno = round_up(map.br_startoff, geo->fsbcount);
+		     dabno < map.br_startoff + map.br_blockcount;
+		     dabno += geo->fsbcount) {
+			error = xfs_da_read_buf(sc->tp, sc->tempip,
+					dabno, 0, &bp, XFS_ATTR_FORK, NULL);
+			if (error)
+				return error;
+			if (!bp)
+				return -EFSCORRUPTED;
+
+			info = bp->b_addr;
+			info->owner = cpu_to_be64(sc->ip->i_ino);
+
+			/* If nobody set a buffer type or ops, set them now. */
+			if (bp->b_ops == NULL) {
+				switch (info->hdr.magic) {
+				case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+					bp->b_ops = &xfs_attr3_leaf_buf_ops;
+					break;
+				case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+					bp->b_ops = &xfs_da3_node_buf_ops;
+					break;
+				default:
+					xfs_trans_brelse(sc->tp, bp);
+					return -EFSCORRUPTED;
+				}
+				xfs_buf_set_ref(bp, XFS_ATTR_BTREE_REF);
+			}
+
+			xfs_trans_ordered_buf(sc->tp, bp);
+			xfs_trans_brelse(sc->tp, bp);
+		}
+	}
+
+	return 0;
+}
+/*
+ * Walk the temporary file's xattr blocks, setting the owner field of each
+ * block to the new owner.  We use ordered and delwri buffers to flush
+ * everything out to disk ahead of comitting the atomic extent swap.  Rewriting
+ * the attr blocks like this is apparently safe because attr inactivation isn't
+ * picky about owner field enforcement(!)
+ */
+STATIC int
+xrep_xattr_swap_owner(
+	struct xfs_scrub		*sc)
+{
+	struct xrep_xattr_swap_owner	xso = {
+		.ctx.dp			= sc->tempip,
+		.ctx.resynch		= 1,
+		.ctx.put_listent	= xrep_xattr_swap_rmt_owner,
+		.ctx.allow_incomplete	= false,
+		.ctx.seen_enough	= 0,
+		.ctx.tp			= sc->tp,
+		.sc			= sc,
+	};
+	int				error;
+
+	xbitmap_init(&xso.rmt_blocks);
+
+	/* First pass -- change the owners of the remote blocks. */
+	error = xfs_attr_list_ilocked(&xso.ctx);
+	if (error)
+		goto out;
+	if (xso.ctx.seen_enough) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* Second pass -- change each attr leaf/node buffer. */
+	error = xrep_xattr_swap_leaf_owner(&xso);
+out:
+	xbitmap_destroy(&xso.rmt_blocks);
+	return error;
+}
+
+/*
+ * If both files' attribute structure are in short format, we can copy
+ * the short format data from the tempfile to the repaired file if it'll
+ * fit.
+ */
+STATIC void
+xrep_xattr_swap_local(
+	struct xfs_scrub	*sc,
+	int			newsize,
+	int			forkoff)
+{
+	struct xfs_ifork	*ifp1, *ifp2;
+
+	ifp1 = XFS_IFORK_PTR(sc->tempip, XFS_ATTR_FORK);
+	ifp2 = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+	sc->ip->i_d.di_forkoff = forkoff;
+
+	xfs_idata_realloc(sc->ip, ifp1->if_bytes - ifp2->if_bytes,
+			XFS_ATTR_FORK);
+
+	memcpy(ifp2->if_u1.if_data, ifp1->if_u1.if_data, newsize);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
+}
+
+/* Swap the temporary file's attribute fork with the one being repaired. */
+STATIC int
+xrep_xattr_swap(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	unsigned int		resblks;
+	bool			ip_local, temp_local;
+	int			error;
+
+	resblks = xfs_swap_range_calc_resblks(sc->tempip, sc->ip,
+			XFS_ATTR_FORK, XFS_MAX_FILEOFF);
+	error = xchk_trans_alloc(sc, max(1U, resblks));
+	if (error)
+		return error;
+
+	/*
+	 * Lock and join the inodes to the tansaction so that transaction commit
+	 * or cancel will unlock the inodes from this point onwards.
+	 */
+	xfs_lock_two_inodes(sc->ip, XFS_ILOCK_EXCL, sc->tempip,
+			XFS_ILOCK_EXCL);
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	ip_local = XFS_IFORK_FORMAT(sc->ip, XFS_ATTR_FORK) ==
+				XFS_DINODE_FMT_LOCAL;
+	temp_local = XFS_IFORK_FORMAT(sc->tempip, XFS_ATTR_FORK) ==
+				XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both files have a local format attr fork and the rebuilt
+	 * xattr data would fit in the repaired file's attr fork, just copy
+	 * the contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local) {
+		int	forkoff;
+		int	newsize;
+
+		newsize = XFS_ATTR_SF_TOTSIZE(sc->tempip);
+		forkoff = xfs_attr_shortform_bytesfit(sc->ip, newsize);
+		if (forkoff > 0) {
+			xrep_xattr_swap_local(sc, newsize, forkoff);
+			return 0;
+		}
+	}
+
+	/* Otherwise, make sure both attr forks are in block-mapping mode. */
+	error = xrep_xattr_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	/* Rewrite the owner field of all attr blocks in the temporary file. */
+	error = xrep_xattr_swap_owner(sc);
+	if (error)
+		return error;
+
+	return xfs_swapext_atomic(&sc->tp, sc->tempip, sc->ip, XFS_ATTR_FORK,
+			0, 0, NULLFILEOFF, XFS_SWAPEXT_TO_SHORTFORM2);
+}
+
+/*
+ * Insert into the tempfile all the attributes that we collected.
  *
  * Commit the repair transaction and drop the ilock because the attribute
  * setting code needs to be able to allocate special transactions and take the
- * ilock on its own.  Some day we'll have deferred attribute setting, at which
- * point we'll be able to use that to replace the attributes atomically and
- * safely.
+ * ilock on its own.  The attributes are added to the temporary file (which can
+ * be disposed of easily on failure).  If we finish rebuilding all of the
+ * salvageable attrs, we can then use atomic extent swapping to commit the
+ * new attr index to the file.
  */
 STATIC int
 xrep_xattr_rebuild_tree(
 	struct xrep_xattr	*rx)
 {
+	uint64_t		nr_attrs = xfbma_length(rx->xattr_records);
 	int			error;
 
+	/* Nothing to salvage?  Zap the attr fork and finish. */
+	if (nr_attrs == 0) {
+		xfs_trans_ijoin(rx->sc->tp, rx->sc->ip, 0);
+		return xrep_xattr_reset_fork(rx->sc, rx->sc->ip);
+	}
+
 	/*
 	 * Commit the repair transaction and drop the ILOCK so that we can
 	 * use individual transactions to re-add each extended attribute.
@@ -772,8 +1163,29 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Re-add every attr to the file. */
-	return xfbma_iter_del(rx->xattr_records, xrep_xattr_insert_rec, rx);
+	/* Add every attr to the tempfile. */
+	error = xfbma_iter_del(rx->xattr_records, xrep_xattr_insert_rec, rx);
+	if (error)
+		return error;
+
+	/* Swap the tempfile's attr fork with the file being repaired. */
+	error = xrep_xattr_swap(rx);
+	if (error)
+		return error;
+
+	/*
+	 * Now wipe out the attr fork of the temp file so that regular inode
+	 * inactivation won't trip over the corrupt attr fork.  We're done
+	 * with the inode that we want to repair, so roll the transaction and
+	 * drop its ILOCK before we tackle the temporary file.
+	 */
+	error = xfs_trans_roll_inode(&rx->sc->tp, rx->sc->tempip);
+	if (error)
+		return error;
+	xfs_iunlock(rx->sc->ip, XFS_ILOCK_EXCL);
+	rx->sc->ilock_flags &= ~XFS_ILOCK_EXCL;
+
+	return xrep_xattr_reset_fork(rx->sc, rx->sc->tempip);
 }
 
 /*
@@ -811,17 +1223,6 @@ xrep_xattr(
 	if (error)
 		goto out;
 
-	/*
-	 * Invalidate and truncate all attribute fork extents.  This is the
-	 * point at which we are no longer able to bail out gracefully.
-	 * We commit the transaction here because xfs_attr_set allocates its
-	 * own transactions.
-	 */
-	xfs_trans_ijoin(sc->tp, sc->ip, 0);
-	error = xrep_xattr_reset_fork(sc, sc->ip);
-	if (error)
-		goto out;
-
 	/* Now rebuild the attribute information. */
 	error = xrep_xattr_rebuild_tree(&rx);
 out:
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index a304a54997f9..25dfa1a4469e 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -382,3 +382,25 @@ xbitmap_count_set_regions(
 
 	return nr;
 }
+
+/* Is the start of the range set or clear?  And for how long? */
+bool
+xbitmap_test(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		*len)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		last = start + *len - 1;
+
+	bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return false;
+	if (bn->bn_start <= start) {
+		if (bn->bn_last < last)
+			*len = bn->bn_last - start + 1;
+		return true;
+	}
+	*len = bn->bn_start - start;
+	return false;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 33548004f111..deb39528691e 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -39,5 +39,6 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 
 bool xbitmap_empty(struct xbitmap *bitmap);
 uint64_t xbitmap_count_set_regions(struct xbitmap *bitmap);
+bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index de6d1747a3fa..6a833ea58d0e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1597,7 +1597,7 @@ xfs_bmap_count_range_blocks(
  * Compute the number of blocks we need to reserve to handle a log-assisted
  * extent swap operation.
  */
-static inline unsigned int
+unsigned int
 xfs_swap_range_calc_resblks(
 	struct xfs_inode	*ip1,
 	struct xfs_inode	*ip2,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index e0712c274dd2..1da6b4cdf0b4 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -81,4 +81,7 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
+unsigned int xfs_swap_range_calc_resblks(struct xfs_inode *ip1,
+		struct xfs_inode *ip2, int whichfork, xfs_filblks_t blockcount);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 306cf86c353d..03b736bc054c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3843,7 +3843,8 @@ DEFINE_NAMESPACE_EVENT(xfs_imeta_dir_zap);
 
 #define XFS_SWAPEXT_FLAGS \
 	{ XFS_SWAP_EXTENT_ATTR_FORK,		"ATTRFORK" }, \
-	{ XFS_SWAP_EXTENT_SET_SIZES,		"SETSIZES" }
+	{ XFS_SWAP_EXTENT_SET_SIZES,		"SETSIZES" }, \
+	{ XFS_SWAP_EXTENT_TO_SHORTFORM2,	"TO_SHORTFORM2" }
 
 TRACE_EVENT(xfs_swapext_defer,
 	TP_PROTO(struct xfs_mount *mp, const struct xfs_swapext_intent *sxi),

