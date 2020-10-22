Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00926C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 18:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F11A24641
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 18:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjar6Tu8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368845AbgJVSqz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 14:46:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35368 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899798AbgJVSqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 14:46:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MITbFI017457;
        Thu, 22 Oct 2020 18:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=XxFbqvkl0jKbhGW2cKx2b95ZMsn78jna7Gq4oz866Ow=;
 b=cjar6Tu8EeazFhshG0bLTcQ8tsLcShxaJljNdpd3xoNDBQNe3Q9jiIHXLpqjJf+IehWC
 3fsKW5Vv/98yxcVeBOAwkod4M08TgGtr9YhmnKU9ZaMNdir8mYKywXq16wL/1GNJgszh
 xZ3PoUZbDhDwh4ZGYKbj9x+foybMTgorZ8mN1y4mNkSRgfq2//+P1PIZNxTVH6RWrRmR
 JBdt2atD3dojJkr8yS3dHT73dKoImW1d5WBpvgKJJGrhO2gF2yGsLjXYIyzVmedTGXBI
 IzFBg/VZGKLJYNLCfWdSRrrosC6GsvWQI61RRCaOgi/qo/Q03aLSaMOOHx1PTgb5GhGd mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4b7pra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 18:46:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MITjtH075034;
        Thu, 22 Oct 2020 18:46:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 348ah15y7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 18:46:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MIkoOX007149;
        Thu, 22 Oct 2020 18:46:50 GMT
Received: from localhost (/10.159.228.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 11:46:50 -0700
Date:   Thu, 22 Oct 2020 11:46:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: set xefi_discard when creating a deferred agfl free log
 intent item
Message-ID: <20201022184649.GT9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=5 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that we actually initialize xefi_discard when we're scheduling
a deferred free of an AGFL block.  This was (eventually) found by the
UBSAN while I was banging on realtime rmap problems, but it exists in
the upstream codebase.  While we're at it, rearrange the structure to
reduce the struct size from 64 to 56 bytes.

Fixes: fcb762f5de2e ("xfs: add bmapi nodiscard flag")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    1 +
 fs/xfs/libxfs/xfs_bmap.h  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 852b536551b5..15640015be9d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2467,6 +2467,7 @@ xfs_defer_agfl_block(
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
+	new->xefi_skip_discard = false;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e1bd484e5548..6747e97a7949 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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
