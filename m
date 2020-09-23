Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0ADC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 05:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A07521D43
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 05:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aq+m8qr2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIWFdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:33:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgIWFdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 01:33:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N5TiWv139983;
        Wed, 23 Sep 2020 05:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Rn9FfcC0FBvkIm8vbGe/zQYwrYpsFK1d7kQI/kI4XSs=;
 b=aq+m8qr2jzHD6pJUrmRwZ4KtP5Ub+Tp66G0saXYWclK/666V09szwEZhVo4siwy/GVfX
 FziBUfbvQk++xSpffzoPiA2Sen/mX3xX2Qh1EMTSvF2tSsL4dFrjZi/ibbZC6NMlcvRG
 9d80/A//Yno3JvTNE+RYM0SPRAwxGqHYmv9Jt9vdTsd9Q0LXdl+TTBz27/64piLwPOLI
 JcCoWuFq3a/ka6L/084K+q4upTZRqXJsgFjMUcMleeoAxaSp5CERmAEox+h4vvWdZnRi
 KuzungFQ+d98DaFRzrnYFhI+gE+0XrpQdA5nVnWnAqS5+lvwlsK3pF1S11ZWlMVDF9fx /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33qcptw7kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 05:33:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N5URak163818;
        Wed, 23 Sep 2020 05:33:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujp56bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 05:33:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08N5X1PD007262;
        Wed, 23 Sep 2020 05:33:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 22:33:01 -0700
Subject: [PATCH v3 0/3] xfs: fix some log stalling problems in defer ops
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com
Date:   Tue, 22 Sep 2020 22:32:59 -0700
Message-ID: <160083917978.1401135.9502772939838940679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230043
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

v2: combine all the relog patches into one, and base the decision to
relog an iten dependent on whether or not it's in an old checkpoint
v3: fix backwards logic, don't relog items in the same checkpoint,
and split up the changes

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
 fs/xfs/libxfs/xfs_defer.c  |   63 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++
 fs/xfs/xfs_extfree_item.c  |   29 ++++++++++++++++++++
 fs/xfs/xfs_log.c           |   41 ++++++++++++++++++++++-------
 fs/xfs/xfs_log.h           |    2 +
 fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++
 fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++
 fs/xfs/xfs_trace.h         |    1 +
 fs/xfs/xfs_trans.h         |   10 +++++++
 9 files changed, 216 insertions(+), 11 deletions(-)

