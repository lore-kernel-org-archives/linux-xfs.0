Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502BDC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC77206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bQGBL3UP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgAABRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E5G5092003
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Ol/PXeRWg2Czycf9bSnVlJuO8rB9pMjbB7wyDnvYSTY=;
 b=bQGBL3UP9Sowei0iTOd5IFDHJhkK8yP9ITi1o/WXyWOswmrii83yLgJSPIlhENkXc4K6
 Bp2aLoMj0mzrvUtl4PmDQ6NgvPvSPo4imeHgNqRIACkRL0QIKTHTaUz1Ub94xLINpyx0
 eWSl1VP8zqkhUv0AHY7cZK2qxm197ugfyTIHaogNHW+9xeYjwCx2eYIAeyAnFQ6xYGgG
 psZlD9DPA8jF5N5YCQwOXxwodm6mzv4WXzh50cTUk16SS17FvwFKu6IGSjqibFylMt0c
 en0fqNLe8izufKMFtZQpCNQWw0i4lESMYIDLLMi+KFXKvbH0/Q7y6QAzWzlDA5MUOPck ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118udw045294
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfgbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011HVgb002234
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:32 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:31 -0800
Subject: [PATCH 11/21] xfs: add realtime reverse map inode to superblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:29 -0800
Message-ID: <157784144907.1368137.8582010073406090393.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=897
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=961 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |    9 +++++++-
 fs/xfs/libxfs/xfs_imeta.c        |    2 ++
 fs/xfs/libxfs/xfs_imeta.h        |    1 +
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 +++++
 fs/xfs/libxfs/xfs_inode_fork.c   |    9 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    6 ++++-
 fs/xfs/xfs_inode.c               |    9 +++++++-
 fs/xfs/xfs_inode_item.c          |    2 ++
 fs/xfs/xfs_log_recover.c         |    1 +
 fs/xfs/xfs_mount.h               |    1 +
 fs/xfs/xfs_rtalloc.c             |   45 +++++++++++++++++++++++++++++++-------
 11 files changed, 80 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 779b178815dd..6a42c886ecd3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -591,6 +591,12 @@ static inline bool xfs_sb_version_hasmetadir(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
 }
 
+static inline bool xfs_sb_version_hasrtrmapbt(struct xfs_sb *sbp)
+{
+	return xfs_sb_version_hasmetadir(sbp) && sbp->sb_rblocks > 0 &&
+	       xfs_sb_version_hasrmapbt(sbp);
+}
+
 /*
  * end of superblock version macros
  */
@@ -1020,7 +1026,8 @@ enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 };
 
 #define XFS_INODE_FORMAT_STR \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 59193eb834ee..7c1faba3a741 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -57,12 +57,14 @@
 /* Static metadata inode paths */
 static const char *rtbitmap_path[]	= {"realtime", "0.bitmap"};
 static const char *rtsummary_path[]	= {"realtime", "0.summary"};
