Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71701C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51262207EA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kBzTQ8dr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHaGHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:07:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36678 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:07:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5sxwk113742;
        Mon, 31 Aug 2020 06:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Rv3kLWOUiST+QofgUvEIMGI5wGybUf9kqE6lDdClLtg=;
 b=kBzTQ8drKX6DYQQoJVGUnIJxqpQ8nsAMuiqP2HsHCRP8r+deYD0GHc1PqG6tHqBj1iqz
 l076K4KOnP9FJutBGG41TqJchzlSrxdyNsESRl9eTk2OhC+GPD/MU0mE2yyiePk6bAQG
 zAUZdUETyX+F9yAhE7t4KNWBhJF6alHZ/+7iNbSZfGCwBqUGMm9OQaj3BY27uXwXaCqH
 8qMTL6Xc11d8PwFchE5VktTCEcS5w6toX7QMxIQqf3quHndtXY/AGBRzDarXn8l2v7Mz
 zDT+bXJoUcTUdbsRJEx5rP5xQJJ+6rybvdxSwX2YgFZFqloCCuAljvkJG8auMswCcVFA 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqmc0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:07:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5tcXa123901;
        Mon, 31 Aug 2020 06:07:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3380xu99ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:07:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07V67TVn003505;
        Mon, 31 Aug 2020 06:07:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:07:29 -0700
Subject: [PATCH 07/11] xfs: redefine xfs_ictimestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:07:33 -0700
Message-ID: <159885405305.3608006.13513560786992998269.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redefine xfs_ictimestamp_t as a uint64_t typedef in preparation for the
bigtime functionality.  Preserve the legacy structure format so that we
can let the compiler take care of the masking and shifting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h  |    7 +++++--
 fs/xfs/xfs_inode_item.c         |   30 ++++++++++++++++++++++--------
 fs/xfs/xfs_inode_item_recover.c |    6 ++++--
 fs/xfs/xfs_ondisk.h             |    3 ++-
 4 files changed, 33 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e3400c9c71cd..8bd00da6d2a4 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -368,10 +368,13 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-typedef struct xfs_ictimestamp {
+typedef uint64_t xfs_ictimestamp_t;
+
+/* Legacy timestamp encoding format. */
+struct xfs_legacy_ictimestamp {
 	int32_t		t_sec;		/* timestamp seconds */
 	int32_t		t_nsec;		/* timestamp nanoseconds */
-} xfs_ictimestamp_t;
+};
 
 /*
  * Define the format of the inode core that is logged. This structure must be
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6c65938cee1c..c1be13ca64b9 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,24 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+/*
+ * Convert an incore timestamp to a log timestamp.  Note that the log format
+ * specifies host endian format!
+ */
+static inline xfs_ictimestamp_t
+xfs_inode_to_log_dinode_ts(
+	const struct timespec64		tv)
+{
+	struct xfs_legacy_ictimestamp	*lits;
+	xfs_ictimestamp_t		its;
+
+	lits = (struct xfs_legacy_ictimestamp *)&its;
+	lits->t_sec = tv.tv_sec;
+	lits->t_nsec = tv.tv_nsec;
+
+	return its;
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -313,12 +331,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	to->di_atime = xfs_inode_to_log_dinode_ts(inode->i_atime);
+	to->di_mtime = xfs_inode_to_log_dinode_ts(inode->i_mtime);
+	to->di_ctime = xfs_inode_to_log_dinode_ts(inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -340,8 +355,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		to->di_crtime = xfs_inode_to_log_dinode_ts(from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 03fab432df38..4e895c9ad4d7 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -121,11 +121,13 @@ xfs_log_dinode_to_disk_ts(
 	const xfs_ictimestamp_t		its)
 {
 	struct xfs_legacy_timestamp	*lts;
+	struct xfs_legacy_ictimestamp	*lits;
 	xfs_timestamp_t			ts;
 
 	lts = (struct xfs_legacy_timestamp *)&ts;
-	lts->t_sec = cpu_to_be32(its.t_sec);
-	lts->t_nsec = cpu_to_be32(its.t_nsec);
+	lits = (struct xfs_legacy_ictimestamp *)&its;
+	lts->t_sec = cpu_to_be32(lits->t_sec);
+	lts->t_nsec = cpu_to_be32(lits->t_nsec);
 
 	return ts;
 }
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 4e5f51d07d8d..cfa54d6b7c11 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -122,7 +122,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_ictimestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_ictimestamp_t,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_ictimestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);

