Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACEB9C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DA221789
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 15:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wYa1U9wR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgJHPCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:02:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43642 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730819AbgJHPCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 11:02:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F0PvF158351;
        Thu, 8 Oct 2020 15:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zYz/IYI0cqvBP2pah01wmT4u4QZZ5ATNufVbpZBOMzo=;
 b=wYa1U9wRR3PmKMvETmBz95G187N9Lw55KnMU9pWEKQxBnzayKEWDQEINBXF9DvSLefMa
 iPNcZQmtMrWEXfeeermY5qh8LfKnvN59v/4KCqF9jjzEXSQiRsODb5z56FPe8SDpj0bl
 JgSKKYqgCblDfQD/v02OXF+yvOtYvJQFvanSX4p8o8O40z1zYEyJx3Bja3vDRx9E5L6a
 WsVM/D3tWrxTw/GIhPggGK6xuLh/ScDZl7J5kzJjOQ65YMcUR6ARMnQHvIfCw4EEBUIK
 7Q+sqGN6M/XBvhITO2CAo3i6VUNEiyz67mf8MjgGWRov33k6gg8d9naKFx13N11fFiXY HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetb8ce2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 15:02:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098F1GIB017170;
        Thu, 8 Oct 2020 15:02:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 341xnbt3e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 15:02:06 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098F25Io022350;
        Thu, 8 Oct 2020 15:02:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 08:02:04 -0700
Subject: [PATCH v2 0/3] xfs: a couple of realtime growfs fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Date:   Thu, 08 Oct 2020 08:02:04 -0700
Message-ID: <160216932411.313389.9231180037053830573.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=921 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=940 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was taking a closer look at Chandan's earlier fixes for the
realtime growfs code, I realized that fstests doesn't actually have a
test case for growing a realtime volume.  I wrote one for testing rmap
expansions on the data device and kludged it to work for realtime, and
watched the kernel trip over a ton of assertions and fail xfs_scrub.

The two patches in this series fix the two problems that I found.  The
first is that inode inactivation will truncate the new bitmap blocks if
we don't set the VFS inode size; and the second is that we don't update
the secondary superblocks with the new rt geometry.

I'll cough up a test case after this patch.

v2: fix some review comments, add a locking annotation fix

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rt-growfs-fixes-5.10
---
 fs/xfs/xfs_rtalloc.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