+static const char *rtrmapbt_path[]	= {"realtime", "0.rmap"};
 static const char *usrquota_path[]	= {"quota", "user"};
 static const char *grpquota_path[]	= {"quota", "group"};
 static const char *prjquota_path[]	= {"quota", "project"};
 
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTBITMAP,	rtbitmap_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTSUMMARY,	rtsummary_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTRMAPBT,	rtrmapbt_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 33024889fc71..7e183f7c2db3 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -33,6 +33,7 @@ struct xfs_imeta_end {
 /* Lookup keys for static metadata inodes. */
 extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
 extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
+extern const struct xfs_imeta_path XFS_IMETA_RTRMAPBT;
 extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6823e6eeec2c..189029cf3855 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -400,6 +400,12 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		}
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!xfs_sb_version_hasrtrmapbt(&mp->m_sb))
+			return __this_address;
+		if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b66d34c99787..4c99c532693c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -75,6 +75,11 @@ xfs_iformat_fork(
 		case XFS_DINODE_FMT_BTREE:
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
+		case XFS_DINODE_FMT_RMAP:
+			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb))
+				return -EFSCORRUPTED;
+			/* to be implemented later */
+			break;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -546,6 +551,10 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_RMAP:
+		/* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index b6a10926359c..992ebd9ed4d0 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -318,6 +318,7 @@ xfs_rtrmapbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
+	xfs_ino_t		ino = XFS_RMAP_OWN_UNKNOWN;
 	int			level;
 
 	if (block->bb_magic != cpu_to_be32(XFS_RTRMAP_CRC_MAGIC))
@@ -325,7 +326,9 @@ xfs_rtrmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return __this_address;
-	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (mp->m_rrmapip)
+		ino = mp->m_rrmapip->i_ino;
+	fa = xfs_btree_lblock_v5hdr_verify(bp, ino);
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
@@ -507,6 +510,7 @@ xfs_rtrmapbt_commit_staged_btree(
 	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(ifake->if_format == XFS_DINODE_FMT_RMAP);
 
 	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, XFS_DATA_FORK);
 	xfs_ifork_reset(ifp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b4bd82d86277..2af41d73bd8c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2876,7 +2876,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_d.di_format == XFS_DINODE_FMT_RMAP) {
+		if (mp->m_rrmapip && mp->m_rrmapip->i_ino != ip->i_ino) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt rmapbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto corrupt_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 168d53062fab..24c2ea2825be 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -47,6 +47,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -167,6 +168,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ba97c001d632..e966a7e569be 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3028,6 +3028,7 @@ xlog_recover_inode_pass2(
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, ldip,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2879031027c5..95ee6b898d3d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,6 +119,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_rrmapip;	/* pointer to rmap inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_inode	*m_metadirip;	/* metadata inode directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f0487e1c9cc1..0c5fe0c04307 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_imeta.h"
+#include "xfs_error.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1228,12 +1229,13 @@ xfs_rtmount_init(
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
  */
-int					/* error */
+int
 xfs_rtmount_inodes(
-	xfs_mount_t	*mp)		/* file system mount structure */
+	struct xfs_mount	*mp)
 {
-	int		error;		/* error return value */
-	xfs_sb_t	*sbp;
+	struct xfs_sb		*sbp;
+	xfs_ino_t		ino;
+	int			error;
 
 	sbp = &mp->m_sb;
 	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
@@ -1248,13 +1250,38 @@ xfs_rtmount_inodes(
 			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
-	if (error) {
-		xfs_imeta_irele(mp->m_rbmip);
-		return error;
-	}
+	if (error)
+		goto out_rbm;
 	ASSERT(mp->m_rsumip != NULL);
+
+	/* If we have rmap and a realtime device, look for the rtrmapbt. */
+	if (xfs_sb_version_hasrtrmapbt(&mp->m_sb)) {
+		error = xfs_imeta_lookup(mp, &XFS_IMETA_RTRMAPBT, &ino);
+		if (error)
+			goto out_rsum;
+
+		error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE,
+				&mp->m_rrmapip);
+		if (error)
+			goto out_rsum;
+
+		if (XFS_IS_CORRUPT(mp,
+				   mp->m_rrmapip->i_d.di_format !=
+				   XFS_DINODE_FMT_RMAP)) {
+			error = -EFSCORRUPTED;
+			goto out_rrmap;
+		}
+	}
+
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	return 0;
+out_rrmap:
+	xfs_imeta_irele(mp->m_rrmapip);
+out_rsum:
+	xfs_imeta_irele(mp->m_rsumip);
+out_rbm:
+	xfs_imeta_irele(mp->m_rbmip);
+	return error;
 }
 
 void
@@ -1262,6 +1289,8 @@ xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
 	kmem_free(mp->m_rsum_cache);
+	if (mp->m_rrmapip)
+		xfs_imeta_irele(mp->m_rrmapip);
 	if (mp->m_rbmip)
 		xfs_imeta_irele(mp->m_rbmip);
 	if (mp->m_rsumip)

