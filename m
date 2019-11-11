Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD94C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C2E206DF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aoUYpey7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfKKBSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbfKKBSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1Ic85103122;
        Mon, 11 Nov 2019 01:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=vGtoWxXd0KYZ89mZHOD7iLqzkOQPS7tCOHO6tGgOOzY=;
 b=aoUYpey7aQi3iuZbUmNqruu1fB1yi6sNAuQiE4IB+53mPlSqSn35qIwgGJ8iFf+Glc/s
 8PR+URX1TiLKRLT7yZiyV0LxeecIX9aRVLNroEuvRlC2Mpf9wqwm8RLPuycAY9NmrPyM
 BWo2IGvJ32ePdDG0F/AmFwMQ0LFiN4rbkB9j/QXSfwaGzwAj2/oLG0UJVkf0JgUcVOZc
 P9oe2GILOZzAnpFJfhhw0Cwz5FE98/aeaFrb/Ly3RKwMZ9CSnewi0mri4TcfjB1HCPnZ
 fOfywg0DSmjO71oHF8RKIJpCtQDCN19Inqsfv5MtlCYO2ciJVXMhcETEvLC6v0MgxMKh Jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w5ndpv4kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IdQ3014901;
        Mon, 11 Nov 2019 01:18:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w66wjehgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB1HrPI029126;
        Mon, 11 Nov 2019 01:17:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:17:53 -0800
Subject: [PATCH v4 0/3] xfs: refactor corruption returns
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.org
Date:   Sun, 10 Nov 2019 17:17:51 -0800
Message-ID: <157343507145.1945685.2940312466469213044.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=600
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=691 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series refactors the code that XFS uses to determine that it is
dealing with corrupt metadata and report that to userspace.

The first patch defines some a couple of new macros to handle testing
and reporting corruption errors.

The next patch replaces the XFS_WANT_CORRUPT* macros with open-coded
versions because it's a little strange that a thing that looks like a
simple function call actually has series effects on code flow.

The third patch cleans up all the "if (bad) { XFS_ERROR_REPORT..." code
by combining that into a single XFS_IS_CORRUPT macro that does all that
logging.  This cleans up the error handling code blocks some more.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
