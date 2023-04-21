Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B97C77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 11:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDULx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 07:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjDULx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 07:53:28 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC646181
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 04:53:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2shg0lyWz9v7Q5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 19:28:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwDH+IJudUJkSOICBg--.28716S2;
        Fri, 21 Apr 2023 11:37:23 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 0/2] xfs fix and clean up
Date:   Fri, 21 Apr 2023 19:37:14 +0800
Message-Id: <20230421113716.1890274-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwDH+IJudUJkSOICBg--.28716S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF45KFWrXr4xWFW7CF43GFg_yoWxCFX_Aa
        yI9F97Gw12qFy7Aay8JFnrtry7GrWxXrsrJayUJF4akr12yFyxXrZrZrs0vr18urs8Kry8
        Jr1UXr95trySvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbS8YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7Iv64x0x7Aq67IIx4CEVc8vx2IErcIFxwAC
        I402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij2
        8IcwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAnYwUUUUU=
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave & Darrick,

Recent xfs work, I found xfs debug print code doesn't work properly.
The two patches for fix print level parsing and try to make it works.

v1: fix parsing failed of `kstrtoint` by skip KERN_SOH 
v2: with Dave's suggestion, directly set loglevel in their definition

Thanks.

Guo Xuenan (2):
  xfs: fix xfs print level wrong parsing
  xfs: clean up some unnecessary xfs_stack_trace

 fs/xfs/libxfs/xfs_ialloc.c |  1 -
 fs/xfs/xfs_error.c         |  9 ---------
 fs/xfs/xfs_fsops.c         |  2 --
 fs/xfs/xfs_log.c           |  2 --
 fs/xfs/xfs_message.c       |  5 ++---
 fs/xfs/xfs_message.h       | 28 ++++++++++++++--------------
 6 files changed, 16 insertions(+), 31 deletions(-)

-- 
2.31.1

