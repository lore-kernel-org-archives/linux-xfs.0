Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44596 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfFNM7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jun 2019 08:59:08 -0400
Received: by mail-yw1-f66.google.com with SMTP id l79so1040555ywe.11
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2019 05:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
In-Reply-To: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Jun 2019 15:58:56 +0300
Message-ID: <CAOQ4uxjTKbwiQpj5FZZZM5Mbq8=jjHna+KU5HP74+UuKdPe1Sw@mail.gmail.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Fri, Oct 14, 2016 at 3:36 PM Chris Mason <clm@fb.com> wrote:
>
>
> Hi Dave,
>
> This is part of a series of patches we're growing to fix a perf
> regression on a few straggler tiers that are still on v3.10.  In this
> case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
> slower on recent kernels.
>
> Between v3.10 and v4.x, kswapd is less effective overall.  This leads
> more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
> in xfs_reclaim_inodes_ag().
>
> Since slab shrinking happens very early in direct reclaim, we've seen
> systems with 130GB of ram where hundreds of procs are stuck on the xfs
> slab shrinker fighting to walk a slab 900MB in size.  They'd have better
> luck moving on to the page cache instead.
>
> Also, we're going into direct reclaim much more often than we should
> because kswapd is getting stuck on XFS inode locks and writeback.
> Dropping the SYNC_WAIT means that kswapd can move on to other things and
> let the async worker threads get kicked to work on the inodes.
>
> We're still working on the series, and this is only compile tested on
> current Linus git.  I'm working out some better simulations for the
> hadoop workload to stuff into Mel's tests.  Numbers from prod take
> roughly 3 days to stabilize, so I haven't isolated this patch from the rest
> of the series.
>
> Unpatched v4.x our base allocation stall rate goes up to as much as
> 200-300/sec, averaging 70/sec.  The series I'm finalizing gets that
> number down to < 1 /sec.
>
> Omar Sandoval did some digging and found you added the SYNC_WAIT in
> response to a workload I sent ages ago.  I tried to make this OOM with
> fsmark creating empty files, and it has been soaking in memory
> constrained workloads in production for almost two weeks.
>
> Signed-off-by: Chris Mason <clm@fb.com>
> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index bf2d607..63938fb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1195,7 +1195,7 @@ xfs_reclaim_inodes_nr(
>         xfs_reclaim_work_queue(mp);
>         xfs_ail_push_all(mp->m_ail);
>
> -       return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
> +       return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
>  }
>
>  /*
> --

Hi Chris,

We've being seeing memory allocation stalls on some v4.9.y production systems
involving direct reclaim of xfs inodes.

I saw a similar issue was reported again here:
https://bugzilla.kernel.org/show_bug.cgi?id=192981

I couldn't find any resolution to the reported issue in upstream
commits, so I wonder,
does Facebook still carry this patch? Or was there a proper fix and I missed it?

Thanks,
Amir.
