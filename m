Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE35BC3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B490D206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kbTP28uw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEEBKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514jEk056553
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E20RC8jDHJ2yaeqwu8n0QgWVY0ztNJulQ0Htodn4ZFI=;
 b=kbTP28uwITpmgjSDUstaGvss932cLSBWZOBC4SzFudvJeoezq52/YWceIHga0eaAN/Pa
 9UNhMy4pmklMpdTk50jmb2eVRq4YiUZvok6KZGEZGz3KEYUgH4QR7DZjuIsQqrLNW0PN
 MJvHzF7TV8bVkMxjvOlThUx4uQUeqrAkNZsVFW9iK6KVkaPwB/ROa4rqWAiX7uP3T1+v
 +L7I4GWZobbUclZ1tWzp2ZOAOOV/c2oQE0TddkM+M1kc1F9aIbbHvH8WWn7WBOCB5GhS
 7++jnQY9D9vNlHLjuHTONToPBBCPAAuC3xUvppb/CGl3+VSwMGDoE57NJoloY764Arae Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1vgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515S6x145304
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30sjnckp8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:30 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451AUAV026021
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:30 -0700
Subject: [PATCH 3/3] xfs: actually account for quota changes in
 xfs_swap_extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:29 -0700
Message-ID: <158864102885.182577.15936710415441871446.stgit@magnolia>
In-Reply-To: <158864100980.182577.10199078041909350877.stgit@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, xfs_swap_extents neither checks for sufficient quota
reservation nor does it actually update quota counts when swapping the
extent forks.  While the primary known user of extent swapping (xfs_fsr)
is careful to ensure that the user/group/project ids of both files
match, this is not required by the kernel.  Consequently, unprivileged
userspace can cause the quota counts to be incorrect.

Fix this by updating quota counts when we swap the extents, and be sure
to make a quota reservation for the difference in blocks so that we can
bail out with EDQUOT early if needed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h |   13 +++--
 fs/xfs/xfs_bmap_util.c   |  125 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3259ad5c22c..463346caca46 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
 	{ BMAP_ATTRFORK,	"ATTR" }, \
 	{ BMAP_COWFORK,		"COW" }
 
