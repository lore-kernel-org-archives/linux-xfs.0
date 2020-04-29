Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D1BC83001
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66EF02073E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mvu2+btv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgD2Cqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 22:46:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgD2Cqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 22:46:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2ha3E121509
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=80FcyABMUDnw0Ir9b2fsosl5qdQV3SDgzLRcwf85W8g=;
 b=mvu2+btvtV5m5IkxfaU8Ascl1uUdL5bVNO2evt+rvesVWkUWCog0nLlkwMsDKq8qtlfq
 NqluzOqWmUR+YfAb3IVHpch7mCdJUQzCbT3dAS2uwqM478rSJm5WPcay9BkPbrKZoyjB
 ut4v/aVfm45hIO9/thUcoNqIdWnj7ecFJDmzaRbtZau8vDBrp1E6Jw0HCnZJzJDJ7e+/
 WZodYYBRLQ/qlbBsjsyj3M2nM+IegixL5o6PBQG5tcAEICGopgo9XWNqsIhe9upOL9dP
 Ddi+ht94RdQBcJJRKKUjsl4jVjgeWDbYHtc9Bhs4UCFQaeifsWNFHGAYjrqUTR0QD0w8 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p08p59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2g3OY039232
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30mxru06kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03T2kmF9016532
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 19:46:47 -0700
Subject: [PATCH 5/5] xfs: use atomic extent swapping to repair directories
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Apr 2020 19:46:45 -0700
Message-ID: <158812840567.169849.10189780953079405106.stgit@magnolia>
In-Reply-To: <158812837421.169849.625434931406278072.stgit@magnolia>
References: <158812837421.169849.625434931406278072.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When repairing a directory online, stage the new directory contents in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.  As a side effect of this patch, directory
inactivation will be able to purge any leftover dir blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_swapext.c |   34 ++++
 fs/xfs/scrub/dir.c          |   12 +
 fs/xfs/scrub/dir_repair.c   |  415 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.c          |   49 +++++
 4 files changed, 488 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index f16f7d9a0b66..afdc516428bd 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -23,6 +23,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_dir2_priv.h"
 
 /* Information to help us reset reflink flag / CoW fork state after a swap. */
 
@@ -233,6 +234,37 @@ xfs_swapext_attr_to_shortform2(
 	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
 }
 
+/* Convert inode2's block dir fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_dir_to_shortform2(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->si_ip2,
+		.geo		= tp->t_mountp->m_dir_geo,
+		.whichfork	= XFS_DATA_FORK,
+		.trans		= tp,
+	};
+	struct xfs_dir2_sf_hdr	sfh;
+	struct xfs_buf		*bp;
+	int			size;
+	int			error;
+
+	if (!xfs_bmap_one_block(sxi->si_ip2, XFS_DATA_FORK))
+		return 0;
+
+	error = xfs_dir3_block_read(tp, sxi->si_ip2, &bp);
+	if (error)
+		return error;
+
+	size = xfs_dir2_block_sfsize(sxi->si_ip2, bp->b_addr, &sfh);
+	if (size > XFS_IFORK_DSIZE(sxi->si_ip2))
+		return 0;
+
+	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
+}
+
 #define XFS_SWAP_EXTENT_POST_PROCESSING (XFS_SWAP_EXTENT_TO_SHORTFORM2)
 
 /* Do we have more work to do to finish this operation? */
