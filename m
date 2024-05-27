Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512017764E
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 08:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716800349; cv=none; b=PkQ8iR3pZ2x6I9McSaPsZPFvreO2tSQdTc76KQLI91IooRoVV8SF2giyBsGqHq7ItYSR26+5hBd2DnLWNhhz7/iMjRf1jGcH7jAzHM7qoXlHpO4dJMyR+CNTaC5J5JIuMaDNCdb6j0a0b3tVobRT4k55B4KttviHrnBERcXAnCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716800349; c=relaxed/simple;
	bh=hmxUP5Z7QdlGlEg0+Ja3e7QurCcYH+MN7MLrF0tlpwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJKThBr8Jhhxg/4qmzTVoTmV6NvX+ezLlsM3Lvk5lW1sAX7iJ1ODbf3u74kJmbss0xfakn3ohuWsHrNW4xv+P60igoBJAI22yiBT+FhlMlfxjFhrM5ibyl9amw0KhmhGVSK2fKEyttSmmTktOkPS33LDMg602HoweHj2qTjQXaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Cr3NzGa+; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Cr3NzGa+"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6f8ec7e054dso1870251b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 01:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716800348; x=1717405148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nbbx6nUFj83QyRdmf9m/6N662YSsaUnaN6QsIjAe+OU=;
        b=Cr3NzGa+W65vuzVXtkNqM4YuZaHPsiKj0BZUxAPT5XY2AyoTv2QCn4EkZN8EtkGJsF
         TQi0qMFB2b7LqLQCl/u7dQ8C6uc14pXCaI1QQv7MxyVNH0gTr0L3b/2sQOiHtDV4jZot
         E8B1AvXA9agY5RCv0XtdYboJMVBWJIWeC4PeoJIPszELVB3aM9Dw3Nx3YzNVP1SWb/b2
         sGrGW2pdqPnGr6dUzaz1iMy6AMWiklOeKR2NdfDbENdabNkhoDUQAe0o/2GgeMGLgUCM
         MkGM6uyhrtTkXBf+p4bx4yYyO5wwu2zm4n9QiT3ri02xYL5TIbUH4ivHYB39GOT0nKD+
         eKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716800348; x=1717405148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbbx6nUFj83QyRdmf9m/6N662YSsaUnaN6QsIjAe+OU=;
        b=rpAyGsIaWjzZm13YahgcIVNfHLWp4hDY8R+mo8sVHWvjsaZYP+LSC0clf6W8Zjc06R
         ABdcOGhcp0y9MjYGDOsFwEtzBCtWs4X3VqDjjonm3wp1QFXgtd3nbHpiucg+xSCleNTo
         kJqzRmQFwaCFcYQjWqsG+blxYIn3jGKN+UTbp7n4nr1Ty/a7Eui6y8b68BexAeyLeji0
         jdE2wy+tvDKzLj70aB/tBmRHG0Ln455jkD125EeSVeANiMwXrbiGwE1qRMC7L27R8tjj
         F0Sy/v9zFC+zdFdtPbI/yli53xiOE9uBYCW2HA6acXNqIRaEL4yB6UB+7uuaSFhvJ+On
         sTKQ==
X-Gm-Message-State: AOJu0Yy6ploChjj+2UEr4j2vRvm3ZdMuRwU/Wph63D+pomTm7kBaJbl9
	jE1N9zH2/xmz+1/Eu63nMaOyYo10cv9FuwpO/HOQC9WNXZtQHX3/s36niVatVhYHjP1GP2tHtOM
	d
X-Google-Smtp-Source: AGHT+IE7KpvSPdkd4tFoDqSuQ/oSQP/6c4Bex4uzgffVT9s10lzeYFfPXrzfzOdxzJTlkRKq6X2pKw==
X-Received: by 2002:a05:6a00:4c8b:b0:6ea:9252:435 with SMTP id d2e1a72fcca58-6f8f3d70f73mr14322417b3a.30.1716800347451;
        Mon, 27 May 2024 01:59:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6822635dc6esm5597113a12.65.2024.05.27.01.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 01:59:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sBWC8-00C8Jr-14;
	Mon, 27 May 2024 18:59:04 +1000
Date: Mon, 27 May 2024 18:59:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid redundant AGFL buffer invalidation
Message-ID: <ZlRLWP3Ty6uvMzjd@dread.disaster.area>
References: <20240527061006.4045908-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240527061006.4045908-1-hsiangkao@linux.alibaba.com>