+/* Return true if the extent is an allocated extent, written or not. */
+static inline bool xfs_bmap_is_mapped_extent(struct xfs_bmbt_irec *irec)
+{
+	return irec->br_startblock != HOLESTARTBLOCK &&
+		irec->br_startblock != DELAYSTARTBLOCK &&
+		!isnullstartblock(irec->br_startblock);
+}
 
 /*
  * Return true if the extent is a real, allocated extent, or false if it is  a
@@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  */
 static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
 {
-	return irec->br_state != XFS_EXT_UNWRITTEN &&
-		irec->br_startblock != HOLESTARTBLOCK &&
-		irec->br_startblock != DELAYSTARTBLOCK &&
-		!isnullstartblock(irec->br_startblock);
+	return xfs_bmap_is_mapped_extent(irec) &&
+	       irec->br_state != XFS_EXT_UNWRITTEN;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2774939e176d..bcac7530d1ac 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1358,6 +1358,8 @@ xfs_swap_extent_rmap(
 
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
+			int64_t		ip_delta = 0, tip_delta = 0;
+
 			ASSERT(tp->t_firstblock == NULLFSBLOCK);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
@@ -1388,6 +1390,23 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			/* Update quota accounting. */
+			if (xfs_bmap_is_mapped_extent(&irec)) {
+				tip_delta += irec.br_blockcount;
+				ip_delta -= irec.br_blockcount;
+			}
+			if (xfs_bmap_is_mapped_extent(&uirec)) {
+				tip_delta -= uirec.br_blockcount;
+				ip_delta += uirec.br_blockcount;
+			}
+
+			if (tip_delta)
+				xfs_trans_mod_dquot_byino(tp, tip,
+						XFS_TRANS_DQ_BCOUNT, tip_delta);
+			if (ip_delta)
+				xfs_trans_mod_dquot_byino(tp, ip,
+						XFS_TRANS_DQ_BCOUNT, ip_delta);
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
@@ -1435,6 +1454,7 @@ xfs_swap_extent_forks(
 {
 	xfs_filblks_t		aforkblks = 0;
 	xfs_filblks_t		taforkblks = 0;
+	int64_t			temp_blks;
 	xfs_extnum_t		junk;
 	uint64_t		tmp;
 	int			error;
@@ -1476,6 +1496,15 @@ xfs_swap_extent_forks(
 	 */
 	swap(ip->i_df, tip->i_df);
 
+	/* Update quota accounting. */
+	temp_blks = tip->i_d.di_nblocks - taforkblks + aforkblks;
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+			temp_blks - ip->i_d.di_nblocks);
+
+	temp_blks = ip->i_d.di_nblocks + taforkblks - aforkblks;
+	xfs_trans_mod_dquot_byino(tp, tip, XFS_TRANS_DQ_BCOUNT,
+			temp_blks - tip->i_d.di_nblocks);
+
 	/*
 	 * Fix the on-disk inode values
 	 */
@@ -1566,6 +1595,93 @@ xfs_swap_change_owner(
 	return error;
 }
 
+/*
+ * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
+ * this if quota enforcement is disabled or if both inodes' dquots are the
+ * same.
+ */
+STATIC int
+xfs_swap_extents_prep_quota(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_inode	*tip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		aforkblks = 0;
+	xfs_filblks_t		taforkblks = 0;
+	xfs_filblks_t		ip_mapped, tip_mapped;
+	xfs_extnum_t		junk;
+	int			error;
+
+	/*
+	 * Don't bother with a quota reservation if we're not enforcing them
+	 * or the two inodes have the same dquots.
+	 */
+	if (!(mp->m_qflags & XFS_ALL_QUOTA_ENFD) ||
+	    (ip->i_udquot == tip->i_udquot &&
+	     ip->i_gdquot == tip->i_gdquot &&
+	     ip->i_pdquot == tip->i_pdquot))
+		return 0;
+
+	/*
+	 * Count the number of extended attribute blocks
+	 */
+	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
+	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
+		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
+				&aforkblks);
+		if (error)
+			return error;
+	}
+	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
+	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
+		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
+				&taforkblks);
+		if (error)
+			return error;
+	}
+
+	/* Figure out how many blocks we'll move out of each file. */
+	ip_mapped = ip->i_d.di_nblocks - aforkblks;
+	tip_mapped = tip->i_d.di_nblocks - taforkblks;
+
+	/*
+	 * For each file, compute the net gain in the number of blocks that
+	 * will be mapped into that file and reserve that much quota.  The
+	 * quota counts must be able to absorb at least that much space.
+	 */
+	if (tip_mapped > ip_mapped) {
+		error = xfs_trans_reserve_quota_nblks(tp, ip,
+				tip_mapped - ip_mapped, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			return error;
+	}
+
+	if (ip_mapped > tip_mapped) {
+		error = xfs_trans_reserve_quota_nblks(tp, tip,
+				ip_mapped - tip_mapped, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * For each file, forcibly reserve the gross gain in mapped blocks so
+	 * that we don't trip over any quota block reservation assertions.
+	 * We must reserve the gross gain because the quota code subtracts from
+	 * bcount the number of blocks that we unmap; it does not add that
+	 * quantity back to the quota block reservation.
+	 */
+	error = xfs_trans_reserve_quota_nblks(tp, ip, ip_mapped, 0,
+			XFS_QMOPT_FORCE_RES | XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		return error;
+
+	return xfs_trans_reserve_quota_nblks(tp, tip, tip_mapped, 0,
+			XFS_QMOPT_FORCE_RES | XFS_QMOPT_RES_REGBLKS);
+}
+
 int
 xfs_swap_extents(
 	struct xfs_inode	*ip,	/* target inode */
@@ -1702,6 +1818,15 @@ xfs_swap_extents(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * Reserve ourselves some quota if any of them are in enforcing mode.
+	 * In theory we only need enough to satisfy the change in the number
+	 * of blocks between the two ranges being remapped.
+	 */
+	error = xfs_swap_extents_prep_quota(tp, ip, tip);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Note the trickiness in setting the log flags - we set the owner log
 	 * flag on the opposite inode (i.e. the inode we are setting the new

