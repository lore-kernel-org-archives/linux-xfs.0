Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816B0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA6F20678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLaWnK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgLaWnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMctU9143534
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4QUZvTUzRrjkg+OmboAutQqQCHRS4oWuYmU2lcRe3cg=;
 b=DbMCS5cAo6m7H19Aa6y9HFjwcGX3ZeLaOIynZObKF4KDhpFfz0l72BVXcjimkA5XLBRz
 bIqh/RWLcUSe21Vvyylr6Ep2UcMlk7/iWla+PlO62/TKyoNbxbY09svkkfpY0fhT6DaG
 vy0M083LPixSlrBo9RWpdi15PkQlXfX/Fq1L19JlDHpSMilNXIG3CgIwLa/lcvcGO2ON
 ijIe/nK7cqt7vFO8QYy09YBJdU3oHX6YwtPptBScU0CQWFXbudAPi2nyhVVOfVC56yWB
 L8lem4HG1ViS1CRtCe8R+AI9YnwCki/iIx9QSBBVzE1vf1JLbFYWCI2ehDhcKNKuyWBw gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35phm1jt1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe8qZ015334
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35perpncvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgRDD007834
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:27 -0800
Subject: [PATCHSET 0/5] xfs: fix reflink inefficiencies
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:26 -0800
Message-ID: <160945454662.2828383.3736240985312451645.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As Dave Chinner has complained about on IRC, there are a couple of
things about reflink that are very inefficient.  First of all, we
limited the size of all bunmapi operations to avoid flooding the log
with defer ops in the worst case, but recent changes to the defer ops
code have solved that problem, so get rid of the bunmapi length clamp.

Second, the log reservations for reflink operations are far far larger
than they need to be.  Shrink them to exactly what we need to handle
each deferred RUI and CUI log item, and no more.  Also reduce logcount
because we don't need 8 rolls per operation.  Introduce a transaction
reservation compatibility layer to avoid changing the minimum log size
calculations.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-speedups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reflink-speedups
---
 fs/xfs/libxfs/xfs_bmap.c       |   22 -----
 fs/xfs/libxfs/xfs_log_rlimit.c |   17 +++-
 fs/xfs/libxfs/xfs_refcount.c   |   14 ++-
 fs/xfs/libxfs/xfs_refcount.h   |    8 --
 fs/xfs/libxfs/xfs_trans_resv.c |  168 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_trans_resv.h |    8 +-
 fs/xfs/xfs_reflink.c           |    7 +-
 fs/xfs/xfs_trace.h             |   12 ++-
 8 files changed, 194 insertions(+), 62 deletions(-)

