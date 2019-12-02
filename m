Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932F0C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BAFE20848
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUKT71Kb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfLBRfo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:35:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfLBRfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:35:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZMsF035981;
        Mon, 2 Dec 2019 17:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=XgONUt7gY+5X3Ur+rCARrJu4GadwboFNEwhR6NDTouE=;
 b=LUKT71KbLBIzpUvAEQn9LZSMCwZlqP9pX+pBANC8+rnh/1D4VZuwgWAeQUto20cAPrb0
 wsYaaIi1yzBgYw61agTR8SguyYW+Y1x4AERXVMlDtFsFTaLd7Lo1MOXDj6pBcT4/Nrvy
 Db3GhWeMmjJBaMP/grSkJrFJ7rKRRNlNjYSJKUk5/KeN3szq0g8gE7QyQbMgEq6u3brO
 4FmTGPzCYBjsmcGaT6yJZkVjJmh74khq3Idmd7pk0aMfzJ3L2yWxrS5NCE/dFa2siiPD
 uqE2mNTd5A92/Zs1jaqgVxHRqMp/iAUU7S8UUfSErQSWMH0JOnmIBNjmSkRmsGDdxeBz /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wkh2r1he7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:35:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYOU9102589;
        Mon, 2 Dec 2019 17:35:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wm2jw9xnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:35:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2HZebw010394;
        Mon, 2 Dec 2019 17:35:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:35:39 -0800
Date:   Mon, 2 Dec 2019 09:35:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Alex Lyakas <alex@zadara.com>
Subject: [RFC PATCH] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
Message-ID: <20191202173538.GD7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
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
 fs/xfs/libxfs/xfs_ialloc.c |   88 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    2 +
 fs/xfs/xfs_ioctl.c         |    3 ++
 fs/xfs/xfs_ioctl32.c       |    4 ++
 fs/xfs/xfs_mount.c         |   47 +++++++++++++++++-------
 5 files changed, 130 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 988cde7744e6..51fbf0cb3255 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2909,3 +2909,91 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/*
+ * Compute the first and last inodes numbers of the inode chunk that was
+ * preallocated for the root directory.
+ */
+void
+xfs_ialloc_find_prealloc(
+	struct xfs_mount	*mp,
+	xfs_agino_t		*first_agino,
+	xfs_agino_t		*last_agino)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
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
+	 * single level trees, so the calculation is pertty straight forward for
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
+	first_bno += (2 * min(2U, mp->m_ag_maxlevels)) + 1;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		first_bno += min(2U, mp->m_rmap_maxlevels); /* agfl blocks */
+		first_bno++;
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
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
+
+		/*
+		 * XXX(hch): verify that sb_logstart makes sense?
+		 */
+		 first_bno += mp->m_sb.sb_logblocks;
+	}
+
+	/*
+	 * ditto the location of the first inode chunks in the fs ('/')
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
+		*first_agino = XFS_AGB_TO_AGINO(mp,
+				roundup(first_bno, mp->m_sb.sb_unit));
+	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+		   mp->m_sb.sb_inoalignmt > 1)  {
+		*first_agino = XFS_AGB_TO_AGINO(mp,
+				roundup(first_bno, mp->m_sb.sb_inoalignmt));
+	} else  {
+		*first_agino = XFS_AGB_TO_AGINO(mp, first_bno);
+	}
+
+	ASSERT(igeo->ialloc_blks > 0);
+
+	if (igeo->ialloc_blks > 1)
+		*last_agino = *first_agino + XFS_INODES_PER_CHUNK;
+	else
+		*last_agino = XFS_AGB_TO_AGINO(mp, first_bno + 1);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..9d9fe7b488b8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
+		xfs_agino_t *last_agino);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b35d62ede9f..d830a9e13817 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -891,6 +891,9 @@ xfs_ioc_fsgeometry(
 
 	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
 
+	fsgeo.sunit = mp->m_sb.sb_unit;
+	fsgeo.swidth = mp->m_sb.sb_width;
+
 	if (struct_version <= 3)
 		len = sizeof(struct xfs_fsop_geom_v1);
 	else if (struct_version == 4)
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4c4f09113d3..7e9009d26628 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -51,6 +51,10 @@ xfs_compat_ioc_fsgeometry_v1(
 	struct xfs_fsop_geom	  fsgeo;
 
 	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
+
+	fsgeo.sunit = mp->m_sb.sb_unit;
+	fsgeo.swidth = mp->m_sb.sb_width;
+
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -EFAULT;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fca65109cf24..0323a89256c7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -368,6 +368,11 @@ xfs_update_alignment(xfs_mount_t *mp)
 	xfs_sb_t	*sbp = &(mp->m_sb);
 
 	if (mp->m_dalign) {
+		uint32_t	old_su;
+		uint32_t	old_sw;
+		xfs_agino_t	first;
+		xfs_agino_t	last;
+
 		/*
 		 * If stripe unit and stripe width are not multiples
 		 * of the fs blocksize turn off alignment.
@@ -398,24 +403,38 @@ xfs_update_alignment(xfs_mount_t *mp)
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
+		old_su = sbp->sb_unit;
+		old_sw = sbp->sb_width;
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		xfs_ialloc_find_prealloc(mp, &first, &last);
+
+		/*
+		 * If the sunit/swidth change would move the precomputed root
+		 * inode value, we must reject the ondisk change because repair
+		 * will stumble over that.  However, we allow the mount to
+		 * proceed because we never rejected this combination before.
+		 */
+		if (sbp->sb_rootino != XFS_AGINO_TO_INO(mp, 0, first)) {
+			sbp->sb_unit = old_su;
+			sbp->sb_width = old_sw;
+			xfs_warn(mp,
+	"cannot change alignment: would require moving root inode");
+			return 0;
+		}
+
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
 			mp->m_dalign = sbp->sb_unit;
