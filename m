Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63A7C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D839205ED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qKLNa48I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfLDREh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:04:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35364 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfLDREh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:04:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4H4YeU195489;
        Wed, 4 Dec 2019 17:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=S0gH1ndfdCFJCmTJpWO2fjjcXzwv/cbMPf6mnM+PQ/Y=;
 b=qKLNa48ILuzAXPrWfhJ6i+cp6TSE1AJFke5q+Bfo200Xe+szHTx07/zGgKfYATDL8zoo
 QKJVQpzO0YS2zRr2nrMOuVQnqNFbaLApBnTqQS/MuVwIb2YXkgW1f2agDOdSXVDcZE1I
 AjSP976FpqnYSvBkjyKP/1CsDoB7u9xXYC3uYjPFqon+2mRGIIEq8tMi840YxIsHnMIB
 pZ60tIO+dzK4ubp5siWwxDueMQkOi2fhtUgu1NSlp+HAdwvEQ8GWThcvEW57sVFW++03
 2YoNdZwY5x+qBeVvN8wU0jrVY/thdpcCZD3o31k/5F35U2Gy8pHGdMYZyo+ItbuJg+V7 lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wkh2rfm1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GwrIB167250;
        Wed, 4 Dec 2019 17:04:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wp20cpy7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:04:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB4H4US5004890;
        Wed, 4 Dec 2019 17:04:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:04:30 -0800
Subject: [PATCH 1/6] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Wed, 04 Dec 2019 09:04:29 -0800
Message-ID: <157547906943.974712.12407327608486006790.stgit@magnolia>
In-Reply-To: <157547906289.974712.8933333382010386076.stgit@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port the computation code from xfs_repair and teach mount to avoid the
ondisk update if it would cause problems for repair.  We allow the mount
to proceed (and new allocations will reflect this new geometry) because
we've never screened this kind of thing before.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.h |    1 +
 2 files changed, 82 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f039b287..1d56d764 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2848,3 +2848,84 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/*
+ * Compute the location of the root directory inode that is laid out by mkfs.
+ * The @sunit parameter will be copied from the superblock if it is negative.
+ */
+xfs_ino_t
+xfs_ialloc_calc_rootino(
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agino_t		first_agino;
+	xfs_agblock_t		first_bno;
+
+	if (sunit < 0)
+		sunit = mp->m_sb.sb_unit;
+
+	/*
+	 * Pre-calculate the geometry of ag 0. We know what it looks like
+	 * because we know what mkfs does: 2 allocation btree roots (by block
+	 * and by size), the inode allocation btree root, the free inode
+	 * allocation btree root (if enabled) and some number of blocks to
+	 * prefill the agfl.
+	 *
+	 * Because the current shape of the btrees may differ from the current
+	 * shape, we open code the mkfs freelist block count here. mkfs creates
+	 * single level trees, so the calculation is pretty straight forward for
+	 * the trees that use the AGFL.
+	 */
+
+	/* free space by block btree root comes after the ag headers */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* free space by length btree root */
+	first_bno += 1;
+
+	/* inode btree root */
+	first_bno += 1;
+
+	/* agfl */
+	first_bno += (2 * min_t(xfs_agblock_t, 2, mp->m_ag_maxlevels)) + 1;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		first_bno++;
+		/* agfl blocks */
+		first_bno += min_t(xfs_agblock_t, 2, mp->m_rmap_maxlevels);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * If the log is allocated in the first allocation group we need to
+	 * add the number of blocks used by the log to the above calculation.
+	 *
+	 * This can happens with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+		 first_bno += mp->m_sb.sb_logblocks;
+
+	/*
+	 * ditto the location of the first inode chunks in the fs ('/')
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
+		first_agino = XFS_AGB_TO_AGINO(mp, roundup(first_bno, sunit));
+	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+		   mp->m_sb.sb_inoalignmt > 1)  {
+		first_agino = XFS_AGB_TO_AGINO(mp,
+				roundup(first_bno, mp->m_sb.sb_inoalignmt));
+	} else  {
+		first_agino = XFS_AGB_TO_AGINO(mp, first_bno);
+	}
+
+	return XFS_AGINO_TO_INO(mp, 0, first_agino);
+}
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 323592d5..72b3468b 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */

