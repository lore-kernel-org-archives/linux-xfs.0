Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9787DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56035206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bDCWHZYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAABQq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:16:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57224 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:16:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E8bw112531
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nWLfDkaghjlX4RctBZeR7hWPJgMqiARHSJ0tn/JKgAI=;
 b=bDCWHZYn1Uv3y8d+mwtkndNtQQc7Ogo37jmTyztN8OibTIjB3VJhM6UFwQVoW73SEJvM
 aUgbGn1ydEpNNJXiINhFkUSOpuuxi1ZIa6mLZBiCK1bqvC+RO59KU4qeff87Y6Dnt82N
 525yK80/FXV+VM3pXm1//pg7PgIpf5wiyCgrP+QN/+EPEJ4PITovX/sc7pyljCE+KZaf
 oCVDD/dkAhZ93Qp+ragPStPEkDjVlUXIMiM5+lLISJQmqaWLxLOX4ELkX0TFIufSOvw0
 8W2LyhA76Mmdrnr0RWGjNpZ5rXkzr1zyDc3bCKsmfRFMr5DdOTe0ZP5EC5hw1Uemdn5G ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vXF172094
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj91atf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011Gf2T001809
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:41 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:41 -0800
Subject: [PATCH 03/21] xfs: widen xfs_rmap_irec fields to handle realtime
 rmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:16:38 -0800
