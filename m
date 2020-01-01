Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E351C2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F65206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bLYaC0bT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgAABMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119iCT089415
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Auhp190xVf6dbIb/V1C31+jlh7OhpuQG8MmfJ0iZtjE=;
 b=bLYaC0bT9fJenJDIw2yCfCaBo/ZWE9g0RuXzdBx4DftQpKJ+zJEPRTmC+fGlbLkqOZ3c
 TmAB+BjFm107k1kJVFWXYnbut6mU4tanIvqyE0efGJfHRyq4qTY/pn0JH4z7oFnLJ/tn
 QfFJG4mBnXmLvpeshORbd2wI9DRNHTnv/inyGcHphJNZpkhTKvxc71ZiuNIKiy0SmslI
 nHwODblCB0G4wTRCUMKHlf+zjoL4luBm2bPKzJufOgzK3I3i4j988174e02mKgtlM58+
 5fZHXqLdL5qcxz3hyAJaIgpDeLwK0vt9YMJY2Eshw4Yj5xEl2zjtkVsI91cqPBSSTlNk mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v1n172084
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj917sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:09 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011C8EP032618
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:08 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:08 -0800
Subject: [PATCH 10/14] xfs: convert struct xfs_timestamp to union
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:06 -0800
Message-ID: <157784112596.1364230.11061695243014872367.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
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
index b3ace144f6ce..8a1bb33ebdd5 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -848,9 +848,11 @@ typedef struct xfs_agfl {
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
@@ -896,9 +898,9 @@ typedef struct xfs_dinode {
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
@@ -923,7 +925,7 @@ typedef struct xfs_dinode {
 	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	struct xfs_timestamp di_crtime;	/* time created */
+	union xfs_timestamp di_crtime;	/* time created */
 	__be64		di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 66f7895a9fee..f4725e4916ab 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -204,7 +204,7 @@ xfs_imap_to_bp(
 void
 xfs_inode_from_disk_timestamp(
 	struct timespec64		*tv,
-	const struct xfs_timestamp	*ts)
+	const union xfs_timestamp	*ts)
 {
 	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
 	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
@@ -273,7 +273,7 @@ xfs_inode_from_disk(
 
 void
 xfs_inode_to_disk_timestamp(
-	struct xfs_timestamp		*ts,
+	union xfs_timestamp		*ts,
 	const struct timespec64		*tv)
 {
 	ts->t_sec = cpu_to_be32(tv->tv_sec);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 8eca71ac0c5a..787a50df232f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -76,8 +76,8 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint64_t flags2);
 
 void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
-		const struct xfs_timestamp *ts);
-void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const union xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(union xfs_timestamp *ts,
 		const struct timespec64 *tv);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6694be6ddc3c..c98060115352 100644
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
index 40131cefc165..a8d3c6aad1b8 100644
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
index b8811f927a3c..5a3372fb6e6d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -53,7 +53,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(union xfs_timestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
@@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(union xfs_ictimestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);

