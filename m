Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340C4C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC98620707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DYE9WCwy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgHaGHv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:07:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:07:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5rW5r018890;
        Mon, 31 Aug 2020 06:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9XxsuXSIKSPy3Lj4OUM4hWQzVPR/zxdaSkE/lAjtaKY=;
 b=DYE9WCwy+9tnKtD+QjONgCB5+IFr/vAWP1dzSDu070tjGIqDe4Ovj8juz9lpJZ5AyjqJ
 jngWotkAxqAXaitZbgZIAttqeSK/oKA95lyBWBpjarVH3cUSp5F4Lvqzrj9LQr6+vYOj
 CAYtyQkh6fRfGrAOclSgaThgyffyYxWg/36z76+m38UvQuin0Yg2ktARPlywayufV+Lw
 szg/Kg87y6/JdYi7xPdhn70iI/YyGGcg6DKmOvg8I8XELU9GAnQN1acpMQe5kf973qjj
 ied6/UctacpuK//CAUJlN+eKejhbE8O3ncpy1H2TnQvwQuyT1+KFkpJ8YfcHzQpc15Nu ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhbd9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:07:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5t7pq021291;
        Mon, 31 Aug 2020 06:07:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kk6vd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:07:37 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07V67aHl002773;
        Mon, 31 Aug 2020 06:07:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:07:36 -0700
Subject: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with y2038+
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:07:39 -0700
Message-ID: <159885405947.3608006.8484361543372730964.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=2 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redesign the ondisk inode timestamps to be a simple unsigned 64-bit
counter of nanoseconds since 14 Dec 1901 (i.e. the minimum time in the
32-bit unix time epoch).  This enables us to handle dates up to 2486,
which solves the y2038 problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      |   70 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_fs.h          |    1 +
 fs/xfs/libxfs/xfs_ialloc.c      |    4 ++
 fs/xfs/libxfs/xfs_inode_buf.c   |   40 ++++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.h   |   13 +++++++
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_shared.h      |    3 ++
 fs/xfs/libxfs/xfs_trans_inode.c |   16 +++++++++
 fs/xfs/scrub/inode.c            |   16 ++++++---
 fs/xfs/xfs_inode.c              |    4 +-
 fs/xfs/xfs_inode.h              |    5 +++
 fs/xfs/xfs_inode_item.c         |   12 ++++---
 fs/xfs/xfs_inode_item_recover.c |   19 ++++++++---
 fs/xfs/xfs_ioctl.c              |    3 +-
 fs/xfs/xfs_ondisk.h             |   13 +++++++
 fs/xfs/xfs_super.c              |   13 ++++++-
 16 files changed, 206 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d9b629f12c00..6aabe15786b8 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -467,6 +467,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -565,6 +566,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
+}
+
 /*
  * Inode btree block counter.  We record the number of inobt and finobt blocks
  * in the AGI header so that we can skip the finobt walk at mount time when
@@ -858,6 +865,13 @@ struct xfs_agfl {
  * Therefore, the ondisk min and max defined here can be used directly to
  * constrain the incore timestamps on a Unix system.  Note that we actually
  * encode a __be64 value on disk.
+ *
+ * When the bigtime feature is enabled, ondisk inode timestamps become an
+ * unsigned 64-bit nanoseconds counter.  This means that the bigtime inode
+ * timestamp epoch is the start of the classic timestamp range, which is
+ * Dec 31 20:45:52 UTC 1901.  Because the epochs are not the same, callers
+ * /must/ use the bigtime conversion functions when encoding and decoding raw
+ * timestamps.
  */
 typedef __be64 xfs_timestamp_t;
 
