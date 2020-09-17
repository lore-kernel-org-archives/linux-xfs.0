Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F5DC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22E92075E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j1dK2eUb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIQHIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:08:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIQHIK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:08:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H70OrM121140;
        Thu, 17 Sep 2020 07:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Njgb32f0KB2O7sqWRsHV6zBdN0Ol4jBlV+ZTUOrMohY=;
 b=j1dK2eUbZpRZCW0yjNjYbx73B5uZw6XF5n9Hxr+NCMuIMyKJbSNcAwzQq+a6wl2HrnlT
 jqUyusyFpRfFJhGH26GBMz8/ps9IGdFOi1im1AhSX0FVMmfcwUsXKE31M89Y7wCjNxAY
 8z4YEwGdojs1ahpta5g1r/rSXPcw/fpVz3GqxLrSdnGqt03/KimWErvwrCpo9vVtcMsi
 SW9dIiz+mSBN2kjjkMVSC+F6cwHYvQ2wq8xB1PMNYjfHT0o0smsqtkpjNNcpERO/hmiD
 MYEEV9TQbknrEjIhvUMJjJNBkFEvBwMAkvwTm03AtyUOByqSE3v//dHBIB2OnUIasVCi 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91drwru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 07:08:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H742vW103637;
        Thu, 17 Sep 2020 07:08:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33khpmky98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 07:08:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H783bS019019;
        Thu, 17 Sep 2020 07:08:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 07:08:03 +0000
Date:   Thu, 17 Sep 2020 00:08:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v2 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20200917070802.GW7955@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337657.3624582.4680281255744277782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031337657.3624582.4680281255744277782.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=5 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170051
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In most places in XFS, we have a specific order in which we gather
resources: grab the inode, allocate a transaction, then lock the inode.
xfs_bui_item_recover doesn't do it in that order, so fix it to be more
consistent.  This also makes the error bailout code a bit less weird.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix the error-out paths to free the BUI if the BUD hasn't been
created
---
 fs/xfs/xfs_bmap_item.c |   49 +++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 4e5aa29f75b7..f088cfd495bd 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -432,7 +432,7 @@ xfs_bui_item_recover(
 	struct xfs_inode		*ip = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
-	struct xfs_bud_log_item		*budp;
+	struct xfs_bud_log_item		*budp = NULL;
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
@@ -475,27 +475,26 @@ xfs_bui_item_recover(
 	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
 		goto garbage;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
-	if (error) {
-		xfs_bui_release(buip);
-		return error;
-	}
-
-	budp = xfs_trans_get_bud(tp, buip);
-
 	/* Grab the inode. */
-	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
 	if (error)
-		goto err_inode;
+		goto err_bui;
 
-	error = xfs_qm_dqattach_locked(ip, false);
+	error = xfs_qm_dqattach(ip);
 	if (error)
-		goto err_inode;
+		goto err_rele;
 
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	/* Allocate transaction and do the work. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	budp = xfs_trans_get_bud(tp, buip);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
@@ -503,7 +502,7 @@ xfs_bui_item_recover(
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
 	if (error)
-		goto err_inode;
+		goto err_cancel;
 
 	if (count > 0) {
 		ASSERT(bui_type == XFS_BMAP_UNMAP);
@@ -514,17 +513,21 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
+	/* Commit transaction, which frees tp. */
 	error = xlog_recover_trans_commit(tp, dfcp);
+	if (error)
+		goto err_unlock;
+	return 0;
+
+err_cancel:
+	xfs_trans_cancel(tp);
+err_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
 	xfs_irele(ip);
-	return error;
-
-err_inode:
-	xfs_trans_cancel(tp);
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-	}
+err_bui:
+	if (!budp)
+		xfs_bui_release(buip);
 	return error;
 garbage:
 	xfs_bui_release(buip);
