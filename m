Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7837DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568CE20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K5XQYbVa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgFBE0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:26:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBE0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:26:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I0YH106856;
        Tue, 2 Jun 2020 04:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RMFQAbDdo2mLJdpwQ4FdK+pZ0nXHokJNuOU3Mxskuso=;
 b=K5XQYbVa1PJIN1S8zMSIvYUvAA2jMhyC27IeHpbt6InS0t339sz+Jrk+V3M2IfuelgzQ
 Zd2GS6Em8ZGSlH8Q2BadUBiH9hOKZJ2eZ8vK7CmQQ56rYkXiEw4RlgvuAXxV70g/K5O0
 746bxCRWz2SF2X7vnQSRmZfCKTMxM4IQ94HbdkhM3SHGOqtgzaDbmMb8XflYOQBl6FbQ
 ZWP8Tqx/8kZium8BbRpRTp+n+B7mSw+UvuOkNlvkn7QXtCcbHnjdW13kOzbIhjed856J
 TF90FZr6LzzIBedolguBUN5gEEYayFV8I1gMwfmkIiw/MwTNGvEyilTAxQ/JpZwv9dhi zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31bewqswjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JM4m102166;
        Tue, 2 Jun 2020 04:26:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12ng4je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524QjUN021541;
        Tue, 2 Jun 2020 04:26:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:45 -0700
Subject: [PATCH 16/17] xfs_repair: complain about extents in unknown state
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:26:44 -0700
Message-ID: <159107200446.313760.9591682884362621614.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=2 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=2 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During phase 4, if we find any extents that are unaccounted for, report
the entire extent, not just the first block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index a43413c7..191b4842 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -315,8 +315,8 @@ phase4(xfs_mount_t *mp)
 			case XR_E_BAD_STATE:
 			default:
 				do_warn(
-				_("unknown block state, ag %d, block %d\n"),
-					i, j);
+				_("unknown block state, ag %d, blocks %u-%u\n"),
+					i, j, j + blen - 1);
 				/* fall through .. */
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:

