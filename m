Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF79AC3DA79
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Dec 2022 11:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiLZLXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Dec 2022 06:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiLZLXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Dec 2022 06:23:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E776962E2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Dec 2022 03:23:04 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r18so7019427pgr.12
        for <linux-xfs@vger.kernel.org>; Mon, 26 Dec 2022 03:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ogQbAktEAoYvHLm37CTNsA4GNu72OoMaN5F5n3BlueE=;
        b=soALswgirORUy6ooXJe2T9kD9XtGGvFkr3zbeVebEST2p8JPc1nQ1rGJWE1kJldNs9
         +XY/Pp/qPR/KRr0Chk7WPPOACOr9+lz/cIlRq2Gf3A1dj3iDFzrZVPbeDMjq6tENPIi1
         SwBjc8JjmGOfKkk2gIjT/dL8+NzHOdJGLZPf46hPbCP3VjmrB59OzaaLiINOT7x3x+i0
         oXMbqvFiVS+MjbqGKLAaWbQuL8xHcTsFT8LOSdT4RdYdZQWqOkj/Oi8XNk1fQ7AEeZNh
         bmnrKFFT5FaI7Y9ubAmQsWX5HhEj/Z2ZzHxp3ZIELzmI+tmRG9nfrkXgqz52ul3Q/kCK
         wciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogQbAktEAoYvHLm37CTNsA4GNu72OoMaN5F5n3BlueE=;
        b=8DTbQw/04vMiJsYlHx4Awr3nj6v9s0MvKEqY8HLTuzFXdCWTLEpA4aChMtSFatd078
         5FzRZFScccYrK4EeKnGUJfvNKzFwWfoKdugf/EvXV689/dxCEh0kgOGSQk67Ir3SRN2Y
         GlqrcVxci8+XwpjJCLHtnSjiW78gU2cXgTFN1U0RjCywlFpr3XV2m0jQmzCr9xODwrPQ
         qUVE59UzfSvYCjYsKW0cPYkOtYrZR9MGvnPo1GBWZQqbgVL62r4HwoSshPRTqMEm8W3B
         7JHGxdxtYV65KoV/1PzHIWlwlsmBEeQ4b2sMJ0g8as+L9Rl+qI5wp6ana6asXiFSW7GJ
         4eKQ==
X-Gm-Message-State: AFqh2koA0N4IBl+41HIsdj8A3ISwfqTREzDVb/9xpWbUy1rkFyOFLfgj
        Yf6L501VOh4KFiMs9KOJzbSlmk82SdU9/Emz
X-Google-Smtp-Source: AMrXdXs6x435tN8uE8fMeGQeMIzSLdkgC5lnuPBNGeuuuHcLBbqgNzq3365EZSQcI1Cv2iA1AKqLew==
X-Received: by 2002:a62:6347:0:b0:56b:d328:5441 with SMTP id x68-20020a626347000000b0056bd3285441mr17488553pfb.11.1672053784428;
        Mon, 26 Dec 2022 03:23:04 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79ae3000000b00574c54423d3sm6874710pfp.145.2022.12.26.03.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 03:23:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p9lZM-00D2uZ-GP; Mon, 26 Dec 2022 22:23:00 +1100
