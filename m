Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6943C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C9FE2080C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zOXRO3JX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIQD3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:29:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQD32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:29:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OSU7116002;
        Thu, 17 Sep 2020 03:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=X5ZlgSQjqBWIsuqMttZCEFyPdgUsEzTUR7eY6sU/2gg=;
 b=zOXRO3JXJ1/GfpVhMBDfg5KscEgVb5Pnn19GnT7fcVx6waEp33pyKx7wffBg5OCO6Rsw
 bgRs5TtmdgsH9QpQAsMPV0Vj7T4/8Lc8nCAU4kbY2SnUOUselJsx9ho6Mzh+K1jH5zdx
 tPJBSKChhyF+pFj0leo6g5jP1oMyRYPGKqcNuRyqUWwN8/LKSOJCTbu8oixjqllfzSGL
 ybz1YzDCRGrorXuZE60UGpRzE8b2ugesLk4TZdPiaHVgHDZI9ef7zFrFisqwjrctL1nA
 45VeuNVadEGb9wlSQXcAiTHIgQBTG4oqH6g/jILkXIcNBOaoPMt+zZ4PGns6iTUg2qBY Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dr5h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:29:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3PWbg080061;
        Thu, 17 Sep 2020 03:29:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h88a268h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:25 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3TPsN007021;
        Thu, 17 Sep 2020 03:29:25 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:25 +0000
Subject: [PATCH 0/3] xfs: fix inode use-after-free during log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:24 -0700
Message-ID: <160031336397.3624582.9639363323333392474.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, I try to fix a use-after-free that I discovered during
development of the dfops freezer, where BUI recovery releases the inode
even if it requeues itself.  If the inode gets reclaimed, the fs
corrupts memory and explodes.  The fix is to make the dfops freezer take
over ownership of the inodes if there's any more work to be done.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-bmap-intent-recovery
---
 fs/xfs/libxfs/xfs_defer.c       |   57 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_defer.h       |   21 ++++++++-
 fs/xfs/libxfs/xfs_log_recover.h |   14 +++++-
 fs/xfs/xfs_bmap_item.c          |   95 +++++++++++++++------------------------
 fs/xfs/xfs_icache.c             |   41 +++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   32 +++++++++++--
 fs/xfs/xfs_trans.h              |    6 --
 7 files changed, 191 insertions(+), 75 deletions(-)

