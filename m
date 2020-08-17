Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AF1C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6AA2065D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xcra61Pa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgHQW5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:57:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHQW5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:57:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMva3Z136318;
        Mon, 17 Aug 2020 22:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2C6+iyXRfa99DklBO2D0WGqjiKXw8mo24tN6LjKbzU0=;
 b=Xcra61Pa0vNZ508oS2tSHX/080FmH2mQUGRC11mD+qPAGManISP218qn3BX91rl23YA/
 oBu5VebHclOhLZx//sMbHL91G5NGfz8Uxd5fL1cPA+vv+LdQz0LE//VtSOnR7nCBCjFs
 iy/Z6pdLKkd9oxoNl+thUs+4qDPfahuwIyN0QTyxgPlhjiOuX0JTVWK2/avl7LsibBC7
 +n/Z8InhI3n4a/n/6jZfpkKeMsgC8gBy22QNkeF9NAVK1e2lc1mvQuYNQlD4Qt1WM3Lc
 uvOvFbaJO3AO9KbdssXpOonXimAgq/qxI0RX3HiBn7QpySEsjQKkrRSRJ27CaqVn4Zwz Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn1fuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:57:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMmiRc102735;
        Mon, 17 Aug 2020 22:57:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9m9y28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:57:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMvXkP017258;
        Mon, 17 Aug 2020 22:57:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:57:33 -0700
Subject: [PATCH 07/11] xfs: convert struct xfs_timestamp to union
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:57:32 -0700
Message-ID: <159770505260.3956827.6046629630710794322.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the xfs_timestamp struct to a union so that we can overload it
in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index c2f9a0adeed2..64cde59ed51a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -297,8 +297,8 @@ xfs_inode_item_format_attr_fork(
 
 static inline void
 xfs_from_log_timestamp(
-	struct xfs_timestamp		*ts,
-	const struct xfs_ictimestamp	*its)
+	union xfs_timestamp		*ts,
+	const union xfs_ictimestamp	*its)
 {
 	ts->t_sec = cpu_to_be32(its->t_sec);
 	ts->t_nsec = cpu_to_be32(its->t_nsec);
@@ -354,7 +354,7 @@ xfs_log_dinode_to_disk(
 
 static inline void
 xfs_to_log_timestamp(
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

