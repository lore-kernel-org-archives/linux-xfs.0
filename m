Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7078BC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4988C2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kDgxyjUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgEIQce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEIQce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVKB196418;
        Sat, 9 May 2020 16:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Iu8vn0gwJmpVl6FBPO7HEUlXZJazdRsBWNbbNCO+XO0=;
 b=kDgxyjUEfh2tlEqlqwt3l5EJl/JZkO4Ou8n5f2x2IUOitg+Dcuqus/KQzGZwrUrrDbnV
 TWfmyexpe8yFm4ZF9calOHYEaymAqiXa072RIVUM8oIyVBQwthwn+hN9W8ZGlhIddHzd
 6MLJtVIQB2vhuh/9cdioph8QRMT1xrqNg3frgIGG22+zIVbUyzkWA3bwAp9Cv3qDHawh
 n0LawoywTdyvjHB7dGXDlt+tksBUA5eEVazlf4a4EkfAYCBAZE3mpfMBJvH3KVYAfSh4
 Y4M8KK0oXGAtULkP6wNtltpHKXKKvP/fMAMJeAt4Y1IkCWvzi6+tkinq+6RL/IB1sB5x CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30wmfm1540-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GWU32117376;
        Sat, 9 May 2020 16:32:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wwwpnjh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GUIG5020462;
        Sat, 9 May 2020 16:30:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:17 -0700
Subject: [PATCH 04/16] xfs_repair: fix bnobt and refcountbt record order
 checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:17 -0700
Message-ID: <158904181736.982941.3404117959961230293.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
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

