Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0941C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22BC2065D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZva3wH6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHQW5t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:57:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHQW5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:57:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvAUF136210;
        Mon, 17 Aug 2020 22:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZeWVuONoMTgt4E04Uov/+jsyqkd21jpNctL3so9WElw=;
 b=nZva3wH6CWNKrhlVk1sVjbXD8oMsJFbiomUcG/bhk3sqDp8wZz78v9qz5kGN82RKj5rJ
 nNi75Muou6et7VvOZqPagiVxWf6z+rSgs5Npns7Of6hcmrH3LUJvIhzhnG6BN1wf5Y7B
 kA4j0uBSMVUXqKAh+34kJ9wSQ3DcHIngAlHBBJFtQp686DyLCjWHhxtBhAuy7DGsCZ7K
 6NQQqG36tzHJ3as3SnnDWpwL0O2vUkY1f6753fTuNChTmcsrkSeHj0YdUs2X6UnvTNp5
 nJ6ECfa2LUYWBk+Gz5YNwfkCTpZhV/qZFNn5nnbRomKhs4axQhAMdqKUr3onoUeynNNF mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn1fun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:57:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMm7YY101660;
        Mon, 17 Aug 2020 22:57:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9m9y39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:57:40 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMve3D024740;
        Mon, 17 Aug 2020 22:57:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:57:39 -0700
Subject: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:57:39 -0700
Message-ID: <159770505894.3956827.5973810026298120596.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=3 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=3 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
time epoch).  This enables us to handle dates up to 2486, which solves
the y2038 problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |   38 +++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_fs.h         |    1 +
 fs/xfs/libxfs/xfs_inode_buf.c  |   54 ++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_buf.h  |    8 +++---
 fs/xfs/libxfs/xfs_log_format.h |    3 ++
 fs/xfs/libxfs/xfs_sb.c         |    2 +
 fs/xfs/scrub/inode.c           |   16 ++++++++----
 fs/xfs/xfs_inode.c             |   11 ++++++++
 fs/xfs/xfs_inode_item.c        |   35 ++++++++++++++++++++------
 fs/xfs/xfs_ioctl.c             |    3 +-
 fs/xfs/xfs_ondisk.h            |    3 ++
 fs/xfs/xfs_super.c             |   13 ++++++++--
 12 files changed, 158 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 772113db41aa..57343973e5e5 100644
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
@@ -855,12 +862,18 @@ struct xfs_agfl {
  *
  * Inode timestamps consist of signed 32-bit counters for seconds and
  * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
+ *
+ * When bigtime is enabled, timestamps become an unsigned 64-bit nanoseconds
+ * counter.  Time zero is the start of the classic timestamp range.
  */
 union xfs_timestamp {
 	struct {
 		__be32		t_sec;		/* timestamp seconds */
 		__be32		t_nsec;		/* timestamp nanoseconds */
 	};
+
+	/* Nanoseconds since the bigtime epoch. */
+	__be64			t_bigtime;
 };
 
 /*
@@ -875,6 +888,25 @@ union xfs_timestamp {
  */
 #define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
 
+/*
+ * Number of seconds between the start of the bigtime timestamp range and the
+ * start of the Unix epoch.
+ */
+#define XFS_INO_BIGTIME_EPOCH	(-XFS_INO_TIME_MIN)
+
+/*
+ * Smallest possible timestamp with big timestamps, which is
+ * Dec 13 20:45:52 UTC 1901.
+ */
+#define XFS_INO_BIGTIME_MIN	(XFS_INO_TIME_MIN)
+
+/*
+ * Largest possible timestamp with big timestamps, which is
+ * Jul  2 20:20:25 UTC 2486.
+ */
+#define XFS_INO_BIGTIME_MAX	((int64_t)((-1ULL / NSEC_PER_SEC) - \
+					   XFS_INO_BIGTIME_EPOCH))
+
 /*
  * On-disk inode structure.
  *
@@ -1100,12 +1132,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cc1316a5fe0c..c59ddb56bb90 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,11 +157,25 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+/* Convert an ondisk timestamp into the 64-bit safe incore format. */
 void
 xfs_inode_from_disk_timestamp(
+	struct xfs_dinode		*dip,
 	struct timespec64		*tv,
 	const union xfs_timestamp	*ts)
 {
+	if (dip->di_version >= 3 &&
+	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
+		uint64_t		t = be64_to_cpu(ts->t_bigtime);
+		uint64_t		s;
+		uint32_t		n;
+
+		s = div_u64_rem(t, NSEC_PER_SEC, &n);
+		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
+		tv->tv_nsec = n;
+		return;
+	}
+
 	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
 	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
 }
