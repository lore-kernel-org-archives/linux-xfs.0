Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCABC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E222076E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tUzT0Ph1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgHUCOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:14:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:14:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27nDK053196;
        Fri, 21 Aug 2020 02:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qoa+OopY0wkWrhWpDjqDXdSPMtsEP/phRTo1Ae6iczY=;
 b=tUzT0Ph19I+AgthT9rFYAdu54OwLt17RLkNFimMawU/QUShqxQWCk6OTHVQaEqL3AKP3
 ceDtivJOorgUf7eXVqktPr4HzOhwiEJQZLNJVGF941xc72PRIYFq/BllNvavRMem3vGF
 0YefVdawYy/NomcYdjccvQBPmcGFsowxBkojBAamGY6MTD2thK4m5UhI9C5A05kC9rp1
 +S474d+cvPOucyegpsE2briPV/tlUQML8QExYf/ao2zhFb21J5X/eH8qYMQNzc3HXoHG
 cmcMlty7Mq2NprIlOZ3PZ4yIkzeYGUmJ9NDoAREfp0qpvEwauirJRvNMKspn+vDBCaxY tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3322bjge0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:14:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L294nh012379;
        Fri, 21 Aug 2020 02:12:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsn2303r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07L2CGP1028393;
        Fri, 21 Aug 2020 02:12:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:16 -0700
Subject: [PATCH 07/11] xfs: convert struct xfs_timestamp to union
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:15 -0700
Message-ID: <159797593518.965217.18264791906308377426.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the xfs_timestamp struct to a union so that we can overload it
in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h     |   16 +++++++++-------
 fs/xfs/libxfs/xfs_inode_buf.c  |    4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |    4 ++--
 fs/xfs/libxfs/xfs_log_format.h |   16 +++++++++-------
 fs/xfs/scrub/inode.c           |    2 +-
 fs/xfs/xfs_inode_item.c        |    6 +++---
 fs/xfs/xfs_ondisk.h            |    4 ++--
 7 files changed, 28 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1f3a2be6c396..772113db41aa 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -856,9 +856,11 @@ struct xfs_agfl {
  * Inode timestamps consist of signed 32-bit counters for seconds and
  * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
  */
-struct xfs_timestamp {
-	__be32		t_sec;		/* timestamp seconds */
-	__be32		t_nsec;		/* timestamp nanoseconds */
+union xfs_timestamp {
+	struct {
+		__be32		t_sec;		/* timestamp seconds */
+		__be32		t_nsec;		/* timestamp nanoseconds */
+	};
 };
 
 /*
@@ -904,9 +906,9 @@ typedef struct xfs_dinode {
 	__be16		di_projid_hi;	/* higher part owner's project id */
 	__u8		di_pad[6];	/* unused, zeroed space */
 	__be16		di_flushiter;	/* incremented on flush */
-	struct xfs_timestamp di_atime;	/* time last accessed */
-	struct xfs_timestamp di_mtime;	/* time last modified */
-	struct xfs_timestamp di_ctime;	/* time created/inode modified */
+	union xfs_timestamp di_atime;	/* time last accessed */
+	union xfs_timestamp di_mtime;	/* time last modified */
+	union xfs_timestamp di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
@@ -931,7 +933,7 @@ typedef struct xfs_dinode {
 	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	struct xfs_timestamp di_crtime;	/* time created */
+	union xfs_timestamp di_crtime;	/* time created */
 	__be64		di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4930eabed6d8..cc1316a5fe0c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -160,7 +160,7 @@ xfs_imap_to_bp(
 void
 xfs_inode_from_disk_timestamp(
 	struct timespec64		*tv,
-	const struct xfs_timestamp	*ts)
+	const union xfs_timestamp	*ts)
 {
 	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
 	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
@@ -259,7 +259,7 @@ xfs_inode_from_disk(
 
 void
 xfs_inode_to_disk_timestamp(
-	struct xfs_timestamp		*ts,
+	union xfs_timestamp		*ts,
 	const struct timespec64		*tv)
 {
 	ts->t_sec = cpu_to_be32(tv->tv_sec);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9c63f3f932d7..f6160033fcbd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,8 +59,8 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint64_t flags2);
 
 void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
-		const struct xfs_timestamp *ts);
-void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const union xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(union xfs_timestamp *ts,
 		const struct timespec64 *tv);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f2fac9bea66d..17c83d29998c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -368,9 +368,11 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-struct xfs_ictimestamp {
-	int32_t		t_sec;		/* timestamp seconds */
-	int32_t		t_nsec;		/* timestamp nanoseconds */
+union xfs_ictimestamp {
+	struct {
+		int32_t		t_sec;		/* timestamp seconds */
+		int32_t		t_nsec;		/* timestamp nanoseconds */
+	};
 };
 
 /*
@@ -390,9 +392,9 @@ struct xfs_log_dinode {
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	uint8_t		di_pad[6];	/* unused, zeroed space */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	struct xfs_ictimestamp di_atime;	/* time last accessed */
-	struct xfs_ictimestamp di_mtime;	/* time last modified */
-	struct xfs_ictimestamp di_ctime;	/* time created/inode modified */
+	union xfs_ictimestamp di_atime;	/* time last accessed */
+	union xfs_ictimestamp di_mtime;	/* time last modified */
+	union xfs_ictimestamp di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -417,7 +419,7 @@ struct xfs_log_dinode {
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	struct xfs_ictimestamp di_crtime;	/* time created */
+	union xfs_ictimestamp di_crtime;	/* time created */
 	xfs_ino_t	di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index ccb5c217c0ee..9f036053fdb7 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -199,7 +199,7 @@ static inline void
 xchk_dinode_nsec(
 	struct xfs_scrub		*sc,
 	xfs_ino_t			ino,
-	const struct xfs_timestamp	*ts)
+	const union xfs_timestamp	*ts)
 {
 	struct timespec64		tv;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index dac0ab59e88f..cec6d4d82bc4 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -298,8 +298,8 @@ xfs_inode_item_format_attr_fork(
 /* Write a log_dinode timestamp into an ondisk inode timestamp. */
 static inline void
 xfs_log_dinode_to_disk_ts(
-	struct xfs_timestamp		*ts,
-	const struct xfs_ictimestamp	*its)
+	union xfs_timestamp		*ts,
+	const union xfs_ictimestamp	*its)
 {
 	ts->t_sec = cpu_to_be32(its->t_sec);
 	ts->t_nsec = cpu_to_be32(its->t_nsec);
@@ -356,7 +356,7 @@ xfs_log_dinode_to_disk(
 /* Write an incore inode timestamp into a log_dinode timestamp. */
 static inline void
 xfs_inode_to_log_dinode_ts(
-	struct xfs_ictimestamp		*its,
+	union xfs_ictimestamp		*its,
 	const struct timespec64		*ts)
 {
 	its->t_sec = ts->tv_sec;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 498e9063c605..7158a8de719f 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -57,7 +57,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(union xfs_timestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
@@ -137,7 +137,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(union xfs_ictimestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);

