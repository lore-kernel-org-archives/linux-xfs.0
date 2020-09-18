Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5D3C43466
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A442238A0
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 02:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i3XHuunM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgIRC2A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:28:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729233AbgIRCP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 22:15:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I2E5Jw127495;
        Fri, 18 Sep 2020 02:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jKzds6bOxXvHdLUfA/ruoQVPofuBQhy72R0e6toYdC0=;
 b=i3XHuunM42C1HwOJ35MbjSUbhT5hYYvUTLflUvgZv6WN5ShW7/fDreSppt4UykZNuM9V
 WTXzTcFdAd81izyS9veimv+tFnttgZgOIRt9+RCpVqQ9Ok+C2e/XjOJuriF3t3NWrnx8
 xoAc03ytQfUgS6RqZ+LOq+wL5iHuboHWCwDvqlqHy+nCpLlxAjpWvnv5nLoQHTL/hBgr
 r5QxVzAXQhXai14VBIJS/MExFDCZRcLFv/Tv1NYCRco12Vn1VcH4hdyD8S6+DHU2QWjp
 J22I6gDfhb6hYvoNe+dFwaamSiNEl6hx41ldPcD6P1B+2+T2qsu6OM81mwvnXI1swoaO WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrrcmbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 02:14:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I25Zcq038605;
        Fri, 18 Sep 2020 02:14:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h88d3jpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 02:14:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I2EuM2020230;
        Fri, 18 Sep 2020 02:14:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 02:14:52 +0000
Date:   Thu, 17 Sep 2020 19:14:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 1/2] xfs: don't free rt blocks when we're doing a REMAP
 bunmapi call
Message-ID: <20200918021450.GU7955@magnolia>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331319.3624286.3971628628820322437.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031331319.3624286.3971628628820322437.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180020
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
to be unmapped from the given file fork without the extent being freed.
We do this for non-rt files, but we forgot to do this for realtime
files.  So far this isn't a big deal since nobody makes a bunmapi call
to a rt file with the REMAP flag set, but don't leave a logic bomb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: only compute bno if we're going to use it
---
 fs/xfs/libxfs/xfs_bmap.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1b0a01b06a05..d9a692484eae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5046,20 +5046,25 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_fsblock_t	bno;
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
-		bno = div_u64_rem(del->br_startblock, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
 		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
 				  &mod);
 		ASSERT(mod == 0);
 
-		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
-		if (error)
-			goto done;
+		if (!(bflags & XFS_BMAPI_REMAP)) {
+			xfs_fsblock_t	bno;
+
+			bno = div_u64_rem(del->br_startblock,
+					mp->m_sb.sb_rextsize, &mod);
+			ASSERT(mod == 0);
+
+			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			if (error)
+				goto done;
+		}
+
 		do_fx = 0;
 		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
