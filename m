Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77172C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5681520735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KxwldELu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgEIQbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:31:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbgEIQbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:31:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVbo196455;
        Sat, 9 May 2020 16:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=rgRxs2zFd3hRrb7nWQO61o2lxyrIBCVhbv3UwHVAgbc=;
 b=KxwldELugzWxHxFPej3a6FSGlFsTNt/tKT0dwr6ITVbVMYP9u8PjS4fgbwPi1rVM84ve
 8oWY6dRLdso5aZrYtBA02yK4HzOzsu7zMyu7Ho6Iebsp4yjFZh8JGUypk+/CMit80jjc
 e6KiEA58g8JK8dqDoDbnfRVyQbqEceO2+a3oGpYaFGbzDSvpOrlz33YKpoaErzTLzCz/
 WkI417ag6yR6aSbPrIc2qU5Pk9Zrn74/do6sR8pP5su7Uvzz1O7ppzwZ0cllyOUH7Hvi
 rthZJ140H1emd6OxW0QdrwdPUXP42MkKR1vlBPAI07GM3Oqj1M0E1MVEAVSv/EmD7TFm 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30wmfm1527-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRbNP132479;
        Sat, 9 May 2020 16:31:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30wwxb5j5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:31:42 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GVfYJ005092;
        Sat, 9 May 2020 16:31:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:31:40 -0700
Subject: [PATCH v4 0/9] xfs_repair: use btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sat, 09 May 2020 09:31:40 -0700
Message-ID: <158904190079.984305.707785748675261111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
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

Hi all,

In preparation for landing the online fs repair feature, it was
necessary to design a generic btree bulk loading module that it could
use.  Fortunately, xfs_repair has four of these (for the four btree
types), so I synthesized one generic version and pushed it into the
kernel libxfs in 5.7.

That being done, port xfs_repair to use the generic btree bulk loader.
In addition to dropping a lot of code from xfs_repair, this also enables
us to control the fullness of the tree nodes in the rebuilt indices for
testing.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
