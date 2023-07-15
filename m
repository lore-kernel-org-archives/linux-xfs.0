Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE81FEB64DC
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Jul 2023 06:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjGOGjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Jul 2023 02:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGOGjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Jul 2023 02:39:45 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE8F358E
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 23:39:42 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R2zCt36jqzLmqV;
        Sat, 15 Jul 2023 14:37:14 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 15 Jul 2023 14:39:36 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v2 0/3] xfs: fix two problem when recovery intents fails
Date:   Sat, 15 Jul 2023 14:36:44 +0800
Message-ID: <20230715063647.2094989-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch set fix two problem when recovery intents fails.

Patches 1-2 fix the possible problem that intent items not released.
When recovery intents, new intents items may be created during recovery
intents. if recovery fails, new intents items may be left in AIL or
leaks.

Patch 3 fix a uaf problem, when recovery intents fails, intent items
may be freed before done item commited.

v2:
 - change xfs_defer_pending_abort to static in patch 1
 - rewrite commit message in patch 2-3
 - rename xfs_defer_ops_capture_free to xfs_defer_ops_capture_abort, and
 add xfs_defer_pending_abort to the start of xfs_defer_ops_capture_abort

Long Li (3):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail
  xfs: make sure done item committed before cancel intents

 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h |  2 +-
 fs/xfs/xfs_log_recover.c  | 16 ++++++++--------
 3 files changed, 27 insertions(+), 19 deletions(-)

-- 
2.31.1

