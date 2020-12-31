Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131EEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF4D20760
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgLaWq2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56330 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgLaWq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMiaDn154623
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kURoCoGTeJL6ukmayaINaDLMmIPSV59Xlq+81DGu3yk=;
 b=HsA3Fl8MbwwJsfX+KhnjllrIo9O9q89JaE5AvnDiJXkqV41bolHnxJnipwKs0PKuRzyV
 fAjQSN+6d4K86aHyuH/p/xmE9SJicn5ISALTupvNzHbOrixQn29Ygs1vmHMb6flsZSZU
 41f8RHI56pYeP7tjCgCt3Eg88uPysVpgsocGQOju4n9s740GOffbrEs5TGHvFkkROSlU
 a9D0hkoFCT3i4QKG591giqPfV5ah7rqrkaVGlpB4LfLNCRl0uCBmuRyR6pzmpZZtC4XT
 +SRgOTSartIWDbEC5Mu8ve6Ies2GcV+JXcOQ42ssLRZyj3BKRrfodGU3ZbenRPYDo7uc RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5BK143850
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35pexuku4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMjiat018922
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:44 -0800
Subject: [PATCHSET 0/2] xfs: enable in-core block reservation for rt metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:43 -0800
Message-ID: <160945474378.2832062.1791649989351690926.stgit@magnolia>
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

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the per-AG block reservation system for use
with realtime metadata.  This effectively allows us to pre-allocate
space for the rmap and refcount btrees in the same manner as we do for
the data device counterparts, which is how we avoid ENOSPC failures when
space is low but we've already committed to a COW operation.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
 fs/xfs/libxfs/xfs_ag_resv.c |  116 +++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_ag_resv.h |    6 +-
 fs/xfs/libxfs/xfs_types.h   |    1 
 fs/xfs/scrub/fscounters.c   |    3 +
 fs/xfs/xfs_fsops.c          |    9 +++
 fs/xfs/xfs_mount.h          |   25 ++++++---
 fs/xfs/xfs_rtalloc.c        |   13 +++++
 fs/xfs/xfs_trace.h          |   43 ++++++++++++++--
 8 files changed, 183 insertions(+), 33 deletions(-)

