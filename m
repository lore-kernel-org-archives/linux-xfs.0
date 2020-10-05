Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8007C47095
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6956220B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bzYJ70cr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgJESUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:20:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgJESUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:20:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9NP3101367;
        Mon, 5 Oct 2020 18:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=QrjaMoiQiuHbIP6hKx4pDudYpZupsTUPJU/Cdqh1nXY=;
 b=bzYJ70cr1FruTV6zCPYIr8raUtUikHfTQO5F2CHFSWVCyHdXR7MROWdG1p5UbgBmyjLq
 /35We8YtmBTwvqa5C8w3a55Sh2CCyp2FRRWwj2o4vI+EYAKUgAdZNHDyw79nDjXLqyj6
 SnQke0eRWXSZoZken4oj6yHH9/iUQNXpFPQ3/QXHd8FdWTVlqqBmgx+zjTpdEc+2BDWi
 F1C8UYrIY8uosQgQ1r7fX3xbw9di6RtvdcApNo0jfwMEWLmiIC6cz3aTMYPBBlYnNsjF
 3s8rncTZaV0+MesaNohl/+uZQmfWVis90Gu9ZMYJJ2Cry/GcWWVp9Mnq3/QYikZ03I/a Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmpyqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:19:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IAk99014607;
        Mon, 5 Oct 2020 18:19:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33y36wth85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:19:58 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095IJuDL029899;
        Mon, 5 Oct 2020 18:19:56 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:19:55 -0700
Subject: [PATCH v5 0/5] xfs: fix how we deal with new intents during recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de, bfoster@redhat.com
Date:   Mon, 05 Oct 2020 11:19:54 -0700
Message-ID: <160192199449.2568681.679506644186725342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
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
v3: rework the api again, per bfoster suggestions, so now
xfs_defer_capture is only responsible for creating the capture device,
and log recovery still has to do some work to commit a transaction and
free resources
v4: kill XFS_LI_RECOVERED and move all the defer capture commit and
release code to xfs_defer.c
v5: absorb remaining realtime reservation, only save transaction
reservation (and not logcount or flags)

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovery-intent-chaining-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |  120 ++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_defer.h  |   26 +++++++++
 fs/xfs/xfs_bmap_item.c     |   16 +----
 fs/xfs/xfs_extfree_item.c  |    7 +-
 fs/xfs/xfs_log_recover.c   |  129 +++++++++++++++++++++++++-------------------
 fs/xfs/xfs_refcount_item.c |   16 +----
 fs/xfs/xfs_rmap_item.c     |    7 +-
 fs/xfs/xfs_trans.h         |    7 +-
 8 files changed, 208 insertions(+), 120 deletions(-)

