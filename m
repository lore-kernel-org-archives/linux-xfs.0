Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2AEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4428720772
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sWiLlgUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFDBXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 21:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDBXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 21:23:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5787BC03E96D
        for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2020 18:23:17 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b5so4493071iln.5
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jun 2020 18:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uDIuA2etOnBR8Xme7hmnwCaiLyfz/qLgjkS4XkxLYtI=;
        b=sWiLlgUvG9aauXWNcHvJvzCCi8QxXs7p9Hvvk8EEMiGLtFNb+5LOJO1wNFqOtbgsqQ
         WnrZ9+5f+Ob/uf6wXMu5S2LEiUaU24Ct24U/0KU3nud1K+fDDA1VMT5NPSmBKDwMv5/f
         0Lxredr2J42omrhYXLLk0wcoM/z84lFgLDJ4xhschWRt7VA062vRVjeK389pfB7YAfZ7
         NIrKClmMnFGvXBB1yoNN6KgHzaCpeFO2/O3pKfVC0AyoNPv5CpmOsGdteoGLX5+/uCY5
         iTpJ3TIRhXilw56ZnjWQm5hvJwfZyOhV+uDT1RN3O/JvO/04757DywncYeVM9qThwyAa
         QZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uDIuA2etOnBR8Xme7hmnwCaiLyfz/qLgjkS4XkxLYtI=;
        b=uXopj2WJsiKgSGOMSW2+8zyCc7q8Z0iVLnQJWcdsS3iElcsWxBCExl88WTJft1jGop
         QNJsths/ctIUuV5fduaMGJudH/qKSk4/r66MmU5ShnnpAr1tL1D2Oh+co6dtAC5NHeYc
         wtEW9ISN2Dx6qraVYpa2tQ5D+vTEYWAxTq/uIbq/4b+VLkSmk/6iU3hNql/dGS73VnEE
         YbALpMer1lvavTSXewC81rucJ1ZbYZgZgRyiZ3f1w9WGLxXPEA5S4uvyiwMJ3HMd58O6
         SeC4oW3z0fDYZxVnvbnnFeVi83Sdh6hQRw3MK7BF23Bv+d5lWqr60GbG0DcEnUGVR04J
         G7zw==
X-Gm-Message-State: AOAM531lXsS+uq+DReUVCEXvQWcZp4bPrTNAR15ZXu5QfPNUZoYvDQ7b
        qHUOtjdlzutMjcVf4KKxtBmzxVDX43NFjS2c4LbuU2cNJbg=
X-Google-Smtp-Source: ABdhPJwCyfCcjQCKBfxUlLcqikeB7i76uMvyjlo4NQjqc8+W87/5VqLzzh+WwqC374IaXVBRktu9ZozRlIXLYcoOSfQ=
X-Received: by 2002:a92:4899:: with SMTP id j25mr2224094ilg.168.1591233796781;
 Wed, 03 Jun 2020 18:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <1591179035-9270-1-git-send-email-laoar.shao@gmail.com>
 <20200603172355.GP2162697@magnolia> <20200603222741.GQ2040@dread.disaster.area>
In-Reply-To: <20200603222741.GQ2040@dread.disaster.area>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 4 Jun 2020 09:22:40 +0800
Message-ID: <CALOAHbBz-bjBz8Q_zGBThr27EE5qxi-t=CVkiGb7WFGXZ9SE-Q@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: avoid deadlock when tigger memory reclam in xfs_map_blocks()
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 4, 2020 at 6:27 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Jun 03, 2020 at 10:23:55AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 03, 2020 at 06:10:35AM -0400, Yafang Shao wrote:
> > > Recently there is an XFS deadlock on our server with an old kernel.
> > > The deadlock is caused by allocating memory xfs_map_blocks() while doing
> > > writeback on behalf of memroy reclaim. Although this deadlock happens on an
> > > old kernel, I think it could happen on the newest kernel as well. This
> > > issue only happence once and can't be reproduced, so I haven't tried to
> > > produce it on the newesr kernel.
> > >
> > > Bellow is the call trace of this deadlock. Note that
> > > xfs_iomap_write_allocate() is replaced by xfs_convert_blocks() in
> > > commit 4ad765edb02a ("xfs: move xfs_iomap_write_allocate to xfs_aops.c").
> > >
> > > [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> > > [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> > > [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> > > [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> > > [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> > > [480594.790096] Call Trace:
> > > [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> > > [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> > > [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> > > [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> > > [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> > > [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> > > [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> > > [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> > > [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> > > [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> > > [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> > > [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> > > [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> > > [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> > > [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> > > [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> > > [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> > > [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> > > [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> > > [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> > > [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> > > [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> > > [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> > > [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> > > [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> > > [480594.790276]  [<ffffffffa04e958b>] xfs_iomap_write_allocate+0x1cb/0x390 [xfs]
> > > [480594.790299]  [<ffffffffa04d3616>] xfs_map_blocks+0x1a6/0x210 [xfs]
> > > [480594.790312]  [<ffffffffa04d416b>] xfs_do_writepage+0x17b/0x550 [xfs]
> >
> > xfs_do_writepages doesn't exist anymore.  Does upstream have this
> > problem?  What kernel is this patch targeting?
>
> It does via xfs_bmapi_convert_delalloc() -> xfs_trans_alloc().
>
> I suspect the entire iomap_do_writepage() path should be run under
> GFP_NOFS context given that it is called with a locked page
> cache page and calls ->map_blocks from that context...
>

Agreed, I will send v2.



-- 
Thanks
Yafang
