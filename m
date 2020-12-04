Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467E5C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD34224BE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgLDBPS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:15:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59458 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:15:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419me5187996;
        Fri, 4 Dec 2020 01:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n6OUntal9srBdc73fs9P+Jp4OgQsyU9p7sjixjRiFkg=;
 b=UdMnedFZ4Radea22tEtpau85rRklizgSVZZUyCcC61VAilr1nvJJaOcT4zzqYZFwsaHa
 AD0NuG1njryrGAvxNZpMM8xBJ2aZ9oGNgGO4MmCN5AQLLK5vRnUZ6W64V5mSJmD9k8ua
 nYX480CJdvmKEsuldT85VvoTrZxtevgHy7PCTUYWHsSJiPYo4HfAMQwVd7/5xP6rPfBK
 oJyDeSrX+OxyDx8Joh515EKG/5vX/rrUVltNwfP4OeCogsqI0MZwkNAsFX34/caZMYvy
 ae/fEcM7Usu+aaLIlUBPm04hhMWKkuYVnm9B8jKwwZYAl5cxa1TagUOxCbOlkjd8q6TB Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2b9372-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:12:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41BSPR157324;
        Fri, 4 Dec 2020 01:12:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g2sw5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:12:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B41CVHr025324;
        Fri, 4 Dec 2020 01:12:31 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:12:31 -0800
Subject: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:12:30 -0800
Message-ID: <160704435080.734470.11175993745850698818.stgit@magnolia>
In-Reply-To: <160704429410.734470.15640089119078502938.stgit@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The bmap, rmap, and refcount log intent items were added to support the
rmap and reflink features.  Because these features come with changes to
the ondisk format, the log items aren't tied to a log incompat flag.

However, the log recovery routines don't actually check for those
feature flags.  The kernel has no business replayng an intent item for a
feature that isn't enabled, so check that as part of recovered log item
validation.  (Note that kernels pre-dating rmap and reflink will fail
the mount on the unknown log item type code.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     |    4 ++++
 fs/xfs/xfs_refcount_item.c |    3 +++
 fs/xfs/xfs_rmap_item.c     |    3 +++
 3 files changed, 10 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 78346d47564b..4ea9132716c6 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,6 +425,10 @@ xfs_bui_validate(
 {
 	struct xfs_map_extent		*bmap;
 
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    !xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8ad6c81f6d8f..2b28f5643c0b 100644
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
index f296ec349936..2628bc0080fe 100644
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
 