@@ -879,6 +893,50 @@ struct xfs_legacy_timestamp {
  */
 #define XFS_LEGACY_TIME_MAX	((int64_t)S32_MAX)
 
+/*
+ * Smallest possible ondisk seconds value with bigtime timestamps.  This
+ * corresponds (after conversion to a Unix timestamp) with the traditional
+ * minimum timestamp of Dec 13 20:45:52 UTC 1901.
+ */
+#define XFS_BIGTIME_TIME_MIN	((int64_t)0)
+
+/*
+ * Largest supported ondisk seconds value with bigtime timestamps.  This
+ * corresponds (after conversion to a Unix timestamp) with an incore timestamp
+ * of Jul  2 20:20:24 UTC 2486.
+ *
+ * We round down the ondisk limit so that the bigtime quota and inode max
+ * timestamps will be the same.
+ */
+#define XFS_BIGTIME_TIME_MAX	((int64_t)((-1ULL / NSEC_PER_SEC) & ~0x3ULL))
+
+/*
+ * Bigtime epoch is set exactly to the minimum time value that a traditional
+ * 32-bit timestamp can represent when using the Unix epoch as a reference.
+ * Hence the Unix epoch is at a fixed offset into the supported bigtime
+ * timestamp range.
+ *
+ * The bigtime epoch also matches the minimum value an on-disk 32-bit XFS
+ * timestamp can represent so we will not lose any fidelity in converting
+ * to/from unix and bigtime timestamps.
+ *
+ * The following conversion factor converts a seconds counter from the Unix
+ * epoch to the bigtime epoch.
+ */
+#define XFS_BIGTIME_EPOCH_OFFSET	(-(int64_t)S32_MIN)
+
+/* Convert a timestamp from the Unix epoch to the bigtime epoch. */
+static inline uint64_t xfs_unix_to_bigtime(time64_t unix_seconds)
+{
+	return (uint64_t)unix_seconds + XFS_BIGTIME_EPOCH_OFFSET;
+}
+
+/* Convert a timestamp from the bigtime epoch to the Unix epoch. */
+static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
+{
+	return (time64_t)ondisk_seconds - XFS_BIGTIME_EPOCH_OFFSET;
+}
+
 /*
  * On-disk inode structure.
  *
@@ -1104,12 +1162,22 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
+#define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
+#define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
 
 #define XFS_DIFLAG2_ANY \
-	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
+	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
+	 XFS_DIFLAG2_BIGTIME)
+
+static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
+}
 
 /*
  * Inode number format:
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 84bcffa87753..2a2e3cfd94f0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -249,6 +249,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	(1 << 18) /* sparse inode chunks   */
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fef1d94c60a4..938753ee96c8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2807,6 +2807,10 @@ xfs_ialloc_setup_geometry(
 	uint64_t		icount;
 	uint			inodes;
 
+	igeo->new_diflags2 = 0;
+	if (xfs_sb_version_hasbigtime(&mp->m_sb))
+		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
 	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 891d171c6e61..997a8ea96351 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,14 +157,29 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+static inline struct timespec64 xfs_inode_decode_bigtime(uint64_t ts)
+{
+	struct timespec64	tv;
+	uint32_t		n;
+
+	tv.tv_sec = xfs_bigtime_to_unix(div_u64_rem(ts, NSEC_PER_SEC, &n));
+	tv.tv_nsec = n;
+
+	return tv;
+}
+
 /* Convert an ondisk timestamp to an incore timestamp. */
 struct timespec64
 xfs_inode_from_disk_ts(
+	struct xfs_dinode		*dip,
 	const xfs_timestamp_t		ts)
 {
 	struct timespec64		tv;
 	struct xfs_legacy_timestamp	*lts;
 
+	if (xfs_dinode_has_bigtime(dip))
+		return xfs_inode_decode_bigtime(be64_to_cpu(ts));
+
 	lts = (struct xfs_legacy_timestamp *)&ts;
 	tv.tv_sec = (int64_t)be32_to_cpu(lts->t_sec);
 	tv.tv_nsec = (int)be32_to_cpu(lts->t_nsec);
@@ -226,9 +241,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime = xfs_inode_from_disk_ts(from->di_atime);
-	inode->i_mtime = xfs_inode_from_disk_ts(from->di_mtime);
-	inode->i_ctime = xfs_inode_from_disk_ts(from->di_ctime);
+	inode->i_atime = xfs_inode_from_disk_ts(from, from->di_atime);
+	inode->i_mtime = xfs_inode_from_disk_ts(from, from->di_mtime);
+	inode->i_ctime = xfs_inode_from_disk_ts(from, from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -241,7 +256,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime = xfs_inode_from_disk_ts(from->di_crtime);
+		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -266,11 +281,15 @@ xfs_inode_from_disk(
 /* Convert an incore timestamp to an ondisk timestamp. */
 static inline xfs_timestamp_t
 xfs_inode_to_disk_ts(
+	struct xfs_inode		*ip,
 	const struct timespec64		tv)
 {
 	struct xfs_legacy_timestamp	*lts;
 	xfs_timestamp_t			ts;
 
+	if (xfs_inode_has_bigtime(ip))
+		return cpu_to_be64(xfs_inode_encode_bigtime(tv));
+
 	lts = (struct xfs_legacy_timestamp *)&ts;
 	lts->t_sec = cpu_to_be32(tv.tv_sec);
 	lts->t_nsec = cpu_to_be32(tv.tv_nsec);
@@ -297,9 +316,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
-	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
-	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
+	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
+	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
+	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -318,7 +337,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
+		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
@@ -538,6 +557,11 @@ xfs_dinode_verify(
 	if (fa)
 		return fa;
 
+	/* bigtime iflag can only happen on bigtime filesystems */
+	if (xfs_dinode_has_bigtime(dip) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 3060ecd24a2e..ac374ecb7335 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -32,6 +32,11 @@ struct xfs_icdinode {
 	struct timespec64 di_crtime;	/* time created */
 };
 
+static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
+{
+	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
+}
+
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
@@ -58,6 +63,12 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
-struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
+static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
+{
+	return (xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC) + tv.tv_nsec;
+}
+
+struct timespec64 xfs_inode_from_disk_ts(struct xfs_dinode *dip,
+		const xfs_timestamp_t ts);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ae9aaf1f34bf..d5d60cd1c2ea 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1166,6 +1166,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
 	if (xfs_sb_version_hasreflink(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
+	if (xfs_sb_version_hasbigtime(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 708feb8eac76..c795ae47b3c9 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -176,6 +176,9 @@ struct xfs_ino_geometry {
 	unsigned int	ialloc_align;
 
 	unsigned int	agino_log;	/* #bits for agino in inum */
+
+	/* precomputed value for di_flags2 */
+	uint64_t	new_diflags2;
 };
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index e15129647e00..0ccb4a1f1cd1 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -73,6 +73,12 @@ xfs_trans_ichgtime(
 		ip->i_d.di_crtime = tv;
 }
 
+static inline bool xfs_inode_want_bigtime_upgrade(struct xfs_inode *ip)
+{
+	return xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
+	       !xfs_inode_has_bigtime(ip);
+}
+
 /*
  * This is called to mark the fields indicated in fieldmask as needing to be
  * logged when the transaction is committed.  The inode must already be
@@ -131,6 +137,16 @@ xfs_trans_log_inode(
 			iversion_flags = XFS_ILOG_CORE;
 	}
 
+	/*
+	 * If we're updating the inode core or the timestamps and it's possible
+	 * to upgrade this inode to bigtime format, do so now.
+	 */
+	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
+	    xfs_inode_want_bigtime_upgrade(ip)) {
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eb1cc013d4ca..3aa85b64de36 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -190,6 +190,11 @@ xchk_inode_flags2(
 	if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
 		goto bad;
 
+	/* no bigtime iflag without the bigtime feature */
+	if (xfs_dinode_has_bigtime(dip) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);
@@ -199,11 +204,12 @@ static inline void
 xchk_dinode_nsec(
 	struct xfs_scrub	*sc,
 	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
 	const xfs_timestamp_t	ts)
 {
 	struct timespec64	tv;
 
-	tv = xfs_inode_from_disk_ts(ts);
+	tv = xfs_inode_from_disk_ts(dip, ts);
 	if (tv.tv_nsec < 0 || tv.tv_nsec >= NSEC_PER_SEC)
 		xchk_ino_set_corrupt(sc, ino);
 }
@@ -306,9 +312,9 @@ xchk_dinode(
 	}
 
 	/* di_[amc]time.nsec */
-	xchk_dinode_nsec(sc, ino, dip->di_atime);
-	xchk_dinode_nsec(sc, ino, dip->di_mtime);
-	xchk_dinode_nsec(sc, ino, dip->di_ctime);
+	xchk_dinode_nsec(sc, ino, dip, dip->di_atime);
+	xchk_dinode_nsec(sc, ino, dip, dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, dip, dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -413,7 +419,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		xchk_dinode_nsec(sc, ino, dip->di_crtime);
+		xchk_dinode_nsec(sc, ino, dip, dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..bf5e8b85773e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -840,7 +840,7 @@ xfs_ialloc(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
@@ -2717,7 +2717,7 @@ xfs_ifree(
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
-	ip->i_d.di_flags2 = 0;
+	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e9a8bb184d1f..315908a352d3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -194,6 +194,11 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 	return ip->i_cowfp && ip->i_cowfp->if_bytes;
 }
 
+static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c1be13ca64b9..c59bc8aba14a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -301,11 +301,15 @@ xfs_inode_item_format_attr_fork(
  */
 static inline xfs_ictimestamp_t
 xfs_inode_to_log_dinode_ts(
+	struct xfs_inode		*ip,
 	const struct timespec64		tv)
 {
 	struct xfs_legacy_ictimestamp	*lits;
 	xfs_ictimestamp_t		its;
 
+	if (xfs_inode_has_bigtime(ip))
+		return xfs_inode_encode_bigtime(tv);
+
 	lits = (struct xfs_legacy_ictimestamp *)&its;
 	lits->t_sec = tv.tv_sec;
 	lits->t_nsec = tv.tv_nsec;
@@ -331,9 +335,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime = xfs_inode_to_log_dinode_ts(inode->i_atime);
-	to->di_mtime = xfs_inode_to_log_dinode_ts(inode->i_mtime);
-	to->di_ctime = xfs_inode_to_log_dinode_ts(inode->i_ctime);
+	to->di_atime = xfs_inode_to_log_dinode_ts(ip, inode->i_atime);
+	to->di_mtime = xfs_inode_to_log_dinode_ts(ip, inode->i_mtime);
+	to->di_ctime = xfs_inode_to_log_dinode_ts(ip, inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -355,7 +359,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime = xfs_inode_to_log_dinode_ts(from->di_crtime);
+		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 4e895c9ad4d7..cb44f7653f03 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -115,15 +115,25 @@ xfs_recover_inode_owner_change(
 	return error;
 }
 
+static inline bool xfs_log_dinode_has_bigtime(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_BIGTIME);
+}
+
 /* Convert a log timestamp to an ondisk timestamp. */
 static inline xfs_timestamp_t
 xfs_log_dinode_to_disk_ts(
+	struct xfs_log_dinode		*from,
 	const xfs_ictimestamp_t		its)
 {
 	struct xfs_legacy_timestamp	*lts;
 	struct xfs_legacy_ictimestamp	*lits;
 	xfs_timestamp_t			ts;
 
+	if (xfs_log_dinode_has_bigtime(from))
+		return cpu_to_be64(its);
+
 	lts = (struct xfs_legacy_timestamp *)&ts;
 	lits = (struct xfs_legacy_ictimestamp *)&its;
 	lts->t_sec = cpu_to_be32(lits->t_sec);
@@ -149,9 +159,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime = xfs_log_dinode_to_disk_ts(from->di_atime);
-	to->di_mtime = xfs_log_dinode_to_disk_ts(from->di_mtime);
-	to->di_ctime = xfs_log_dinode_to_disk_ts(from->di_ctime);
+	to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
+	to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
+	to->di_ctime = xfs_log_dinode_to_disk_ts(from, from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -167,7 +177,8 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime = xfs_log_dinode_to_disk_ts(from->di_crtime);
+		to->di_crtime = xfs_log_dinode_to_disk_ts(from,
+							  from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f22a66777cd..13396c3665d1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1190,7 +1190,8 @@ xfs_flags2diflags2(
 	unsigned int		xflags)
 {
 	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
+		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
+				      XFS_DIFLAG2_BIGTIME));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index cfa54d6b7c11..a9dbf21f13d8 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -15,6 +15,10 @@
 		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
 		"expected " #off)
 
+#define XFS_CHECK_VALUE(value, expected) \
+	BUILD_BUG_ON_MSG((value) != (expected), \
+		"XFS: value of " #value " is wrong, expected " #expected)
+
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
@@ -154,6 +158,15 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
+
+	/*
+	 * Make sure the incore inode timestamp range corresponds to hand
+	 * converted values based on the ondisk format specification.
+	 */
+	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
+			XFS_LEGACY_TIME_MIN);
+	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
+			16299260424LL);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b3b0e6154bf2..58be2220ae05 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1484,8 +1484,13 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = XFS_LEGACY_TIME_MIN;
-	sb->s_time_max = XFS_LEGACY_TIME_MAX;
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		sb->s_time_min = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MIN);
+		sb->s_time_max = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MAX);
+	} else {
+		sb->s_time_min = XFS_LEGACY_TIME_MIN;
+		sb->s_time_max = XFS_LEGACY_TIME_MAX;
+	}
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);
@@ -1494,6 +1499,10 @@ xfs_fc_fill_super(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		sb->s_flags |= SB_I_VERSION;
 
+	if (xfs_sb_version_hasbigtime(&mp->m_sb))
+		xfs_warn(mp,
+ "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
+
 	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 

