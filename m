Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF59C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiFFMcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbiFFMcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:32:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA32B2EAE
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 05:31:57 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LGtB64XHrzjWvp;
        Mon,  6 Jun 2022 20:30:38 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:31:56 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 20:31:55 +0800
Message-ID: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
Date:   Mon, 6 Jun 2022 20:31:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
To:     <sandeen@sandeen.net>, <djwong@kernel.org>
CC:     <liuzhiqiang26@huawei.com>, linfeilong <linfeilong@huawei.com>,
        <linux-xfs@vger.kernel.org>
From:   zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH 0/3] xfsprogs: avoid to use NULL pointer
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml100019.china.huawei.com (7.185.36.175) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Change malloc to xmalloc for avoid to use NULL pointer.

zhanchengbin (3):
   mkfs/proto.c: avoid to use NULL pointer
   db: avoid to use NULL pointer
   repair/slab.c: avoid to use NULL pointer

  db/block.c    | 2 +-
  db/check.c    | 4 ++--
  db/faddr.c    | 6 +++---
  db/namei.c    | 2 +-
  mkfs/proto.c  | 4 ++--
  repair/slab.c | 2 +-
  6 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.27.0
