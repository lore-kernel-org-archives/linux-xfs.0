Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69A5C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 13:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjKGNcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 08:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjKGNcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 08:32:02 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B440C8F
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 05:31:57 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SPpzB2kPqz4f3lVn
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 21:31:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 228431A016D
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 21:31:54 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP1 (Coremail) with SMTP id cCh0CgCnqxFAPEplqDAkAQ--.983S3;
        Tue, 07 Nov 2023 21:31:45 +0800 (CST)
Date:   Tue, 7 Nov 2023 21:36:07 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com, djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v3 0/3] xfs: fix two problem when recovery intents fails
Message-ID: <20231107133607.GA560725@ceph-admin>
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731124619.3925403-1-leo.lilong@huawei.com>
X-CM-TRANSID: cCh0CgCnqxFAPEplqDAkAQ--.983S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr43Ww4fJF17JF4DKryDZFb_yoW8CryfpF
        n3Kwn8ua9xGF18ZF43JFyjqa45tr4kAr4jkrs7Jr9rWay8Ary7WrWFvFyFvFyUurWSga13
        Zr1kuw1rWa43JFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgvb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
        JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
        kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
        6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIx
        AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
        Ja73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 31, 2023 at 08:46:16PM +0800, Long Li wrote:
> This patch set fix two problem when recovery intents fails.
> 
> Patches 1-2 fix the possible problem that intent items not released.
> When recovery intents, new intents items may be created during recovery
> intents. if recovery fails, new intents items may be left in AIL or
> leaks.

Hi Chandan,
	
In this patchset, patches 1-2 [1][2] have already been reviewed by Darrick,
and are not related to patch 3, is it possible to merge patches 1-2 in first?? 	
Patch 3 seems still has a lot of work to do.

[1] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-2-leo.lilong@huawei.com/
[2] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-3-leo.lilong@huawei.com/

Thanks,
Long Li

> 
> Patch 3 fix a uaf problem, when recovery intents fails, intent items
> may be freed before done item commited.
> 
> v3:
>  - Modified as suggested by Dave, solves the UAF problem by correctly
>  handling the reference counting of intents in patch 3
> 
> v2:
>  - change xfs_defer_pending_abort to static in patch 1
>  - rewrite commit message in patch 2-3
>  - rename xfs_defer_ops_capture_free to xfs_defer_ops_capture_abort, and
>  add xfs_defer_pending_abort to the start of xfs_defer_ops_capture_abort
> 
> 
> Long Li (3):
>   xfs: factor out xfs_defer_pending_abort
>   xfs: abort intent items when recovery intents fail
>   xfs: fix intent item uaf when recover intents fail
> 
>  fs/xfs/libxfs/xfs_defer.c  | 28 ++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_defer.h  |  2 +-
>  fs/xfs/xfs_attr_item.c     |  1 +
>  fs/xfs/xfs_bmap_item.c     |  1 +
>  fs/xfs/xfs_extfree_item.c  |  1 +
>  fs/xfs/xfs_log_recover.c   |  2 +-
>  fs/xfs/xfs_refcount_item.c |  1 +
>  fs/xfs/xfs_rmap_item.c     |  1 +
>  8 files changed, 25 insertions(+), 12 deletions(-)
> 
> -- 
> 2.31.1
> 

