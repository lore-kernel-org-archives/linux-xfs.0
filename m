Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDA0C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE72C20874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oWnKeoAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407310AbgJZXjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:39:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407284AbgJZXjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:39:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQusr158977;
        Mon, 26 Oct 2020 23:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PDHR+8MCXOBuQOtWwL3UA/MrpNjkObNIjc5McBz2Pos=;
 b=oWnKeoAXNbMaL0gwcGyRy5t7XPJAARvCZPOdVhYSvapucNYlA92MG3lUIjnU6qs47p6w
 nhs3jOQL1UJ1GdDxm/P6Fvd91wkQ0resskXD68ig64KKbrlBl/Du+r8kZdc+36YkUUQO
 Nf90U4Bxlz2HOmNJxIRAKyZ5cchcsXcEBLjbBb4YU9GTBSTjon3Zz/GojxeRxNtkZQHH
 xLY/o5KKXhbXGbvFPf5ZKC4ve5sAFx1MnHQezJl0enRXL8drNXnLxUmZF6oQDicssPOP
 BfnFXY6t6+lYmsEGwQmaItmAfWUTULALYcKQjUilhzkGj7EalkzC/rDJOeeWNAFa+Y+2 rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:39:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQPDn058494;
        Mon, 26 Oct 2020 23:39:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukrap1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:39:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNdAkt014530;
        Mon, 26 Oct 2020 23:39:10 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:39:10 -0700
Subject: [PATCH 21/21] xfs: set xefi_discard when creating a deferred agfl
 free log intent item
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:39:09 -0700
Message-ID: <160375554961.882906.11703878041965365139.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we actually initialize xefi_discard when we're scheduling
a deferred free of an AGFL block.  This was (eventually) found by the
UBSAN while I was banging on realtime rmap problems, but it exists in
the upstream codebase.

Fixes: fcb762f5de2e ("xfs: add bmapi nodiscard flag")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |    1 +
 libxfs/xfs_bmap.h  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 93043d5927a3..92f61fae4a70 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2463,6 +2463,7 @@ xfs_defer_agfl_block(
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
+	new->xefi_skip_discard = false;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index e1bd484e5548..6747e97a7949 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -52,9 +52,9 @@ struct xfs_extent_free_item
 {
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
+	bool			xefi_skip_discard;
 	struct list_head	xefi_list;
 	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
-	bool			xefi_skip_discard;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4

