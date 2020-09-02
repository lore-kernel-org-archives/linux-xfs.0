Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192EFC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C042087E
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkTR9HO2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIBC53 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:57:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgIBC50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:57:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822sP6Y089794;
        Wed, 2 Sep 2020 02:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v55OvaeLmar4Wj3GtLMLJlfmlkMJ2Al9DLeie3+pwjM=;
 b=BkTR9HO2u8ypa16r3WKZDVenhewaEWgvriX1CqEDANoW+cIGvRltv8999Lad3k/WlQyB
 fiQO1efQaRSEex7j5o+tnhUmxvOY2fLrbQoNawvzSyuE4QFAcMBunY96vPJNgYpoNPJR
 R9leaUXGF6sSiCG4NJOj+dVyR2Hf0q15j/8knDiDBYas1VEUXvZLPmkD9BHMJAl+MEON
 B/G51DCxopNGBqULkAN7WJVxa3Ld+FmDCVMuVW5KAZFTnFAYi2LXEMUTNX/yF+TdA4LI
 ezepn6O89ECS4QLV4E0XSXgw1xcOUGsnCgWiEZKUoVOO1JI33ftC53/DCa/XRqqNGZWD VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eym7sv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:57:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822sbW9131813;
        Wed, 2 Sep 2020 02:57:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x58gr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:57:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822vIr3028518;
        Wed, 2 Sep 2020 02:57:18 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:57:18 -0700
Subject: [PATCH 07/11] xfs: redefine xfs_ictimestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Tue, 01 Sep 2020 19:57:16 -0700
Message-ID: <159901543615.548109.11336095414072971331.stgit@magnolia>
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redefine xfs_ictimestamp_t as a uint64_t typedef in preparation for the
bigtime functionality.  Preserve the legacy structure format so that we
can let the compiler take care of the masking and shifting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
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