@@ -265,6 +297,8 @@ xfs_swapext_finish_one(
 		if (sxi->si_flags & XFS_SWAP_EXTENT_TO_SHORTFORM2) {
 			if (sxi->si_flags & XFS_SWAP_EXTENT_ATTR_FORK)
 				error = xfs_swapext_attr_to_shortform2(tp, sxi);
+			else if (S_ISDIR(VFS_I(sxi->si_ip2)->i_mode))
+				error = xfs_swapext_dir_to_shortform2(tp, sxi);
 			sxi->si_flags &= ~XFS_SWAP_EXTENT_TO_SHORTFORM2;
 			return error;
 		}
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e318dd46cb15..948b7440e591 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -18,6 +18,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub directories. */
 int
@@ -28,6 +29,17 @@ xchk_setup_directory(
 	unsigned int		sz;
 	int			error;
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		if (!xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
+			return -EOPNOTSUPP;
+
+		error = xrep_create_tempfile(sc, S_IFDIR);
+		if (error)
+			return error;
+	}
+#endif
+
 	if (sc->flags & XCHK_TRY_HARDER) {
 		error = xchk_fs_freeze(sc);
 		if (error)
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index b299f8b35ce4..3004505c55a9 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -25,6 +25,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_iwalk.h"
+#include "xfs_swapext.h"
+#include "xfs_bmap_util.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -78,6 +80,9 @@ struct xrep_dir {
 	 * found a good candidate.
 	 */
 	xfs_ino_t		parent_ino;
+
+	/* nlink value of the corrected directory. */
+	xfs_nlink_t		new_nlink;
 };
 
 /*
@@ -523,7 +528,6 @@ xrep_dir_reset_fork(
 	dp->i_d.di_size = 0;
 
 	/* Reinitialize the short form directory. */
-	set_nlink(VFS_I(dp), 2);
 	args->geo = sc->mp->m_dir_geo;
 	args->dp = dp;
 	args->trans = sc->tp;
@@ -610,10 +614,10 @@ xrep_dir_insert_rec(
 	if (error)
 		return error;
 
-	trace_xrep_dir_insert_rec(rd->sc->ip, namebuf, key->namelen, key->ino,
-			key->ftype);
+	trace_xrep_dir_insert_rec(rd->sc->tempip, namebuf, key->namelen,
+			key->ino, key->ftype);
 
-	error = xfs_qm_dqattach(rd->sc->ip);
+	error = xfs_qm_dqattach(rd->sc->tempip);
 	if (error)
 		return error;
 
@@ -626,18 +630,19 @@ xrep_dir_insert_rec(
 	if (error)
 		return error;
 
-	xfs_ilock(rd->sc->ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, rd->sc->ip, XFS_ILOCK_EXCL);
+	xfs_ilock(rd->sc->tempip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, rd->sc->tempip, XFS_ILOCK_EXCL);
 
 	name.len = key->namelen;
 	name.type = key->ftype;
-	error = xfs_dir_createname(tp, rd->sc->ip, &name, key->ino, resblks);
+	error = xfs_dir_createname(tp, rd->sc->tempip, &name, key->ino,
+			resblks);
 	if (error)
 		goto err;
 
 	if (name.type == XFS_DIR3_FT_DIR)
-		inc_nlink(VFS_I(rd->sc->ip));
-	xfs_trans_log_inode(tp, rd->sc->ip, XFS_ILOG_CORE);
+		rd->new_nlink++;
+	xfs_trans_log_inode(tp, rd->sc->tempip, XFS_ILOG_CORE);
 	return xfs_trans_commit(tp);
 
 err:
@@ -645,6 +650,356 @@ xrep_dir_insert_rec(
 	return error;
 }
 
+/*
+ * Prepare both inodes' directory forks for extent swapping.  Promote the
+ * tempfile from short format to leaf format, and if the file being repaired
+ * has a short format attr fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_dir_swap_prep(
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
+		struct xfs_da_args	args = {
+			.dp		= sc->tempip,
+			.geo		= sc->mp->m_dir_geo,
+			.whichfork	= XFS_DATA_FORK,
+			.trans		= sc->tp,
+			.total		= 1,
+		};
+
+		error = xfs_dir2_sf_to_block(&args);
+		if (error)
+			return error;
+
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
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
+		sc->ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		sc->ip->i_d.di_nextents = 0;
+
+		ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+		xfs_ifork_reset(ifp);
+		ifp->if_bytes = 0;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+		ifp->if_flags |= XFS_IFEXTENTS;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_DDATA);
+	}
+
+	return 0;
+}
+
+/*
+ * Set the owner for this directory block to the directory being repaired.
+ * Return the magic number that we found, or the usual negative error.
+ */
+STATIC int
+xrep_dir_reset_owner(
+	struct xfs_scrub		*sc,
+	xfs_dablk_t			dabno,
+	struct xfs_buf			*bp,
+	unsigned int			*magic)
+{
+	struct xfs_da_geometry		*geo = sc->mp->m_dir_geo;
+	struct xfs_dir3_data_hdr	*data3 = bp->b_addr;
+	struct xfs_da3_blkinfo		*info3 = bp->b_addr;
+	struct xfs_dir3_free_hdr	*free3 = bp->b_addr;
+	struct xfs_dir2_data_entry	*dep;
+
+	/* Directory data blocks. */
+	if (dabno < geo->leafblk) {
+		*magic = be32_to_cpu(data3->hdr.magic);
+		if (*magic != XFS_DIR3_BLOCK_MAGIC &&
+		    *magic != XFS_DIR3_DATA_MAGIC)
+			return -EFSCORRUPTED;
+
+		/*
+		 * If this is a block format directory, it's possible that the
+		 * block was created as part of converting the temp directory
+		 * from short format to block format in order to use the atomic
+		 * extent swap.  In that case, the '.' entry will be set to
+		 * the temp dir, so find the dot entry and reset it.
+		 */
+		if (*magic == XFS_DIR3_BLOCK_MAGIC) {
+			dep = bp->b_addr + geo->data_entry_offset;
+			if (dep->namelen != 1 || dep->name[0] != '.')
+				return -EFSCORRUPTED;
+
+			dep->inumber = cpu_to_be64(sc->ip->i_ino);
+		}
+
+		data3->hdr.owner = be64_to_cpu(sc->ip->i_ino);
+		return 0;
+	}
+
+	/* Directory leaf and da node blocks. */
+	if (dabno < geo->freeblk) {
+		*magic = be16_to_cpu(info3->hdr.magic);
+		switch (*magic) {
+		case XFS_DA3_NODE_MAGIC:
+		case XFS_DIR3_LEAF1_MAGIC:
+		case XFS_DIR3_LEAFN_MAGIC:
+			break;
+		default:
+			return -EFSCORRUPTED;
+		}
+
+		info3->owner = be64_to_cpu(sc->ip->i_ino);
+		return 0;
+	}
+
+	/* Directory free blocks. */
+	*magic = be32_to_cpu(free3->hdr.magic);
+	if (*magic != XFS_DIR3_FREE_MAGIC)
+		return -EFSCORRUPTED;
+
+	free3->hdr.owner = be64_to_cpu(sc->ip->i_ino);
+	return 0;
+}
+
+/*
+ * If the buffer didn't have buffer ops set, we need to set them now that we've
+ * dirtied the directory block.
+ */
+STATIC void
+xrep_dir_set_verifier(
+	unsigned int		magic,
+	struct xfs_buf		*bp)
+{
+	switch (magic) {
+	case XFS_DIR3_BLOCK_MAGIC:
+		bp->b_ops = &xfs_dir3_block_buf_ops;
+		break;
+	case XFS_DIR3_DATA_MAGIC:
+		bp->b_ops = &xfs_dir3_data_buf_ops;
+		break;
+	case XFS_DA3_NODE_MAGIC:
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		break;
+	case XFS_DIR3_LEAF1_MAGIC:
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+		break;
+	case XFS_DIR3_LEAFN_MAGIC:
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		break;
+	case XFS_DIR3_FREE_MAGIC:
+		bp->b_ops = &xfs_dir3_free_buf_ops;
+		break;
+	}
+
+	xfs_buf_set_ref(bp, XFS_DIR_BTREE_REF);
+}
+
+/*
+ * Change the owner field of every block in the data fork to match the
+ * directory being repaired.
+ */
+STATIC int
+xrep_dir_swap_owner(
+	struct xfs_scrub		*sc)
+{
+	struct xfs_bmbt_irec		map;
+	struct xfs_da_geometry		*geo = sc->mp->m_dir_geo;
+	struct xfs_buf			*bp;
+	xfs_fileoff_t			offset = 0;
+	xfs_fileoff_t			end = XFS_MAX_FILEOFF;
+	xfs_dablk_t			dabno;
+	int				nmap;
+	int				error;
+
+	for (offset = 0;
+	     offset < end;
+	     offset = map.br_startoff + map.br_blockcount) {
+		nmap = 1;
+		error = xfs_bmapi_read(sc->tempip, offset, end - offset,
+				&map, &nmap, 0);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -EFSCORRUPTED;
+		if (!xfs_bmap_is_real_extent(&map))
+			continue;
+
+
+		for (dabno = round_up(map.br_startoff, geo->fsbcount);
+		     dabno < map.br_startoff + map.br_blockcount;
+		     dabno += geo->fsbcount) {
+			unsigned int	magic;
+
+			error = xfs_da_read_buf(sc->tp, sc->tempip,
+					dabno, 0, &bp, XFS_DATA_FORK, NULL);
+			if (error)
+				return error;
+			if (!bp)
+				return -EFSCORRUPTED;
+
+			error = xrep_dir_reset_owner(sc, dabno, bp, &magic);
+			if (error) {
+				xfs_trans_brelse(sc->tp, bp);
+				return error;
+			}
+
+			if (bp->b_ops == NULL)
+				xrep_dir_set_verifier(magic, bp);
+
+			xfs_trans_ordered_buf(sc->tp, bp);
+			xfs_trans_brelse(sc->tp, bp);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * If both files' directory structure are in short format, we can copy
+ * the short format data from the tempfile to the repaired file if it'll
+ * fit.
+ */
+STATIC void
+xrep_dir_swap_local(
+	struct xfs_scrub	*sc,
+	int			newsize)
+{
+	struct xfs_ifork	*ifp1, *ifp2;
+
+	ifp1 = XFS_IFORK_PTR(sc->tempip, XFS_DATA_FORK);
+	ifp2 = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+
+	xfs_idata_realloc(sc->ip, ifp2->if_bytes - ifp1->if_bytes,
+			XFS_DATA_FORK);
+
+	memcpy(ifp2->if_u1.if_data, ifp1->if_u1.if_data, newsize);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE | XFS_ILOG_DDATA);
+}
+
+struct xfs_name xfs_name_dot = { (unsigned char *)".", 1, XFS_DIR3_FT_DIR };
+
+/* Swap the temporary directory's data fork with the one being repaired. */
+STATIC int
+xrep_dir_swap(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	unsigned int		resblks;
+	bool			ip_local, temp_local;
+	int			error;
+
+	resblks = xfs_swap_range_calc_resblks(sc->tempip, sc->ip,
+			XFS_DATA_FORK, XFS_MAX_FILEOFF);
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
+	/*
+	 * Reset the temporary directory's '.' entry to point to the directory
+	 * we're repairing.  Note: shortform directories lack the dot entry.
+	 *
+	 * It's possible that this replacement could also expand a sf tempdir
+	 * into block format.
+	 */
+	if (XFS_IFORK_FORMAT(sc->tempip, XFS_DATA_FORK) !=
+			XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir_replace(sc->tp, sc->tempip, &xfs_name_dot,
+				sc->ip->i_ino, resblks);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Reset the temporary directory's '..' entry to point to the parent
+	 * that we found.  The temporary directory was created with the root
+	 * directory as the parent, so we can skip this if repairing a
+	 * subdirectory of the root.
+	 *
+	 * It's also possible that this replacement could also expand a sf
+	 * tempdir into block format.
+	 */
+	if (rd->parent_ino != sc->mp->m_rootip->i_ino) {
+		error = xfs_dir_replace(sc->tp, rd->sc->tempip,
+				&xfs_name_dotdot, rd->parent_ino, resblks);
+		if (error)
+			return error;
+	}
+
+	/* XXX: do we need to roll the transaction here? */
+
+	/*
+	 * Changing the dot and dotdot entries could have changed the shape of
+	 * the directory, so we recompute these.
+	 */
+	ip_local = XFS_IFORK_FORMAT(sc->ip, XFS_DATA_FORK) ==
+				XFS_DINODE_FMT_LOCAL;
+	temp_local = XFS_IFORK_FORMAT(sc->tempip, XFS_DATA_FORK) ==
+				XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both files have a local format data fork and the rebuilt
+	 * directory data would fit in the repaired file's data fork, copy
+	 * the contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local) {
+		if (sc->tempip->i_d.di_size <= XFS_IFORK_DSIZE(sc->ip)) {
+			xrep_dir_swap_local(sc, sc->tempip->i_d.di_size);
+			set_nlink(VFS_I(sc->ip), rd->new_nlink);
+			return 0;
+		}
+	}
+
+	/* Otherwise, make sure both data forks are in block-mapping mode. */
+	error = xrep_dir_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	/* Rewrite the owner field of all attr blocks in the temporary file. */
+	error = xrep_dir_swap_owner(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Set nlink of the directory under repair to the number of
+	 * subdirectories that will be in the new directory data.  Do this in
+	 * the same transaction sequence that (atomically) commits the new
+	 * data.
+	 */
+	set_nlink(VFS_I(sc->ip), rd->new_nlink);
+
+	return xfs_swapext_atomic(&sc->tp, sc->tempip, sc->ip, XFS_DATA_FORK,
+			0, 0, NULLFILEOFF,
+			XFS_SWAPEXT_SET_SIZES | XFS_SWAPEXT_TO_SHORTFORM2);
+}
+
 /*
  * Insert all the attributes that we collected.
  *
@@ -669,6 +1024,10 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	/*
+	 * Drop the ILOCK so that we don't pin the tail of the log.  We still
+	 * hold the IOLOCK (aka i_rwsem) which will prevent directory access.
+	 */
 	xfs_iunlock(rd->sc->ip, XFS_ILOCK_EXCL);
 	rd->sc->ilock_flags &= ~XFS_ILOCK_EXCL;
 
@@ -680,8 +1039,30 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Re-add every entry to the directory. */
-	return xfbma_iter_del(rd->dir_entries, xrep_dir_insert_rec, rd);
+	/* Re-add every entry to the temporary directory. */
+	error = xfbma_iter_del(rd->dir_entries, xrep_dir_insert_rec, rd);
+	if (error)
+		return error;
+
+	/* Swap the tempdir's data fork with the file being repaired. */
+	error = xrep_dir_swap(rd);
+	if (error)
+		return error;
+
+	/*
+	 * Now reset the data fork of the temp directory to an empty shortform
+	 * directory because inactivation does nothing for directories.  We're
+	 * done with the inode that we want to repair, so roll the transaction
+	 * and drop its ILOCK before we tackle the temporary file.
+	 */
+	error = xfs_trans_roll_inode(&rd->sc->tp, rd->sc->tempip);
+	if (error)
+		return error;
+	xfs_iunlock(rd->sc->ip, XFS_ILOCK_EXCL);
+	rd->sc->ilock_flags &= ~XFS_ILOCK_EXCL;
+
+	return xrep_dir_reset_fork(rd->sc, rd->sc->tempip,
+			rd->sc->mp->m_rootip->i_ino);
 }
 
 /*
@@ -821,6 +1202,7 @@ xrep_dir(
 	struct xrep_dir		rd = {
 		.sc		= sc,
 		.parent_ino	= NULLFSINO,
+		.new_nlink	= 2,
 	};
 	int			error;
 
@@ -860,17 +1242,6 @@ xrep_dir(
 	if (error)
 		goto out;
 
-	/*
-	 * Invalidate and truncate all data fork extents.  This is the point at
-	 * which we are no longer able to bail out gracefully.  We commit the
-	 * transaction here because the rebuilding step allocates its own
-	 * transactions.
-	 */
-	xfs_trans_ijoin(sc->tp, sc->ip, 0);
-	error = xrep_dir_reset_fork(sc, sc->ip, rd.parent_ino);
-	if (error)
-		goto out;
-
 	/* Now rebuild the directory information. */
 	error = xrep_dir_rebuild_tree(&rd);
 out:
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 080c8838fba5..301fb9afbfde 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -17,6 +17,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_attr.h"
+#include "xfs_bit.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -1292,6 +1293,49 @@ xfs_release(
 	return 0;
 }
 
+/*
+ * Mark all the buffers attached to this directory stale.  In theory we should
+ * never be freeing a directory with any blocks at all, but this covers the
+ * case where we've recovered a directory swap with a "temporary" directory
+ * created by online repair and now need to dump it.
+ */
+STATIC void
+xfs_inactive_dir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_buf		*bp;
+	xfs_fileoff_t		off;
+
+	/*
+	 * Invalidate each directory block.  All directory blocks are of
+	 * fsbcount length and alignment, so we only need to walk those same
+	 * offsets.  We hold the only reference to this inode, so we must wait
+	 * for the buffer locks.
+	 */
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for (off = round_up(got.br_startoff, geo->fsbcount);
+		     off < got.br_startoff + got.br_blockcount;
+		     off += geo->fsbcount) {
+			xfs_fsblock_t	fsbno;
+
+			fsbno = (off - got.br_startoff) + got.br_startblock;
+			bp = xfs_buf_incore(mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, geo->fsbcount),
+					XBF_SCAN_STALE);
+			if (bp) {
+				xfs_buf_stale(bp);
+				xfs_buf_relse(bp);
+			}
+		}
+	}
+}
+
 /*
  * xfs_inactive_truncate
  *
@@ -1694,6 +1738,11 @@ xfs_inactive(
 	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) && ip->i_d.di_nextents > 0) {
+		xfs_inactive_dir(ip);
+		truncate = 1;
+	}
+
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)