@@ -220,9 +234,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
-	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
-	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
+	xfs_inode_from_disk_timestamp(from, &inode->i_atime, &from->di_atime);
+	xfs_inode_from_disk_timestamp(from, &inode->i_mtime, &from->di_mtime);
+	xfs_inode_from_disk_timestamp(from, &inode->i_ctime, &from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -235,9 +249,17 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
+		xfs_inode_from_disk_timestamp(from, &to->di_crtime,
+				&from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
+		/*
+		 * Set the bigtime flag incore so that we automatically convert
+		 * this inode's ondisk timestamps to bigtime format the next
+		 * time we write the inode core to disk.
+		 */
+		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
+			to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
 	}
 
 	error = xfs_iformat_data_fork(ip, from);
@@ -259,9 +281,19 @@ xfs_inode_from_disk(
 
 void
 xfs_inode_to_disk_timestamp(
+	struct xfs_icdinode		*from,
 	union xfs_timestamp		*ts,
 	const struct timespec64		*tv)
 {
+	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
+		uint64_t		t;
+
+		t = (uint64_t)(tv->tv_sec + XFS_INO_BIGTIME_EPOCH);
+		t *= NSEC_PER_SEC;
+		ts->t_bigtime = cpu_to_be64(t + tv->tv_nsec);
+		return;
+	}
+
 	ts->t_sec = cpu_to_be32(tv->tv_sec);
 	ts->t_nsec = cpu_to_be32(tv->tv_nsec);
 }
@@ -285,9 +317,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	xfs_inode_to_disk_timestamp(&to->di_atime, &inode->i_atime);
-	xfs_inode_to_disk_timestamp(&to->di_mtime, &inode->i_mtime);
-	xfs_inode_to_disk_timestamp(&to->di_ctime, &inode->i_ctime);
+	xfs_inode_to_disk_timestamp(from, &to->di_atime, &inode->i_atime);
+	xfs_inode_to_disk_timestamp(from, &to->di_mtime, &inode->i_mtime);
+	xfs_inode_to_disk_timestamp(from, &to->di_ctime, &inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -306,7 +338,8 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
+		xfs_inode_to_disk_timestamp(from, &to->di_crtime,
+				&from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
@@ -526,6 +559,11 @@ xfs_dinode_verify(
 	if (fa)
 		return fa;
 
+	/* bigtime iflag can only happen on bigtime filesystems */
+	if ((flags2 & (XFS_DIFLAG2_BIGTIME)) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f6160033fcbd..3b25e43eafa1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -58,9 +58,9 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
-void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
-		const union xfs_timestamp *ts);
-void xfs_inode_to_disk_timestamp(union xfs_timestamp *ts,
-		const struct timespec64 *tv);
+void xfs_inode_from_disk_timestamp(struct xfs_dinode *dip,
+		struct timespec64 *tv, const union xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(struct xfs_icdinode *from,
+		union xfs_timestamp *ts, const struct timespec64 *tv);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 17c83d29998c..569721f7f9e5 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -373,6 +373,9 @@ union xfs_ictimestamp {
 		int32_t		t_sec;		/* timestamp seconds */
 		int32_t		t_nsec;		/* timestamp nanoseconds */
 	};
+
+	/* Nanoseconds since the bigtime epoch. */
+	uint64_t		t_bigtime;
 };
 
 /*
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
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 9f036053fdb7..b354825f4e51 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -190,6 +190,11 @@ xchk_inode_flags2(
 	if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
 		goto bad;
 
+	/* the incore bigtime iflag always follows the feature flag */
+	if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
+	    !!(flags2 & XFS_DIFLAG2_BIGTIME))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);
@@ -199,11 +204,12 @@ static inline void
 xchk_dinode_nsec(
 	struct xfs_scrub		*sc,
 	xfs_ino_t			ino,
+	struct xfs_dinode		*dip,
 	const union xfs_timestamp	*ts)
 {
 	struct timespec64		tv;
 
-	xfs_inode_from_disk_timestamp(&tv, ts);
+	xfs_inode_from_disk_timestamp(dip, &tv, ts);
 	if (tv.tv_nsec < 0 || tv.tv_nsec >= NSEC_PER_SEC)
 		xchk_ino_set_corrupt(sc, ino);
 }
@@ -306,9 +312,9 @@ xchk_dinode(
 	}
 
 	/* di_[amc]time.nsec */
-	xchk_dinode_nsec(sc, ino, &dip->di_atime);
-	xchk_dinode_nsec(sc, ino, &dip->di_mtime);
-	xchk_dinode_nsec(sc, ino, &dip->di_ctime);
+	xchk_dinode_nsec(sc, ino, dip, &dip->di_atime);
+	xchk_dinode_nsec(sc, ino, dip, &dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, dip, &dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -413,7 +419,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		xchk_dinode_nsec(sc, ino, &dip->di_crtime);
+		xchk_dinode_nsec(sc, ino, dip, &dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..bcd1b4bef123 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -841,6 +841,8 @@ xfs_ialloc(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
+		if (xfs_sb_version_hasbigtime(&mp->m_sb))
+			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
@@ -2718,6 +2720,8 @@ xfs_ifree(
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_flags2 = 0;
+	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
@@ -3503,6 +3507,13 @@ xfs_iflush(
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
 		goto flush_out;
 	}
+	if (xfs_sb_version_hasbigtime(&mp->m_sb) &&
+	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: bad inode %Lu, bigtime unset, ptr "PTR_FMT,
+			__func__, ip->i_ino, ip);
+		goto flush_out;
+	}
 
 	/*
 	 * Inode item log recovery for v2 inodes are dependent on the
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 64cde59ed51a..08f061829429 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -297,9 +297,16 @@ xfs_inode_item_format_attr_fork(
 
 static inline void
 xfs_from_log_timestamp(
+	struct xfs_log_dinode		*from,
 	union xfs_timestamp		*ts,
 	const union xfs_ictimestamp	*its)
 {
+	if (from->di_version >= 3 &&
+	    (from->di_flags2 & XFS_DIFLAG2_BIGTIME)) {
+		ts->t_bigtime = cpu_to_be64(its->t_bigtime);
+		return;
+	}
+
 	ts->t_sec = cpu_to_be32(its->t_sec);
 	ts->t_nsec = cpu_to_be32(its->t_nsec);
 }
@@ -321,9 +328,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	xfs_from_log_timestamp(&to->di_atime, &from->di_atime);
-	xfs_from_log_timestamp(&to->di_mtime, &from->di_mtime);
-	xfs_from_log_timestamp(&to->di_ctime, &from->di_ctime);
+	xfs_from_log_timestamp(from, &to->di_atime, &from->di_atime);
+	xfs_from_log_timestamp(from, &to->di_mtime, &from->di_mtime);
+	xfs_from_log_timestamp(from, &to->di_ctime, &from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -339,7 +346,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		xfs_from_log_timestamp(&to->di_crtime, &from->di_crtime);
+		xfs_from_log_timestamp(from, &to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
@@ -354,9 +361,19 @@ xfs_log_dinode_to_disk(
 
 static inline void
 xfs_to_log_timestamp(
+	struct xfs_icdinode		*from,
 	union xfs_ictimestamp		*its,
 	const struct timespec64		*ts)
 {
+	if (from->di_flags2 & XFS_DIFLAG2_BIGTIME) {
+		uint64_t		t;
+
+		t = (uint64_t)(ts->tv_sec + XFS_INO_BIGTIME_EPOCH);
+		t *= NSEC_PER_SEC;
+		its->t_bigtime = t + ts->tv_nsec;
+		return;
+	}
+
 	its->t_sec = ts->tv_sec;
 	its->t_nsec = ts->tv_nsec;
 }
@@ -379,9 +396,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	xfs_to_log_timestamp(&to->di_atime, &inode->i_atime);
-	xfs_to_log_timestamp(&to->di_mtime, &inode->i_mtime);
-	xfs_to_log_timestamp(&to->di_ctime, &inode->i_ctime);
+	xfs_to_log_timestamp(from, &to->di_atime, &inode->i_atime);
+	xfs_to_log_timestamp(from, &to->di_mtime, &inode->i_mtime);
+	xfs_to_log_timestamp(from, &to->di_ctime, &inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -403,7 +420,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		xfs_to_log_timestamp(&to->di_crtime, &from->di_crtime);
+		xfs_to_log_timestamp(from, &to->di_crtime, &from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
@@ -411,6 +428,8 @@ xfs_inode_to_log_dinode(
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
+		ASSERT((from->di_flags2 & XFS_DIFLAG2_BIGTIME) ||
+		       !xfs_sb_version_hasbigtime(&ip->i_mount->m_sb));
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = from->di_flushiter;
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
index 7158a8de719f..80129b2dc392 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -25,6 +25,9 @@ xfs_check_limits(void)
 	/* make sure timestamp limits are correct */
 	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
 	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
+	XFS_CHECK_VALUE(XFS_INO_BIGTIME_EPOCH,			2147483648LL);
+	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MIN,			-2147483648LL);
+	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MAX,			16299260425LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
 	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
 	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 375f05a47ba4..b19ae052f7a3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1484,8 +1484,13 @@ xfs_fc_fill_super(
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
-	sb->s_time_min = XFS_INO_TIME_MIN;
-	sb->s_time_max = XFS_INO_TIME_MAX;
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		sb->s_time_min = XFS_INO_BIGTIME_MIN;
+		sb->s_time_max = XFS_INO_BIGTIME_MAX;
+	} else {
+		sb->s_time_min = XFS_INO_TIME_MIN;
+		sb->s_time_max = XFS_INO_TIME_MAX;
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
 

