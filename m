Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FACC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BF8238A1
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgLGS1M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:27:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLGS1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 13:27:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7I9rJv005403;
        Mon, 7 Dec 2020 18:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cMd8H5+hk11W2lpWshh1VEbW5uGQWWmQKvLg7S3E2y4=;
 b=EUxmK5e77O7b0dQjuhKf+SAi5N6rJfOpFiNmCGUitz/8k5sDA4yPewFosgTmNLYwvM2u
 1tja5kpUZr7bkB2bZfxiZ4uVoTdjciTR1QP1FaTcEbxV54i2OUWVhm+3FkR+clVe/zHU
 a7eP9XABAjJT/PJdJTKyXDgTiZI+/d0Eb4isT8fyp+aXPfbeGTuuRP2s3OrDl5C6J0fY
 gqcRw60d1MFkzjfx5CtDjLiD9E2Hm6NoNKOblQJYQHvkp5xkcxKigmyk8QOFHyLKAglY
 LTyFMTx5Ozc+wDrC/0ch0K6tsFCdPI1WYuOAYrcA+7nS1Zxpl37B7rv0SL95Idw6upsy xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqpt96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 18:26:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IAUcu177359;
        Mon, 7 Dec 2020 18:26:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m3wqf9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 18:26:25 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7IQPh9013489;
        Mon, 7 Dec 2020 18:26:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 10:26:24 -0800
Date:   Mon, 7 Dec 2020 10:26:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: [PATCH v3.1 09/10] xfs: validate feature support when recovering
 rmap/refcount intents
Message-ID: <20201207182623.GR629293@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
 <160729624155.1607103.14703148264133630631.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729624155.1607103.14703148264133630631.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070118
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The rmap, and refcount log intent items were added to support the rmap
and reflink features.  Because these features come with changes to the
ondisk format, the log items aren't tied to a log incompat flag.

However, the log recovery routines don't actually check for those
feature flags.  The kernel has no business replayng an intent item for a
feature that isn't enabled, so check that as part of recovered log item
validation.  (Note that kernels pre-dating rmap and reflink already fail
log recovery on the unknown log item type code.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3.1: drop the feature check for BUI validation for now
---
 fs/xfs/xfs_refcount_item.c |    3 +++
 fs/xfs/xfs_rmap_item.c     |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c24f2da0f795..937d482c9be4 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,6 +423,9 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
 	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
 		return false;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 6f3250a22093..9b84017184d9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,6 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return false;
+
 	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
 		return false;
 
