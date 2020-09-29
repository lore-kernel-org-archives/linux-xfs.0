Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D7BC4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96EF72076B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OhWoQ7AX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgI2Rn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:43:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2Rn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:43:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdBdI189487;
        Tue, 29 Sep 2020 17:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=PZ8ztJRcdMs7jOO+oHe3KuYBaQc/291bjVwjY7xTjgg=;
 b=OhWoQ7AXr3eZbbozWWCjQw82Cxp7oGZ8a/JhMoN8TjpqtAREFeOu3IE0CFZ20SwxzJK1
 DjKJGn5z5zjt3z72LDTIa/XM+FhnPeusrmuu85uukfnctJ/KzJHgRqZUOuknA6KcKNyZ
 JlpEPPRk4rlBlDvWdhbyXKFsqDMWF4Bzk96ZdjjlwAXzxugnrWchF9RevsLLOxT0x/rI
 8SaRO7VJQNuam0yWqNpCH5dvF9oHCI2nbNRgMUwDetOQVBWTh2/xFQoXBy4Q3MPkPluJ
 xR/vj6Ru7Vv6WFI40rNHJu9f35PoPCz/HVAPE3mxbE6mfGReYX3xZfaRPUWDz7c+EUTk 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9n47q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:43:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THeR3r167299;
        Tue, 29 Sep 2020 17:43:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhxyw8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:16 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THhDLc017393;
        Tue, 29 Sep 2020 17:43:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:13 -0700
Subject: [PATCH v4 0/5] xfs: fix how we deal with new intents during recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:43:12 -0700
Message-ID: <160140139198.830233.3093053332257853111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series of log fixes dates back to an earlier discussion that Dave
and I had about the weird way that log recovery works w.r.t. intent
items.  The current code juggles nested transactions so that it can
siphon off new deferred items for later; this we replace with a new
dfops freezer that captures the log reservation type and remaining block
reservation so that we finish the new deferred items with the same
transaction context as we would have had the system not gone down.

v2: rework the defer capture api per hch suggestions
v3: rework the api again, per bfoster suggestions, so now xfs_defer_capture
is only responsible for creating the capture device, and log recovery still
has to do some work to commit a transaction and free resources
v4: kill XFS_LI_RECOVERED and move all the defer capture commit and release
code to xfs_defer.c

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovery-intent-chaining-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |  127 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_defer.h  |   21 +++++++
 fs/xfs/xfs_bmap_item.c     |   16 +-----
 fs/xfs/xfs_extfree_item.c  |    7 +-
 fs/xfs/xfs_log_recover.c   |  110 +++++++++++++++++++-------------------
 fs/xfs/xfs_refcount_item.c |   16 +-----
 fs/xfs/xfs_rmap_item.c     |    7 +-
 fs/xfs/xfs_trans.h         |    7 +-
 8 files changed, 193 insertions(+), 118 deletions(-)

