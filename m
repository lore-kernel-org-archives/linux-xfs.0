Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6747BC7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 03:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjDUDcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 23:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDUDcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 23:32:05 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B304010C1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 20:32:03 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q2fwM1FVNz9xrt1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 11:22:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwC35oCgA0JkJLD+BQ--.17472S2;
        Fri, 21 Apr 2023 03:31:49 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH 0/3] xfs fixes and clean up
Date:   Fri, 21 Apr 2023 11:31:39 +0800
Message-Id: <20230421033142.1656296-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwC35oCgA0JkJLD+BQ--.17472S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF15tr1xCrW3ZryUCrWDtwb_yoW3tFb_Ja
        929ry8G3yqqa9rArWIyFn0qFWxtayxXrsrZay7tFWayw12yF17XrWDurs0gFn8Wrs8Kr95
        Jr1UAFyrKry09jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbqxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7M4II
        rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMx
        AIw28IcVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
        wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
        0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
        xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr
        0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1vP
        fPUUUUU==
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave & Darrick,

Recent xfs work, I found and fixed two bugs on our xfs, which also
exist on the mainline. The first patch fix a memory leak problem,
although in my opinion, it will not cause serious problems in release
version, in Debug mode it brings assertion. The last two patches for
xfs debug framework, fix print level parsing and try to make it work
better.

Thanks.

Guo Xuenan (3):
  xfs: fix leak memory when xfs_attr_inactive fails
  xfs: fix xfs print level wrong parsing
  xfs: clean up some unnecessary xfs_stack_trace

 fs/xfs/libxfs/xfs_ialloc.c |  1 -
 fs/xfs/xfs_attr_inactive.c | 16 +++++++++-------
 fs/xfs/xfs_error.c         |  9 ---------
 fs/xfs/xfs_fsops.c         |  2 --
 fs/xfs/xfs_icache.c        |  6 +++++-
 fs/xfs/xfs_log.c           |  2 --
 fs/xfs/xfs_message.c       |  2 +-
 7 files changed, 15 insertions(+), 23 deletions(-)

-- 
2.31.1

