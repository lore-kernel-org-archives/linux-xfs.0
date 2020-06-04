Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114E5C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED5E20679
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+x9rshA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgFDBW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 21:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDBW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 21:22:28 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E75FC03E96D
        for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2020 18:22:28 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j8so4486418iog.13
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jun 2020 18:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4WriEwgfm8pHF9JBoY8Er3+yARQGQMQIzJc77P0RKRw=;
        b=O+x9rshABTWBYe+pojr7imX9WkBx2BYYOxzXWVAwWwFt0B3xWRJBfMIhzwjuUuFFLn
         IiGfw7Sg3Rmj6HVBjg5oR+otq+WjpKGXMxdhbF1nCZvEZ1ezQhiuh9B/mvDUGcrZCipB
         Av1yJNxTZNP8Uu9jlNdsV1hIUZfUtInn5Cdk0qtHJsK0sMa/JKE4Gg6ibHMdo5WooYXG
         ELCYGqoGdznsS38/l0ApCtLtQqPAD4+yBahvOAeN8ze67aPkZreQCeme6JXC0YvIxZNu
         dBHx3CGMR6v122kobjyiXOGFJAMXLVr2HU59lUUHns5o2yOyQwMM4lFQuFHtpz583pe4
         3+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4WriEwgfm8pHF9JBoY8Er3+yARQGQMQIzJc77P0RKRw=;
        b=CktCkHwUxs8KtjMovZOaAsx1c1AhkGTD5K+1ayCLd74+5N9uxXIknX963g+SHxl8Hd
         6kVtGw0R+UDa4yhSkRXH6KIA6Zp87Ni1PxbitvC8xvFI3qXsr8FP5UOjgK7HcArJkOOF
         ZvWAqobyvIMK+P+gn8ABP5XqxwmUrJb5w4BiP+AqjwTwbjltYVOrqDTwJYSt86I4Yg8R
         6oCz9hI/gf9NFdnMaEWovCTSU0PoPo73MYXy2EqY2eO0vh9ThhnflNB/Sn+G88t/v/+j
         MjcCvLNDUZ2YArQDSLIiRbOZyTpl3F/qGA3b0awIx4+MqwCS5v8yY1LePTb9SdlsFpkc
         LvYw==
X-Gm-Message-State: AOAM532H6AYC2LZ/qvB/8EhNzo3WVNehFimuj2VRtfb2dVrB/Zfg72Di
        xgItDz+FaV2WUMx1aQoxPjwN3BlM6LM79yhCjzM=
X-Google-Smtp-Source: ABdhPJzIcPWbICX5+8HliIdJhbFvSbpOGKBZgAs4MlfUxfLRvwD6Xoov1DEU3vQklzUL+JWWoBIqIic0V9ZXxzcOAKA=
X-Received: by 2002:a02:ac0a:: with SMTP id a10mr2360269jao.97.1591233747051;
 Wed, 03 Jun 2020 18:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <1591179035-9270-1-git-send-email-laoar.shao@gmail.com> <20200603172355.GP2162697@magnolia>
In-Reply-To: <20200603172355.GP2162697@magnolia>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 4 Jun 2020 09:21:51 +0800
Message-ID: <CALOAHbBq-5k+dfj-oOmHnDtbok2wQ6QhW02hifs0HaTMXcbNZw@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: avoid deadlock when tigger memory reclam in xfs_map_blocks()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 4, 2020 at 1:26 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Jun 03, 2020 at 06:10:35AM -0400, Yafang Shao wrote:
> > Recently there is an XFS deadlock on our server with an old kernel.
> > The deadlock is caused by allocating memory xfs_map_blocks() while doing
> > writeback on behalf of memroy reclaim. Although this deadlock happens on an
> > old kernel, I think it could happen on the newest kernel as well. This
> > issue only happence once and can't be reproduced, so I haven't tried to
> > produce it on the newesr kernel.
> >
> > Bellow is the call trace of this deadlock. Note that
> > xfs_iomap_write_allocate() is replaced by xfs_convert_blocks() in
> > commit 4ad765edb02a ("xfs: move xfs_iomap_write_allocate to xfs_aops.c").
> >
> > [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> > [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> > [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> > [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> > [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> > [480594.790096] Call Trace:
> > [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> > [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> > [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> > [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> > [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> > [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> > [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> > [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> > [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> > [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> > [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> > [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> > [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> > [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> > [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> > [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> > [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> > [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> > [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> > [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> > [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> > [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> > [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> > [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> > [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> > [480594.790276]  [<ffffffffa04e958b>] xfs_iomap_write_allocate+0x1cb/0x390 [xfs]
> > [480594.790299]  [<ffffffffa04d3616>] xfs_map_blocks+0x1a6/0x210 [xfs]
> > [480594.790312]  [<ffffffffa04d416b>] xfs_do_writepage+0x17b/0x550 [xfs]
>
> xfs_do_writepages doesn't exist anymore.  Does upstream have this
> problem?  What kernel is this patch targeting?
>

I think the upstream has this issue as well. This patch is targeted
for Linus's current tree.

> --D
>
> > [480594.790314]  [<ffffffff8118d881>] write_cache_pages+0x251/0x4d0 [xfs]
> > [480594.790338]  [<ffffffffa04d3e05>] xfs_vm_writepages+0xc5/0xe0 [xfs]
> > [480594.790341]  [<ffffffff8118ebfe>] do_writepages+0x1e/0x40
> > [480594.790343]  [<ffffffff811837b5>] __filemap_fdatawrite_range+0x65/0x80
> > [480594.790346]  [<ffffffff81183901>] filemap_write_and_wait_range+0x41/0x90
> > [480594.790360]  [<ffffffffa04df2c6>] xfs_file_fsync+0x66/0x1e0 [xfs]
> > [480594.790363]  [<ffffffff81231cf5>] do_fsync+0x65/0xa0
> > [480594.790365]  [<ffffffff81231fe3>] SyS_fdatasync+0x13/0x20
> > [480594.790367]  [<ffffffff81698d09>] system_call_fastpath+0x16/0x1b
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  fs/xfs/xfs_aops.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 1fd4fb7..3f60766 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -352,6 +352,7 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
> >       struct xfs_iext_cursor  icur;
> >       int                     retries = 0;
> >       int                     error = 0;
> > +     unsigned int            nofs_flag;
> >
> >       if (XFS_FORCED_SHUTDOWN(mp))
> >               return -EIO;
> > @@ -445,8 +446,16 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
> >       xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0);
> >       trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
> >       return 0;
> > +
> >  allocate_blocks:
> > +     /*
> > +      * We can allocate memory here while doing writeback on behalf of
> > +      * memory reclaim.  To avoid memory allocation deadlocks set the
> > +      * task-wide nofs context for the following operations.
> > +      */
> > +     nofs_flag = memalloc_nofs_save();
> >       error = xfs_convert_blocks(wpc, ip, whichfork, offset);
> > +     memalloc_nofs_restore(nofs_flag);
> >       if (error) {
> >               /*
> >                * If we failed to find the extent in the COW fork we might have
> > --
> > 1.8.3.1
> >



-- 
Thanks
Yafang
