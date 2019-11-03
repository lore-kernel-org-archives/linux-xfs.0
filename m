Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3109FCA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F162190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o4AKhMb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfKCWYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfKCWYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOCee061222
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ihFyXJLF7LgSf2xmxURsPlVQj0maUBR/hYgGJtkEvq0=;
 b=o4AKhMb37umh3aQfsgF1Y1km9ZVs6jN1UzX8NTLaAs0mf6tEAeaGE8BQDd4zq/kZkp72
 u+gzH3xOwcBCEKjZlCZ4ERQhbffQr174QrcJ6jQa22mYjSIJXnT2KiWuLh2kdY3KhBkB
 J8teo+G29Rsc9S19UHq6jxdjOqir5YHkjdJQvRckJ9ATiZ8wzWRMIFvl+97+IQH85wJW
 hCBEhYCmVZDIjuopAYXHjEfnEBTyY+qsMdfS3vNvQUlOQbrTFgk7q89IVXbOtyUrq8PQ
 3jxtseVhKtCTCIBdsPgKFK60wo80FHr/IhElHi4wrgCCyhLJjGfeEr9YH5M+6NKpanTj nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12eqv04w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOOdY137163
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w1kxc3m8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:28 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MO6Xm031993
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:06 -0800
Subject: [PATCH 0/6] xfs: refactor corruption checking and reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:04 -0800
Message-ID: <157281984457.4151907.11281776450827989936.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=800
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this second series, we refactor the code that XFS uses to determine
that it is dealing with corrupt metadata and report that to userspace.

As usual, the first 4 patches perform some small cleanups to lay the
groundwork for the meat of the series, which are in the last two
patches.

The fifth patch replaces the XFS_WANT_CORRUPT* macros with open-coded
versions because it's a little strange that a thing that looks like a
simple function call actually has series effects on code flow.

The sixth patch cleans up all the "if (bad) { XFS_ERROR_REPORT..." code
by combining that into a single XFS_CORRUPT_ON macro that does all that
logging.  This cleans up the error handling code blocks some more.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
