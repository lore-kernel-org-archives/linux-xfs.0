Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4152C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB28423A34
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RLuhsH4C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgI0XmF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:42:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgI0XmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:42:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNdcnq143008;
        Sun, 27 Sep 2020 23:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NFP82nLeoh1w4O9MA7v4V7z544ExRnIQklOoi0w4dRs=;
 b=RLuhsH4CjcgnRBkr1yzDGfjDnYQVtpFtbulJd5EFD97VujPT/2enRXQkMFBBJJEi+k0y
 7ZJvRcdr4TZgD8iiBzzqCW3Bzui+L+NokQ3OQHxXdMAu+FNlf9XZsEu7J8eqq3M7tJFB
 r4RMte9m1pe73/6I2b7ixd/GbxSGO/aLWD+ohBVhV6X7MvP7zhqvxhKu3KsayfjGCJnv
 Okaf8QdZSUg9R+ejFwDhh+y+t2Pe9Efa+fdBN7uIThCcclkZ+aftFwmo3pqLbrqLIJP4
 ihyrb459QLLXfQ1h8DyeVI7/SaMtuPQ6aVHyW/u/B1yrUq4fRWYzzxWxIgnmixzg20Lr sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkjh60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:42:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNedRP094452;
        Sun, 27 Sep 2020 23:42:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdp5bun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:42:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNg0Hr002361;
        Sun, 27 Sep 2020 23:42:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:42:00 -0700
Subject: [PATCH v4 0/4] xfs: fix some log stalling problems in defer ops
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 27 Sep 2020 16:41:59 -0700
Message-ID: <160125011935.174867.2604597189723452984.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This last series tries to fix some structural problems in the defer ops
code.  The defer ops code has been finishing items in the wrong order --
if a top level defer op creates items A and B, and finishing item A
creates more defer ops A1 and A2, we'll put the new items on the end of
the chain and process them in the order A B A1 A2.  This is kind of
weird, since it's convenient for programmers to be able to think of A
and B as an ordered sequence where all the work for A must finish before
we move on to B, e.g. A A1 A2 D.

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

v2: combine all the relog patches into one, and base the decision to
relog an iten dependent on whether or not it's in an old checkpoint
v3: fix backwards logic, don't relog items in the same checkpoint,
and split up the changes
v4: fix some comments, split the log changes into a separate patch

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-ops-stalls-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |   64 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 ++++++++++++++++++++
 fs/xfs/xfs_log.c           |   40 +++++++++++++++++++++-------
 fs/xfs/xfs_log.h           |    2 +
 fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 +++++++
 9 files changed, 216 insertions(+), 11 deletions(-)

