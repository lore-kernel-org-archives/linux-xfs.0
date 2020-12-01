Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA7EC83011
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E74C207FF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z4xomTVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgLADiP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TjIl066001;
        Tue, 1 Dec 2020 03:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LfH7ML5hvF37a0vB3N3W8myAMXUEs0/WbOa+YC/I5EU=;
 b=Z4xomTVtKA3ncnTmlf914esE7OWXNGtqmajZaZJHnCQpHSXAJ6xlvXOX31lIGukWIX2q
 2pgCi9Bs/yJbCrgUR40qu6DZ1T52o8pafmosgJ6Z4Rs/CrnDjzqQ4u1UKrdH+T3YEtCC
 HNQyPmv6OXbCl/dQyoiLMouNUGb4JcimQwioij0tsjscVduGZxm1g6ktPkQalY4Wxv/A
 ZqXKUC3aB4c5U0xbWvJyPqiZXM3VIsvbWBQkfdG2MIrwWW2wy/23NZp7ruPEyGfs0cw2
 PDNavtMMBmAxAYXXofivt1zGEBV7UZ/ZpUhoDZUcY0bbGHKdz7N1jU/yeo4ICbhTSxHm vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2arhkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 03:37:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UOF6160869;
        Tue, 1 Dec 2020 03:37:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404mbvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 03:37:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13bW1V004991;
        Tue, 1 Dec 2020 03:37:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:32 -0800
Subject: [PATCH 2/3] xfs: define a new "needrepair" feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:31 -0800
Message-ID: <160679385127.447856.3129099457617444604.stgit@magnolia>
In-Reply-To: <160679383892.447856.12907477074923729733.stgit@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define an incompat feature flag to indicate that the filesystem needs to
be repaired.  While libxfs will recognize this feature, the kernel will
refuse to mount if the feature flag is set, and only xfs_repair will be
able to clear the flag.  The goal here is to force the admin to run
xfs_repair to completion after upgrading the filesystem, or if we
otherwise detect anomalies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/xfs_mount.c         |    6 ++++++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dd764da08f6f..5d8ba609ac0b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -468,6 +468,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
+#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -584,6 +585,12 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
 }
 
+static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7bc7901d648d..2853ad49b27d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -266,6 +266,12 @@ xfs_sb_validate_mount(
 	struct xfs_buf		*bp,
 	struct xfs_sb		*sbp)
 {
+	/* Filesystem claims it needs repair, so refuse the mount. */
+	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Don't touch the filesystem if a user tool thinks it owns the primary
 	 * superblock.  mkfs doesn't clear the flag from secondary supers, so

