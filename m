Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC198C4708E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Dec 2022 13:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiL1Nc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Dec 2022 08:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiL1Ncy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Dec 2022 08:32:54 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7E1F5A0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Dec 2022 05:32:51 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Nhshc33pbz9v7Yg
        for <linux-xfs@vger.kernel.org>; Wed, 28 Dec 2022 21:25:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwDH831tRaxjRYy6AA--.10559S2;
        Wed, 28 Dec 2022 13:32:37 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     guoxuenan@huawei.com, guoxuenan@huaweicloud.com,
        houtao1@huawei.com, jack.qiu@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: [PATCH] xfs: fix btree splitting failure when AG space about to be exhausted
Date:   Wed, 28 Dec 2022 21:32:04 +0800
Message-Id: <20221228133204.4021519-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwDH831tRaxjRYy6AA--.10559S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WrW3Xr15WF1DGw1DZr1xAFb_yoW7Aw4rpr
        W2kw1fGa9IqF10grs0qw1kK3WrKayrur4UJrnYgr18ZrZxG3Z2grnYkr4UZa47Arn5W3Wj
        qr40vw47AFyUAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7Iv64x0x7Aq67IIx4CEVc8vx2IErcIFxwCF
        04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
        73UjIFyTuYvjxUFjg4DUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently, I noticed an special problem on our products. The disk space
is sufficient, while encounter btree split failure. After looking inside
the disk, I found the specific AG space is about to be exhausted.
More seriously, under this special situation, btree split failure will
always be triggered and XFS filesystem is unavailable.

After analysis the disk image and the AG, which seem same as Gao Xiang met
before [1], The slight difference is my problem is triggered by creating
new inode, I read through your discussion the mailing list[1], I think it's
probably the same root cause.

As Dave pointed out, args->minleft has an *exact* meaning, both inode fork
allocations and inode chunk extent allocation pre-calculate args->minleft
to ensure inobt record insertion succeed in any circumstances. But, this
guarantee dosen't seem to be reliable, especially when it happens to meet
cnt&bno btree splitting. Gao Xiang proposed an solution by adding postalloc
to make current allocation reserve more space for inobt splitting, I think
it's ok to slove their own problem, but may not be sloved completely, since
inode chunk extent allocation may failed during inobt splitting too.

Meanwhile, Gao Xiang also noticed strip align requirement may increase
probablility of the problem, which is totally true. I think the reason is
that align requirement may lead to one free extent divied into two, which
increase probablility of the problem. eg: we needs an extent length 4 and
align 4 and find a suitable free extent [3,10] ([start,length]), after this
allocation, the lefted extents are [3,1] and [9,5]. Therefore, alignment
allocation is more likely to increase the number of free extents, then may
lead cnt&bno btree splitting, which increases likelihood of the problem.

In my opinion, XFS has avariety of btrees, in order to ensure the growth of
the btrees, XFS use args->minleft/agfl/perag reservation to achieve this,
which corresponds as follows:

perag reservation: for reverse map & freeinode & refcount btree
args->minleft    : for inode btree & inode/attr fork btree
agfl             : for block btree (bnobt) & count btree (cntbt)
(rmapbt is exception, it has reservation but get free block from agfl,
since agfl blocks are considered as free when calculate available space,
and rmapbt allocates block from it's reservation, *rmapbt growth* don't
affect available space calculation, so don't care about it)

Before each allocation need to calculate or prepare these reservation,
more precisely, call `xfs_alloc_space_available` to determine whether there
is enough space to complete current allocation, including those involved
tree growth. if xfs_alloc_space_available is true which means tree growth
can definitely success.

I think the root cause of the current problem is when AG space is about to
exhausted and happened to encounter cnt&bno btree splitting,
`xfs_alloc_space_available` does't work well.

Because, considering btree splitting during "space allocation", we will
meet block allocations many times for each "space allocation":
1st. allocation for space required at the beginning, i.e extent A1.
2nd. then need to *insert* or *update* free extent to cntbt & bnobt, which
     *may* lead to btree splitting and need allocation (as explained above)
3rd. extent A1 need to insert inode/attr fork btree or inobt etc.. which
     *may* also lead to splitting and allocation

So, during block allocations, which will calling xfs_alloc_space_available
at least 2 times (2nd don't call it, because bnt&cnt btree get block from
agfl). Since the 1st judgement of space available, it has guaranteed there
is enough space to complete 2nd and 3rd allocation, *BUT* after 2nd
allocation, if the height bno&cnt btree increase, min_freelist of agfl will
increase, more acurrate, xfs_alloc_min_freelist will increase, which may
lead to 3rd allocation failed, and 3rd allocation failure will make our xfs
filesystem unavailable.

According to the above description, since every space allocation, we have
guaranteed agfl min free list is enough for bno&cnt btree growth by
calling `xfs_alloc_fix_freelist` to reserve enough agfl before we do 1st
allocation. So the 2nd allocation will always succeed. args->minleft can
guaranteed 3rd allocation will make it, it is no need to rejudge space
available in 3rd allocation, so xfs_alloc_space_available should always
be true.

In summary, since btree alloc_block don't need any minleft, both 2rd and
3rd allocation are allocation for btree. So just treat these allocation
same as freeing extents (caller with flag XFS_ALLOC_FLAG_FREEING set).

[1] https://lore.kernel.org/linux-xfs/20221109034802.40322-1-hsiangkao@linux.alibaba.com/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 989cf341779b..6d9ada93aec3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2305,7 +2305,7 @@ xfs_alloc_space_available(
 	int			available;
 	xfs_extlen_t		agflcount;
 
-	if (flags & XFS_ALLOC_FLAG_FREEING)
+	if (flags & XFS_ALLOC_FLAG_FREEING || args->minleft == 0)
 		return true;
 
 	reservation = xfs_ag_resv_needed(pag, args->resv);
-- 
2.31.1

