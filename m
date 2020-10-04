Return-Path: <SRS0=mrUW=DL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E68DC4363C
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F554206DD
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 19:09:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fpB3yFVT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgJDTJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:09:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJDTJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Oct 2020 15:09:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094J9mSc177768;
        Sun, 4 Oct 2020 19:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OsjkoI0gbQz6hIun3gmP/B3ufbC8KYy9HZaC9pEUCEw=;
 b=fpB3yFVTd+REScVYnxtip/nKCU8rtoAJlBs/OTRBDfsSNMnGP3cmUHHEOY0U6cQB0WLK
 fq9vjlq+YVf+X4PSYd7Vw2ulp8ej6nN+wjaXOyeLDnhiVzq5QymlqLy9p8YkOrfOKYMk
 KGhVbRV7cNpse9u/i72nD6TM0NuzWnApbaq9Psq8P+9FaEbC0a9NL7WGPzDSUjXSaLZc
 ZmDldvFe+rt5hSQ9x+l2Aa4Z43mhyCpPuhVQZ3lRXYThXgYNHBv9VbUgGiOJPyX0Nych
 39LfXwkgavJW98TmE1oL9D6FfiwYYibI/O8Ki21oqKzNfcm+bFOFrFoCQJqwB0JfW7lj RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym3480e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 04 Oct 2020 19:09:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 094J01IJ178997;
        Sun, 4 Oct 2020 19:09:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37u95t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 04 Oct 2020 19:09:46 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 094J9e2M010389;
        Sun, 4 Oct 2020 19:09:40 GMT
Received: from localhost (/10.159.155.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Oct 2020 12:09:39 -0700
Date:   Sun, 4 Oct 2020 12:09:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3.2 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20201004190939.GB49547@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144017.830434.9012644788797432565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140144017.830434.9012644788797432565.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010040145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9764 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010040146
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In most places in XFS, we have a specific order in which we gather
resources: grab the inode, allocate a transaction, then lock the inode.
xfs_bui_item_recover doesn't do it in that order, so fix it to be more
consistent.  This also makes the error bailout code a bit less weird.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v3.2: don't remove the iunlock/irele if the defer commit succeeds
---
 fs/xfs/xfs_bmap_item.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index c1f2cc3c42cb..852411568d14 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -475,25 +475,26 @@ xfs_bui_item_recover(
 	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
 		return -EFSCORRUPTED;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
-	if (error)
-		return error;
-
-	budp = xfs_trans_get_bud(tp, buip);
-
 	/* Grab the inode. */
-	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
 	if (error)
-		goto err_inode;
+		return error;
 
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
@@ -501,7 +502,7 @@ xfs_bui_item_recover(
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
 	if (error)
-		goto err_inode;
+		goto err_cancel;
 
 	if (count > 0) {
 		ASSERT(bui_type == XFS_BMAP_UNMAP);
@@ -512,17 +513,21 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
+	/* Commit transaction, which frees the transaction. */
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto err_unlock;
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-	return error;
+	return 0;
 
-err_inode:
+err_cancel:
 	xfs_trans_cancel(tp);
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-	}
+err_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
+	xfs_irele(ip);
 	return error;
 }
 