On Mon, May 27, 2024 at 02:10:06PM +0800, Gao Xiang wrote:
> Currently AGFL blocks can be filled from the following three sources:
>  - allocbt free blocks, as in xfs_allocbt_free_block();
>  - rmapbt free blocks, as in xfs_rmapbt_free_block();
>  - refilled from freespace btrees, as in xfs_alloc_fix_freelist().
> 
> Originally, allocbt free blocks would be marked as stale only when they
> put back in the general free space pool as Dave mentioned on IRC, "we
> don't stale AGF metadata btree blocks when they are returned to the
> AGFL .. but once they get put back in the general free space pool, we
> have to make sure the buffers are marked stale as the next user of
> those blocks might be user data...."

So it turns out that xfs_alloc_ag_vextent_small() does this when
allocating from the AGFL:

	if (args->datatype & XFS_ALLOC_USERDATA) {
                struct xfs_buf  *bp;

                error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
                                XFS_AGB_TO_DADDR(args->mp, args->agno, fbno),
                                args->mp->m_bsize, 0, &bp);
                if (error)
                        goto error;
                xfs_trans_binval(args->tp, bp);
        }

Hence we're already invalidating any buffer over the block allocated
from the AGFL to ensure nothing will overwrite the user data that
will be placed in the block after the allocation is committed.

This means we can trigger the log force from this path - more
about that below....

> However, after commit ca250b1b3d71 ("xfs: invalidate allocbt blocks
> moved to the free list") and commit edfd9dd54921 ("xfs: move buffer
> invalidation to xfs_btree_free_block"), even allocbt / bmapbt free
> blocks will be invalidated immediately since they may fail to pass
> V5 format validation on writeback even writeback to free space would be
> safe.

*nod*

> IOWs, IMHO currently there is actually no difference of free blocks
> between AGFL freespace pool and the general free space pool.  So let's
> avoid extra redundant AGFL buffer invalidation, since otherwise we're
> currently facing unnecessary xfs_log_force() due to xfs_trans_binval()
> again on buffers already marked as stale before as below:
> 
> [  333.507469] Call Trace:
> [  333.507862]  xfs_buf_find+0x371/0x6a0
> [  333.508451]  xfs_buf_get_map+0x3f/0x230
> [  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
> [  333.509751]  xfs_free_agfl_block+0xa1/0xd0
> [  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
> [  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
> [  333.511871]  xfs_defer_finish+0xc/0xa0
> [  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
> [  333.513253]  xfs_inactive_truncate+0xb8/0x130
> [  333.513930]  xfs_inactive+0x223/0x270
> 
> And xfs_log_force() will take tens of milliseconds with AGF buffer
> locked.  It becomes an unnecessary long latency especially on our PMEM
> devices with FSDAX enabled.  Also fstests are passed with this patch.

Well, keep in mind the reason the log force was introduced in
xfs_buf_lock() - commit ed3b4d6cdc81 ("xfs: Improve scalability of
busy extent tracking") says:

    The only problem with this approach is that when a metadata buffer is
    marked stale (e.g. a directory block is removed), then buffer remains
    pinned and locked until the log goes to disk. The issue here is that
    if that stale buffer is reallocated in a subsequent transaction, the
    attempt to lock that buffer in the transaction will hang waiting
    the log to go to disk to unlock and unpin the buffer. Hence if
    someone tries to lock a pinned, stale, locked buffer we need to
    push on the log to get it unlocked ASAP. Effectively we are trading
    off a guaranteed log force for a much less common trigger for log
    force to occur.

IOWs, this "log force on buffer lock" trigger isn't specific to AGFL
blocks.  The log force is placed there to ensure that access latency
to any block we rapidly reallocate is *only* a few milliseconds,
rather than being "whenever the next log writes trigger" which could
be tens of seconds away....

Hence we need to be aware that removing the double invalidation on
the AGFL blocks does not make this "log force on stale buffer"
latency issue go away, it just changes when and where it happens
(i.e. on reallocation).

> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6cb8b2ddc541..a80d2a31252a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2432,22 +2432,8 @@ xfs_free_agfl_block(
>  	struct xfs_buf		*agbp,
>  	struct xfs_owner_info	*oinfo)
>  {
> -	int			error;
> -	struct xfs_buf		*bp;
> -
> -	error = xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
> -				   XFS_AG_RESV_AGFL);
> -	if (error)
> -		return error;
> -
> -	error = xfs_trans_get_buf(tp, tp->t_mountp->m_ddev_targp,
> -			XFS_AGB_TO_DADDR(tp->t_mountp, agno, agbno),
> -			tp->t_mountp->m_bsize, 0, &bp);
> -	if (error)
> -		return error;
> -	xfs_trans_binval(tp, bp);
> -
> -	return 0;
> +	return xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
> +				  XFS_AG_RESV_AGFL);
>  }

I'd just get rid of the xfs_free_agfl_block() wrapper entirely and
call xfs_free_ag_extent() directly from xfs_agfl_free_finish_item().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
