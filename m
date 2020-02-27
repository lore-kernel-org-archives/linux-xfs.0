Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F906C11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206CD2468F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTglrBIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgB0UX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:23:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0UX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:23:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKDkPN012255;
        Thu, 27 Feb 2020 20:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8qv7d4xCUY9tKnivx9Q3ZnzKgxy2lC4UhtDJORlHrxU=;
 b=UTglrBIBNh1B1tXK9CrrPI9sH8PXcnl/G/vf7Y5lygjR6bbZVQ5uu53apcNM1/IJ4Jer
 ESwf/Erw0+aKs47tQvM/t7YbarVOODo4JkujhGy5LFoPKzihRil3n+wm7F+sXTYrNtFO
 0tPor2M7VP+sRHG8eZVsOo5WkCkMDhp918doQvcjDtVn326sLqXQWX2iVbniawpN+Kja
 KHvL+p6fifwqs3wXgW8OxMvIRGdbGl5GhqroIqf00SkXdo4zKt03c5MFAftsum1QCMyC
 IT9dmPHvy89FNrkP4tjbpjDlCIQHN5BIdV6s9rKIanpXEdEuLkH/g30dRHRDqTSmpuGX EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yehxrs158-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:23:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKEOcs110973;
        Thu, 27 Feb 2020 20:23:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ydcs67quu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:23:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RKNLKM022399;
        Thu, 27 Feb 2020 20:23:22 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 12:23:21 -0800
Date:   Thu, 27 Feb 2020 12:23:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub: fix reporting of EINVAL for online repairs
Message-ID: <20200227202320.GN8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The arguments to str_corrupt() are in the wrong order.  Fix that.

Fixes: de5d20ece73f579 ("libfrog: convert scrub.c functions to negative error codes")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/scrub/scrub.c b/scrub/scrub.c
index f8fa6b7a..6e7f99a5 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -774,9 +774,8 @@ _("Filesystem is shut down, aborting."));
 		/* fall through */
 	case EINVAL:
 		/* Kernel doesn't know how to repair this? */
-		str_corrupt(ctx,
-_("%s: Don't know how to fix; offline repair required."),
-				descr_render(&dsc));
+		str_corrupt(ctx, descr_render(&dsc),
+_("Don't know how to fix; offline repair required."));
 		return CHECK_DONE;
 	case EROFS:
 		/* Read-only filesystem, can't fix. */
