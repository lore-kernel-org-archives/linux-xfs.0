Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED9EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A96323120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgLFXLf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5KlY020617;
        Sun, 6 Dec 2020 23:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pfc0WNEycjn9Wml2YquiLF0cvpTVWZf/WYv7GvIbk/U=;
 b=VYhB2NbTzo29ZYzbi5UTR6f2obEVh4wRO1aXV+Frlnu3Hjr+9BB0cKawvuXhP5UcsOqs
 DzsJjfihbsSVz9jc5YAvNz3tKD2tGHfez/cNH59U9eY1ObeDRUjsQEADwhMKo++9MkI1
 yKql3H/wa4Jh1HqGO+ZbvY0gOJ9n0nnZgji4xeFq5XSTQhJegkb7k1w93TMnmpmTzden
 77RUktewuquQn9s18lNj1d0h1glD9zPj71US3x7ZK6LeOH16oly/0a6WBzCrhyRaMheh
 Z+J4DS2sqWzvE6vr0xjJY/SZXwrzGigbXfJkL2o5KMcQjTDDog6S7wKaIAy2N8HrB54D Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbk0wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAeEW177282;
        Sun, 6 Dec 2020 23:10:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358kskgb4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NAqJa011944;
        Sun, 6 Dec 2020 23:10:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:51 -0800
Subject: [PATCH 0/4] xfs: refactor extent validation for 5.11
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:10:50 -0800
Message-ID: <160729625074.1608297.13414859761208067117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While reviewing the "strengthen log intent validation" series, Brian
Foster suggested that we should refactor all the validation code that
checks physical extents into a common helper, so I've done that for both
data and rt volume mappings.  I also did the same for file ranges, since
those were kind of a mess of open-coded stuff.  Dave Chinner also asked
to rename xfs_fc -> xfs_fs so that's the last patch.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactorings-5.11
---
 fs/xfs/libxfs/xfs_bmap.c   |   23 ++++------------
 fs/xfs/libxfs/xfs_types.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h  |    7 +++++
 fs/xfs/scrub/bmap.c        |   17 ++++--------
 fs/xfs/scrub/rtbitmap.c    |    4 +--
 fs/xfs/xfs_bmap_item.c     |   13 +--------
 fs/xfs/xfs_extfree_item.c  |   11 +-------
 fs/xfs/xfs_refcount_item.c |   11 +-------
 fs/xfs/xfs_rmap_item.c     |   13 +--------
 fs/xfs/xfs_super.c         |   26 +++++++++---------
 10 files changed, 103 insertions(+), 86 deletions(-)

