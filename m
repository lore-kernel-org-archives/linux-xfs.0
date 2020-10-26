Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1842C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 942B420809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IPxJk54J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406346AbgJZXcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406297AbgJZXcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPvE6177195;
        Mon, 26 Oct 2020 23:32:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QRfDRbDjPEkgXHzDFrX8ErWZ2zWlsdQpw5tpqo35YpI=;
 b=IPxJk54JVfKyDA8oSqpaH4BVEWPgCfNZp8Vq1B4qSWj+xLjTWMVWljAYay8Vll5qaZcH
 BcsFMo2AcgxbS86fK+8i0b08i5dDJKWMWDroL7hbO6IEINxqPr9SM8kyBC0f1GtXAaOq
 D4eOStOY5fwcjVJutmGQg/Dj1V++UBaJIuKSR7WltG+nG1NU3s04hInFf/vr6+n2C/ya
 rGYjdfAcB1vRjDT8IGemjHHkpG/vK6ruNlMdm4G8sioUYQ7c0sFdNxh1F0CEnPt1NFXC
 tV98ZJbwXm/LkKqTObzE1SJeWiGLs1AcJLfYWypVxhlQKxkCHwqe7v1WafCXWFuOIl3+ tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqcsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxSQ110493;
        Mon, 26 Oct 2020 23:32:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wfqea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:02 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNW1uS004549;
        Mon, 26 Oct 2020 23:32:01 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:00 -0700
Subject: [PATCH 1/5] mkfs: allow users to specify rtinherit=0
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:31:59 -0700
Message-ID: <160375511989.879169.8816363379781873320.stgit@magnolia>
In-Reply-To: <160375511371.879169.3659553317719857738.stgit@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

mkfs has quite a few boolean options that can be specified in several
ways: "option=1" (turn it on), "option" (turn it on), or "option=0"
(turn it off).  For whatever reason, rtinherit sticks out as the only
mkfs parameter that doesn't behave that way.  Let's make it behave the
same as all the other boolean variables.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d74b0a..908d520df909 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -349,7 +349,7 @@ static struct opt_params dopts = {
 		},
 		{ .index = D_RTINHERIT,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
-		  .minval = 1,
+		  .minval = 0,
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
@@ -1429,6 +1429,8 @@ data_opts_parser(
 	case D_RTINHERIT:
 		if (getnum(value, opts, subopt))
 			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_RTINHERIT;
 		break;
 	case D_PROJINHERIT:
 		cli->fsx.fsx_projid = getnum(value, opts, subopt);

