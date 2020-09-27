Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21759C4727F
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0B123A32
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MUWBY6ph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgI0XlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:41:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0XlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:41:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNddO8051051;
        Sun, 27 Sep 2020 23:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=DEAhYsbzk06GXO44JhYZ2STV+kOQIpOQdXeA61Ice0c=;
 b=MUWBY6phQ7m6KpUBmKEmcv1qMpbBqL4OMul96cAhMyUhQZpwyZ+NoHMvHJQrmv1+O6km
 Rz83I/Gop8pzaTYx6x/oJcGEV4IbMM4lARl4H19v2m7B22U7Ym6DsbT2UhBP966S6G6O
 OeAzToxFWjK3+EDj6LxUqgT7/S7/JwLbiCrkN3dG0To2RElZdxdVLKqZOJpsB5KtanGy
 h3jAKEXwgy7Wjk4afL6oJHkAYjdgJbC7qly9e1yrnyy4xdlftSHutuRn670U/py0znp6
 LOPFyfr0M7Blojkx3ozEqEMLELcLWwVn1FLWGFJ4tVKPv7dAABi0Sip/xd5XuUDQsd6c 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9mtg1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:41:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNdhLW167906;
        Sun, 27 Sep 2020 23:41:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfju3ncy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08RNf9nc009921;
        Sun, 27 Sep 2020 23:41:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:09 -0700
Subject: [PATCH v3 0/4] xfs: fix how we deal with new intents during recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de, bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:41:08 -0700
Message-ID: <160125006793.174438.10683462598722457550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovery-intent-chaining-5.10
---
 fs/xfs/libxfs/xfs_defer.c       |   89 ++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |   22 ++++++
 fs/xfs/libxfs/xfs_log_recover.h |    2 +
 fs/xfs/xfs_bmap_item.c          |   16 +----
 fs/xfs/xfs_extfree_item.c       |    7 +-
 fs/xfs/xfs_log_recover.c        |  136 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_refcount_item.c      |   16 +----
 fs/xfs/xfs_rmap_item.c          |    7 +-
 fs/xfs/xfs_trans.h              |    3 +
 9 files changed, 184 insertions(+), 114 deletions(-)

