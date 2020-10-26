Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36E8C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9267A20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BD8OIX5a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406463AbgJZXc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406462AbgJZXc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQuse158977;
        Mon, 26 Oct 2020 23:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NUHEVS8BtnS/6zIa7+LEY3nRBCOZLc6hti4h7M2EWv4=;
 b=BD8OIX5aJf8q7vTiRDZB9M6tWxCO2k5yAe/Tns+BX239J8mRSv9USAnYIrNpEJLiLNS7
 9GFtsoaPuXn3HeVmFXHQ33DsXZMEvyQi67uHSXyOgQR279mP4quuhuiQsr/bAXDvc+Ju
 WyOr/tjzUxtX4m60cpsLT9WHUi9htwdivbzJzz0HssbeVGTpUTvlqZaVp8n+qdzTfYKW
 nxSACC4ZhDW5rH0F8Es8YQTR1UYLmZmfsAWX9Ly/AVTbou+t04hgWieYx5XOfYA80kt4
 hUul3nGw1heW6uU+SKx/rnQ6/hMKFsFTOxZnn0pf4Gs1VvmC+cOVZi84f8PhpKgJdjXE RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGnP121010;
        Mon, 26 Oct 2020 23:32:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6va4n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNWj9Y004913;
        Mon, 26 Oct 2020 23:32:45 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:44 -0700
Subject: [PATCH 0/3] xfsprogs: sync with 5.10, part 1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:43 -0700
Message-ID: <160375516392.880210.12781119775998925242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The first part of syncing libxfs with 5.10.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.10-sync-part1
---
 include/kmem.h            |    2 +-
 include/xfs_trans.h       |    2 +-
 libxfs/kmem.c             |    2 +-
 libxfs/trans.c            |    6 +++---
 libxfs/xfs_iext_tree.c    |    2 +-
 libxfs/xfs_inode_fork.c   |    8 ++++----
 libxfs/xfs_sb.c           |    4 ++--
 libxfs/xfs_trans_inode.c  |    6 +++---
 libxlog/xfs_log_recover.c |    2 +-
 9 files changed, 17 insertions(+), 17 deletions(-)

