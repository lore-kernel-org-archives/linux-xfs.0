Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2982CC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D80207BB
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 02:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yRQ/cpJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHUCMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 22:12:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgHUCMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 22:12:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L271v9043414;
        Fri, 21 Aug 2020 02:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pdj+aoi0PdfIY2bEndGGdGUvW+LTNGDpHxY/47YfGqY=;
 b=yRQ/cpJJRC7Uogs2B6yyGVzUfisMN2tRzputAduwoIg67wKJo4VKBto1QOpcUfvZ7gb4
 BSk6TGEGqAqeGvtb/GdAdx/Cs3Dzn9o6gzwTnlVoHG0VGBvs/r6i61SnL63XDcd4t1uV
 xFOAaKFL6ykBPIqw2IkAH0oMhuEBznGnPI+4D++oagQCw3vr0sDpOVamNn3BNV/jeUZK
 PfG3rlcT5ujaxCgnSS+BYC8YCGEoAH2eQb4VZtuyUAr0LyOK5gsphnhSvI8t84dfpRU9
 7LHSVW/gIlGxklHur9+MriMRmpVsJQZm0pdjHWBCctSzTd7O70klY5AJxXRP/eOfDvr9 TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bnkr7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 02:12:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07L27s4N034727;
        Fri, 21 Aug 2020 02:12:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 330pvqm3g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 02:12:11 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07L2CAQQ019704;
        Fri, 21 Aug 2020 02:12:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 19:12:09 -0700
Subject: [PATCH 06/11] xfs: refactor inode timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Thu, 20 Aug 2020 19:12:08 -0700
Message-ID: <159797592873.965217.7436192080471557112.stgit@magnolia>
In-Reply-To: <159797588727.965217.7260803484540460144.stgit@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor inode timestamp encoding and decoding into helper functions so
that we can add extra behaviors in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   42 ++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_inode_buf.h |    5 +++++
 fs/xfs/scrub/inode.c          |   25 ++++++++++++++++-------
 fs/xfs/xfs_inode_item.c       |   44 ++++++++++++++++++++++++++---------------
 4 files changed, 76 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fa83591ca89b..4930eabed6d8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,6 +157,15 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+void
+xfs_inode_from_disk_timestamp(
+	struct timespec64		*tv,
+	const struct xfs_timestamp	*ts)
+{
+	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
+	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
+}
+
 int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -211,12 +220,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
+	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
+	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -229,8 +235,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -252,6 +257,15 @@ xfs_inode_from_disk(
 	return error;
 }
 
+void
+xfs_inode_to_disk_timestamp(
+	struct xfs_timestamp		*ts,
+	const struct timespec64		*tv)
+{
+	ts->t_sec = cpu_to_be32(tv->tv_sec);
+	ts->t_nsec = cpu_to_be32(tv->tv_nsec);
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -271,12 +285,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	xfs_inode_to_disk_timestamp(&to->di_atime, &inode->i_atime);
+	xfs_inode_to_disk_timestamp(&to->di_mtime, &inode->i_mtime);
+	xfs_inode_to_disk_timestamp(&to->di_ctime, &inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -295,8 +306,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..9c63f3f932d7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -58,4 +58,9 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
+		const struct xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const struct timespec64 *tv);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..ccb5c217c0ee 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -195,6 +195,19 @@ xchk_inode_flags2(
 	xchk_ino_set_corrupt(sc, ino);
 }
 
+static inline void
+xchk_dinode_nsec(
+	struct xfs_scrub		*sc,
+	xfs_ino_t			ino,
+	const struct xfs_timestamp	*ts)
+{
+	struct timespec64		tv;
+
+	xfs_inode_from_disk_timestamp(&tv, ts);
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
+	xchk_dinode_nsec(sc, ino, &dip->di_atime);
+	xchk_dinode_nsec(sc, ino, &dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, &dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -403,8 +413,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xchk_ino_set_corrupt(sc, ino);
+		xchk_dinode_nsec(sc, ino, &dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d95a00376fad..dac0ab59e88f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,16 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+/* Write a log_dinode timestamp into an ondisk inode timestamp. */
+static inline void
+xfs_log_dinode_to_disk_ts(
+	struct xfs_timestamp		*ts,
+	const struct xfs_ictimestamp	*its)
+{
+	ts->t_sec = cpu_to_be32(its->t_sec);
+	ts->t_nsec = cpu_to_be32(its->t_nsec);
+}
+
 void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -312,12 +322,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	xfs_log_dinode_to_disk_ts(&to->di_atime, &from->di_atime);
+	xfs_log_dinode_to_disk_ts(&to->di_mtime, &from->di_mtime);
+	xfs_log_dinode_to_disk_ts(&to->di_ctime, &from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -333,8 +340,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		xfs_log_dinode_to_disk_ts(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
@@ -347,6 +353,16 @@ xfs_log_dinode_to_disk(
 	}
 }
 
+/* Write an incore inode timestamp into a log_dinode timestamp. */
+static inline void
+xfs_inode_to_log_dinode_ts(
+	struct xfs_ictimestamp		*its,
+	const struct timespec64		*ts)
+{
+	its->t_sec = ts->tv_sec;
+	its->t_nsec = ts->tv_nsec;
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -365,12 +381,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	xfs_inode_to_log_dinode_ts(&to->di_atime, &inode->i_atime);
+	xfs_inode_to_log_dinode_ts(&to->di_mtime, &inode->i_mtime);
+	xfs_inode_to_log_dinode_ts(&to->di_ctime, &inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -392,8 +405,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		xfs_inode_to_log_dinode_ts(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;

