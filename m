Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4CCC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4DCC2063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YT0XoQLv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHQW7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35746 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgHQW7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwA4a164165;
        Mon, 17 Aug 2020 22:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=grGKzAlqDDiYZbhGvGU9PinkXTKZtgu01DloLBU35XY=;
 b=YT0XoQLvWnQHOe/VqzuE7dU/4R+p9hBPuqzkYA3iJWgAqBXaU2XtHACxN/fZrBpGkxH0
 AjLPZUQkAGhPBZ9cPMW2SKmwZso5BVJ6NVxMUPEei5H/wb3fPMfOLoY3RVwLkfvQchRD
 NkKdrN00fGSmFYpxzptan71/+FjyL0SVUz+muQzGwkdHME6kKkq8RSwvAo+BNGNYl1jw
 a4peUyLkImEauPSeg9+gVtndQJCcZ22CC3Fn3T9cpuoG6x4fma/6Ew9PXDRVOMspNoXW
 5OHpUe+DfOINzTfrDd6CAnmN+ueQo/IkRQRUemwvO9QWiYtfaDJ/NwkO+jrnwT8e1tLq WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r1mug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwtKN113566;
        Mon, 17 Aug 2020 22:59:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsmwgh24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMxjxK025655;
        Mon, 17 Aug 2020 22:59:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:44 -0700
Subject: [PATCH 08/18] xfs: convert struct xfs_timestamp to union
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:43 -0700
Message-ID: <159770518396.3958786.953688801201393844.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
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
 db/field.c              |    2 +-
 db/inode.c              |    2 +-
 libxfs/xfs_format.h     |   16 +++++++++-------
 libxfs/xfs_inode_buf.c  |    4 ++--
 libxfs/xfs_inode_buf.h  |    4 ++--
 libxfs/xfs_log_format.h |   16 +++++++++-------
 repair/dinode.c         |    2 +-
 7 files changed, 25 insertions(+), 21 deletions(-)


diff --git a/db/field.c b/db/field.c
index 0f41be636db4..cf3002c730e6 100644
--- a/db/field.c
+++ b/db/field.c
@@ -350,7 +350,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(int32_t)), FTARG_SIGNED,
 	  NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
-	  SI(bitsz(struct xfs_timestamp)), 0, NULL, timestamp_flds },
+	  SI(bitsz(union xfs_timestamp)), 0, NULL, timestamp_flds },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
 	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(uint16_t)), 0, NULL,
 	  NULL },
diff --git a/db/inode.c b/db/inode.c
index dfaf12816d75..25112bb5e4d8 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -179,7 +179,7 @@ const field_t	inode_v3_flds[] = {
 };
 
 
-#define	TOFF(f)	bitize(offsetof(struct xfs_timestamp, t_ ## f))
+#define	TOFF(f)	bitize(offsetof(union xfs_timestamp, t_ ## f))
 const field_t	timestamp_flds[] = {
 	{ "sec", FLDT_TIME, OI(TOFF(sec)), C1, 0, TYP_NONE },
 	{ "nsec", FLDT_NSEC, OI(TOFF(nsec)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d11adbbd1808..5403d3412cb6 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 9f7309f9a576..a6c44ca6f2ad 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -161,7 +161,7 @@ xfs_imap_to_bp(
 void
 xfs_inode_from_disk_timestamp(
 	struct timespec64		*tv,
-	const struct xfs_timestamp	*ts)
+	const union xfs_timestamp	*ts)
 {
 	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
 	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
@@ -260,7 +260,7 @@ xfs_inode_from_disk(
 
 void
 xfs_inode_to_disk_timestamp(
-	struct xfs_timestamp		*ts,
+	union xfs_timestamp		*ts,
 	const struct timespec64		*tv)
 {
 	ts->t_sec = cpu_to_be32(tv->tv_sec);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 9c63f3f932d7..f6160033fcbd 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -59,8 +59,8 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint64_t flags2);
 
 void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
-		const struct xfs_timestamp *ts);
-void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const union xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(union xfs_timestamp *ts,
 		const struct timespec64 *tv);
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index f2fac9bea66d..17c83d29998c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 957a2698b09e..c5f2248b2b9a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2169,7 +2169,7 @@ static void
 check_nsec(
 	const char		*name,
 	xfs_ino_t		lino,
-	struct xfs_timestamp	*t,
+	union xfs_timestamp	*t,
 	int			*dirty)
 {
 	if (be32_to_cpu(t->t_nsec) < 1000000000)

