Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E223C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFD2620809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dcIFPVNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407127AbgJZXgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407121AbgJZXgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP028157929;
        Mon, 26 Oct 2020 23:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n4RJBMSqDEU1q1h6RYXSGPl1mrI4tLeb1nhaq6x5hEs=;
 b=dcIFPVNKM+e3uPRQyUJvwKghE7CTvCFFcp+/Z5+2x6HFCrUrlifKkwtIl5X4TKLevRlE
 MEW6eAanaO/NZ1DveoSpMe+GjPEoFiagquSVrjjlHeRkn+IwV4pG6BmUccPT1PEBv15f
 6czA0aSIHyOmFRew4ypuLNxP3YP66z/Abfwo1MvP4zc9qZIKzTQvgVXgnZ8JQFl+zgzl
 Z7cJx6eoiuexwQwHAkefIRtCwb/e0zashRXqjSVHBmRbcbjZl6xxFxdU7mjzkz5tV/BN
 /Ssj80FgsEUWwyTu1lDgnBqygCs/B/CYU3IKyy9/k+MVf9QGGMXzWoKoDoy+/bpeyGh0 pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNkE058374;
        Mon, 26 Oct 2020 23:35:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwukr98m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNZqnx006201;
        Mon, 26 Oct 2020 23:35:52 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:51 -0700
Subject: [PATCH 16/26] xfs: widen ondisk inode timestamps to deal with y2038+
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:50 -0700
Message-ID: <160375535063.881414.15265400787138494976.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: f93e5436f0ee5a85eaa3a86d2614d215873fb18b

Redesign the ondisk inode timestamps to be a simple unsigned 64-bit
counter of nanoseconds since 14 Dec 1901 (i.e. the minimum time in the
32-bit unix time epoch).  This enables us to handle dates up to 2486,
which solves the y2038 problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fprint.c              |    4 +--
 include/xfs_inode.h      |    5 +++
 libxfs/xfs_format.h      |   70 +++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_fs.h          |    1 +
 libxfs/xfs_ialloc.c      |    4 +++
 libxfs/xfs_inode_buf.c   |   40 +++++++++++++++++++++-----
 libxfs/xfs_inode_buf.h   |   13 ++++++++-
 libxfs/xfs_sb.c          |    2 +
 libxfs/xfs_shared.h      |    3 ++
 libxfs/xfs_trans_inode.c |   11 +++++++
 10 files changed, 141 insertions(+), 12 deletions(-)


diff --git a/db/fprint.c b/db/fprint.c
index 1e8a7b49efe6..7ceab29cc608 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -138,7 +138,7 @@ fp_time(
 			dbprintf("%d:", i + base);
 
 		ts = obj + byteize(bitpos);
-		tv = libxfs_inode_from_disk_ts(*ts);
+		tv = libxfs_inode_from_disk_ts(obj, *ts);
 		t = tv.tv_sec;
 
 		c = ctime(&t);
@@ -174,7 +174,7 @@ fp_nsec(
 			dbprintf("%d:", i + base);
 
 		ts = obj + byteize(bitpos);
-		tv = libxfs_inode_from_disk_ts(*ts);
+		tv = libxfs_inode_from_disk_ts(obj, *ts);
 
 		dbprintf("%u", tv.tv_nsec);
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 12676cb30bf2..40310df6a785 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -140,6 +140,11 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ca11a3eb56dd..dbc7008e4498 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 84bcffa87753..2a2e3cfd94f0 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -249,6 +249,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	(1 << 18) /* sparse inode chunks   */
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8adeb10e5d2e..d78f960c6d44 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2802,6 +2802,10 @@ xfs_ialloc_setup_geometry(
 	uint64_t		icount;
 	uint			inodes;
 
+	igeo->new_diflags2 = 0;
+	if (xfs_sb_version_hasbigtime(&mp->m_sb))
+		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
 	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 1b9f63ebe9f9..6722d5afddac 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -154,14 +154,29 @@ xfs_imap_to_bp(
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
 	tv.tv_sec = (int)be32_to_cpu(lts->t_sec);
 	tv.tv_nsec = (int)be32_to_cpu(lts->t_nsec);
@@ -223,9 +238,9 @@ xfs_inode_from_disk(
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
@@ -238,7 +253,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime = xfs_inode_from_disk_ts(from->di_crtime);
+		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -263,11 +278,15 @@ xfs_inode_from_disk(
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
@@ -294,9 +313,9 @@ xfs_inode_to_disk(
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
@@ -315,7 +334,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
+		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
@@ -535,6 +554,11 @@ xfs_dinode_verify(
 	if (fa)
 		return fa;
 
+	/* bigtime iflag can only happen on bigtime filesystems */
+	if (xfs_dinode_has_bigtime(dip) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 3060ecd24a2e..536666143fe7 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
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
+	return xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC + tv.tv_nsec;
+}
+
+struct timespec64 xfs_inode_from_disk_ts(struct xfs_dinode *dip,
+		const xfs_timestamp_t ts);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7c7e56a8979c..fb2212b89912 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1143,6 +1143,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
 	if (xfs_sb_version_hasreflink(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
+	if (xfs_sb_version_hasbigtime(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 708feb8eac76..c795ae47b3c9 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -176,6 +176,9 @@ struct xfs_ino_geometry {
 	unsigned int	ialloc_align;
 
 	unsigned int	agino_log;	/* #bits for agino in inum */
+
+	/* precomputed value for di_flags2 */
+	uint64_t	new_diflags2;
 };
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index a392fd293d25..66dadd8716ee 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -128,6 +128,17 @@ xfs_trans_log_inode(
 			iversion_flags = XFS_ILOG_CORE;
 	}
 
+	/*
+	 * If we're updating the inode core or the timestamps and it's possible
+	 * to upgrade this inode to bigtime format, do so now.
+	 */
+	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
+	    xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
+	    !xfs_inode_has_bigtime(ip)) {
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp

