Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C42C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91B81206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DX11jqN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgAABMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011A4kg089813
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MVFDIHkGvHpO4WRimSTR7UdtOnvXAkdvb6hbcbNuJ2g=;
 b=DX11jqN4LE8sNnmo9PdVaT2UptadwI+7556CzqijXrOBQrOfaf+bhlJSB8QMNfvQcpRp
 RTH8SkFFwj2omCbpQkF+j/jdvnEtWupcMWWioBJoKhVu5C9xhyieb6HTPo4kRwcrw2Wl
 Dg3eDkyv9N7OkZppVc2zRRpkR3p3kGdCv15k5B7mUAHIEJJ31mO3H5q0z4/eG3XFAaSM
 9ln8INIwqNuIatc9Trib6oHHLFim+j3xgwy4XsIiduVMpahZ5cQCyYVOu3HeKr2y8xai
 qbYP8AkCx4uNGPfJmhn2hTdEyhyL+Qit8inpkgX4NgbXmef3+ORsoq35sXxGmcRwZnQS 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xG6012465
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8gueeyd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011C2hN028858
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:02 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:02 -0800
Subject: [PATCH 09/14] xfs: refactor timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:11:59 -0800
Message-ID: <157784111984.1364230.13316084715812463489.stgit@magnolia>
In-Reply-To: <157784106066.1364230.569420432829402226.stgit@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=922
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=985 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor timestamp encoding and decoding into helper functions so that
we can add extra behaviors in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   42 +++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_inode_buf.h |    5 +++++
 fs/xfs/scrub/inode.c          |   25 +++++++++++++++++-------
 fs/xfs/xfs_inode_item.c       |   42 +++++++++++++++++++++++++----------------
 4 files changed, 74 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ea8b7f5bae59..66f7895a9fee 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -201,6 +201,15 @@ xfs_imap_to_bp(
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
 void
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -236,12 +245,9 @@ xfs_inode_from_disk(
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
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 
@@ -259,13 +265,21 @@ xfs_inode_from_disk(
 	if (to->di_version == 3) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
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
@@ -286,12 +300,9 @@ xfs_inode_to_disk(
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
@@ -309,8 +320,7 @@ xfs_inode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 1351a9db68b0..8eca71ac0c5a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -75,4 +75,9 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
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
index 826bb6b777d3..40131cefc165 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,15 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+static inline void
+xfs_from_log_timestamp(
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
@@ -312,12 +321,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	xfs_from_log_timestamp(&to->di_atime, &from->di_atime);
+	xfs_from_log_timestamp(&to->di_mtime, &from->di_mtime);
+	xfs_from_log_timestamp(&to->di_ctime, &from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -333,8 +339,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		xfs_from_log_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
@@ -347,6 +352,15 @@ xfs_log_dinode_to_disk(
 	}
 }
 
+static inline void
+xfs_to_log_timestamp(
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
@@ -367,12 +381,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	xfs_to_log_timestamp(&to->di_atime, &inode->i_atime);
+	xfs_to_log_timestamp(&to->di_mtime, &inode->i_mtime);
+	xfs_to_log_timestamp(&to->di_ctime, &inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -393,8 +404,7 @@ xfs_inode_to_log_dinode(
 
 	if (from->di_version == 3) {
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		xfs_to_log_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;

