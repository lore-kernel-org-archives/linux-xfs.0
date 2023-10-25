Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85EFC25B71
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 04:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJYEfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 00:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjJYEfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 00:35:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB074182
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 21:35:20 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6b20577ef7bso4288896b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2023 21:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698208520; x=1698813320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3xTKZpDGvVD8fC2vvttoOmCxGnsDSb+BGjrCoCkNPc=;
        b=dOmSA0FZpEW6/UkW+731OPASqna2YTo4q75Nqv83TZTFvBUIoCzQXqkV6R5IqOjJNL
         l1njKgve89z0+W3IqKXPJR8lSI7Moqv+t+3l/BioTIENlMBFkNU5trcXNefH8xsHSMbJ
         yenNZP/TrJIfOl9/sDPwFZ+drrLAWkJm4FR4TcRwm2ZRKH5jauAaj3NwWa0OkTBqYEm4
         TiNHP/0irWrW6hthLPi0pFrb2x/ZJdiGI/OM/LooHilgmTuJGbC3qfc72tcQKruRHGjT
         NPh8a2rczrIvg9bVFS8JhlsApx/h/4h0uI7IhLxTeu8K8WagsKa/9rvO9eleEeWUAiSO
         6FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698208520; x=1698813320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3xTKZpDGvVD8fC2vvttoOmCxGnsDSb+BGjrCoCkNPc=;
        b=LPTCpkc6PKnNIya9gqhawU5a+2WdL9Vq7qQBL4r8kPAEthcdGSVJJeV28afZBxtDo/
         3D54Iypy1adqcqQy1+/Dgi5gBLOwsRuA/6j0ek4junhwlIXLUMs+WIxjYhXGeVoS8v99
         hHnVJvm7SwtDpOHaa0gBm38oiodP+b7of4AdkFQ7XuoSFdUpca9O9CWKNzPFhZn0HuXW
         49Uy6HzsdQDZJJZWkUrRIjgAUfK2Rx3j9dLgyFX1TzppiXjLNIe7ZLG9MN5gYj8t1Iww
         TlIy5m08JTfO7kKM2FEFQjhBqWNBDyq28fLsS9JsbuKBl5KpAnXP+LxuGJbhFgroP6lN
         GZRw==
X-Gm-Message-State: AOJu0Yyxk0GL71TyQkT/6Ac+VSf0WRn9+NopYk6gyG05yYgsvJHnZYT+
        wmGWm0QQFwVvjSC7b0dB8cppmUCtaa0APdozF8s=
X-Google-Smtp-Source: AGHT+IGY0EXwsona6jaLAUX25xvb3UHumq8tMWQ6D//c9oOX3MUFt65mR/XoAfCpwlGLYEZMI3nMLA==
X-Received: by 2002:a05:6a00:1a86:b0:68e:2f6e:b4c0 with SMTP id e6-20020a056a001a8600b0068e2f6eb4c0mr12174357pfv.28.1698208520305;
        Tue, 24 Oct 2023 21:35:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id e8-20020a056a0000c800b006bd26bdc909sm8485740pfj.72.2023.10.24.21.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 21:35:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qvVbx-003bLX-1J;
        Wed, 25 Oct 2023 15:35:17 +1100
Date:   Wed, 25 Oct 2023 15:35:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <ZTibBf0ef5PMcJiH@dread.disaster.area>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> We've been seeing XFS errors like the following:
> 
> XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
> ...
> Call Trace:
>  xfs_corruption_error+0x94/0xa0
>  xfs_btree_insert+0x221/0x280
>  xfs_alloc_fixup_trees+0x104/0x3e0
>  xfs_alloc_ag_vextent_size+0x667/0x820
>  xfs_alloc_fix_freelist+0x5d9/0x750
>  xfs_free_extent_fix_freelist+0x65/0xa0
>  __xfs_free_extent+0x57/0x180
> ...

Good find, Omar!

For completeness, what's the rest of the trace? We've recently
changed how extent freeing path works w.r.t. busy extents so I'm
curious as to what the path into this code is.

Lots of what follows is really notes as I try to pull this apart and
understand it. Please check my working!

> 
> This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
> xfs_btree_insrec() fails.
> 
> After converting this into a panic and dissecting the core dump, I found
> that xfs_btree_insrec() is failing because it's trying to split a leaf
> node in the cntbt when the AG free list is empty. In particular, it's
> failing to get a block from the AGFL _while trying to refill the AGFL_.
> Our filesystems don't have the rmapbt enabled, so if both the bnobt and
> cntbt are 2 levels, the free list is 6 blocks.
>
> If a single operation
> causes both the bnobt and cntbt to split from 2 levels to 3 levels, this
> will allocate 6 new blocks and exhaust the free list.

