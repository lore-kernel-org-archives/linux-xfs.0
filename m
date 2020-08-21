Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB67C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2EB207DE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3vpUo1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHUCO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:14:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:14:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L26p1S111237;
        Fri, 21 Aug 2020 02:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6WTb1IHXn9KpZ5lxmruL9rTTK9Q4ilD29mXZXLvznjw=;
 b=Q3vpUo1bllUvqF5tJNWI32EkncA93afXvNRALgqUbkhO5CrfU+1GcnO3rI0IN8N+vlvo
 xJwUptt4dsjJRBa3krDEsKLzL2HtuRORKupsqEHVM5jvjr1wFxHV0rcLSniVj5PF+Zst
 dLfR9lyso6kPHJ8apTN00ZOu/0CD/x2BdhOLggJruT63KH5XV960ipT70b1syILT+cOG
 j9bE0jVX6+yU5WbYaFIhU8PImPLo8XF9HrbHvnaifYS96PsJ1arz35YlvbDRbqWCI3Uy
 YizqvgC5nSpKvtfyU6NRIcka8wtaL6cAzQ4WIp8peOoIZr5druMGcwAjdkXnJOogT0Bg sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74rkwff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:14:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L293Xg012101;
        Fri, 21 Aug 2020 02:12:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32xsn2308t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07L2CNoS003094;
        Fri, 21 Aug 2020 02:12:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:22 -0700
Subject: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038 problem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:21 -0700
Message-ID: <159797594159.965217.2504039364311840477.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=3 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=3 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h      |   38 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h          |    1 +
 fs/xfs/libxfs/xfs_inode_buf.c   |   54 +++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_buf.h   |    8 +++---
 fs/xfs/libxfs/xfs_log_format.h  |    3 ++
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_trans_inode.c |   11 ++++++++
 fs/xfs/scrub/inode.c            |   16 ++++++++----
 fs/xfs/xfs_inode.c              |   15 ++++++++++-
 fs/xfs/xfs_inode_item.c         |   33 ++++++++++++++++++------
 fs/xfs/xfs_ioctl.c              |    3 +-
 fs/xfs/xfs_ondisk.h             |    6 ++++
 fs/xfs/xfs_super.c              |   13 ++++++++-
 13 files changed, 173 insertions(+), 30 deletions(-)


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
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index e15129647e00..71aca4587715 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -131,6 +131,17 @@ xfs_trans_log_inode(
 			iversion_flags = XFS_ILOG_CORE;
 	}
 
+	/*
+	 * If we're updating the inode core or the timestamps and it's possible
+	 * to upgrade this inode to bigtime format, do so now.
+	 */
+	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
+	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
+	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 9f036053fdb7..6f00309de2d4 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -190,6 +190,11 @@ xchk_inode_flags2(
 	if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
 		goto bad;
 
+	/* no bigtime iflag without the bigtime feature */
+	if (!xfs_sb_version_hasbigtime(&mp->m_sb) &&
+	    (flags2 & XFS_DIFLAG2_BIGTIME))
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
index c06129cffba9..bbc309bc70c4 100644
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
@@ -2717,7 +2719,11 @@ xfs_ifree(
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
-	ip->i_d.di_flags2 = 0;
+	/*
+	 * Preserve the bigtime flag so that di_ctime accurately stores the
+	 * deletion time.
+	 */
+	ip->i_d.di_flags2 &= XFS_DIFLAG2_BIGTIME;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
@@ -3503,6 +3509,13 @@ xfs_iflush(
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
index cec6d4d82bc4..c38af3eea48f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -298,9 +298,16 @@ xfs_inode_item_format_attr_fork(
 /* Write a log_dinode timestamp into an ondisk inode timestamp. */
 static inline void
 xfs_log_dinode_to_disk_ts(
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
@@ -322,9 +329,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	xfs_log_dinode_to_disk_ts(&to->di_atime, &from->di_atime);
-	xfs_log_dinode_to_disk_ts(&to->di_mtime, &from->di_mtime);
-	xfs_log_dinode_to_disk_ts(&to->di_ctime, &from->di_ctime);
+	xfs_log_dinode_to_disk_ts(from, &to->di_atime, &from->di_atime);
+	xfs_log_dinode_to_disk_ts(from, &to->di_mtime, &from->di_mtime);
+	xfs_log_dinode_to_disk_ts(from, &to->di_ctime, &from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -340,7 +347,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		xfs_log_dinode_to_disk_ts(&to->di_crtime, &from->di_crtime);
+		xfs_log_dinode_to_disk_ts(from, &to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
@@ -356,9 +363,19 @@ xfs_log_dinode_to_disk(
 /* Write an incore inode timestamp into a log_dinode timestamp. */
 static inline void
 xfs_inode_to_log_dinode_ts(
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
@@ -381,9 +398,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	xfs_inode_to_log_dinode_ts(&to->di_atime, &inode->i_atime);
-	xfs_inode_to_log_dinode_ts(&to->di_mtime, &inode->i_mtime);
-	xfs_inode_to_log_dinode_ts(&to->di_ctime, &inode->i_ctime);
+	xfs_inode_to_log_dinode_ts(from, &to->di_atime, &inode->i_atime);
+	xfs_inode_to_log_dinode_ts(from, &to->di_mtime, &inode->i_mtime);
+	xfs_inode_to_log_dinode_ts(from, &to->di_ctime, &inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -405,7 +422,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		xfs_inode_to_log_dinode_ts(&to->di_crtime, &from->di_crtime);
+		xfs_inode_to_log_dinode_ts(from, &to->di_crtime, &from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
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
index 7158a8de719f..3e0c677cff15 100644
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
@@ -58,6 +61,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
 	XFS_CHECK_STRUCT_SIZE(union xfs_timestamp,		8);
+	XFS_CHECK_OFFSET(union xfs_timestamp, t_bigtime,	0);
+	XFS_CHECK_OFFSET(union xfs_timestamp, t_sec,		0);
+	XFS_CHECK_OFFSET(union xfs_timestamp, t_nsec,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
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
 

