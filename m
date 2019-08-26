Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FB0C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C8A217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qhqZ5bYW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfHZVto (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLnTLY029790
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9ewrBE9AzCtghqdDJlF7/yquoWQSuNfW6fZw/pLAi/A=;
 b=qhqZ5bYW/4lcXgQo+lI/KU+l6PqipsLJhidp7Ckt9OQKU/uY5fD+MCNo6zCi46/kiCf8
 rX9BGhlfQU5qpKJ69xaT3lTVakCgUepXXfghC5y8/xCcLu9l8n8GoYcUDmAjSx6umlsc
 GOEJldhYMmSN3S1j3ZMnyBgJaz/1adt8M9kiLwxRnD9x0BmsFS1mg8qnRcWldtvt2Gh8
 vELh4UxwNjHZJabKHMOPLBLS8pbuGiXYEgDKCaKk98AIdTeSyJK0pHCBXRTkpCa7Mm2Z
 b1y+2X38CA4iAMhudTfyiPkWwtVl8Pxr97PPxlKFoPNFfxLhcAQk2KM33NNjHdxTq9YT bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx083c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmCwE093701
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2umj1tm5k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:42 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLnfsq017327
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:41 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:40 -0700
Subject: [PATCH 4/5] xfs: remove unnecessary int returns from deferred bmap
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:49:40 -0700
Message-ID: <156685618004.2853674.8675927096254274691.stgit@magnolia>
In-Reply-To: <156685615360.2853674.5160169873645196259.stgit@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the return value from the functions that schedule deferred bmap
operations since they never fail and do not return status.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   12 ++++++------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_item.c   |    4 +---
 fs/xfs/xfs_bmap_util.c   |   16 ++++------------
 fs/xfs/xfs_reflink.c     |    8 ++------
 5 files changed, 15 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e0cbe73ebf04..fb0da409f143 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6085,29 +6085,29 @@ __xfs_bmap_add(
 }
 
 /* Map an extent into a file. */
-int
+void
 xfs_bmap_map_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*PREV)
 {
 	if (!xfs_bmap_is_update_needed(PREV))
-		return 0;
+		return;
 
-	return __xfs_bmap_add(tp, XFS_BMAP_MAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_MAP, ip, XFS_DATA_FORK, PREV);
 }
 
 /* Unmap an extent out of a file. */
-int
+void
 xfs_bmap_unmap_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*PREV)
 {
 	if (!xfs_bmap_is_update_needed(PREV))
-		return 0;
+		return;
 
-	return __xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, XFS_DATA_FORK, PREV);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 8f597f9abdbe..c409871a096e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -254,9 +254,9 @@ int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
 		enum xfs_bmap_intent_type type, int whichfork,
 		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
 		xfs_filblks_t *blockcount, xfs_exntst_t state);
-int	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
-int	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
 
 static inline int xfs_bmap_fork_to_state(int whichfork)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9fa4a7ee8cfc..c9d1903aee3e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -542,9 +542,7 @@ xfs_bui_recover(
 		irec.br_blockcount = count;
 		irec.br_startoff = bmap->me_startoff;
 		irec.br_state = state;
-		error = xfs_bmap_unmap_extent(tp, ip, &irec);
-		if (error)
-			goto err_inode;
+		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 98c6a7a71427..e12f0ba7f2eb 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1532,24 +1532,16 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			/* Remove the mapping from the donor file. */
-			error = xfs_bmap_unmap_extent(tp, tip, &uirec);
-			if (error)
-				goto out;
+			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
 			/* Remove the mapping from the source file. */
-			error = xfs_bmap_unmap_extent(tp, ip, &irec);
-			if (error)
-				goto out;
+			xfs_bmap_unmap_extent(tp, ip, &irec);
 
 			/* Map the donor file's blocks into the source file. */
-			error = xfs_bmap_map_extent(tp, ip, &uirec);
-			if (error)
-				goto out;
+			xfs_bmap_map_extent(tp, ip, &uirec);
 
 			/* Map the source file's blocks into the donor file. */
-			error = xfs_bmap_map_extent(tp, tip, &irec);
-			if (error)
-				goto out;
+			xfs_bmap_map_extent(tp, tip, &irec);
 
 			error = xfs_defer_finish(tpp);
 			tp = *tpp;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eae128ea0c12..0f08153b4994 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -676,9 +676,7 @@ xfs_reflink_end_cow_extent(
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
-	error = xfs_bmap_map_extent(tp, ip, &del);
-	if (error)
-		goto out_cancel;
+	xfs_bmap_map_extent(tp, ip, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
@@ -1068,9 +1066,7 @@ xfs_reflink_remap_extent(
 		xfs_refcount_increase_extent(tp, &uirec);
 
 		/* Map the new blocks into the data fork. */
-		error = xfs_bmap_map_extent(tp, ip, &uirec);
-		if (error)
-			goto out_cancel;
+		xfs_bmap_map_extent(tp, ip, &uirec);
 
 		/* Update quota accounting. */
 		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,

