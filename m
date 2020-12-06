Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AE4C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4FF23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgLFXN3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:13:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58422 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgLFXN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:13:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5LkA020633;
        Sun, 6 Dec 2020 23:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vCMk2jy3llWe3iYS4Tk7q/0sOnInqAyRZRM6SdNEeD8=;
 b=demJTUwZjmGZqRX4zd4DPp5Mh77VryUfZ34B4qNOP2ZhyoRyED9Ghg2eqB5VeoDXWQuM
 azKddnQyW2JfB7WUl0NLm8dxm4JUTlNNdK3A9yoxwPz3G3RPx2xMd6CRBwmvk8KP8qN/
 SelP6vKRf4zHomVX9xu0iyp6h8Iq7xEkFq13dAubsWwvDnBpwczsNLfcNa+QNbIDwG6T
 fGv6KaC0Wp0Xc3l24/zKs/rDdCk447c55V774AWLMlriMtCGzxs9Mc0u0CT4O7c09E0a
 +7k5l0fdWPiqtjBip4dHdZ5fCU7sRA5wG5lxxhq8g5AqzW4V5JybEAlN/BrCvmzP7i4+ 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbk0ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:12:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAfqF138592;
        Sun, 6 Dec 2020 23:10:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyq6s2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NAh08021383;
        Sun, 6 Dec 2020 23:10:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:42 -0800
Subject: [PATCH 09/10] xfs: validate feature support when recovering
 rmap/refcount/bmap intents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:41 -0800
Message-ID: <160729624155.1607103.14703148264133630631.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
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
index a21a9f71c0c0..8d3ed07800f6 100644
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
 

