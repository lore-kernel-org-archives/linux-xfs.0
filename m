Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6958C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 06:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiKKGGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 01:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKKGGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 01:06:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74B35E3F4
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 22:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668146700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/JWAyjUw7bSSDwxMyzQBCXu3ytbIediVihbxXvZqjI=;
        b=TAou51kWWYeCkgCXOXgTRlXZk/aXqNVYDBR1wgAdgprY71Zx/tEXZdWezkMG9JqOz8qGlK
        5OqN+idU5Fz+1iO6BLaaUSUJCvs9WPmKU7/HuAJwCJdadwDnhHstlWqefSdbdE48BUxp/z
        ynUdw/5oy7MiJwRxBVEMJitQ9NJJJlU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-43fXgUsjOZ2NzELDVGgm5w-1; Fri, 11 Nov 2022 01:04:58 -0500
X-MC-Unique: 43fXgUsjOZ2NzELDVGgm5w-1
Received: by mail-pf1-f200.google.com with SMTP id x8-20020aa79568000000b0056dd717e051so2255399pfq.11
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 22:04:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/JWAyjUw7bSSDwxMyzQBCXu3ytbIediVihbxXvZqjI=;
        b=qO/m/spo0d4GQNaDUmiNMJnfxOvlCMM7GD0NWRQn6XQQEq+THMcZsYt/T5d/kh9hV+
         Qy6CmaQpaP62Khj/UBSFF4OaZIfOGpwXjTdKkqVwaFfzX6MqeSJAQc6+P45qIP1JvNb6
         Odtnw97W2Cm5yoDAjI/FrYsZesKN9L4GnhxrPZAdbCiZ7D43KcPuoGnFIMi0qYyW4wwt
         XXFfHj1SO0ZLX+IqCvCJgW7mcMeBDYG1SrlEccvlC2AthHA79runK9D5b4+rM8KZfYKm
         m0v6J8bVtnTVc9jsrv2TrVfuSbTR5hoVJ9rkSfCTeDxIxU2NVoIn6Heeuw2kyVIOSHt+
         gK8A==
X-Gm-Message-State: ANoB5pl2yZ1dPiIufhtCo+i0vGr+TFQ4DRfg7Ygdjxcxl170QBptYZOw
        l8+DNwk5uNszF420mE0CsZR65rxaGUZOqIwlXesmOmWa+udFoqG9aronjjRU5PfP/YgeBzXCA/a
        kSQK0eoxVLVp/6gOul9s/
X-Received: by 2002:a63:4747:0:b0:46f:1e8d:d6a8 with SMTP id w7-20020a634747000000b0046f1e8dd6a8mr383484pgk.248.1668146696408;
        Thu, 10 Nov 2022 22:04:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5bjpjz9x8TOGd+JQjM6RdnSQ1YB0NAIU3ZKPPwrlqsFob4jQXRnSNLU4U5PxVQi54ZX4ujRA==
X-Received: by 2002:a63:4747:0:b0:46f:1e8d:d6a8 with SMTP id w7-20020a634747000000b0046f1e8dd6a8mr383459pgk.248.1668146696005;
        Thu, 10 Nov 2022 22:04:56 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y7-20020aa79e07000000b0056e8eb09d58sm698142pfq.170.2022.11.10.22.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 22:04:55 -0800 (PST)
Date:   Fri, 11 Nov 2022 14:04:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: account extra freespace btree splits for multiple
 allocations
