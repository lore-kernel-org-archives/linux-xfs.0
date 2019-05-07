Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfEGPr6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 11:47:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47FXkLi099171
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 15:47:57 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2s94bfxawt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 15:47:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Fl2sC040082
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 15:47:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s9ayey7my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 15:47:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x47FltDq010604
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 15:47:55 GMT
Date: Tue, 7 May 2019 08:47:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't reserve per-AG space for an internal log
Message-ID: <20190507154754.GU5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

It turns out that the log can consume nearly all the space in an AG, and
when this happens this it's possible that there will be less free space
in the AG than the reservation would try to hide.  On a debug kernel
this can trigger an ASSERT in xfs/250:

XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 319

The log is permanently allocated, so we know we're never going to have
to expand the btrees to hold any records associated with the log space.
We therefore can treat the space as if it doesn't exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    9 +++++++++
 fs/xfs/libxfs/xfs_refcount_btree.c |    9 +++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c     |    9 +++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 1080381ff243..bc2dfacd2f4a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -549,6 +549,15 @@ xfs_inobt_max_size(
 	if (mp->m_inobt_mxr[0] == 0)
 		return 0;
 
+	/*
+	 * The log is permanently allocated, so the space it occupies will
+	 * never be available for the kinds of things that would require btree
+	 * expansion.  We therefore can pretend the space isn't there.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+		agblocks -= mp->m_sb.sb_logblocks;
+
 	return xfs_btree_calc_size(mp->m_inobt_mnr,
 				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
 					XFS_INODES_PER_CHUNK);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 6f47ab876d90..5d9de9b21726 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -427,6 +427,15 @@ xfs_refcountbt_calc_reserves(
 	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
 	xfs_trans_brelse(tp, agbp);
 
+	/*
+	 * The log is permanently allocated, so the space it occupies will
+	 * never be available for the kinds of things that would require btree
+	 * expansion.  We therefore can pretend the space isn't there.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+		agblocks -= mp->m_sb.sb_logblocks;
+
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
 	*used += tree_len;
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 5738e11055e6..5d1f8884c888 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -578,6 +578,15 @@ xfs_rmapbt_calc_reserves(
 	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
 	xfs_trans_brelse(tp, agbp);
 
+	/*
+	 * The log is permanently allocated, so the space it occupies will
+	 * never be available for the kinds of things that would require btree
+	 * expansion.  We therefore can pretend the space isn't there.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+		agblocks -= mp->m_sb.sb_logblocks;
+
 	/* Reserve 1% of the AG or enough for 1 block per record. */
 	*ask += max(agblocks / 100, xfs_rmapbt_max_size(mp, agblocks));
 	*used += tree_len;
