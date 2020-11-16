Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD19C63777
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4225822240
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 21:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n2S8Uenv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKPVPW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:15:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47788 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgKPVPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Nov 2020 16:15:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGLAjGe044072;
        Mon, 16 Nov 2020 21:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ea4punyrawAksnRAioU2ZQ7F6+yVCNq76lc/Z7YtF1Q=;
 b=n2S8Uenve4fe/PZ/FcmmMFpBEjq7gtCaxsXgghXIXZPKahLxNVfPwdeUjGu1WCWO5L0S
 sFPBESMqDxaxjFnaLw1oSKJpLII5/uN+V9jn0H4G1fNAFTU5JOr1c0q1c+rP4Xcq8xDB
 PElhjjWwi9ZGsWh/sh28VmxGNu9TAYMyf1sk8wa2M3vHF3tm2WKJIvkhF/vn3MZZ3lkI
 /vJTVettM1eId4l/fVNoTk2WjGmD+tVOBBejDBRdYiUFxhf8A9GnbmwLYbwwcrJOfpQO
 77/AxLkX94ZMgijLFNVcKxsBOPJJYU8cu292/10ukkd8L7+uqe2wPq9bXDxfVwjarcXs 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34t4raqgm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Nov 2020 21:15:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AGLBExQ030676;
        Mon, 16 Nov 2020 21:15:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34umcxa4na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 21:15:16 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AGLFA9w002344;
        Mon, 16 Nov 2020 21:15:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 13:15:10 -0800
Date:   Mon, 16 Nov 2020 13:15:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH v2 22/26] xfs_db: add bigtime upgrade path
Message-ID: <20201116211509.GU9695@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375538851.881414.17245799256703762517.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375538851.881414.17245799256703762517.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=3 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: rebase patch since the main feature upgrade patch got changed
slightly
---
 db/sb.c              |   15 +++++++++++++++
 man/man8/xfs_admin.8 |    5 +++++
 2 files changed, 20 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 3608508a7eb8..f66907e69da6 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -848,6 +848,21 @@ version_f(
 			}
 
 			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "bigtime")) {
+			if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature is already enabled\n"));
+				exitcode = 1;
+				return 1;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 1;
+				return 1;
+			}
+
+			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 65ca6afc1e12..c09fe62b6827 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -117,6 +117,11 @@ This reduces mount time by caching the size of the inode btrees in the
 allocation group metadata.
 Once enabled, the filesystem will not be writable by older kernels.
 The filesystem cannot be downgraded after this feature is enabled.
+.TP
+.B bigtime
+Upgrade the filesystem to support larger timestamps up to the year 2486.
+Once enabled, the filesystem will not be readable by older kernels.
+The filesystem cannot be downgraded.
 .RE
 .TP
 .BI \-U " uuid"
