Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30689C433E1
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7BA206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="So4P20Q1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgFBE3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:29:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524ILne121680;
        Tue, 2 Jun 2020 04:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GX4OYNA+UG6kfHNmM9f1YoQqzYOa7eOJvmrVvIPngh8=;
 b=So4P20Q1+6LEzj8PTTbokdDxWPIogqAqunIcZr/GCPHs812lIi41kLjgoZBUa9M1alce
 X3dlvOm1/Nr4+6XY1n8XaLukoCN6YJVd2ubWJwHHvsN4/FPo6qUdWICgAw+NFXNYi0qu
 8Myt8pJbwBmC8Ojn5b4e1xcedBceinTmAj3PyqM8tsXfMckXBhYIhqDGLF5VBbmF8bGq
 p/yGo0ydNa1TOwYEXo+HYjTdfFEVLeDNEtFFefk4DN89nJBhQ39kzyzVHs37lNq4x7Xx
 uLFHHNdJ1s88VESkcsqgEQ28N4NGW5uuq8rTHTPrY6sQINSlwjWa8jVmLtSFS0YtZDdi NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31d5qr20rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuYc126657;
        Tue, 2 Jun 2020 04:25:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25mnfu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:35 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524PZr8020900;
        Tue, 2 Jun 2020 04:25:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:35 -0700
Subject: [PATCH 05/17] xfs_repair: fix bnobt and refcountbt record order
 checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:34 -0700
Message-ID: <159107193410.313760.7458420982893800558.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The bnobt and refcountbt scanners attempt to check that records are in
the correct order.  However, the lastblock variable in both functions
ought to be set to the end of the previous record (instead of the start)
because otherwise we fail to catch overlapping records, which are not
allowed in either btree type.

Found by running xfs/410 with recs[1].blockcount = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 1ddb5763..2d156d64 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -699,7 +699,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	"out-of-order bno btree record %d (%u %u) block %u/%u\n"),
 						i, b, len, agno, bno);
 				} else {
-					lastblock = b;
+					lastblock = end - 1;
 				}
 			} else {
 				agcnts->fdblocks += len;
@@ -1396,7 +1396,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	"out-of-order %s btree record %d (%u %u) block %u/%u\n"),
 					name, i, b, len, agno, bno);
 			} else {
-				lastblock = b;
+				lastblock = end - 1;
 			}
 
 			/* Is this record mergeable with the last one? */

