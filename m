Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E81C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400BE205ED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gr+x/lbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfLDRDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:03:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfLDRDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:03:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GxEBs002062;
        Wed, 4 Dec 2019 17:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Q8AaAjxmehpaySgDi7gLK1PKTlXP6vCpzTwHLCj71Ck=;
 b=Gr+x/lbzzUFsTCXVxyv1UicYabpeA5rmRkUXdFpbvnt7Z8t4u5OaA1p27ZWy3LKp+RDc
 cuSrTCum0SSxddsHastAfOV2siyX1UI652mX6B2FIiGn3H0gvWTtv/1IeZ8KCrUCIiJu
 HRWfUDi0RPwLTceoNycaseRd+fx2jKurtaPDzpbgU8AIHGzCd8SsUjs7xugoKSH7bIwV
 OlS6hViZDuzzO0qwRklQDYEgpsVPsM4cqnHJKOub4bjaooyb7as1uyKeGZ+MMwSfdA+T
 gS8maMXXFtZIoxUPsxAxGPacu7Cp78zXAYoKa8BaeBNDJLxgSeutYrToHI5GoCyT33gG 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcqfprt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:03:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4GwHFl076579;
        Wed, 4 Dec 2019 17:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wp16b7630-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 17:03:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB4H3guO012928;
        Wed, 4 Dec 2019 17:03:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 09:03:41 -0800
Date:   Wed, 4 Dec 2019 09:03:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Alex Lyakas <alex@zadara.com>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't commit sunit/swidth updates to disk if that would
 cause repair failures
Message-ID: <20191204170340.GR7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
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
 definitions=main-1912040137
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
v2: compute the root inode location directly
---
 fs/xfs/libxfs/xfs_ialloc.c |   81 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    1 +
 fs/xfs/xfs_mount.c         |   51 ++++++++++++++++++----------
 3 files changed, 115 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 988cde7744e6..6df9bcc96251 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2909,3 +2909,84 @@ xfs_ialloc_setup_geometry(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..72b3468b97b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fca65109cf24..a4eb3ae34a84 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -363,9 +363,10 @@ xfs_readsb(
  * Update alignment values based on mount options and sb values
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_update_alignment(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb		*sbp = &mp->m_sb;
 
 	if (mp->m_dalign) {
 		/*
@@ -398,28 +399,42 @@ xfs_update_alignment(xfs_mount_t *mp)
 			}
 		}
 
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
-		} else {
+		/* Update superblock with new values and log changes. */
+		if (!xfs_sb_version_hasdalign(sbp)) {
 			xfs_warn(mp,
 	"cannot change alignment: superblock does not support data alignment");
 			return -EINVAL;
 		}
+
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		/*
+		 * If the sunit/swidth change would move the precomputed root
+		 * inode value, we must reject the ondisk change because repair
+		 * will stumble over that.  However, we allow the mount to
+		 * proceed because we never rejected this combination before.
+		 */
+		if (sbp->sb_rootino !=
+		    xfs_ialloc_calc_rootino(mp, mp->m_dalign)) {
+			xfs_warn(mp,
+	"cannot change stripe alignment: would require moving root inode");
+
+			/*
+			 * XXX: Next time we add a new incompat feature, this
+			 * should start returning -EINVAL.
+			 */
+			return 0;
+		}
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
