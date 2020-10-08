Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0E9C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A06F21527
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NXfsIe/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgJHD5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:57:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgJHD5h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 23:57:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983mW5U124421;
        Thu, 8 Oct 2020 03:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=LXHt+FcQzkEMEJ3ODohCrZK632uh2VWxVV7PgvxkUDY=;
 b=NXfsIe/NOhGUrgZYllLtibcglxG36rmUJ6IJuDcW/lxSR/17XbU+zprEAZTtIGbk/xyn
 Vzl/+TQ6ydlIzirseSYdmiTHql5rY1iFvyNFRiKO/uW9O0YuMRXqPp+LV3Lg4p3p35Ef
 wnE5UB1fF+tSUslXD6UxnEyseXQXqmpKEfcXqtz19Eq+igtnKpHRF/qOlZzrFlYJApnR
 xgRUXP2qqrgHqXg9rMfDcGDtp2ip2NZY4yI4yHbgqwtQrbcRyxdALiTvw3FSzKzPimjV
 iQhlIU0LnZgvJMbjSiqLYeZVGapteSKCPSgo/xBAzfyCycJGPT4miCJLNz6RWDPPdGzt og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb5g75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:57:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983kDnU018185;
        Thu, 8 Oct 2020 03:57:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33y380eq95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:57:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0983vX8r025676;
        Thu, 8 Oct 2020 03:57:33 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:57:33 -0700
Date:   Wed, 7 Oct 2020 20:57:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libfrog: fix a potential null pointer dereference
Message-ID: <20201008035732.GA6535@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Apparently, gcc 10.2 thinks that it's possible for either of the calloc
arguments to be zero here, in which case it will return NULL with a zero
errno.  I suppose it's possible to do that via integer overflow in the
macro, though I find it unlikely unless someone passes in a yuuuge value.

Nevertheless, just shut up the warning by hardcoding the error number
so I can move on to nastier bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bulkstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c3e5c5f804e4..195f6ea053bd 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -428,7 +428,7 @@ xfrog_bulkstat_alloc_req(
 
 	breq = calloc(1, XFS_BULKSTAT_REQ_SIZE(nr));
 	if (!breq)
-		return -errno;
+		return -ENOMEM;
 
 	breq->hdr.icount = nr;
 	breq->hdr.ino = startino;
