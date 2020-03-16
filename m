Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF95C3F2CE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16B02051A
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgCPNAE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:00:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731062AbgCPNAE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 09:00:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D8A62BE7DC834D9E09AC;
        Mon, 16 Mar 2020 21:00:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Mar 2020
 20:59:55 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 0/2] xfs: always init fdblocks in mount and avoid f_bfree overflow
Date:   Mon, 16 Mar 2020 21:07:06 +0800
Message-ID: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use buffer io to test xfs mount point:
cp file1M /mnt  -->just check fdblocks
sync            -->find suiteable AG, agf->agf_freeblks & agf->agf_longest

fdblocks may not be correct, if hackers use xfs_db to modify it, always
init fdblocks in mount, also avoid f_bfree overflow.

Zheng Bin (2):
  xfs: always init fdblocks in mount
  xfs: avoid f_bfree overflow

 fs/xfs/xfs_mount.c | 39 ++++++---------------------------------
 fs/xfs/xfs_super.c |  3 ++-
 2 files changed, 8 insertions(+), 34 deletions(-)

--
2.7.4

