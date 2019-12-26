Return-Path: <SRS0=V5eY=2Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F83C2D0DD
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 13:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FCB20740
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 13:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfLZNsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Dec 2019 08:48:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfLZNsI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Dec 2019 08:48:08 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1951A97D24DC772E1786;
        Thu, 26 Dec 2019 21:48:02 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Dec 2019
 21:47:54 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <bfoster@redhat.com>,
        <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <cmaiolino@redhat.com>, <hch@lst.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 0/2] fix stale data exposure problem
Date:   Thu, 26 Dec 2019 21:47:19 +0800
Message-ID: <20191226134721.43797-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The problem was found by generic/042, however, I have no idea why the
problem didn't get fixed.

yu kuai (2):
  xfs: introduce xfs_bmap_split_da_extent
  xfs: fix stale data exposure problem when punch hole, collapse range
    or zero range across a delalloc extent

 fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  1 +
 fs/xfs/xfs_file.c        | 47 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 2 deletions(-)

-- 
2.17.2