Message-ID: <157784139871.1368137.13166326523641835965.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the startblock and blockcount fields of xfs_rmap_irec to be 64
bits wide.  This enables us to use the same high level rmap code for
either tree.  We'll also collect all the resulting breakage fixes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h   |    4 +-
 fs/xfs/libxfs/xfs_refcount.c |    6 +--
 fs/xfs/libxfs/xfs_rmap.c     |   81 +++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_rmap.h     |   36 +++++++++----------
 fs/xfs/scrub/alloc_repair.c  |    6 +--
 fs/xfs/xfs_trace.h           |   38 ++++++++++----------
 6 files changed, 84 insertions(+), 87 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b610338de5b0..8b3975dedd7f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1582,8 +1582,8 @@ struct xfs_rmap_rec {
 					 XFS_RMAP_BMBT_BLOCK)
 #define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
 struct xfs_rmap_irec {
-	xfs_agblock_t	rm_startblock;	/* extent start block */
-	xfs_extlen_t	rm_blockcount;	/* extent length */
+	xfs_fsblock_t	rm_startblock;	/* extent start block */
+	xfs_filblks_t	rm_blockcount;	/* extent length */
 	uint64_t	rm_owner;	/* extent owner */
 	uint64_t	rm_offset;	/* offset within the owner */
 	unsigned int	rm_flags;	/* state flags */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index af597f4496ab..e761b796170e 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1663,8 +1663,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1680,8 +1679,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index c0c2c4acb61e..8f81151a063e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -30,8 +30,8 @@
 int
 xfs_rmap_lookup_le(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -52,8 +52,8 @@ xfs_rmap_lookup_le(
 int
 xfs_rmap_lookup_eq(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -99,8 +99,8 @@ xfs_rmap_update(
 int
 xfs_rmap_insert(
 	struct xfs_btree_cur	*rcur,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		agbno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -143,8 +143,8 @@ xfs_rmap_insert(
 STATIC int
 xfs_rmap_delete(
 	struct xfs_btree_cur	*rcur,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		agbno,
+	xfs_filblks_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -212,6 +212,9 @@ xfs_rmap_get_rec(
 	union xfs_btree_rec	*rec;
 	int			error;
 
+	if (cur->bc_btnum != XFS_BTNUM_RMAP)
+		goto out_bad_rec;
+
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
 		return error;
@@ -249,7 +252,7 @@ xfs_rmap_get_rec(
 		"Reverse Mapping BTree record corruption in AG %d detected!",
 		agno);
 	xfs_warn(mp,
-		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
+		"Owner 0x%llx, flags 0x%x, start block 0x%llx block count 0x%llx",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
 	xfs_btree_mark_sick(cur);
@@ -296,7 +299,7 @@ xfs_rmap_find_left_neighbor_helper(
 int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -374,7 +377,7 @@ xfs_rmap_lookup_le_range_helper(
 int
 xfs_rmap_lookup_le_range(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		bno,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags,
@@ -496,8 +499,8 @@ xfs_rmap_free_check_owner(
 STATIC int
 xfs_rmap_unmap(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -670,7 +673,7 @@ xfs_rmap_unmap(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
@@ -774,8 +777,8 @@ xfs_rmap_is_mergeable(
 STATIC int
 xfs_rmap_map(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1016,8 +1019,8 @@ xfs_rmap_alloc(
 STATIC int
 xfs_rmap_convert(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1536,8 +1539,8 @@ xfs_rmap_convert(
 STATIC int
 xfs_rmap_convert_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -1972,8 +1975,8 @@ xfs_rmap_convert_shared(
 STATIC int
 xfs_rmap_unmap_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -2119,7 +2122,7 @@ xfs_rmap_unmap_shared(
 		 * Result:  |rrrrr|         |rrrr|
 		 *               bno       len
 		 */
-		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+		xfs_filblks_t	orig_len = ltrec.rm_blockcount;
 
 		/* Shrink the left side of the rmap */
 		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
@@ -2167,8 +2170,8 @@ xfs_rmap_unmap_shared(
 STATIC int
 xfs_rmap_map_shared(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	bool				unwritten,
 	const struct xfs_owner_info	*oinfo)
 {
@@ -2443,7 +2446,7 @@ xfs_rmap_finish_one(
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
-	xfs_agblock_t			bno;
+	xfs_fsblock_t			bno;
 	bool				unwritten;
 
 	agno = XFS_FSB_TO_AGNO(mp, startblock);
@@ -2631,9 +2634,8 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2641,7 +2643,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2653,9 +2655,8 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		len,
 	uint64_t		owner)
 {
 	struct xfs_bmbt_irec	bmap;
@@ -2663,7 +2664,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2703,8 +2704,8 @@ xfs_rmap_compare(
 int
 xfs_rmap_has_record(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
 	bool			*exists)
 {
 	union xfs_btree_irec	low;
@@ -2728,8 +2729,8 @@ xfs_rmap_has_record(
 int
 xfs_rmap_record_exists(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	bool				*has_rmap)
 {
@@ -2796,8 +2797,8 @@ xfs_rmap_has_other_keys_helper(
 int
 xfs_rmap_has_other_keys(
 	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	bool				*has_rmap)
 {
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index e756989d0da5..c187f1a678dd 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -119,14 +119,14 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  const struct xfs_owner_info *oinfo);
 
-int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
-int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
-int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_agblock_t agbno,
-		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_fsblock_t agbno,
+		xfs_filblks_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags);
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
@@ -169,10 +169,10 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, uint64_t owner);
+void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
@@ -181,10 +181,10 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
-int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
-int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
@@ -192,13 +192,13 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(struct xfs_btree_cur *cur, union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
-int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
-int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
-int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index c098715f704e..ec04bbe14120 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -407,10 +407,8 @@ xrep_abt_dispose_reservations(
 	for_each_xrep_newbt_reservation(&ra->new_bnobt_info, resv, n) {
 		/* Add a deferred rmap for each extent we used. */
 		if (resv->used > 0)
-			xfs_rmap_alloc_extent(sc->tp,
-					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
-					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
-					resv->used, XFS_RMAP_OWN_AG);
+			xfs_rmap_alloc_extent(sc->tp, resv->fsbno, resv->used,
+					XFS_RMAP_OWN_AG);
 
 		/*
 		 * Add a deferred free for each block we didn't use and now
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6ed9139b1463..36361e7bcb04 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2403,14 +2403,14 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo),
+	TP_ARGS(mp, agno, bno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
 		__field(unsigned long, flags)
@@ -2418,7 +2418,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2426,10 +2426,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno %d bno %llu len %llu owner %lld offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->bno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2438,9 +2438,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
+	TP_ARGS(mp, agno, bno, len, unwritten, oinfo))
 
 /* simple AG-based error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_ag_error_class,
@@ -2459,7 +2459,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %pS",
+	TP_printk("dev %d:%d agno %d error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2485,14 +2485,14 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_fsblock_t bno, xfs_filblks_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+	TP_ARGS(mp, agno, bno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
 		__field(unsigned int, flags)
@@ -2500,16 +2500,16 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->agbno = agbno;
+		__entry->bno = bno;
 		__entry->len = len;
 		__entry->owner = owner;
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno %d bno %llu len %llu owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->bno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2518,9 +2518,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
+	TP_ARGS(mp, agno, bno, len, owner, offset, flags))
 
 #define DEFINE_RMAP_DEFERRED_EVENT DEFINE_MAP_EXTENT_DEFERRED_EVENT
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);

