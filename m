Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7881BC64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0844720796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ya+HhOdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgLADjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:39:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgLADjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:39:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TFpF169926
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Fxhd5wbjpxLy1O1G9bZANqcSqxlhUX/5RTc6MquzKU0=;
 b=Ya+HhOdGkn3mpldUtFI5BZXuysoeMi/fIKOOqiyVimSS8IXcetoA8OhBlrkcBx5MlFUA
 V6LjnxwvfYGSM7tXfB3SQflIhzKVryMjxM02E2D1eg2ht2x29wS3nMoRQ2V1skNMBCgm
 mMo4RB3lh9gubqDHhMu8JHjoQZNRwKawpNqe862y7O4hiexszHDuGRESb6jWNHdkzKTj
 0I79p8FAL75StB6pETeT95/FouXq/QTPNpGJVfaCdB8PyEVjSRYjHb7BJdiM0ZWDA/1g
 XD3fMY0J1pkFyeX1w3QlmJjT2Ru267CT1A5RG+ixOp13hydqcW9mBXBr8FSqTKD9E2m/ rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqge0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13U3r4134142
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540exd35e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:38:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B13cadI018665
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:38:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:38:36 -0800
Subject: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:38:34 -0800
Message-ID: <160679391475.447963.3291546751575520166.stgit@magnolia>
In-Reply-To: <160679385987.447963.9630288535682256882.stgit@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The bmap, rmap, and refcount log intent items were added to support the
rmap and reflink features.  Because these features come with changes to
the ondisk format, the log items aren't tied to a log incompat flags.

However, the log recovery routines don't actually check for those
feature flags.  The kernel has no business replayng an intent item for a
feature that isn't enabled, so check that as part of recovered log item
validation.  (Note that kernels pre-dating rmap and reflink will fail
the mount on the unknown log item type code.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |    4 ++++
 fs/xfs/xfs_refcount_item.c |    3 +++
 fs/xfs/xfs_rmap_item.c     |    3 +++
 3 files changed, 10 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 19f89a6b65a1..f36005c999b2 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -426,6 +426,10 @@ xfs_bui_validate(
 	struct xfs_map_extent		*bmap;
 	xfs_fsblock_t			end;
 
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    !xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 20e5c22bb754..2017108b37a1 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -425,6 +425,9 @@ xfs_cui_validate_phys(
 {
 	xfs_fsblock_t			end;
 
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
 	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
 		return false;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2779cbee8fa8..13871882ffb6 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -468,6 +468,9 @@ xfs_rui_validate_map(
 {
 	xfs_fsblock_t			end;
 
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return false;
+
 	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
 		return false;
 

