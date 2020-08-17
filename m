Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB23C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1939D20772
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a54o/VR2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgHQW7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgHQW7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvu3s052952;
        Mon, 17 Aug 2020 22:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r30fz7G7K05P5NWToFQcuw5JOLHx2Qe9qsPAqc6+x+w=;
 b=a54o/VR2lDuq4/x7dE3guvsDJ9h21PMTPKs5oSwFh6aJ/LVStC4JE1Pt/09F3SDEY6BK
 kznoftrCnDkLXoFAEDG9qtOuI8FOiAcJBiKOU4HGYavkERNTeX9e5KSXwwe3D+Pcov+F
 VXfUKC8vTX9mUAtG+PKB3RKcSNNnwnq36mVb7FW2gCT+Ba4lsl3fHQn36HLYeUjob4EF
 6nyhR0UJf2x9HEmAjtJkOabrrXpirIJq0t+FnMTw+ADR60qjBeq25rfjVzlft/o7zk+3
 dvm/r0wLt61jXidlLPk0qY67iFleG6CSaPyVJd1WEuh6o2fljgxWseMcW+uFZ0GWnrwj CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32x7nm9js7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwtKM113566;
        Mon, 17 Aug 2020 22:59:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32xsmwgh18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMxdEn017478;
        Mon, 17 Aug 2020 22:59:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:38 -0700
Subject: [PATCH 07/18] xfs: refactor inode timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:37 -0700
Message-ID: <159770517786.3958786.15888272976594846679.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=988 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=982
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor inode timestamp encoding and decoding into helper functions so
that we can add extra behaviors in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_inode_buf.c |   42 ++++++++++++++++++++++++++----------------
 libxfs/xfs_inode_buf.h |    5 +++++
 2 files changed, 31 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index ecb9abd82a3e..9f7309f9a576 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -158,6 +158,15 @@ xfs_imap_to_bp(
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
@@ -212,12 +221,9 @@ xfs_inode_from_disk(
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
@@ -230,8 +236,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -253,6 +258,15 @@ xfs_inode_from_disk(
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
@@ -272,12 +286,9 @@ xfs_inode_to_disk(
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
@@ -296,8 +307,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..9c63f3f932d7 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -58,4 +58,9 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
+		const struct xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const struct timespec64 *tv);
+
 #endif	/* __XFS_INODE_BUF_H__ */

