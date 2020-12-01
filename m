Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F53C64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A894207DE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uGtsV2jP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgLADiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59988 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgLADiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UQXm066758;
        Tue, 1 Dec 2020 03:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Qr5xJ4fR73Fo5Pa61iWTf4ugc0xqYfG0HQxOY9lVzi8=;
 b=uGtsV2jPu24cf0WFYdScVmWsykUhFoDLiqUCB/d8ymI9rQluaXGvHweddnL06StKAfQZ
 nPCZV0CPDO6b2Kalx+ty4Ozk1kLF1mkvo6GMTOlQ8l+P9eP0y0rH63IVgSfuTBO5UA7d
 stMF8eiJVhhTWq9VdIuuJfdL8FLxc9ERkOMYE2btaW4seEYFbF+h5u9cLwXOCqp4VNR5
 CziGzb0cdzgY9NfYtP8tgOt0MvJ3g8EiR4zIMhtRukmYbqOIGVtJ9kxqhg9Pr764oJjY
 su29idKHEq0XOIP4fujEK8L3FY4s+H4CilOU/klH5E3ZzR+ENetqTNyTnGtqOz55bsWs eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2arhjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 03:37:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13U3qA134021;
        Tue, 1 Dec 2020 03:37:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540exd2m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 03:37:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B13bKU7013700;
        Tue, 1 Dec 2020 03:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:19 -0800
Subject: [PATCH 0/3] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:19 -0800
Message-ID: <160679383892.447856.12907477074923729733.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This "new feature" adds a new incompat feature flag so that we can force
a sysadmin to run xfs_repair on a filesystem before mounting.  The
intent for this code is to make it so that one can use xfs_db to upgrade
a filesystem to support new V5 features (e.g. y2038 or inode btree
counters).  Because some upgrades may require xfs_repair to fix or add
things before the filesystem goes back into use, this is the means for
xfs_db to force that to happen.

Note: xfs_admin will automatically run repair when required, so
sysadmins won't have to issue the repair command directly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair-5.11
---
 fs/xfs/libxfs/xfs_format.h |   10 +++++++++-
 fs/xfs/libxfs/xfs_sb.c     |   23 ++++-------------------
 fs/xfs/libxfs/xfs_sb.h     |    3 +++
 fs/xfs/xfs_mount.c         |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 20 deletions(-)

