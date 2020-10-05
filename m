Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C13EC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A830020B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QeY7n+Nf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgJESZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:25:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47164 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:25:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IADsI148617;
        Mon, 5 Oct 2020 18:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XztyanmUXP8e/FPi0h/yvZFZMEgiBxAIYf7blEVWLkk=;
 b=QeY7n+NfilVy8vUKo7slMbd8oP0K9PaQFI81yvyBfx3JQ8yrO6lk0z8dJXVDmAPPyzYH
 aNKBZETl4G+69O1uVZ4c8IOxHVTVflHn/4+A2hjvZ3wUnBa/L1JhkzDtI49YCxYSn+wR
 gjlBOMHgRNWJ1GRUCsXx8uyMVBMYTEA1Il4OclfVr7RrkBARg7hJZl/WM/Rb1+nLDcm1
 T65J32Zry83Px+oi5P1qY3+xtRI9r+WnEhFntzr87nReg7KPEpF1sC/JijN3Tndd9a89
 gB/EN/TweQvdFSvRFxqydno6SPiHJ8DoZCTVyeT2bfa7BFdzMz06Bi5ZBlqwY1db9cLc 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetaq7d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:22:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IBRCS073703;
        Mon, 5 Oct 2020 18:20:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vkug8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095IKt20019015;
        Mon, 5 Oct 2020 18:20:55 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:55 -0700
Subject: [PATCH v5 0/4] xfs: fix some log stalling problems in defer ops
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com, hch@lst.de
Date:   Mon, 05 Oct 2020 11:20:54 -0700
Message-ID: <160192205402.2569788.11403566753219528155.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
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
v5: add a defer ops relog counter to the xfs stats file

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-ops-stalls-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |   69 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 ++++++++++++++++++
 fs/xfs/xfs_log.c           |   40 +++++++++++++++++++-------
 fs/xfs/xfs_log.h           |    2 +
 fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++
 fs/xfs/xfs_stats.c         |    4 +++
 fs/xfs/xfs_stats.h         |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 ++++++
 11 files changed, 226 insertions(+), 11 deletions(-)