Which is just fine - the AGFL was sized correctly for that specific
operation to allow it to succeed.

> Then, when the
> next operation tries to refill the freelist, it allocates space.

Ok, so the initial condition for this allocation is a completely
empty AGFL.

> If the
> allocation does not use a full extent, it will need to insert records
> for the remaining space in the bnobt and cntbt. And if those new records
> go in full leaves, the leaves need to be split.

Ok, so we've gone to do a by-size allocation, which will start the
search at:

	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0,
                        args->maxlen + args->alignment - 1, &i)))

an extent that covers maxlen + alignment. The allocation parameters
set by the freelist fixup will be:

	targs.alignment = targs.minlen = targs.prod = 1;
...
	targs.maxlen = need - pag->pagf_flcount;

Ok, so the by-size allocation will select the first extent the same
size of larger than what the AGFL needs to fill the empty slots.

Oversize extents get selected because the allocation doesn't find an
extent of the exact size requested and so pulls a larger extent of
the free space tree. If that extent is not suitable (e.g. it is
busy), it then keeps walking in the direction of larger extents to
carve the free list out of.

IOWs, this search direction guarantees that we'll have to split
the free space extent if there is no free extent the exact size the
AGFL needs.

Ok, that's a possible avenue for fixing the issue - when the agfl is
completely empty, do a LE search so we never have to split a free
space extent and hence completely avoid btree splits....

> (It's guaranteed that
> none of the internal nodes need to be split because they were just
> split.)

Hmmm. That doesn't sound right - btrees don't work that way.

We don't know what path the tree split along in the previous insert
operation  - a split only guarantees the next insert along that same
path won't split if the insert hits one of the two leaf blocks from
the split.  Insert into a different leaf can still split interior
nodes all the way back up the tree the point where it intersects
with the previous full height split path.

e.g. if the previous full height split was down the left side of the
tree and the next insert is in the right half of the tree, the right
half can split on insert all the way up to the level below the old
root.

> Fix it by adding an extra block of slack in the freelist for the
> potential leaf split in each of the bnobt and cntbt.

Hmmm. yeah - example given is 2->3 level split, hence only need to
handle a single level leaf split before path intersection occurs.
Yup, adding an extra block will make the exact problem being seen go
away.

Ok, what's the general solution? 4-level, 5-level or larger trees?

Worst split after a full split is up to the level below the old root
block. the root block was split, so it won't need a split again, so
only it's children could split again. OK, so that's (height - 1)
needed for a max split to refill the AGFL after a full height split
occurred.

Hence it looks like the minimum AGFL space for any given
allocation/free operation needs to be:

	(full height split reservation) + (AGFL refill split height)

which is:

	= (new height) + (new height - 2)
	= 2 * new height - 2
	= 2 * (current height + 1) - 2
	= 2 * current height

Ok, so we essentially have to double the AGFL minimum size to handle
the generic case of AGFL refill splitting free space trees after a
transaction that has exhausted it's AGFL reservation.

Now, did I get that right?

> P.S. As far as I can tell, this bug has existed for a long time -- maybe
> back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
> ...") in April 1994! It requires a very unlucky sequence of events, and
> in fact we didn't hit it until a particular sparse mmap workload updated
> from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
> exposed by some other change in allocation or writeback patterns.

No surprise there - these sorts of fundamental reservations and
limits that largely avoid ENOSPC issues don't get touched unless a
problem is found. Who knows how many deep dark corners this specific
change will expose to the light...

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3069194527dd..2cbcf18fb903 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2275,12 +2275,16 @@ xfs_alloc_min_freelist(
>  
>  	ASSERT(mp->m_alloc_maxlevels > 0);
>  
> -	/* space needed by-bno freespace btree */
> +	/*
> +	 * space needed by-bno freespace btree: one per level that may be split
> +	 * by an insert, plus one more for a leaf split that may be necessary to
> +	 * refill the AGFL
> +	 */
>  	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
> -				       mp->m_alloc_maxlevels);
> -	/* space needed by-size freespace btree */
> +				       mp->m_alloc_maxlevels) + 1;
> +	/* space needed by-size freespace btree, same as above */
>  	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
> -				       mp->m_alloc_maxlevels);
> +				       mp->m_alloc_maxlevels) + 1;
>  	/* space needed reverse mapping used space btree */
>  	if (xfs_has_rmapbt(mp))
>  		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,

The rmapbt case will need this change, too, because rmapbt blocks
are allocated from the free list and so an rmapbt update can exhaust
the free list completely, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
