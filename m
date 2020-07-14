Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A16C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0E99206F0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AAFRN7AU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgGNVsC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:48:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:48:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELcTxi065724;
        Tue, 14 Jul 2020 21:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4VZ7BeHPFNu+7DdFIDO2rBvwQbxJpMsy3TmeMXrxCJk=;
 b=AAFRN7AU5SEDyAAtsdSJBUPrxftrAt53HwepbRnTjHHW3V9BI2DLSZmJjG6LY/eSUeBC
 mlARccGfMZvPJLN65qZR33UntqidFS7e5nBg+/IsJIhnjEOpirqoINTyRGSAjDR/KvWS
 5bYUBwFi+LN22BVMMWW9Ln33XiX2KqYU+3Zmk+M6hmr1WAckkz7XWctFun7tyo83ioDz
 lay+hDD2G+tqOfOBZ3ga4KxAWuBLAMZ64ShpKJ42Ulz/lM699aBJfCsJz8DlYnbempCQ
 ZXc9pRmFV5iOjnAzfKcnY8POJ7gftMgQZYDHAhMCRLcG7V4jo1nZT2FizHT4MWs7Usoy iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur82yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:47:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhbJG182850;
        Tue, 14 Jul 2020 21:45:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 327q6t47e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:45:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELjuh7025057;
        Tue, 14 Jul 2020 21:45:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:45:56 -0700
Subject: [PATCH v2 0/1] xfsprogs: minor fixes for 5.7
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:45:55 -0700
Message-ID: <159476315531.3155818.235241123940681968.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a short series to collect various xfsprogs fixes for 5.7.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.7-fixes
---
 copy/xfs_copy.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

