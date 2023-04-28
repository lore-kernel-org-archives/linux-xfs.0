Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9157DC77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 01:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjD1Btg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 21:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjD1Btf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 21:49:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451EE2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 18:49:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b7b54642cso6550315b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 18:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682646572; x=1685238572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xsZp2+5FbN9shs5KrEUcJsuV941hwBcwFGm0GNPfMw=;
        b=d2EP6RgdPW6JfMoN1RXedm9RX0kx04xkDv8ygO9cLQFLhZRK2yMYdNOar3Qih7IGcj
         X4ooKiDBD/ILfWKKdnttP5Td0br+PiuDUNuuQq/FSBYqkrxlCJ8g6Y0meHs8BpogJnfH
         qZTORT1g5YEHq1gk1cMRlHbgHABnX8v3vi8gjdNwresfZjtjjqCy4w0nlYv49VbO4rtx
         qBhdG+xoBKhcKiDt/O4qWT/ZpHQE81VUIStlWYoCuE2aLz1RHIBnTeM0j5UEkRgYXVmV
         8o6CNV87MTxi2nXH6nO/V/WX4pOT6SMrz87zqKsTJjNXUqg+uxQAy9o/cSUtXVibvUMv
         LgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682646572; x=1685238572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xsZp2+5FbN9shs5KrEUcJsuV941hwBcwFGm0GNPfMw=;
        b=V07Fa8BCWS1/wCjvW0ckoDQIMxuuZhC7dD+vh63HfcE/j8Sgrq36WysRVj/J2f/YWO
         LmlLRmejU+VafOfBlaE7JxSE9w0SkJWK56n9leC8uJyYB/DzBu6n+WK6SpspDX3dRWk9
         Aum0fUVfaFwb6qCBBmNO2G5L2LvxtoYHPeeiFgXwpagsuVdUA4GJNNUVuaIz7aT/3mu2
         YgapjqKZ78CeCeSuAdenE3+9xd0b/VV+EGNGOwNtQCGN/QLXG3Hsh7Zy9otDbUXxD/Uw
         CggU+viFy9i5MPGxHgKTQqyE2AwPOwT+hYh7/+bnAZZA81jtkh9dPrf1apnL7WZ4IfoQ
         FzCQ==
X-Gm-Message-State: AC+VfDwcpXgFOa/G9eLGkqAy4Hran9XEoqLBXViBsHIwAFBqXSrMqc5R
        CaI+q2Z3FUFDOUt0h40SpMm2+kM6OzMQ5if/SpA=
X-Google-Smtp-Source: ACHHUZ4LEiolLdHls+bKAOmOHrjyTZeOnkmhQIWZQb6/La89NuQ1wP1b5HiWa5T8MRK87fDzqVuPBg==
X-Received: by 2002:a05:6a00:88f:b0:641:d9b:a44a with SMTP id q15-20020a056a00088f00b006410d9ba44amr4589348pfj.22.1682646572431;
        Thu, 27 Apr 2023 18:49:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a001a0900b0063b642c5230sm14255684pfv.177.2023.04.27.18.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 18:49:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDEm-008hVi-VW; Fri, 28 Apr 2023 11:49:29 +1000
Date:   Fri, 28 Apr 2023 11:49:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't unconditionally null args->pag in
 xfs_bmap_btalloc_at_eof
Message-ID: <20230428014928.GN3223426@dread.disaster.area>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263573987.1717721.305790819127740342.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263573987.1717721.305790819127740342.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:48:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/170 on a filesystem with su=128k,sw=4 produces this splat:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000010
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 0 P4D 0
> Oops: 0002 [#1] PREEMPT SMP
> CPU: 1 PID: 4022907 Comm: dd Tainted: G        W          6.3.0-xfsx #2 6ebeeffbe9577d32
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-bu
> RIP: 0010:xfs_perag_rele+0x10/0x70 [xfs]
> RSP: 0018:ffffc90001e43858 EFLAGS: 00010217
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100
> RDX: ffffffffa054e717 RSI: 0000000000000005 RDI: 0000000000000000
> RBP: ffff888194eea000 R08: 0000000000000000 R09: 0000000000000037
> R10: ffff888100ac1cb0 R11: 0000000000000018 R12: 0000000000000000
> R13: ffffc90001e43a38 R14: ffff888194eea000 R15: ffff888194eea000
> FS:  00007f93d1a0e740(0000) GS:ffff88843fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000010 CR3: 000000018a34f000 CR4: 00000000003506e0
> Call Trace:
>  <TASK>
>  xfs_bmap_btalloc+0x1a7/0x5d0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  xfs_bmapi_allocate+0xee/0x470 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  xfs_bmapi_write+0x539/0x9e0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  xfs_iomap_write_direct+0x1bb/0x2b0 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  xfs_direct_write_iomap_begin+0x51c/0x710 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  iomap_iter+0x132/0x2f0
>  __iomap_dio_rw+0x2f8/0x840
>  iomap_dio_rw+0xe/0x30
>  xfs_file_dio_write_aligned+0xad/0x180 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  xfs_file_write_iter+0xfb/0x190 [xfs f85291d6841cbb3dc740083f1f331c0327394518]
>  vfs_write+0x2eb/0x410
>  ksys_write+0x65/0xe0
>  do_syscall_64+0x2b/0x80
> 
> This crash occurs under the "out_low_space" label.  We grabbed a perag
> reference, passed it via args->pag into xfs_bmap_btalloc_at_eof, and
> afterwards args->pag is NULL.  Fix the second function not to clobber
> args->pag if the caller had passed one in.
> 
> Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b512de0540d5..cd8870a16fd1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3494,8 +3494,10 @@ xfs_bmap_btalloc_at_eof(
>  		if (!caller_pag)
>  			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
>  		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
> -		if (!caller_pag)
> +		if (!caller_pag) {
>  			xfs_perag_put(args->pag);
> +			args->pag = NULL;
> +		}
>  		if (error)
>  			return error;
>  
> @@ -3505,7 +3507,6 @@ xfs_bmap_btalloc_at_eof(
>  		 * Exact allocation failed. Reset to try an aligned allocation
>  		 * according to the original allocation specification.
>  		 */
> -		args->pag = NULL;
>  		args->alignment = stripe_align;
>  		args->minlen = nextminlen;
>  		args->minalignslop = 0;

Yup, that'll fix the problem.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

FWIW, I'm working on some patches to take this further by always
providing a caller perag to this function.  That gets rid of all the
conditional code here and it gets rid of the only case where we call
xfs_alloc_vextent_near_bno() without args->pag set so the
conditional caller_pag code goes from there, too. This makes
xfs_alloc_vextent_{near,exact}_bno() identical except for one line
so they can be collapsed. And now that we always specify args->pag
for these functions, we can ignore the agno part of the target block
meaning we can select the perag to allocate from at a much higher
level via setting up args->pag when we initially scan the AGs to
set up args->minlen/maxlen based on the the nearest AG with 
contiguous free space large enough for the whole allocation. This
avoids attempting allocations that are guaranteed to fail before
we fall back to iterating from the target block agno and eventually
finding the same AG we originally found that had enough contiguous
free space in it for a maxlen allocation....

I think I can take it further an make both filestreams and the
normal allocator use the same "this ag" algorithm for EOF and
aligned allocation and then have them both fall back to the same
unaligned allocation attempts, which will then allow a bunch of code
to be collapsed in the xfs_bmap_btalloc() path...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