Date:   Mon, 26 Dec 2022 22:23:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        guoxuenan@huawei.com, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] xfs: Fix deadlock on xfs_inodegc_queue
Message-ID: <20221226112300.GN1971568@dread.disaster.area>
References: <2eebcc2b-f4d4-594b-d05e-e2520d26b4c6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eebcc2b-f4d4-594b-d05e-e2520d26b4c6@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 26, 2022 at 10:15:33AM +0800, Wu Guanghao wrote:
> We did a test to delete a large number of files when the memory
> was insufficient, and then A deadlock problem was found.
> 
> [ 1240.279183] -> #1 (fs_reclaim){+.+.}-{0:0}:
> [ 1240.280450]        lock_acquire+0x197/0x460
> [ 1240.281548]        fs_reclaim_acquire.part.0+0x20/0x30
> [ 1240.282625]        kmem_cache_alloc+0x2b/0x940
> [ 1240.283816]        xfs_trans_alloc+0x8a/0x8b0
> [ 1240.284757]        xfs_inactive_ifree+0xe4/0x4e0
> [ 1240.285935]        xfs_inactive+0x4e9/0x8a0
> [ 1240.286836]        xfs_inodegc_worker+0x160/0x5e0
> [ 1240.287969]        process_one_work+0xa19/0x16b0
> [ 1240.289030]        worker_thread+0x9e/0x1050
> [ 1240.290131]        kthread+0x34f/0x460
> [ 1240.290999]        ret_from_fork+0x22/0x30
> [ 1240.291905]
> [ 1240.291905] -> #0 ((work_completion)(&gc->work)){+.+.}-{0:0}:
> [ 1240.293569]        check_prev_add+0x160/0x2490
> [ 1240.294473]        __lock_acquire+0x2c4d/0x5160
> [ 1240.295544]        lock_acquire+0x197/0x460
> [ 1240.296403]        __flush_work+0x6bc/0xa20
> [ 1240.297522]        xfs_inode_mark_reclaimable+0x6f0/0xdc0
> [ 1240.298649]        destroy_inode+0xc6/0x1b0
> [ 1240.299677]        dispose_list+0xe1/0x1d0
> [ 1240.300567]        prune_icache_sb+0xec/0x150
> [ 1240.301794]        super_cache_scan+0x2c9/0x480
> [ 1240.302776]        do_shrink_slab+0x3f0/0xaa0
> [ 1240.303671]        shrink_slab+0x170/0x660
> [ 1240.304601]        shrink_node+0x7f7/0x1df0
> [ 1240.305515]        balance_pgdat+0x766/0xf50
> [ 1240.306657]        kswapd+0x5bd/0xd20
> [ 1240.307551]        kthread+0x34f/0x460
> [ 1240.308346]        ret_from_fork+0x22/0x30
> [ 1240.309247]
> [ 1240.309247] other info that might help us debug this:
> [ 1240.309247]
> [ 1240.310944]  Possible unsafe locking scenario:
> [ 1240.310944]
> [ 1240.312379]        CPU0                    CPU1
> [ 1240.313363]        ----                    ----
> [ 1240.314433]   lock(fs_reclaim);
> [ 1240.315107]                                lock((work_completion)(&gc->work));
> [ 1240.316828]                                lock(fs_reclaim);
> [ 1240.318088]   lock((work_completion)(&gc->work));
> [ 1240.319203]
> [ 1240.319203]  *** DEADLOCK ***
> ...
> [ 2438.431081] Workqueue: xfs-inodegc/sda xfs_inodegc_worker
> [ 2438.432089] Call Trace:
> [ 2438.432562]  __schedule+0xa94/0x1d20
> [ 2438.435787]  schedule+0xbf/0x270
> [ 2438.436397]  schedule_timeout+0x6f8/0x8b0
> [ 2438.445126]  wait_for_completion+0x163/0x260
> [ 2438.448610]  __flush_work+0x4c4/0xa40
> [ 2438.455011]  xfs_inode_mark_reclaimable+0x6ef/0xda0
> [ 2438.456695]  destroy_inode+0xc6/0x1b0
> [ 2438.457375]  dispose_list+0xe1/0x1d0
> [ 2438.458834]  prune_icache_sb+0xe8/0x150
> [ 2438.461181]  super_cache_scan+0x2b3/0x470
> [ 2438.461950]  do_shrink_slab+0x3cf/0xa50
> [ 2438.462687]  shrink_slab+0x17d/0x660
> [ 2438.466392]  shrink_node+0x87e/0x1d40
> [ 2438.467894]  do_try_to_free_pages+0x364/0x1300
> [ 2438.471188]  try_to_free_pages+0x26c/0x5b0
> [ 2438.473567]  __alloc_pages_slowpath.constprop.136+0x7aa/0x2100
> [ 2438.482577]  __alloc_pages+0x5db/0x710
> [ 2438.485231]  alloc_pages+0x100/0x200
> [ 2438.485923]  allocate_slab+0x2c0/0x380
> [ 2438.486623]  ___slab_alloc+0x41f/0x690
> [ 2438.490254]  __slab_alloc+0x54/0x70
> [ 2438.491692]  kmem_cache_alloc+0x23e/0x270
> [ 2438.492437]  xfs_trans_alloc+0x88/0x880
> [ 2438.493168]  xfs_inactive_ifree+0xe2/0x4e0
> [ 2438.496419]  xfs_inactive+0x4eb/0x8b0
> [ 2438.497123]  xfs_inodegc_worker+0x16b/0x5e0
> [ 2438.497918]  process_one_work+0xbf7/0x1a20
> [ 2438.500316]  worker_thread+0x8c/0x1060
> [ 2438.504938]  ret_from_fork+0x22/0x30
> 
> When the memory is insufficient, xfs_inonodegc_worker will trigger memory
> reclamation when memory is allocated, then flush_work() may be called to
> wait for the work to complete. This causes a deadlock.

Yup, but did you notice that xfs_trans_alloc() is doing GFP_KERNEL
allocation from a context that is doing filesystem work on behalf of
memory reclaim?

The right fix is to make the inodegc workers use
memalloc_nofs_save() context, similar to what is done in
xfs_end_ioend(), as both the IO completion workers and the inodegc
workers can be doing work on behalf of memory reclaim....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
