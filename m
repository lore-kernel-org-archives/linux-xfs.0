Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA21C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CCC420658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgLaWpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:45:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55624 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgLaWpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:45:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMiUTB154617
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KbOmqqzCriANCbTmSHd7Se4m0aSKJV+g6I1q5x0jVjE=;
 b=GXASUkFBmJAcBr87zL+Nun52PYq4go959/jJnj5bU/I266x3ZQmqWXAuoqPd2awx38FO
 8H+/1++oHsMPqMldb881rJPj/L4lTlmLVms4SRk3Xs2v4Huxoa0tTm6uSP8E1jT/T1r7
 BqqhSP41R+gR/63OmdGmM67ZhNp8tlCJXHEWSTzNqYB1Lyhax0sBnpZo4pb9QP0aGdP1
 IT70VwdoslTwnpPFnhoQvRRcdzXdq6oAsDBgWuG2B9Pxdhmpw2ef4Ec/Oq+NYp7esxrl
 4ASaPh4W5fMtMDaf9DiT/QIBNhUaYrv4DwuNbZ72+O5xt9qZDou4SUvp095r+aRBThvv FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMeUoF083476
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35pf307m0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMiPbp003000
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:24 -0800
Subject: [PATCHSET 0/2] xfs: support attrfork and unwritten BUIs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:24 -0800
Message-ID: <160945466397.2830800.13578631929018018482.stgit@magnolia>
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

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=expand-bmap-intent-usage

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=expand-bmap-intent-usage
---
 fs/xfs/libxfs/xfs_bmap.c |   44 ++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_item.c   |    2 +-
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    6 +++---
 5 files changed, 28 insertions(+), 36 deletions(-)

