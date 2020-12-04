Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123BCC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD2D6224B1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgLDBMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:12:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57602 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387518AbgLDBMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:12:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41B29V188991;
        Fri, 4 Dec 2020 01:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fY4MkjcUeyopx4QNRqFaJVCeNYAFabuMM7XtmqEzQzY=;
 b=joh8aaoW3XERiHcStDUDrI7IWfpp6tkwpDWP0bTz7f5Ff7KJlFGycET5sSQodTi8e4gP
 JG9lA3KhJLy3izc4rXsviYeEGii77XGwq+BoCzwQ/0qbuz4JxgWAkLq74b/7f/EBrUGS
 B2iJxr8T4pYjMV2VynQjhUCYqU14+A6B1r8GmgPiVg6+X8jnd0cDafmxuTgRYDWbEX31
 vr7Os1AdPNnFiBgs+6YtJxzMUufyDcEvQTKJJ/sL6VNuUEdm/ZHU9JsbaghlEur0UM43
 pHcOqC0peYWQKR8j7v/9KFdJzAdNoLcdg5+kyBxoU1Sg9jM9L/tZM6iiVJjtrul5Q7ND QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b9359-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:11:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AXJq093349;
        Fri, 4 Dec 2020 01:11:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404rn62y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:11:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41BlZw002251;
        Fri, 4 Dec 2020 01:11:47 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:11:47 -0800
Subject: [PATCH 02/10] xfs: improve the code that checks recovered bmap intent
 items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:11:46 -0800
Message-ID: <160704430659.734470.2948483798298982986.stgit@magnolia>
In-Reply-To: <160704429410.734470.15640089119078502938.stgit@magnolia>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

The code that validates recovered bmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 555453d0e080..78346d47564b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -424,18 +424,12 @@ xfs_bui_validate(
 	struct xfs_bui_log_item		*buip)
 {
 	struct xfs_map_extent		*bmap;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 
 	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -448,13 +442,19 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+	if (!xfs_verify_ino(mp, bmap->me_owner))
+		return false;
+
+	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+		return false;
+
+	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
 		return false;
 
 	return true;

