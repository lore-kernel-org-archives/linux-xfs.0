Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177CFC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 03:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiK3Ds4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 22:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiK3Dsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 22:48:55 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FB01E3C2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 19:48:53 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NMQ4G1tcGz9xqd7
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 11:41:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwC39l+S0oZj0DJ2AQ--.17355S2;
        Wed, 30 Nov 2022 03:48:39 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org,
        guoxuenan@huawei.com, houtao1@huawei.com, jack.qiu@huawei.com,
        fangwei1@huawei.com, yi.zhang@huawei.com, zhengbin13@huawei.com,
        leo.lilong@huawei.com
Subject: [PATCH v2] xfs: get rid of assert from xfs_btree_islastblock
Date:   Wed, 30 Nov 2022 12:02:37 +0800
Message-Id: <20221130040237.2434259-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwC39l+S0oZj0DJ2AQ--.17355S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyDAw4xAF1fur45ur47XFb_yoW5JrWxp3
        9ak3WFkrZrKw17uFn8tw1jq3WfWw1fCr4xA393Aryav345Jr1xJryFyry0qF9Fvr4fZ3ZF
        gF45t3y3A3yUKaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvvb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjxUFjg4DUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_btree_check_block contains debugging knobs. With XFS_DEBUG setting up,
turn on the debugging knob can trigger the assert of xfs_btree_islastblock,
test script as follows:

while true
do
    mount $disk $mountpoint
    fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null
    echo 1 > /sys/fs/xfs/sda/errortag/btree_chk_sblk
    sleep 10
    umount $mountpoint
done

Kick off fsstress and only *then* turn on the debugging knob. If it
happens that the knob gets turned on after the cntbt lookup succeeds
but before the call to xfs_btree_islastblock, then we *can* end up in
the situation where a previously checked btree block suddenly starts
returning EFSCORRUPTED from xfs_btree_check_block. Kaboom.

Darrick give a very detailed explanation as follows:
Looking back at commit 27d9ee577dcce, I think the point of all this was
to make sure that the cursor has actually performed a lookup, and that
the btree block at whatever level we're asking about is ok.

If the caller hasn't ever done a lookup, the bc_levels array will be
empty, so cur->bc_levels[level].bp pointer will be NULL.  The call to
xfs_btree_get_block will crash anyway, so the "ASSERT(block);" part is
pointless.

If the caller did a lookup but the lookup failed due to block
corruption, the corresponding cur->bc_levels[level].bp pointer will also
be NULL, and we'll still crash.  The "ASSERT(xfs_btree_check_block);"
logic is also unnecessary.

If the cursor level points to an inode root, the block buffer will be
incore, so it had better always be consistent.

If the caller ignores a failed lookup after a successful one and calls
this function, the cursor state is garbage and the assert wouldn't have
tripped anyway. So get rid of the assert.

Fixes: 27d9ee577dcc ("xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index eef27858a013..29c4b4ccb909 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -556,7 +556,6 @@ xfs_btree_islastblock(
 	struct xfs_buf		*bp;
 
 	block = xfs_btree_get_block(cur, level, &bp);
-	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
 
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
-- 
2.31.1

