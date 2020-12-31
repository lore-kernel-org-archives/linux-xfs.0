Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F84FC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04052206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgLaWqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34162 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgLaWqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMiwIh147523
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5BKkvnzICqlkKJSUkwmxzpbqO3RxYKn2txEolH2Q3bg=;
 b=qIxgTXHIAljRR/s73AXn/S+2s4OE/ejKZgZj3TRODLsK+T9rAM6qwqalTTkQH+KMMw15
 zK1PtVupbIvOdcwQ6Fp/aKPGVu8Np5klDmTdYXsmKz4+5zDPJ9CUy6BiEh55YzlU2gLJ
 QM3R3OO5rgWG+PaUQZR56Xi0/nQ6zj89Jt3L7ssSRvO0zuZhxM2BM3QaThvwNa+gR/t+
 6+a/Wyv7W9rMDlpo+1kRtsnDM7RvXSrdMhUcF5HomMulh1cvtxxNSPa7r99gDT75EU4N
 urlSaMcEdX9a6kxbf8UPa+8dNpqpMo1St0ReaPhQnLnCXc18WZJkFAQDadOqLu/vD35g 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35phm1jt3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe7UB015206
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35perpnd4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMhdrV024685
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:38 -0800
Subject: [PATCHSET v2 0/6] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:38 -0800
Message-ID: <160945461791.2829150.17964129644434132153.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=995 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have been hanging onto for the purpose of speeding up front-end
filesystem operations (appending writes, cow staging).  The upcoming
deferred inactivation series will greatly increase the amount of
allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder
---
 fs/xfs/xfs_bmap_util.c   |   29 ++++++++++
 fs/xfs/xfs_file.c        |   24 +++-----
 fs/xfs/xfs_icache.c      |  132 +++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_icache.h      |   14 ++---
 fs/xfs/xfs_inode.c       |   29 +++++++++-
 fs/xfs/xfs_ioctl.c       |    2 +
 fs/xfs/xfs_iomap.c       |   32 +++++++++++
 fs/xfs/xfs_qm_syscalls.c |    3 -
 fs/xfs/xfs_reflink.c     |   63 +++++++++++++++++++++-
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   41 ++++++++++++++
 11 files changed, 306 insertions(+), 64 deletions(-)

