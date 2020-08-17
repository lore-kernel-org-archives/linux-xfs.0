Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857A9C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53902204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VsHYDfuV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgHQXCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:02:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgHQXCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:02:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvc7O050127;
        Mon, 17 Aug 2020 23:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q+TZOCaHdHGBuE2Io6ZeNkiQ5TVFFLBao+1pFw5uPj4=;
 b=VsHYDfuVkW/wnHswEhPnsZOOKxJ9wXOz2DDclQCP6bjUYeaelbvz+5ifwBbErJ+yN9Zn
 4uq9RkC7uF8w7Sqf8kMj4FqIKxt2DsqbNWWBV2ruzj/f4W4crU7wEizjN4qY4enCXCyF
 3K4QQL+jvR+m4iqpjkpRjN7/vrrbbJL0MoJV0zuiGy5cpGMtAXJXUBIcfwpSN+QTaW47
 OOvzntpK5fhIoEDPa0YXJJN+St9fOO5QiUYXxH3vFMjSxHTZTfAfK1Re5h6kdXkSrqOm
 V7qtgoWzUHCWjKQUemLpMOLuPy3lexOZPqevtSHiZJkXcY/qZY/DAQl2wbqiTMTXibom Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nm9k29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9Q6084679;
        Mon, 17 Aug 2020 22:59:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfr59wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMxvVr015020;
        Mon, 17 Aug 2020 22:59:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:57 -0700
Subject: [PATCH 10/18] xfs: widen ondisk timestamps to deal with y2038 problem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:56 -0700
Message-ID: <159770519622.3958786.16858432845716831168.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
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
 libfrog/fsgeom.c        |    6 +++--
 libxfs/util.c           |   10 ++++++---
 libxfs/xfs_format.h     |   38 ++++++++++++++++++++++++++++++++-
 libxfs/xfs_fs.h         |    1 +
 libxfs/xfs_inode_buf.c  |   54 ++++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_inode_buf.h  |    8 +++----
 libxfs/xfs_log_format.h |    3 +++
 libxfs/xfs_sb.c         |    2 ++
 repair/dinode.c         |   12 ++++++----
 9 files changed, 111 insertions(+), 23 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bd93924ea795..14507668e41b 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -28,6 +28,7 @@ xfs_report_geom(
 	int			spinodes;
 	int			rmapbt_enabled;
 	int			reflink_enabled;
+	int			bigtime_enabled;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -43,12 +44,13 @@ xfs_report_geom(
 	spinodes = geo->flags & XFS_FSOP_GEOM_FLAGS_SPINODES ? 1 : 0;
 	rmapbt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
+	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -58,7 +60,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled,
+		"", reflink_enabled, bigtime_enabled,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
diff --git a/libxfs/util.c b/libxfs/util.c
index 6670fcdfa1d0..eceb6dc29a3b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -197,7 +197,8 @@ xfs_flags2diflags2(
 	unsigned int		xflags)
 {
 	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
+		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
+				      XFS_DIFLAG2_BIGTIME));
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
@@ -279,8 +280,9 @@ libxfs_ialloc(
 		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = pip ? 0 : xfs_flags2diflags2(ip,
 				fsx->fsx_xflags);
-		ip->i_d.di_crtime.tv_sec = (int32_t)VFS_I(ip)->i_mtime.tv_sec;
-		ip->i_d.di_crtime.tv_nsec = (int32_t)VFS_I(ip)->i_mtime.tv_nsec;
+		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
+			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+		ip->i_d.di_crtime = VFS_I(ip)->i_mtime;
 		ip->i_d.di_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
 	}
 
@@ -375,6 +377,8 @@ libxfs_iflush_int(
 	}
 	ASSERT(ip->i_df.if_nextents+ip->i_afp->if_nextents <= ip->i_d.di_nblocks);
 	ASSERT(ip->i_d.di_forkoff <= mp->m_sb.sb_inodesize);
+	ASSERT(!(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME) &&
+	       xfs_sb_version_hasbigtime(&mp->m_sb));
 
 	/* bump the change count on v3 inodes */
 	if (xfs_sb_version_has_v3inode(&mp->m_sb))
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5403d3412cb6..67303e517260 100644
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
@@ -1101,12 +1133,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index dc2543dd5955..69f998666569 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -249,6 +249,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	(1 << 18) /* sparse inode chunks   */
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index a6c44ca6f2ad..2fb668c07b70 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -158,11 +158,25 @@ xfs_imap_to_bp(
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
@@ -221,9 +235,9 @@ xfs_inode_from_disk(
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
@@ -236,9 +250,17 @@ xfs_inode_from_disk(
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
@@ -260,9 +282,19 @@ xfs_inode_from_disk(
 
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
@@ -286,9 +318,9 @@ xfs_inode_to_disk(
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
@@ -307,7 +339,8 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
+		xfs_inode_to_disk_timestamp(from, &to->di_crtime,
+				&from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
@@ -527,6 +560,11 @@ xfs_dinode_verify(
 	if (fa)
 		return fa;
 
+	/* bigtime iflag can only happen on bigtime filesystems */
+	if ((flags2 & (XFS_DIFLAG2_BIGTIME)) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
 	return NULL;
 }
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index f6160033fcbd..3b25e43eafa1 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
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
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 17c83d29998c..569721f7f9e5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -373,6 +373,9 @@ union xfs_ictimestamp {
 		int32_t		t_sec;		/* timestamp seconds */
 		int32_t		t_nsec;		/* timestamp nanoseconds */
 	};
+
+	/* Nanoseconds since the bigtime epoch. */
+	uint64_t		t_bigtime;
 };
 
 /*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0eb16305e221..001b88865b0a 100644
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
diff --git a/repair/dinode.c b/repair/dinode.c
index 0bee3c3d988e..ad2f672d8703 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2169,10 +2169,12 @@ static void
 check_nsec(
 	const char		*name,
 	xfs_ino_t		lino,
+	struct xfs_dinode	*dip,
 	union xfs_timestamp	*t,
 	int			*dirty)
 {
-	if (be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
+	if ((dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_BIGTIME)) ||
+	    be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
 
 	do_warn(
@@ -2726,11 +2728,11 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	}
 
 	/* nsec fields cannot be larger than 1 billion */
-	check_nsec("atime", lino, &dino->di_atime, dirty);
-	check_nsec("mtime", lino, &dino->di_mtime, dirty);
-	check_nsec("ctime", lino, &dino->di_ctime, dirty);
+	check_nsec("atime", lino, dino, &dino->di_atime, dirty);
+	check_nsec("mtime", lino, dino, &dino->di_mtime, dirty);
+	check_nsec("ctime", lino, dino, &dino->di_ctime, dirty);
 	if (dino->di_version >= 3)
-		check_nsec("crtime", lino, &dino->di_crtime, dirty);
+		check_nsec("crtime", lino, dino, &dino->di_crtime, dirty);
 
 	/*
 	 * general size/consistency checks:

