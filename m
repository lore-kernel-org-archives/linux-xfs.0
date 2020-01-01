Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A58C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A4EF206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NCbJw0x7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAABPe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABPe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FXHd113308
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zjszPaH+rlIn9f8kElfwsK+LDqAGENPxjBJ50VckY0s=;
 b=NCbJw0x7B37LBv97KxwobMek3n/nlvlCOsmDydk+oQm7Krhqw8EdTXTobHljAQY6Oahp
 ///uQu2Ch2kloSevnlhU56d/O5d3XH6yrfz0OnurOiw3pUk+Si7gGpFPMWiOZQ4utPAk
 DtvENhsIBROtI3npyJc1r+1n02NoAxQ0jvjx4YeH87mDCG9witb+3A4+HDEq4KDd4ou2
 iYgb74skytH2hBqXM6rn1/XDq4tC6MSeWkIY11SIedcsVr4ijmB8eEtyTf/KMKtXVXi/
 rezmIqIkfm/REkvqgBfbaunu21IBbXSkb9bS6CLYdUlGwhAbZEMuSSjER8YRiWxm/97R zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uOm190233
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrg3yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011FVUr029944
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:31 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:31 -0800
Subject: [PATCH 06/13] xfs: define the on-disk format for the metadir feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:28 -0800
Message-ID: <157784132892.1366873.9554440811184160170.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
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
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define the on-disk layout and feature flags for the metadata inode
directory feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   28 ++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.h         |    5 +++++
 fs/xfs/xfs_super.c         |    4 ++++
 3 files changed, 35 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f2f4f07b9357..8352bc921a9e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -175,6 +175,14 @@ typedef struct xfs_sb {
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	/*
+	 * Metadata Directory Inode.  On disk this lives in the sb_rbmino slot,
+	 * but we continue to use the in-core superblock to cache the classic
+	 * inodes (rt bitmap; rt summary; user, group, and project quotas) so
+	 * we cache the metadir inode value here too.
+	 */
+	xfs_ino_t	sb_metadirino;
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -193,7 +201,14 @@ typedef struct xfs_dsb {
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	__be64		sb_logstart;	/* starting block of log if internal */
 	__be64		sb_rootino;	/* root inode number */
-	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
+	/*
+	 * bitmap inode for realtime extents.
+	 *
+	 * The metadata inode directory feature uses the sb_rbmino field to
+	 * point to the root of the metadata directory tree.  All other sb
+	 * inode pointers are cancelled.
+	 */
+	__be64		sb_rbmino;
 	__be64		sb_rsumino;	/* summary inode for rt bitmap */
 	__be32		sb_rextsize;	/* realtime extent size, blocks */
 	__be32		sb_agblocks;	/* size of an allocation group */
@@ -468,6 +483,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
+#define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 4)	/* metadata ino dir */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -568,6 +584,12 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
 }
 
+static inline bool xfs_sb_version_hasmetadir(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
 /*
  * end of superblock version macros
  */
@@ -1128,15 +1150,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_METADATA_BIT 4	/* filesystem metadata */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_METADATA	(1 << XFS_DIFLAG2_METADATA_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_METADATA)
 
 /*
  * Inode number format:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index efc28b47578a..02bacc0e5466 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -180,6 +180,11 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_METADATA;
+}
+
 bool xfs_is_always_cow_inode(struct xfs_inode *ip);
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0dd6bc7b82c1..3ebd66347df0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1635,6 +1635,10 @@ xfs_fc_fill_super(
 		}
 	}
 
+	if (xfs_sb_version_hasmetadir(&mp->m_sb))
+		xfs_warn(mp,
+"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,

