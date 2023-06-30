Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA5CC0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jun 2023 01:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjF3ByZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 21:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjF3ByX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 21:54:23 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E6A1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 18:54:21 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QsdfG3Rndz4f3s6j
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2023 09:54:14 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgCHLaHINZ5kD5ZjMw--.62504S3;
        Fri, 30 Jun 2023 09:54:16 +0800 (CST)
Date:   Fri, 30 Jun 2023 09:51:54 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/3] xfs: abort intent items when recovery intents fail
Message-ID: <20230630015154.GA2415675@ceph-admin>
References: <20230629131725.945004-1-leo.lilong@huawei.com>
 <20230629131725.945004-3-leo.lilong@huawei.com>
 <20230629144236.GB11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230629144236.GB11441@frogsfrogsfrogs>
X-CM-TRANSID: gCh0CgCHLaHINZ5kD5ZjMw--.62504S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWrtr4kJw1xtFWxtr1kXwb_yoW7uFWDpr
        1ktw1UCrWDt348Xa15KFWYqFy8Zr4xAa1UCr93Wry2q3WrG34fX34avF15KayDWr4DXa12
        9Fn5Xw4UXay5uFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUglb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3w
        CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
        xhVjvjDU0xZFpf9x07UQzVbUUUUU=
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 07:42:36AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 29, 2023 at 09:17:24PM +0800, Long Li wrote:
> > When recovery intents, it may capture some deferred ops and commit the new
> > intent items, if recovery intents fails, there will be no done item drop
> > the reference to the new intent item. New intent items will left in AIL
> > and caused mount thread hung all the time as fllows:
> 
> Er... let me try rewriting this a bit:
> 

I have tried my best to express it clearly, but there are still some
language barriers. Thank you very much for making the commit message
clearer.

> "When recovering intents, we capture newly created intent items as part
> of committing recovered intent items.  If intent recovery fails at a
> later point, we forget to remove those newly created intent items from
> the AIL and hang:
> 
> > 
> >     [root@localhost ~]# cat /proc/539/stack
> >     [<0>] xfs_ail_push_all_sync+0x174/0x230
> >     [<0>] xfs_unmount_flush_inodes+0x8d/0xd0
> >     [<0>] xfs_mountfs+0x15f7/0x1e70
> >     [<0>] xfs_fs_fill_super+0x10ec/0x1b20
> >     [<0>] get_tree_bdev+0x3c8/0x730
> >     [<0>] vfs_get_tree+0x89/0x2c0
> >     [<0>] path_mount+0xecf/0x1800
> >     [<0>] do_mount+0xf3/0x110
> >     [<0>] __x64_sys_mount+0x154/0x1f0
> >     [<0>] do_syscall_64+0x39/0x80
> >     [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> > During intent item recover, if transaction that have deferred ops commmit
> > fails in xfs_defer_ops_capture_and_commit(), defer capture would not added
> > to capture list, so matching done items would not commit when finish defer
> > operations, this will cause intent item leaks:
> 
> "Intent recovery hasn't created done items for these newly created
> intent items, so the capture structure is the sole owner of the captured
> intent items.  We must release them explicitly or else they leak:
> 
> > unreferenced object 0xffff888016719108 (size 432):
> >   comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
> >   hex dump (first 32 bytes):
> >     08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
> >     18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
> >   backtrace:
> >     [<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
> >     [<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
> >     [<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
> >     [<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
> >     [<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
> >     [<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
> >     [<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
> >     [<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
> >     [<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
> >     [<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
> >     [<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
> >     [<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
> >     [<ffffffff81a9f35f>] path_mount+0xecf/0x1800
> >     [<ffffffff81a9fd83>] do_mount+0xf3/0x110
> >     [<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
> >     [<ffffffff83968739>] do_syscall_64+0x39/0x80
> > 
> > Fix the problem above by abort intent items that don't have a done item
> > when recovery intents fail.
> > 
> > Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 1 +
> >  fs/xfs/libxfs/xfs_defer.h | 1 +
> >  fs/xfs/xfs_log_recover.c  | 1 +
> >  3 files changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 7ec6812fa625..b2b46d142281 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -809,6 +809,7 @@ xfs_defer_ops_capture_and_commit(
> >  	/* Commit the transaction and add the capture structure to the list. */
> >  	error = xfs_trans_commit(tp);
> >  	if (error) {
> > +		xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
> >  		xfs_defer_ops_capture_free(mp, dfc);
> 
> I prefer that we not go extern'ing two functions that mess around with
> internal state.  Could you instead add the xfs_defer_pending_abort call
> to the start of xfs_defer_ops_capture_free, and rename
> xfs_defer_ops_capture_free to xfs_defer_ops_capture_abort?
> 

Thanks for your suggestion, it seems reasonable and clean enough, it will
change in the next version.

> Other than those two things, I /think/ this looks correct.  Assuming my
> understanding of the problem is reflected in the tweaks I made to the
> commit message. ;)
> 
> --D

Thanks for your review again, the commit message you wrote is exactly
what I want to describe, so I will send a new version later. 

ddThanks,
Long Li

> 
> >  		return error;
> >  	}
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 114a3a4930a3..c3775014f7ab 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -37,6 +37,7 @@ struct xfs_defer_pending {
> >  	enum xfs_defer_ops_type		dfp_type;
> >  };
> >  
> > +void xfs_defer_pending_abort(struct xfs_mount *mp, struct list_head *dop_list);
> >  void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
> >  		struct list_head *h);
> >  int xfs_defer_finish_noroll(struct xfs_trans **tp);
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 82c81d20459d..924beecf07bb 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2511,6 +2511,7 @@ xlog_abort_defer_ops(
> >  
> >  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> >  		list_del_init(&dfc->dfc_list);
> > +		xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
> >  		xfs_defer_ops_capture_free(mp, dfc);
> >  	}
> >  }
> > -- 
> > 2.31.1
> > 

