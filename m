Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB3AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B48F7206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgLaWs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:48:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgLaWs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:48:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMliLY156216;
        Thu, 31 Dec 2020 22:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Bstm3Atz665yxNYdSWL16ZIxUFmBIJ0VmEY6BD2k+xk=;
 b=Mgxlvk7vKzz8EYXge1sYAsQNX2wWQc9KGnwlNCM89wOEYEY15v7UJIhimaCdG6d9bANu
 ED1U328xOg9un304N88xnMcRcSrpUy5xzUdHEaSDvKqvyE5bRAiGnQmIflis00fCxJfy
 q6NluPxLcya/ehjUGXWrbSyd/0d4gRTD8UeRZrpKpRcroHEez/CUmZFheyjdAZDWvXls
 2LoWFRcXyLrjMBrS8QcJVa52kWZo6FMMuZBJPd24AGBAWq0ChdWT846QReMBaF6NEKaO
 IbUNM9aT9KPduyAgiuihQkA1jhlyN613OOIaEPAsiguhPBP40NF6KqiPEomgRAPBFzpl 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:47:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkUGU093333;
        Thu, 31 Dec 2020 22:47:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35pf307myp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:47:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMlg79004070;
        Thu, 31 Dec 2020 22:47:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:47:42 -0800
Subject: [PATCHSET 0/3] xfs_scrub: improve balancing of threads for inode scan
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:47:41 -0800
Message-ID: <160945486106.2835436.7426056673035720483.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
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

Dave Chinner introduced a patch to the userspace workqueues that allows
for controlling the maximum queue depth as part of phase6 cleanups for
xfs_repair.  This enables us to fix a problem in xfs_scrub wherein we
fail to parallelize inode scans to the maximum extent possible if a
filesystem's inode usage isn't evenly balanced across AGs.

Resolve this problem by using two workqueues for the inode scan -- one
that calls INUMBERS to find all the inobt records for the filesystem and
creates separate work items for each record; and a second workqueue to
turn the inobt records into BULKSTAT calls to do the actual scanning.
We use the queue depth control to avoid excessive queuing of inode
chunks.  This creates more threads to manage, but it means that we avoid
the problem of one AG's inode scan continuing on long after the other
threads ran out of work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-iscan-rebalance
---
 libfrog/workqueue.c |   42 ++++++
 libfrog/workqueue.h |    4 +
 scrub/inodes.c      |  335 ++++++++++++++++++++++++++++++++++++++-------------
 scrub/scrub.c       |   30 +++++
 scrub/xfs_scrub.c   |    1 
 scrub/xfs_scrub.h   |    3 
 6 files changed, 324 insertions(+), 91 deletions(-)

