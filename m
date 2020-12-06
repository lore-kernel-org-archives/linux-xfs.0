Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC8EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F3D23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgLFXKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5hU8182039;
        Sun, 6 Dec 2020 23:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+vi8LhqDjYnbUp3QPLL3nELgDeaa/0TTBjGAkKFTRQs=;
 b=h70y9ebVGvvmdmsmbj9SUKpKT7lLFJnPcin1yhVQHukirUL5c66TLPLT+sTFiPNtlZET
 vNItGYhH4wnGN69XoElpgdrLVRc1xmSBEmRBaVXG0mhF1qu+suPdwf6v9KOTE9MFxNRP
 69dR5UB4WllY7lcl+N3JmNn0+1iIjvzSeNMPgjoeGJ4AOLeEigLzrpS5RCHNAAOindnw
 2yYI3cI1Wdbl0TGB+Xx5SLaZ+r28HRv2+ddU1rOQ4+UHf/IQYSX1OCbTxSD6/TTwcXsX
 Kuds+7TCOx+JYhStCZtbANkVl8iDi7rOuBIn8ihWwkVSfFI+TfYRzigRatS+F7xkBJYf vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktug1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:09:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6csf193099;
        Sun, 6 Dec 2020 23:09:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vpcn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:09:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6N9Ygr011251;
        Sun, 6 Dec 2020 23:09:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:09:34 -0800
Subject: [PATCH 2/3] xfs: define a new "needrepair" feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net, bfoster@redhat.com,
        david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:09:33 -0800
Message-ID: <160729617344.1606994.3329458995178500981.stgit@magnolia>
In-Reply-To: <160729616025.1606994.13590463307385382944.stgit@magnolia>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=2 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/xfs_super.c         |    7 +++++++
 2 files changed, 14 insertions(+)


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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 599566c1a3b4..36002f460d7c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1467,6 +1467,13 @@ xfs_fc_fill_super(
 #endif
 	}
 
+	/* Filesystem claims it needs repair, so refuse the mount. */
+	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
+		error = -EFSCORRUPTED;
+		goto out_free_sb;
+	}
+
 	/*
 	 * Don't touch the filesystem if a user tool thinks it owns the primary
 	 * superblock.  mkfs doesn't clear the flag from secondary supers, so

