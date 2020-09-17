Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E911C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C172137B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ftZGIMQJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIQDbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:31:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQDby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:31:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Ng1B162180;
        Thu, 17 Sep 2020 03:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=eHz2OG3pLzIaL/u6mYbMKFK0reS4WQJiCi2qCXMTezI=;
 b=ftZGIMQJhlWAR6cuZhA7NvvlebHOu1RyUZUmin4nfy/83pwebU51L5hwUX1OQKvacZcr
 q/ltuoCUU1WHLwVr+DH8ZUposH9D8X+Ev4OOdrQ7r/NNpFdOQMvPWMxqUdp07iO+0330
 aoGaLg3IN9LnIdyKwvVk/cGP3in5oKMB3bcXZbyaoK4nxzg3C8BQkQL5CywAlcI1GEBX
 Ko2S9NIxRkr15qVeyZfDqaUETtz38o1KzlureYb/Lvotmd8kQV2jg0583zfcO5Pra9ri
 Iz+ZZhYoWS45HnLdPLf7F76Q+fiURQttbrUqZy27IXzm53IhdRLazCcNQLyzA332KoWN cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr6je1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:31:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Psfo181602;
        Thu, 17 Sep 2020 03:29:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm340s69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3Tmon007223;
        Thu, 17 Sep 2020 03:29:48 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:48 +0000
Subject: [PATCH 0/3] xfs: fix some log stalling problems in defer ops
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 16 Sep 2020 20:29:47 -0700
Message-ID: <160031338724.3624707.1335084348340671147.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series tries to fix some structural problems in the defer ops code.
The defer ops code has been finishing items in the wrong order -- if a
top level defer op creates items A and B, and finishing item A creates
more defer ops A1 and A2, we'll put the new items on the end of the chain
and process them in the order A B A1 A2.  This is kind of weird, since
it's convenient for programmers to be able to think of A and B as an
ordered sequence where all the work for A must finish before we move on
to B, e.g. A A1 A2 D.

That isn't how the defer ops actually works, but so far we've been lucky
that this hasn't ever caused serious problems.  This /will/, however,
when we get to the atomic extent swap code, where for refcounting
purposes it actually /does/ matter that unmap and map child intents
execute in that order, and complete before we move on to the next extent
in the files.  This also causes a very long chain of intent items to
build up, which can exhaust memory.

We need to teach defer ops to finish all the sub-work associated with
each defer op that the caller gave us, to minimize the length of the
defer ops chains; and then we need to teach it to relog items
periodically to avoid pinning the log tail.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-ops-stalls

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defer-ops-stalls
---
 fs/xfs/libxfs/xfs_defer.c  |   59 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_item.c     |   25 +++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 ++++++++++++++++++++++
 fs/xfs/xfs_log.c           |   41 +++++++++++++++++++++++--------
 fs/xfs/xfs_log.h           |    2 +
 fs/xfs/xfs_refcount_item.c |   27 ++++++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 ++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 +++++++
 9 files changed, 210 insertions(+), 11 deletions(-)

