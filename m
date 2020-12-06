Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850D8C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF6323120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgLFXKz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N7udG186996;
        Sun, 6 Dec 2020 23:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WjatYXdjGjHFC11n/o0vJROuXGcjCTaJGgZ8p/4K9Y4=;
 b=esd6RZT9wUegEoS287r2cG1TO/PRcMK+8Rs4lhyGl+RvSJWFrpTFxKiTN0XuBCVFOkmE
 ZHB4XiaE3mrLyAfI4klxnqIbcMmxYrvP3y7ifXAXBTQY4BF7ZrF/XK3frFkdRDO9Zl/i
 pBc0Zsc8QYKCV9ajWOHqFfa2BkK049321HXC/kvTMoMUjU7cZhvDRYqF0n0MxBtLCKkj
 aAlgWWcjAeHdjyCrvexVj/2vRb6uDtneoczzv/Vy34erA914kbUNAYktgKwWk9BGmiZn
 cBzSQjjVyu56RAor3WRnHLw6K4u4U/ENBilDBoItDI3qonrCulbIRy9rQh8pcz3Ux4kq 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqjvhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5bHS120610;
        Sun, 6 Dec 2020 23:10:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 358m4v64ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6NAB3O007234;
        Sun, 6 Dec 2020 23:10:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:11 -0800
Subject: [PATCH 04/10] xfs: improve the code that checks recovered rmap intent
 items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:10 -0800
Message-ID: <160729621015.1607103.17158719742514505957.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code that validates recovered rmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_rmap_item.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 19d2dc285ed6..6f3250a22093 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +478,25 @@ xfs_rui_validate_map(
 	case XFS_RMAP_EXTENT_CONVERT_SHARED:
 	case XFS_RMAP_EXTENT_ALLOC:
 	case XFS_RMAP_EXTENT_FREE:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    rmap->me_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    rmap->me_len >= mp->m_sb.sb_agblocks ||
-	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+
+	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
+	    !xfs_verify_ino(mp, rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
 		return false;
 
 	return true;