Message-ID: <20221111060450.nojzqvcalwowov4l@zlang-mailbox>
References: <20221109034802.40322-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109034802.40322-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 11:48:02AM +0800, Gao Xiang wrote:
> There is a long standing issue which could cause fs shutdown due to
> inode extent-to-btree conversion failure right after an extent
> allocation in the same AG, which is absolutely unexpected due to the
> proper minleft reservation in the previous allocation.  Brian once
> addressed one of the root cause [1], however, such symptom can still
> occur after the commit is merged as reported [2], and our cloud
> environment is also suffering from this issue.
> 
> From the description of the commit [1], I found that Zirong has an
> in-house stress test reproducer for this issue, therefore I asked him
> to reproduce again and he confirmed that such issue can still be
> reproduced on RHEL 9 in several days.
> 
> Thanks to him, after adding some debugging code to dump the current
> transaction log items, I think the root cause is as below:
> 
>   1. xfs_bmapi_allocate() with the following condition:
>      freeblks: 18304 pagf_flcount: 6
>      reservation: 18276 need (min_free): 6
>      args->minleft: 1
>      available = freeblks + agflcount - reservation - need - minleft
>                = 18304 + min(6, 6) - 18276 - 6 - 1 = 27
>      The first allocation check itself is ok, and args->maxlen = 27
>      here
> 
>      At this time, AG 3 also has the following state:
>      1st:64  last:69  cnt:6  longest:6395
> 
>      AGFL has the following state:
>      64:547 65:167 66:1651 67:2040807 68:783 69:604
> 
>   2. Tried to get 27 blocks from this AG, but in order to finish such
>      allocation, it had to need a new btree block for cntbt (so take
>      another free block from agfl).  It can be seen with a new AGF
>      recorded in the transaction:
>       blkno 62914177, len 1, map_size 1
>       00000000: 58 41 47 46 00 00 00 01 00 00 00 03 00 27 ff f0  XAGF.........'..
>       00000010: 00 00 00 09 00 00 00 07 00 00 00 00 00 00 00 02  ................
>       00000020: 00 00 00 02 00 00 00 00 00 00 00 41 00 00 00 45  ...........A...E
>       00000030: 00 00 00 05 00 00 47 65 00 00 18 fb 00 00 00 09  ......Ge........
>       00000040: 75 dc c1 b5 1a 45 40 2a 80 50 72 f0 59 6e 62 66  u....E@*.Pr.Ynbf
> 
>       It can be parsed as:
>       agf 3  flfirst: 65 (0x41) fllast: 69 (0x45) cnt: 5
>       freeblks 18277
> 
>   3. agfl 64 (agbno 547, daddr 62918552) was then written as a cntbt
>      block, which can also be seen in a log item as below:
>        type#011= 0x123c
>        flags#011= 0x8
>       blkno 62918552, len 8, map_size 1
>       00000000: 41 42 33 43 00 00 00 fd 00 1f 23 e4 ff ff ff ff  AB3C......#.....
>       00000010: 00 00 00 00 03 c0 0f 98 00 00 00 00 00 00 00 00  ................
>       00000020: 75 dc c1 b5 1a 45 40 2a 80 50 72 f0 59 6e 62 66  u....E@*.Pr.Ynbf
>       ...
> 
>   4. Finally, the following inode extent to btree allocation fails
>      as below:
>      kernel: ------------[ cut here ]------------
>      WARNING: CPU: 15 PID: 49290 at fs/xfs/libxfs/xfs_bmap.c:717 xfs_bmap_extents_to_btree+0xc51/0x1050 [xfs]
>      ...
>      XFS (sda2): agno 3 agflcount 5 freeblks 18277 reservation 18276 6
> 
>      since freeblks = 18304 - 27 = 18277, but with another agfl
>      block allocated (pagf_flcount from 6 to 5), the inequality will
>      not be satisfied:
> 
>      available = freeblks + agflcount - reservation - need - minleft
>                = 18277 + min(5, 6) - 18276 - 6 - 0 = 0   < 1
> 
>   Full current transaction log item dump can be fetched from [3].
> 
> As a short-term solution, the following allocations (e.g. allocation
> for inode extent-to-btree conversion) can be recorded in order to count
> more blocks to reserve for safely freespace btree splits so that it
> will shorten available and args->maxlen to
>      available = freeblks + agflcount - reservation - need - minleft
>                = 18304 + min(6, 6) - 18276 - 6*2 - 1 = 21
>      args->maxlen = 21
> in the first allocation, and the following conversion should then
> succeed.  At least, it's easy to be backported and do hotfix.
> 
> In the long term, args->total and args->minleft have be revisited
> although it could cause more refactoring.
> 
> [1] commit 1ca89fbc48e1 ("xfs: don't account extra agfl blocks as available")
>     https://lore.kernel.org/r/20190327145000.10756-1-bfoster@redhat.com
> [2] https://lore.kernel.org/r/20220105071052.GD20464@templeofstupid.com
> [3] https://lore.kernel.org/linux-xfs/Y2RevDyoeJZSpiat@B-P7TQMD6M-0146.local/2-dmesg.log.xz
> Reported-by: Zirong Lang <zlang@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---

