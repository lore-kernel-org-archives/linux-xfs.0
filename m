Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA20C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD24207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qm8Ekveg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHZWFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:05:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZWFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:05:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QLxP3M139757;
        Wed, 26 Aug 2020 22:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cPbZWBm9btNOD0DT6w+tOW6VBA7+JMWPMXHMwn4CJgE=;
 b=qm8EkvegYXWiMOuYi2ROAHak8YffeFKYx+ASKJwLXY958X4xUxgvTb+cgncyJeedwCJR
 sQIT6wEuxmtJzT4tQNgVhH7OEmUA5qbNO+DXblXsOh2tkcBE4ZV/Osj8ILTQoE/TZTlI
 ZnVD+1S6M7D8NOeH3i7exHWvX5ZPmqS/J7iCp2bX11WRRA9/UL8lVEIHANVhBT25f0i/
 32MZ8jbw/VFpSC09gvPcw2H8SpNzEZ1EEd8TGGak7EnhgSfrNceOqTQ6r7wnXg5dbOyu
 /dMhl8ntCJKm8VNtPmifUp+x+9U1A44sdpT7OGGq24HTUPhHEUiNHJ6pfdr4okihO0s+ XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6u1kjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:05:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM0I66004030;
        Wed, 26 Aug 2020 22:05:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 333rubberu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QM5c2v027437;
        Wed, 26 Aug 2020 22:05:38 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:38 -0700
Subject: [PATCH 06/11] xfs: kill struct xfs_timestamp
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:36 -0700
Message-ID: <159847953684.2601708.8165492597542894989.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace this struct with an encoded __be64 value and add conversion
helpers to deal with the change.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      |    8 ++---
 fs/xfs/libxfs/xfs_inode_buf.c   |   62 +++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_inode_buf.h   |    2 +
 fs/xfs/scrub/inode.c            |   25 +++++++++++-----
 fs/xfs/xfs_inode_item_recover.c |   26 +++++++++++-----
 fs/xfs/xfs_ondisk.h             |    2 +
 6 files changed, 87 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4b68a473b090..96734ba9aa5f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -856,12 +856,10 @@ struct xfs_agfl {
  * seconds and nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC
  * 1970, which means that the timestamp epoch is the same as the Unix epoch.
  * Therefore, the ondisk min and max defined here can be used directly to
- * constrain the incore timestamps on a Unix system.
+ * constrain the incore timestamps on a Unix system.  Note that we actually
+ * encode a __be64 value on disk.
  */
-typedef struct xfs_timestamp {
-	__be32		t_sec;		/* timestamp seconds */
-	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+typedef __be64 xfs_timestamp_t;
 
 /*
  * Smallest possible ondisk seconds value with traditional timestamps.  This
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fa83591ca89b..1e65e28a9386 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,6 +157,26 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+/*
+ * Convert an ondisk timestamp to an incore timestamp.
+ *
+ * For traditional timestamps, the ondisk format specifies that the seconds
+ * are stored in the first four bytes and the nanoseconds in the second four.
+ * Let the be64 conversion rotate the seconds field into the upper 32-bits,
+ * then shift and mask to extract the two values.
+ */
+struct timespec64
+xfs_inode_from_disk_ts(
+	const xfs_timestamp_t	ts)
+{
+	struct timespec64	tv;
+	uint64_t		t = be64_to_cpu(ts);
+
+	tv.tv_sec = (int64_t)t >> 32;
+	tv.tv_nsec = (int32_t)(t & 0xffffffff);
+	return tv;
+}
+
 int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -211,12 +231,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	inode->i_atime = xfs_inode_from_disk_ts(from->di_atime);
+	inode->i_mtime = xfs_inode_from_disk_ts(from->di_mtime);
+	inode->i_ctime = xfs_inode_from_disk_ts(from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -229,8 +246,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_crtime = xfs_inode_from_disk_ts(from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -252,6 +268,24 @@ xfs_inode_from_disk(
 	return error;
 }
 
+/*
+ * Convert an incore timestamp to an ondisk timestamp.
+ *
+ * For traditional timestamps, the ondisk format specifies that the seconds
+ * are stored in the first four bytes and the nanoseconds in the second four.
+ * Shift the seconds into the upper 32-bits so that the be64 conversion will
+ * take care of rotating the bytes for us.
+ */
+static inline xfs_timestamp_t
+xfs_inode_to_disk_ts(
+	const struct timespec64	tv)
+{
+	uint64_t		t;
+
+	t = ((int64_t)tv.tv_sec << 32) | (tv.tv_nsec & 0xffffffff);
+	return cpu_to_be64(t);
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -271,12 +305,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
+	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
+	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -295,8 +326,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..3060ecd24a2e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -58,4 +58,6 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..eb1cc013d4ca 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -195,6 +195,19 @@ xchk_inode_flags2(
 	xchk_ino_set_corrupt(sc, ino);
 }
 
+static inline void
+xchk_dinode_nsec(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		ino,
+	const xfs_timestamp_t	ts)
+{
+	struct timespec64	tv;
+
+	tv = xfs_inode_from_disk_ts(ts);
+	if (tv.tv_nsec < 0 || tv.tv_nsec >= NSEC_PER_SEC)
+		xchk_ino_set_corrupt(sc, ino);
+}
+
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xchk_dinode(
@@ -293,12 +306,9 @@ xchk_dinode(
 	}
 
 	/* di_[amc]time.nsec */
-	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
+	xchk_dinode_nsec(sc, ino, dip->di_atime);
+	xchk_dinode_nsec(sc, ino, dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -403,8 +413,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xchk_ino_set_corrupt(sc, ino);
+		xchk_dinode_nsec(sc, ino, dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 1e417ace2912..e7c6f2b95e17 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -115,6 +115,20 @@ xfs_recover_inode_owner_change(
 	return error;
 }
 
+/*
+ * Convert a log timestamp to an ondisk timestamp.  See notes about the ondisk
+ * encoding in the comments for xfs_inode_to_disk_ts.
+ */
+static inline xfs_timestamp_t
+xfs_log_dinode_to_disk_ts(
+	const xfs_ictimestamp_t	its)
+{
+	uint64_t		t;
+
+	t = ((int64_t)its.t_sec << 32) | (its.t_nsec & 0xffffffff);
+	return cpu_to_be64(t);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -132,12 +146,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	to->di_atime = xfs_log_dinode_to_disk_ts(from->di_atime);
+	to->di_mtime = xfs_log_dinode_to_disk_ts(from->di_mtime);
+	to->di_ctime = xfs_log_dinode_to_disk_ts(from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -153,8 +164,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_crtime = xfs_log_dinode_to_disk_ts(from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index acb9b737fe6b..2f11a6f9e005 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -41,7 +41,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);

