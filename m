Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4626DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DCE120658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgLaWnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgLaWnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMf16e016166
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=45rZjymx0CgE3oEtyxSHO3jnqO2+dbIMPzIawCFfNCk=;
 b=nwPYeULkNAZAwGReqFi4rHyB68ASBY3VvSz5aFoBlbRy0Qw2K9oMUKgTf5gZ/p3zBFRW
 n5Oc62Al1eIjUV1pHNdWVSCN7SX29wzrvudjjldguMbDdsh3Ss6F/pLNa8+stJ/IAnXD
 ncfxyUB9PdCzdwjndfe5E+sgzr2Ox3oz+wN946X98qWw9ZJW1wOYbs4nw0VpZDhTPn4u
 R21RlfoKvFUutTOd94dLIrr59y76RX79xHOO9D/O2ZLqXvt0CjB8Rlcc3upG809iEH9V
 q5BYsNYHOcwype4Hq5m+ZrpOtxUj7UBKKg3KmwvYSQpExfcMQbIf0tp528k78AwQ5ZSG Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35nvkquw8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe857015228
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35perpnd04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgxQk024483
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:59 -0800
Subject: [PATCHSET 0/3] xfs: online scrubbing of realtime summary files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:58 -0800
Message-ID: <160945457867.2828693.10126361592467654869.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset implements an online checker for the realtime summary
file.  We begin with the xfile code from the repair series, which we use
here to build an in-memory copy of the summary information from the
ondisk realtime bitmap that can be paged out to disk.

Next, we move the rtsummary scrubber stub function into a separate file.

The final patch in the series implements the logic to build the
rtsummary file and compare it to the existing contents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary
---
 fs/xfs/Kconfig           |    1 
 fs/xfs/Makefile          |    8 -
 fs/xfs/scrub/array.c     |  665 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/array.h     |   49 +++
 fs/xfs/scrub/common.h    |   10 +
 fs/xfs/scrub/rtbitmap.c  |   41 ---
 fs/xfs/scrub/rtsummary.c |  327 +++++++++++++++++++++++
 fs/xfs/scrub/scrub.c     |    9 -
 fs/xfs/scrub/scrub.h     |    7 
 fs/xfs/scrub/trace.c     |    1 
 fs/xfs/scrub/trace.h     |  118 ++++++++
 fs/xfs/scrub/xfile.c     |  271 +++++++++++++++++++
 fs/xfs/scrub/xfile.h     |   23 ++
 13 files changed, 1486 insertions(+), 44 deletions(-)
 create mode 100644 fs/xfs/scrub/array.c
 create mode 100644 fs/xfs/scrub/array.h
 create mode 100644 fs/xfs/scrub/rtsummary.c
 create mode 100644 fs/xfs/scrub/xfile.c
 create mode 100644 fs/xfs/scrub/xfile.h