FYI, I've tested this bug, with the original reproducer I hit this bug. Although
the reproducer is a big long time (3days) stress test, and can't reproduce
this bug 100%, but generally with about 1/5 chance.

So I submitted 6 testing jobs, all test passed today, didn't this bug, so I
think this patch works for me. (This testing can't replace regression test)

Anway, for more convince, I just submitted more 6 testing jobs again. They'll
be done on next Monday (11-14). I'll feedback if there're any problems, or
nothing wrong.

Thanks,
Zorro

> Previous discussion is at:
> https://lore.kernel.org/linux-xfs/202211040048.FeUQMLE6-lkp@intel.com/T/#mfcfac181079ddaa5a22eecb74db56534fc4ff918
> 
>  fs/xfs/libxfs/xfs_alloc.c | 9 +++++++--
>  fs/xfs/libxfs/xfs_alloc.h | 1 +
>  fs/xfs/libxfs/xfs_bmap.c  | 2 ++
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6261599bb389..684c67310175 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2630,7 +2630,12 @@ xfs_alloc_fix_freelist(
>  		goto out_agbp_relse;
>  	}
>  
> -	need = xfs_alloc_min_freelist(mp, pag);
> +	/*
> +	 * Also need to fulfill freespace btree splits by reservaing more
> +	 * blocks to perform multiple allocations from a single AG and
> +	 * transaction if needed.
> +	 */
> +	need = xfs_alloc_min_freelist(mp, pag) * (1 + args->postallocs);
>  	if (!xfs_alloc_space_available(args, need, flags |
>  			XFS_ALLOC_FLAG_CHECK))
>  		goto out_agbp_relse;
> @@ -2654,7 +2659,7 @@ xfs_alloc_fix_freelist(
>  		xfs_agfl_reset(tp, agbp, pag);
>  
>  	/* If there isn't enough total space or single-extent, reject it. */
> -	need = xfs_alloc_min_freelist(mp, pag);
> +	need = xfs_alloc_min_freelist(mp, pag) * (1 + args->postallocs);
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 2c3f762dfb58..be7f15d6a40d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -73,6 +73,7 @@ typedef struct xfs_alloc_arg {
>  	int		datatype;	/* mask defining data type treatment */
>  	char		wasdel;		/* set if allocation was prev delayed */
>  	char		wasfromfl;	/* set if allocation is from freelist */
> +	bool		postallocs;	/* number of post-allocations */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
>  #ifdef DEBUG
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 49d0d4ea63fc..ed92c6a314b6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3497,6 +3497,7 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	args.alignment = 1;
>  	args.minalignslop = 0;
>  
> +	args.postallocs = 1;
>  	args.minleft = ap->minleft;
>  	args.wasdel = ap->wasdel;
>  	args.resv = XFS_AG_RESV_NONE;
> @@ -3658,6 +3659,7 @@ xfs_bmap_btalloc(
>  		args.alignment = 1;
>  		args.minalignslop = 0;
>  	}
> +	args.postallocs = 1;
>  	args.minleft = ap->minleft;
>  	args.wasdel = ap->wasdel;
>  	args.resv = XFS_AG_RESV_NONE;
> -- 
> 2.24.4
> 

