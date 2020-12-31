Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4A2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD0B20658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgLaWpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:45:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55750 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgLaWpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:45:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMighN154632
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IHmeH8rER3xb7uUo3jnti26aK/HgxtNIudwGKPWWBcI=;
 b=RyMCeVVBLT/rB5wMHIPfHvzdTf+x0WLBEc1b8zNfXth8CKN7qEOgyXgZHW1Br28o99wB
 VfsHaWgRJFAzQhDLi7pJDPyFkxiIhqOQzQvLNk8w0v/+ywfmAhJM/9xbp7JWaXdkYuJI
 QZ6IvRt/PSywWZVWrJNlm+st1keDa047S+3WRWCzxuA9c+O7gGIwh28umefta6sWciTA
 4RbMZktwE25bUz4eX+22LcqjeScgPkmO8PZBbKYAg0mTkuNdz67ob7ntinmD2kzuQPgN
 bJ2V9nS4jx4ASOzANKK2UDOWJVVLYf7bGiGIU1xIZ9aYqYXZRO4BBWC7DrSIhhMxMeSh Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5N0143857
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35pexuktqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:41 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMieLm018552
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:40 -0800
Subject: [PATCHSET v22 0/3] xfs: online repair of realtime summaries
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:39 -0800
Message-ID: <160945467982.2831049.4105930605335577662.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series uses the atomic extent swapping code to enable safe
reconstruction of the realtime summary file.

First, we enable online repair to allocate a temporary file on the
filesystem that can be used by online repair to stage reconstructed
metadata.  Next, we walk the realtime bitmap to compute a new summary in
this temporary file.  Finally, we swap the contents of the two files
with the atomic extent swap feature.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary
---
 fs/xfs/Makefile                 |    4 
 fs/xfs/scrub/repair.c           |  315 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h           |   19 ++
 fs/xfs/scrub/rtsummary.c        |   22 +++
 fs/xfs/scrub/rtsummary_repair.c |   65 ++++++++
 fs/xfs/scrub/scrub.c            |    8 +
 fs/xfs/scrub/scrub.h            |    4 
 fs/xfs/xfs_export.c             |    2 
 fs/xfs/xfs_inode.c              |    3 
 fs/xfs/xfs_inode.h              |    1 
 fs/xfs/xfs_itable.c             |    8 +
 fs/xfs/xfs_xchgrange.c          |    2 
 fs/xfs/xfs_xchgrange.h          |    2 
 13 files changed, 447 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c

